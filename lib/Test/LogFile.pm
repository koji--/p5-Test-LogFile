package Test::LogFile;
use strict;
use warnings;
use base qw(Exporter);
use File::Temp qw(tempfile);
use Test::More;

our $VERSION = '0.01';
our @EXPORT  = qw/
  log_file
  count_ok
  /;

sub log_file {
    my ( $fh, $filename ) = tempfile;
    return wantarray ? ( $fh, $filename ) : $filename;
}

sub count_ok {
    my %args     = @_;
    my $log_file = $args{file} or die "arg file is not found";
    my $str      = $args{str} or die "arg str is not found";
    my $count    = $args{count} or die "arg count is not found";
    my $msg      = $args{msg} || "log count is valid";
    my $hook     = $args{hook};

    open my $fh, '<', $log_file or die $!;

    my $find = 0;
    while (<$fh>) {
        my $line = $_;
        if ( $line =~ /$str/ ) {
            $find++;
            if ( $hook && ( ref $hook eq 'CODE' ) ) {
                $hook->($line);
            }
        }
    }
    is( $find, $count, $msg );
}

1;
__END__

=head1 NAME

Test::LogFile -

=head1 SYNOPSIS

  use Test::LogFile;

=head1 DESCRIPTION

Test::LogFile is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
