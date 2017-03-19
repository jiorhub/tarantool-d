/**
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.types_test;

private
{
    import std.uuid : UUID;
    import std.base64 : Base64;

    import dunit;

    import tarantool.types;
}

class Test
{
    mixin UnitTest;


    // @Test
    // void testCalculateVertionId()
    // {
    //     assertEquals(calculateVersionId(1, 7, 3), calculateVersionId(1, 7, 3));
    //     assertTrue(calculateVersionId(1, 7, 2) < calculateVersionId(1, 7, 3));
    //     assertTrue(calculateVersionId(1, 4, 2) < calculateVersionId(1, 5, 3));
    // }


    // static ubyte[] createFromString(string ver, string salt)
    // {
    //     ubyte[] result = new ubyte[128];
    //     result[] = 32;

    //     ulong verLen = ver.length > 63 ? 63 : ver.length;
    //     result[0..verLen] = (cast(ubyte[])ver)[0..verLen];
    //     result[64] = cast(ubyte)'\n';

    //     ulong saltLen = salt.length > 20 ? 20 : salt.length;
    //     result[65..(65+saltLen)] = (cast(ubyte[])salt)[0..saltLen];

    //     return result;
    // }


    // @Test
    // void testGreetingFromBytes()
    // {
    //     auto exception = expectThrows(
    //         Greeting.fromBytes(createFromString("Tratata", "ssss"))
    //     );
    //     assertEquals(exception.msg, "Is not Tarantool");

    //     string txt = "Tarantool 1.6";
    //     exception = expectThrows(
    //         Greeting.fromBytes(createFromString(txt, "ssss"))
    //     );
    //     assertEquals(exception.msg, "Error versions");

    //     txt = "Tarantool 1.6.6";
    //     assertEquals(
    //             Greeting.fromBytes(createFromString(txt, "ssssssssssssssssssss")),
    //             Greeting(calculateVersionId(1, 6, 6), "Binary", [178, 203, 44, 178, 203, 44, 178, 203, 44, 178, 203, 44, 178, 203, 44])
    //     );

    //     exception = expectThrows(
    //         Greeting.fromBytes(createFromString(txt, "ssss")),
    //     );
    //     assertEquals(exception.msg, "Error salt");

    //     txt = "Tarantool 1.6.6-102-g4e9bde2";
    //     assertEquals(
    //             Greeting.fromBytes(createFromString(txt, "ssssssssssssssssssss")),
    //             Greeting(calculateVersionId(1, 6, 6), "Binary", [178, 203, 44, 178, 203, 44, 178, 203, 44, 178, 203, 44, 178, 203, 44])
    //     );

    //     txt = "Tarantool 1.6.8 (Binary) 3b151c25-4c4a-4b5d-8042-0f1b3a6f61c3";
    //     assertEquals(
    //             Greeting.fromBytes(createFromString(txt, "ssssssssssssssssssss")),
    //             Greeting(calculateVersionId(1, 6, 8), "Binary", Base64.decode("ssssssssssssssssssss"), UUID("3b151c25-4c4a-4b5d-8042-0f1b3a6f61c3"))
    //     );

    //     txt = "Tarantool 1.6.9-132-g82f5424 (Lua console)";
    //     assertEquals(
    //             Greeting.fromBytes(createFromString(txt, "ssssssssssssssssssss")),
    //             Greeting(calculateVersionId(1, 6, 9), "Lua console")
    //     );
    // }
}

