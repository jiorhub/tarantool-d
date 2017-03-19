/**
 * Модуль содержит набор констант 
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.consts;

private
{
    import core.time;
}


/**
  * Тип отправляемого запроса
  */
enum RequestType
{
    OK = 0,
    SELECT = 1,
    INSERT = 2,
    REPLACE = 3,
    UPDATE = 4,
    DELETE = 5,
    CALL = 6,
    AUTHENTICATE = 7,
    EVAL = 8,
    UPSERT = 9,
    PING = 64,
    JOIN = 65,
    SUBSCRIBE = 66,
    ERROR = 1 << 15
}


enum IPROTO_CODE = 0x00;
enum IPROTO_SYNC = 0x01;

// replication keys (header)
enum IPROTO_SERVER_ID = 0x02;
enum IPROTO_LSN = 0x03;
enum IPROTO_TIMESTAMP = 0x04;
enum IPROTO_SCHEMA_ID = 0x05;

enum IPROTO_SPACE_ID = 0x10;
enum IPROTO_INDEX_ID = 0x11;
enum IPROTO_LIMIT = 0x12;
enum IPROTO_OFFSET = 0x13;
enum IPROTO_ITERATOR = 0x14;
enum IPROTO_INDEX_BASE = 0x15;

enum IPROTO_KEY = 0x20;
enum IPROTO_TUPLE = 0x21;
enum IPROTO_FUNCTION_NAME = 0x22;
enum IPROTO_USER_NAME = 0x23;

enum IPROTO_SERVER_UUID = 0x24;
enum IPROTO_CLUSTER_UUID = 0x25;
enum IPROTO_VCLOCK = 0x26;
enum IPROTO_EXPR = 0x27;
enum IPROTO_OPS = 0x28;

enum IPROTO_DATA = 0x30;
enum IPROTO_ERROR = 0x31;

enum IPROTO_GREETING_SIZE = 128;
enum IPROTO_BODY_MAX_LEN = 2_147_483_648;


enum SPACE_SCHEMA = 272;
enum SPACE_SPACE = 280;
enum SPACE_INDEX = 288;
enum SPACE_FUNC = 296;
enum SPACE_VSPACE = 281;
enum SPACE_VINDEX = 289;
enum SPACE_VFUNC = 297;
enum SPACE_USER = 304;
enum SPACE_PRIV = 312;
enum SPACE_CLUSTER = 320;

enum INDEX_SPACE_PRIMARY = 0;
enum INDEX_SPACE_NAME = 2;
enum INDEX_INDEX_PRIMARY = 0;
enum INDEX_INDEX_NAME = 2;

enum ITERATOR_EQ = 0;
enum ITERATOR_REQ = 1;
enum ITERATOR_ALL = 2;
enum ITERATOR_LT = 3;
enum ITERATOR_LE = 4;
enum ITERATOR_GE = 5;
enum ITERATOR_GT = 6;
enum ITERATOR_BITSET_ALL_SET = 7;
enum ITERATOR_BITSET_ANY_SET = 8;
enum ITERATOR_BITSET_ALL_NOT_SET = 9;
enum ITERATOR_OVERLAPS = 10;
enum ITERATOR_NEIGHBOR = 11;

// Default value for socket timeout (seconds)
// enum SOCKET_TIMEOUT = None;
// Default maximum number of attempts to reconnect
enum RECONNECT_MAX_ATTEMPTS = 10;
// Default delay between attempts to reconnect (seconds)
enum RECONNECT_DELAY = 1.seconds;

