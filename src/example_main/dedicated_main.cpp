#include "argument_parser/argument_parser.hpp"
#include "arguments.hpp"

#include <cstdio>

// You could (and probably should) write a specialized function/class for handling arguments; I'm using the main function as an example.
int main(int argc, char** argv)
{
    // Add valid flags
    global_ArgumentParser->AddFlag(&Flags::Help);
    global_ArgumentParser->AddFlag(&Flags::Version);

    // Add valid options
    // global_ArgumentParser->AddOption(&Options::SomeOption);

    // Parse all arguments
    int parser_status = global_ArgumentParser->ParseArguments(argc, argv);

    if(parser_status == ARG_STATUS_FAILED)
        return 1;

    if(Flags::Help.IsActive())
    {
        printf("%s\n    %s\n", _Help_Printout, _Version_Printout);
        return 0;
    }

    if(Flags::Version.IsActive())
    {
        printf("    %s\n", _Version_Printout);
        return 0;
    }

    return 0;
}
