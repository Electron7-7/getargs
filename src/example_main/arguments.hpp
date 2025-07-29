#ifndef ARGUMENTS_H
#define ARGUMENTS_H

#include "argument_parser/argument.hpp"

namespace Flags
{
    static Flag Help    ("--help"    , "-h");
    static Flag Version ("--version" , "-v");
}

namespace Options
{
    // static Option SomeOption("--some-option", "-o");
}

constexpr const char* _Help_Printout =
R"(Usage: getargs [-h|--help] [-v|--version]
    Options:
        -h, --help      print help document
        -v, --version   print program version

    Example:
        getargs
)";

constexpr const char* _Version_Printout = "getargs v1.0.0";

#endif // ARGUMENTS_H
