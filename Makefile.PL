use strict;
use warnings;
use ExtUtils::MakeMaker::Dist::Zilla::Develop;
use ExtUtils::Depends;

my $pkg = ExtUtils::Depends->new('B::Hooks::Parser', 'B::Hooks::OP::Check');
$pkg->install('hook_parser.h');
$pkg->add_xs('Parser.xs');
$pkg->add_pm('lib/B/Hooks/Parser.pm' => '$(INST_LIB)/B/Hooks/Parser.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

WriteMakefile(
    NAME => 'B::Hooks::Parser',
    VERSION_FROM => 'lib/B/Hooks/Parser.pm',
    INSTALLMAN1DIR => 'none',
    INSTALLMAN3DIR => 'none',
    $pkg->get_makefile_vars,
    FUNCLIST => [ qw/hook_parser_setup hook_parser_teardown hook_parser_get_linestr
        hook_parser_get_linestr_offset hook_parser_set_linestr hook_parser_get_lex_stuff
        hook_parser_clear_lex_stuff hook_toke_skipspace hook_toke_scan_str hook_toke_scan_word
        /,
        'boot_B__Hooks__Parser',
    ],
);
