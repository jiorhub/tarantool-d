/**
 * Модуль содержит объекты запросов 
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.request;

/+
private
{
    import std.typecons : tuple;

    import msgpack : Packer;
    import msgpack.tarantool : convertSize;

    import tarantool.connection : TarantoolConnection;
    import tarantool.consts;
}


private ubyte[] createHeader(TarantoolConnection conn, uint code)
{
    auto packer = Packer(false);

    auto schemaId = conn.schemaId;

    packer.beginMap((schemaId > 0) ? 3 : 2);
    packer.pack(IPROTO_CODE);
    packer.pack(code);
    packer.pack(IPROTO_SYNC);
    packer.pack(conn.generateSync());
    if (schemaId > 0)
    {
        packer.pack(IPROTO_SCHEMA_ID);
        packer.pack(schemaId);
    }

    return packer.stream.data;
}


void authenticate(TarantoolConnection conn, string username, string password, ubyte[] salt)
{
    import std.digest.sha : sha1Of;

    auto hash1 = sha1Of(password);
    auto hash2 = sha1Of(hash1);
    auto scramble = sha1Of(salt[0..20], hash2);
    foreach (i; 0..20)
        hash1[i] ^= scramble[i];

    auto header = conn.createHeader(REQUEST_TYPE_AUTHENTICATE);

    auto packerBody = Packer(false);

    packerBody.beginMap(2);
    packerBody.pack(IPROTO_USER_NAME);
    packerBody.pack(username);
    packerBody.pack(IPROTO_TUPLE);
    packerBody.beginArray(2);
    packerBody.pack("chap-sha1");
    packerBody.pack(hash1);

    conn.request(header ~ packerBody.stream.data);
}


void callFunction(Arg...)(TarantoolConnection conn, string name, Arg args)
{
    auto header = conn.createHeader(REQUEST_TYPE_CALL);

    auto packerBody = Packer(false);

    packerBody.beginMap(2);
    packerBody.pack(IPROTO_FUNCTION_NAME);
    packerBody.pack(name);
    packerBody.pack(IPROTO_TUPLE);
    packerBody.packArray(args);

    conn.request(header ~ packerBody.stream.data);
}
+/
