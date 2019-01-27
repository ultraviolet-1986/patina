# Patina Exceptions

## Table of Contents

- [Exception Reference List](#exception-reference-list)
- [Utilising Exceptions](#utilising-exceptions)

## Exception Reference List

As of version 0.7.1, Patina now supports passing exceptions as a means of
quickly informing a user of any errors that have occurred. I will list all 'PE'
numbers (Patina Exception) here for reference.

- **PE0000 `Patina has encountered an unknown error.`**
  - This error should be raised when failure conditions are unknown.

- **PE0001 `Patina has not been given an expected argument.`**
  - This error should be raised when a script/user does not provide at least one
    argument.

- **PE0002 `Patina has been given too many arguments.`**
  - This error should be raised when a script/user provides too many arguments.

- **PE0003 `Patina has not been given a valid argument.`**
  - This error should be raised when a script/user provides at least one
    argument, but it is incorrect or not supported.

- **PE0004 `Patina cannot find the directory specified.`**
  - This error should be raised when Patina attempts to find a directory and it
    does not exist.

- **PE0005 `Patina cannot find the file specified.`**
  - This error should be raised when Patina attempts to find a file and it does
    not exist.

- **PE0006 `Patina could not detect a required application.`**
  - This error should be raised when an external application cannot be executed.
    It can usually mean that a required package is not installed.

- **PE0007 `Patina has not connected any components.`**
  - This error should be raised when Patina cannot (or has not) connected any
    components.

- **PE0008 `Patina does not have access to the Internet.`**
  - This error should be raised when Patina cannot detect an active Internet
    connection.

- **PE0009 `Patina cannot detect a valid source control repository.`**
  - This error should be raised when Patina cannot detect a valid source control
    repository.

- **PE0010 `Patina cannot access a required variable.`**
  - This error should be raised when Patina cannot access a required variable.

## Utilising Exceptions

When writing scripts or components to use with Patina, a user can look up a
reference number above and place it within their component logic. The following
pseudo-code should provide a reference to making this work.

```bash
if [ $something_valid ] ; then
  # Success
  something_happens
elif [ ! $something_valid ] ; then
  # Failure (known)
  nothing_happens
else
  # Failure (unknown)
  patina_throw_exception 'PE0000'
fi
```
