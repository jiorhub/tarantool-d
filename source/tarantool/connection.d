/**
 * Модуль подключения к Tarantool 
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.connection;

private
{
    import core.time : Duration, msecs;

    import std.algorithm.comparison : min;
    import std.socket : AddressFamily;
    import std.uuid : UUID;

    import vibe.core.net;
    import vibe.core.log;
    import vibe.core.core : runTask, Task, sleep;

    import msgpack;
    import msgpack.tarantool;

    import tarantool.types;
    import tarantool.exception;
    import tarantool.consts;
    import tarantool.request;
}


enum BUFFER_SIZE = 64 * 1024;


/**
 * Функция обратного вызова
 */
alias CallbackData = void delegate(Value header, Value response);


struct TarantoolConnectionSettings
{
    ushort reconnectMaxAttempts = RECONNECT_MAX_ATTEMPTS;
    Duration reconnectDelay = 1000.msecs;
    Duration readTimeout = Duration.max; 
}



class TarantoolStream(Connection) if (isConnectionStream!Connection)
{

}


/+

/**
 * Класс подключения к серверу базы Tarantool
 */
abstract class BaseTarantoolConnection
{
    private
    {
        TCPConnection _connection;
        NetworkAddress _address;
        TarantoolConnectionSettings _settings;
        StreamingUnpacker _unpacker = void;
        Greeting _greeting;

        string _username;
        string _password;
        CallbackData _callback;
    }


    this(NetworkAddress address)
    {
        _address = address;
        _unpacker = StreamingUnpacker([], 2048);
    }


    this(NetworkAddress address, TarantoolConnectionSettings settings)
    {
        this(address);
        _settings = settings;
    }


    this(string host, ushort port, AddressFamily family = AddressFamily.INET)
    {
        this(resolveHost(host, family));
        if (_address.family != AddressFamily.UNIX)
            _address.port = port;
    }


    this(string host, ushort port, TarantoolConnectionSettings settings, AddressFamily family = AddressFamily.INET)
    {
        this(resolveHost(host, family), settings);
        if (_address.family != AddressFamily.UNIX)
            _address.port = port;
    }

    /**
     * Подключение к серверу и запуск процесса обработки взодящих пакетов
     * Params:
     *
     * usernamee = Имя пользователя
     * password = Пароль пользователя
     * callback = Функция обработки входящего сообщения
     */
    void connect(string username, string password, CallbackData callback)
    {
        _username = username;
        _password = password;
        _callback = callback;

        connectServer();
        initializeConnection();
    }

    /**
     * Подключение к серверу и запуск процесса обработки взодящих пакетов
     * Params:
     *
     * callback = Функция обработки входящего сообщения
     */
    void connect(CallbackData callback)
    {
        _callback = callback;

        connectServer();
        initializeConnection();
    }


    void send(ubyte[] data)
    {
        if (!_connection.connected)
            reconnect();

        logDiagnostic("Send %s", data);
        _connection.write(data);
    }


    void disconnect()
    {
        if (_connection.connected)
            _connection.close();
    }


protected:

    void doAuthenticate(string username, string password, ubyte[] salt);

private:

    /**
     * Метод производит несколько попыток повторного подключения
     */
    void reconnect()
    {
        ushort attempts;
        Exception lastException;

        while (!_connection.connected)
        {
            if (attempts > _settings.reconnectMaxAttempts)
                throw lastException;
            attempts++;

            sleep(_settings.reconnectDelay);
            try
            {
                connectServer();
                initializeConnection();
            }
            catch (Exception e)
            {
                logWarn("Reconnect attempt %s of %s", attempts, _settings.reconnectMaxAttempts);
                lastException = e;
            }
        }
    }


    void initializeConnection()
    {
        _greeting = handshake();

        if (_callback !is null)
            runTask((CallbackData cb) {
                auto buffer = new ubyte[BUFFER_SIZE];
                scope (exit) () @trusted { delete buffer; } ();

                while (!_connection.empty)
                {
                    _connection.read(buffer[0..5]);
                    immutable(uint) size = unpack!uint(buffer[0..5]);
                    _connection.read(buffer[1..size+1]);
                    buffer[0] = 146;
                    _unpacker.feed(buffer[0..size+1]);
                    while (_unpacker.execute())
                    {
                        auto u = _unpacker.purge();
                        cb(u[0], u[1]);
                    }
                }
            }, _callback);
        else
            logError("Not defined response callback");

        if (_username.length > 0)
            doAuthenticate(_username, _password, _greeting.salt);
    }


    /**
     * Метод утсанавливает сетевое подключение к серверу базы данных
     */
    void connectServer()
    {
        if (_connection.connected)
            return;

        try
        {
            _connection = connectTCP(_address);
            _connection.tcpNoDelay(true);
            _connection.readTimeout(_settings.readTimeout);
        }
        catch (Exception e)
        {
            _connection.close();
            throw new NetworkException(e.msg, __FILE__, __LINE__, e);
        }

        logTrace("Connect to %s", _address);
    }

    /**
     * Метод обрабатывает данные приветствия от сервера
     */
    Greeting handshake()
    {
        ubyte[] buffer = new ubyte[IPROTO_GREETING_SIZE];
        _connection.read(buffer);
        auto greeting = Greeting.fromBytes(buffer);
        if (greeting.protocol != "Binary")
            throw new NetworkException("Unsupported protocol: " ~ greeting.protocol);
        return greeting;
    }
}



class TarantoolConnection : BaseTarantoolConnection
{
    this(NetworkAddress address)
    {
        super(address);
    }


    this(NetworkAddress address, TarantoolConnectionSettings settings)
    {
        super(address, settings);
    }


    this(string host, ushort port, AddressFamily family = AddressFamily.INET)
    {
        super(host, port, family);
    }


    this(string host, ushort port, TarantoolConnectionSettings settings, AddressFamily family = AddressFamily.INET)
    {
        super(host, port, settings, family);
    }
    

    void connect()
    {
        super.connect(&onResponse);          
    }


    void connect(string username, string password)
    {
        super.connect(username, password, &onResponse); 
    }


    void request(ubyte[] data)
    {
        super.send(convertSize(cast(uint)data.length) ~ data);
    }


    uint generateSync()
    {
        return 0;
    }

    uint schemaId() @property const
    {
        return 0;
    }

protected:

    override void doAuthenticate(string username, string password, ubyte[] salt)
    {
        authenticate(this, username, password, salt);        
    }


private:

    void onResponse(Value h, Value b)
    {



        import std.stdio: wl = writeln;
        wl("Header:");
        wl(h.toString(2));
        wl("\nBody:");
        wl(b.toString(2));
    }
}
+/

