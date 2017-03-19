/**
 * Модуль содержит основные типы использвемые в протоколе взаимодейтвия 
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.types;

/+
private
{
    import std.algorithm.iteration : map;
    import std.algorithm.searching : all, findSplit, startsWith;
    import std.array : array, split;
    import std.base64 : Base64, Base64Exception;
    import std.conv : to;
    import std.string : isNumeric, strip;
    import std.uuid : UUID;
}


struct Greeting
{
    uint versionId;
    string protocol;
    ubyte[] salt;
    UUID uuid;

    
    static Greeting fromBytes(ubyte[] data)
    {
        Greeting result;

        string firstLine = cast(string)data[0..63];
        string secondLine = cast(string)data[64..$];

        auto t = firstLine.findSplit(" ");
        if (!t[0].startsWith("Tarantool"))
            throw new Exception("Is not Tarantool");

        t = t[2].findSplit(" ");

        const(string[]) versions = t[0].findSplit("-")[0].split(".");
        if (versions.length < 3 || !versions.all!isNumeric)
            throw new Exception("Error versions");

        int[] v = versions.map!(to!int).array;
        result.versionId = (((v[0] << 8) | v[1]) << 8) | v[2];

        if (t[2].length > 0 && t[2][0] == '(')
        {
            t = t[2][1..$].findSplit(") ");
            result.protocol = t[0];

            if(result.protocol != "Binary")
                return result;

            if (result.versionId >= calculateVersionId(1, 6, 7))
            {
                t = t[2].findSplit(" ");
                result.uuid = UUID(t[0].strip);
            }
        }
        else if (result.versionId < calculateVersionId(1, 6, 7))
            result.protocol = "Binary";
        else if (t[2].strip.length > 0)
            throw new Exception("Unsuported greeting");

        try
            result.salt = Base64.decode(secondLine[0..44]);
        catch (Base64Exception e)
            throw new Exception("Error salt");

        return result;
    }
}


uint calculateVersionId(uint major, uint minor, uint patch)
{
    return (((major << 8) | minor) << 8) | patch;
}
+/
