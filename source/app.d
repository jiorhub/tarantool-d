/**
 * Основной модуль 
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module app;

private
{
    import vibe.core.core : runEventLoop;
    import vibe.core.log;

    import tarantool.request;
    import tarantool.connection;
}

void main()
{
    setLogLevel(LogLevel.trace);

    // auto conn = new TarantoolConnection("localhost", 3301);
    // conn.connect("Oleg", "12345");
    // conn.connect();

    // conn.callFunction("test");

    // conn.disconnect();

    // auto req = RequestTest();
    // conn.send(req);

    // runEventLoop();
}
