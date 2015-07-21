use strict;
use warnings;
package B::Hooks::Parser;
# ABSTRACT: Interface to perl's parser variables

use B::Hooks::OP::Check;
use parent qw/DynaLoader/;

our $VERSION = '0.14';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

sub inject {
    my ($code) = @_;

    setup();

    my $line   = get_linestr();
    my $offset = get_linestr_offset();

    substr($line, $offset, 0) = $code;

    set_linestr($line);

    return;
}

1;

__END__

=pod

=head1 DESCRIPTION

This module provides an API for parts of the perl parser. It can be used to
modify code while it's being parsed.

=head1 Perl API

=head2 C<setup()>

Does some initialization work. This must be called before any other functions
of this module if you intend to use C<set_linestr>. Returns an id that can be
used to disable the magic using C<teardown>.

=head2 C<teardown($id)>

Disables magic registered using C<setup>.

=head2 C<get_linestr()>

Returns the line the parser is currently working on, or undef if perl isn't
parsing anything right now.

=head2 C<get_linestr_offset()>

Returns the position within the current line to which perl has already parsed
the input, or -1 if nothing is being parsed currently.

=head2 C<set_linestr($string)>

Sets the line the perl parser is currently working on to C<$string>.

Note that perl won't notice any changes in the line string after the position
returned by C<get_linestr_offset>.

Throws an exception when nothing is being compiled.

=head2 C<inject($string)>

Convenience function to insert a piece of perl code into the current line
string (as returned by C<get_linestr>) at the current offset (as returned by
C<get_linestr_offset>).

=head2 C<get_lex_stuff()>

Returns the string of additional stuff resulting from recent lexing that
is being held onto by the lexer.  For example, the content of a quoted
string goes here.  Returns C<undef> if there is no such stuff.

=head2 C<clear_lex_stuff()>

Discard the string of additional stuff resulting from recent lexing that
is being held onto by the lexer.

=head1 C API

The following functions work just like their equivalent in the Perl API,
except that they can't handle embedded C<NUL> bytes in strings.

=head2 C<hook_op_check_id hook_parser_setup (pTHX)>

=head2 C<void hook_parser_teardown (hook_op_check_id id)>

=head2 C<const char *hook_parser_get_linestr (pTHX)>

=head2 C<IV hook_parser_get_linestr_offset (pTHX)>

=head2 C<void hook_parser_set_linestr (pTHX_ const char *new_value)>

=head2 C<char *hook_parser_get_lex_stuff (pTHX)>

=head2 C<void hook_parser_clear_lex_stuff (pTHX)>

=cut
