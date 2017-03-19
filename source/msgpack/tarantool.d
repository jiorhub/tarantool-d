/**
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module msgpack.tarantool;

private
{
    import std.traits : hasMember, Parameters;
    import std.format : fmt = format;

    import msgpack.common : convertEndianTo;
    import msgpack.value : Value;
}


ubyte[] convertSize(uint value)
{
    ubyte[] res = [0xce,0,0,0,0];
    immutable(uint) temp = convertEndianTo!32(value);
    *cast(uint*)&res[1] = temp;
    return res;
}



template isMsgpackRequest(T)
{
    static if (hasMember!(T, "toMsgpack"))
    {
        enum isMsgpackRequest = true;    
    }
    else
        enum isMsgpackRequest = false;

    // static if (__traits(compiles, { T.toMsgpack(this, withFieldName_); })) {
    //     object.toMsgpack(this, withFieldName_);
    // } else static if (__traits(compiles, { object.toMsgpack(this); })) { // backward compatible
    //     object.toMsgpack(this);
    // } else {
    //     static assert(0, "Failed to invoke 'toMsgpack' on type '" ~ Unqual!T.stringof ~ "'");
    // }
}


string toString(Value value, uint indent = 0, bool smartIndent = false)
{
    import std.string : leftJustify;
    import std.array : appender;
    import std.conv : to;

    string ind = leftJustify("", indent);
    string getIndentLine(T)(T v)
    {
        if (smartIndent)
            return v.to!string;
        else
            return ind ~ v.to!string;
    }

    switch (value.type) with (Value.Type)
    {
        case nil:
            return getIndentLine("nil");
        case boolean:
            return getIndentLine(value.as!bool);
        case unsigned:
            return getIndentLine(value.as!ulong);
        case signed:
            return getIndentLine(value.as!long);
        case floating:
            return getIndentLine(value.as!real);
        case array:
            auto a = appender!string;
            a.put(getIndentLine("array ["));
            foreach (Value v; value.via.array)
                a.put("\n" ~ v.toString(indent + 4));
            smartIndent = false;
            a.put("\n" ~ getIndentLine("]"));
            return a.data;
        case map:
            auto a = appender!string;
            a.put(getIndentLine("map {"));
            foreach (Value k, Value v; value.via.map)
                a.put("\n" ~ k.toString(indent + 4) ~ " : " ~ v.toString(indent + 4, true));
            smartIndent = false;
            a.put("\n" ~ getIndentLine("}"));
            return a.data;
        case raw:
            return getIndentLine(cast(string)value.via.raw);
        case ext:
            return "{type: %s, data: %s}".fmt(value.via.ext.type, value.via.ext.data);
        default:
            return getIndentLine("error");
    }
}
