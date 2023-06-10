#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Data::Message::Simple;
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
        'lang' => {
                'title' => 'Tags::HTML::Messages example',
        },
        'generator' => 'Tags::HTML::Messages',
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
my $message_ar = [
        Data::Message::Simple->new(
                'text' => 'Error #1',
                'type' => 'error',
        ),
        Data::Message::Simple->new(
                'text' => 'Error #2',
                'type' => 'error',
        ),
        Data::Message::Simple->new(
                'text' => 'Ok #1',
        ),
        Data::Message::Simple->new(
                'text' => 'Ok #2',
        ),
];

# Process page.
$messages->process_css('error', 'red');
$messages->process_css('info', 'green');
$begin->process;
$messages->process($message_ar);
$end->process;

# Print out.
print $tags->flush;

# Output:
# <!DOCTYPE html>
# <html>
#   <head>
#     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
#     <meta name="generator" content="Tags::HTML::Messages" />
#     <title>
#       Tags::HTML::Messages example
#     </title>
#     <style type="text/css">
# .error {
# 	color: red;
# }
# .info {
# 	color: green;
# }
# </style>
#   </head>
#   <body>
#     <span class="error">
#       Error #1
#     </span>
#     <span class="error">
#       Error #2
#     </span>
#     <span class="info">
#       Ok #1
#     </span>
#     <span class="info">
#       Ok #2
#     </span>
#   </body>
# </html>