use strict;
use warnings;

use Data::Message::Simple;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Messages;
use Tags::Output::Structure;
use Test::MockObject;
use Test::More 'tests' => 8;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
my $message_ar = [
	Data::Message::Simple->new(
		'text' => 'This is message.',
	),
];
$obj->process($message_ar);
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'span'],
		['a', 'class', 'info'],
		['d', 'This is message.'],
		['e', 'span'],
	],
	'One message.',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
$message_ar = [
	Data::Message::Simple->new(
		'text' => 'This is message.',
	),
	Data::Message::Simple->new(
		'text' => 'Error message.',
		'type' => 'error',
	),
];
$obj->process($message_ar);
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'span'],
		['a', 'class', 'info'],
		['d', 'This is message.'],
		['e', 'span'],
		['b', 'br'],
		['e', 'br'],
		['b', 'span'],
		['a', 'class', 'error'],
		['d', 'Error message.'],
		['e', 'span'],
	],
	'Two message one info, second error.',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
$message_ar = [];
$obj->process($message_ar);
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[],
	'No messages.',
);

# Test.
$obj = Tags::HTML::Messages->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n",
	"Parameter 'tags' isn't defined.");
clean();

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
eval {
	$obj->process('foo');
};
is($EVAL_ERROR, "Bad list of messages.\n",
	"Bad list of messages.");
clean();

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
eval {
	$obj->process(['foo']);
};
is($EVAL_ERROR, "Bad message data object.\n",
	"Bad message data object.");
clean();

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Messages->new(
	'tags' => $tags,
);
my $test_obj = Test::MockObject->new;
eval {
	$obj->process([$test_obj]);
};
is($EVAL_ERROR, "Bad message data object.\n",
	"Bad message data object.");
clean();