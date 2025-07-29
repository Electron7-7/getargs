#ifndef ARGUMENTS_H
#define ARGUMENTS_H

#include "getargs/argument.hpp"

namespace Flags
{
    static Flag Help    ("--help"    , "-h");
    static Flag Version ("--version" , "-v");

    // Flags & Options don't need both long & short names
    // static Flag OnlyShortFlag("-f");
    // static Flag OnlyLongFlag("--only-long-flag");
}

namespace Options
{
    static Option SomeOption("--some-option", "-o");
    static Option SomeOptionThatRequiresAValue("--special-option", "-s", true);

    // Flags & Options don't need both long & short names
    // static Option OnlyShortOption("-s");
    // static Option OnlyLongOption("--only-long-option");
}

constexpr const char* _Help_Printout =
R"(    Usage: getargs [-h|--help] [-v|--version] [--some-option|-o [<some_argument>]] [--special-option|-s <required_argument>]
    Options:
        -h, --help                  print help document
        -v, --version               print program version
        -o, --some-option ARG       do something with "ARG" (but don't freak out if "ARG" wasn't passed)
        -s, --special-option ARG    do something with "ARG" (and error out if "ARG" wasn't passed)

    Example:
        getargs -v
        getargs --some-option --version
        getargs --special-option "required argument"
)";

constexpr const char* _Version_Printout = "getargs v1.0.0";

#endif // ARGUMENTS_H
