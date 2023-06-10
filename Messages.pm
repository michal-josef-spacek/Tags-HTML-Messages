package Tags::HTML::Messages;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params);
use Error::Pure qw(err);

our $VERSION = 0.03;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = $class->SUPER::new(@params);

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $message_ar, $id) = @_;

	my $num = 0;
	if (@{$message_ar}) {
		foreach my $message (@{$message_ar}) {
			if ($num) {
				$self->{'tags'}->put(
					['b', 'br'],
					['e', 'br'],
				);
			}
			$self->{'tags'}->put(
				['b', 'span'],
				['a', 'id', $id],
				['d', $message],
				['e', 'span'],
			);
		}
		$num++;
	}

	return;
}

# Process 'CSS::Struct'.
sub _process_css {
	my ($self, $id, $color) = @_;

	$self->{'css'}->put(
		['s', '#'.$id],
		['d', 'color', $color],
		['e'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Messages - Tags helper for HTML messages.

=head1 SYNOPSIS

 use Tags::HTML::Messages;

 my $obj = Tags::HTML::Messages->new(%params);
 $obj->process($message_ar, $id);
 $obj->process_css($id, $color);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Messages->new(%params);

Constructor.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($message_ar, $id);

Process Tags structure for output.

Returns undef.

=head2 C<process_css>

 $obj->process_css($id, $color);

Process CSS::Struct structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         Parameter 'css' must be a 'CSS::Struct::Output::*' class.
         Parameter 'tags' must be a 'Tags::Output::*' class.

=head1 EXAMPLE1

=for comment filename=html_page_with_messages.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Tags::HTML::Page::Begin;
 use Tags::HTML::Page::End;
 use Tags::HTML::Messages;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new(
         'preserved' => ['style'],
         'xml' => 1,
 );
 my $css = CSS::Struct::Output::Indent->new;
 my $begin = Tags::HTML::Page::Begin->new(
         'css' => $css,
         'tags' => $tags,
 );
 my $end = Tags::HTML::Page::End->new(
         'tags' => $tags,
 );
 my $messages = Tags::HTML::Messages->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Error structure.
 my $error_messages_ar = [
         'Error #1',
         'Error #2',
 ];
 my $ok_messages_ar = [
         'Ok #1',
         'Ok #2',
 ];

 # Process page.
 $messages->process_css('error', 'red');
 $messages->process_css('ok', 'green');
 $begin->process;
 $messages->process($error_messages_ar, 'error');
 $messages->process($ok_messages_ar, 'ok');
 $end->process;

 # Print out.
 print $tags->flush;

 # Output:
 # <!DOCTYPE html>
 # <html>
 #   <head>
 #     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 #     <title>
 #       Page title
 #     </title>
 #     <style type="text/css">
 # #error {
 # 	color: red;
 # }
 # #ok {
 # 	color: green;
 # }
 # </style>
 #   </head>
 #   <body>
 #     <span id="error">
 #       Error #1
 #     </span>
 #     <span id="error">
 #       Error #2
 #     </span>
 #     <span id="ok">
 #       Ok #1
 #     </span>
 #     <span id="ok">
 #       Ok #2
 #     </span>
 #   </body>
 # </html>

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Tags::HTML>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Messages>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2020-2023

BSD 2-Clause License

=head1 VERSION

0.03

=cut
