# Security

## General Validation

Never trust input regardless of where it is coming from! The responsibility
falls on the library functions to ensure that potentially dangerous input does
not introduce a security hole. Some sort of sanitation, validation, or quoting
must be provided for **all** arguments in a function. This ensures that bad
data does not make its way into an SQL string, a filename, an executable, or
even another function.

Relying on JavaScript-based validation is nice for instant feedback to the
user, but should not replace validation checking in the PHP code.

---
Copyright (c) 2018 Cacti Group
