/**
 * Модуль содержит классы исключений
 *
 * Copyright: (c) 2017, Oleg Lelenkov.
 * License: MIT
 * Authors: Oleg Lelenkov
 */
module tarantool.exception;

private
{

}


mixin template ExceptionMixin()
{
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null)
    {
        super(msg, file, line, next);
    }
}


class DatabaseException : Exception
{
    mixin ExceptionMixin!();
}


class InterfaseError : Exception
{
    mixin ExceptionMixin!();
}


class SchemaException : DatabaseException
{
    mixin ExceptionMixin!();
}


class NetworkException : Exception
{
    mixin ExceptionMixin!();
}
