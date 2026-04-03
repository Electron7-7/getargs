# getargs
A simple C++ header-only library for easily parsing command line arguments. Querying the version can be done via three pre-processor definitions: `GETARGS_VERSION_MAJOR`, `GETARGS_VERSION_MINOR`, and `GETARGS_VERSION_PATCH`.

## Index
- [Function Reference](#function-reference)
  - [set_valid_args](#void-set_valid_argsargs-inargs)
  - [get_args](#int-get_argsint-const-argc-char-const-argv)
  - [get_bad_arg](#const-getargs_string_t-get_bad_arg)
  - [get_flag](#bool-get_flagconst-getargs_string_t)
  - [get_option](#bool-get_optionconst-getargs_string_t-getargs_string_t)
  - [get_option](#const-getargs_string_t-get_optionconst-getargs_string_t)
  - [argument_exists](#bool-argument_existsconst-getargs_string_t)
  - [option_has_value](#bool-option_has_valueconst-getargs_string_t)
- [Pre-Processor Definition Reference](#pre-processor-definition-reference)
  - [GETARGS_IMPLEMENTATION](#getargs_implementation)
  - [GETARGS_NAMESPACE_NAME_OVERRIDE](#getargs_namespace_name_override)
  - [GETARGS_HANDLE_HELP_FLAG](#getargs_handle_help_flag)
  - [GETARGS_EXIT_ON_HELP](#getargs_exit_on_help)
  - [GETARGS_LONG_HELP_FLAG](#getargs_long_help_flag)
  - [GETARGS_SHORT_HELP_FLAG](#getargs_short_help_flag)
  - [GETARGS_HELP_PRINTOUT](#getargs_help_printout)
  - [GETARGS_HANDLE_VERSION_FLAG](#getargs_handle_version_flag)
  - [GETARGS_EXIT_ON_VERSION](#getargs_exit_on_version)
  - [GETARGS_LONG_VERSION_FLAG](#getargs_long_version_flag)
  - [GETARGS_SHORT_VERSION_FLAG](#getargs_short_version_flag)
  - [GETARGS_VERSION_PRINTOUT](#getargs_version_printout)
  - [GETARGS_HANDLE_INVALID_ARGS](#getargs_handle_invalid_args)
  - [GETARGS_EXIT_ON_INVALID_ARG](#getargs_exit_on_invalid_arg)
  - [GETARGS_STRING_t](#getargs_string_t)
  - [GETARGS_MAP_t](#getargs_map_t)
  - [GETARGS_SET_t](#getargs_set_t)
  - [GETARGS_VECTOR_t](#getargs_vector_t)
  - [GETARGS_SAMEAS_c](#getargs_sameas_c)
  - [GETARGS_CONVERTIBLE_TO_c](#getargs_convertible_to_c)

<br>

# Function Reference
### template<[String_t]()... Args> void set_valid_args(Args...)
### int get_args(int const& argc, char** const& argv)
Parses command-line arguments from `argv`, initializes the parsed argument containers, and returns a status indicator (`0` if successful). See [`GETARGS_HANDLE_HELP_FLAG`](#getargs_handle_help_flag), [`GETARGS_HANDLE_VERSION_FLAG`](#getargs_handle_version_flag), and [`GETARGS_HANDLE_INVALID_ARGS`](#getargs_handle_invalid_args) for more information on other return values.

---
### const [GETARGS_STRING_t](#getargs_string_t) get_bad_arg()
Requires [`GETARGS_HANDLE_INVALID_ARGS`] to be defined. If an invalid argument is parsed during [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv), **getargs::get_bad_arg** will return the invalid argument. Otherwise, an empty [GETARGS_STRING_t](#getargs_string_t) will be returned instead.

---
### bool get_flag(const [GETARGS_STRING_t](#getargs_string_t)&)
Returns `true` if the flag was called in the command line, and `false` if not.

---
### bool get_option(const [GETARGS_STRING_t](#getargs_string_t)&, [GETARGS_STRING_t](#getargs_string_t)&)
If the option was called in the command line, the output [GETARGS_STRING_t](#getargs_string_t) argument will be set to the value assigned to the option and the function will return `true`. Otherwise, the argument is untouched and `false` is returned.

---
### const [GETARGS_STRING_t](#getargs_string_t)& get_option(const [GETARGS_STRING_t](#getargs_string_t)&)
If the option was called in the command line, the value assigned to the option will be returned. Otherwise, an empty [GETARGS_STRING_t](#getargs_string_t) is returned instead.

---
### bool argument_exists(const [GETARGS_STRING_t](#getargs_string_t)&)
Returns `true` if the argument was called in the command line. If an option was called but no value was given, this will still return `true`. Returns `false` otherwise.

---
### bool option_has_value(const [GETARGS_STRING_t](#getargs_string_t)&)
Returns `true` if the option was called in the command line _and_ a value was assigned to it. Returns `false` otherwise.

<br>

# Pre-Processor Definition Reference
### GETARGS_IMPLEMENTATION
Must be defined before including the library.

---
### GETARGS_NAMESPACE_NAME_OVERRIDE
Overrides the library's namespace name, which is `getargs` by default.

---
### GETARGS_HANDLE_HELP_FLAG
Enables the handling of arguments matching [`GETARGS_LONG_HELP_FLAG`](#getargs_long_version_flag) and, if it's been defined, [`GETARGS_SHORT_HELP_FLAG`](#getargs_short_version_flag). By default, handling is done by printing [`GETARGS_HELP_PRINTOUT`](#getargs_help_printout), and returning `getargs::HELP_CALLED` from [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv) which has had its return value changed from `int` to [`getargs::Status`](getargs.hpp#L119).

---
### GETARGS_EXIT_ON_HELP
If [`GETARGS_HANDLE_HELP_FLAG`](#getargs_handle_help_flag) is defined, handling is instead done by exiting the program via [`exit(0);`](getargs.hpp#L256) after the printout.

---
### GETARGS_LONG_HELP_FLAG
If [`GETARGS_HANDLE_HELP_FLAG`](#getargs_handle_help_flag) is defined, arguments are matched against **GETARGS_LONG_HELP_FLAG** during [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv) to determine whether or not the help flag has appeared. By default, this is set to `"--help"`.

---
### GETARGS_SHORT_HELP_FLAG
If [`GETARGS_HANDLE_HELP_FLAG`](#getargs_handle_help_flag) is defined, arguments are _also_ matched against **GETARGS_SHORT_HELP_FLAG** during [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv) to determine whether or not the help flag has appeared. By default, this is undefined and not used.

---
### GETARGS_HELP_PRINTOUT
If [`GETARGS_HANDLE_HELP_FLAG`](#getargs_handle_help_flag) is defined, **GETARGS_HELP_PRINTOUT** will be printed to the console when the help flag has been parsed.

---
### GETARGS_HANDLE_VERSION_FLAG
Enables the handling of arguments matching [`GETARGS_LONG_VERSION_FLAG`](#getargs_long_version_flag) and, if it's been defined, [`GETARGS_SHORT_VERSION_FLAG`](#getargs_short_version_flag). By default, handling is done by printing [`GETARGS_VERSION_PRINTOUT`](#getargs_help_printout), and returning `getargs::VERSION_CALLED` from [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv), which has had its return value changed from `int` to [`getargs::Status`](getargs.hpp#L119).

---
### GETARGS_EXIT_ON_VERSION
If [`GETARGS_HANDLE_VERSION_FLAG`](#getargs_handle_version_flag) is defined, handling is instead done by exiting the program via [`exit(0);`](getargs.hpp#L267) after the printout.

---
### GETARGS_LONG_VERSION_FLAG
If [`GETARGS_HANDLE_VERSION_FLAG`](#getargs_handle_version_flag) is defined, arguments are matched against **GETARGS_LONG_VERSION_FLAG** during [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv) to determine whether or not the version flag has appeared. By default, this is set to `"--version"`.

---
### GETARGS_SHORT_VERSION_FLAG
If [`GETARGS_HANDLE_VERSION_FLAG`](#getargs_handle_version_flag) is defined, arguments are _also_ matched against **GETARGS_SHORT_VERSION_FLAG** during [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv) to determine whether or not the version flag has appeared. By default, this is undefined and not used.

---
### GETARGS_VERSION_PRINTOUT
If [`GETARGS_HANDLE_VERSION_FLAG`](#getargs_handle_version_flag) is defined, **GETARGS_VERSION_PRINTOUT** will be printed to the console when the help flag has been parsed.

---
### GETARGS_HANDLE_INVALID_ARGS
Enables the handling of invalid arguments. Now, before arguments can be parsed, valid arguments must be passed to [`getargs::set_valid_args`](#void-set_valid_argsargs-inargs). By default, handling is done by printing [an error message to `stderr`](getargs.hpp#L240), and returning `getargs::INVALID_ARGUMENT` from [`getargs::get_args`](#int-get_argsint-const-argc-char-const-argv), which has had its return value changed from `int` to [`getargs::Status`](getargs.hpp#L119).

---
### GETARGS_EXIT_ON_INVALID_ARG
If [`GETARGS_HANDLE_INVALID_ARGS`](#getargs_handle_invalid_args) is defined, handling is instead done by exiting the program via `exit(-1);` after the printout.

---
### GETARGS_STRING_t
Defines the class used to handle strings. By default, this is set to [`std::string`](getargs.hpp#L82)

---
### GETARGS_MAP_t
Defines the class used to handle maps. By default, this is set to [`std::map`](getargs.hpp#L87)

---
### GETARGS_SET_t
Defines the class used to handle sets. By default, this is set to [`std::set`](getargs.hpp#L92)

---
### GETARGS_VECTOR_t
Defines the class used to handle vectors. By default, this is set to [`std::vector`](getargs.hpp#L97)

---
### GETARGS_SAMEAS_c
Defines one of the [constraints](https://en.cppreference.com/w/cpp/language/constraints.html) used by [`getargs::set_valid_args`](#void-set_valid_argsargs-inargs) when [`GETARGS_HANDLE_INVALID_ARGS`](#getargs_handle_invalid_args) is defined. By default, this is set to [`std::same_as<T, U>`](getargs.hpp#L103)

---
### GETARGS_CONVERTIBLE_TO_c
Defines one of the [constraints](https://en.cppreference.com/w/cpp/language/constraints.html) used by [`getargs::set_valid_args`](#void-set_valid_argsargs-inargs) when [`GETARGS_HANDLE_INVALID_ARGS`](#getargs_handle_invalid_args) is defined. By default, this is set to [`std::convertible_to<From, To>`](getargs.hpp#L108)
