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

Test::LogFile - Wrapper module for testing shared logfile

=head1 SYNOPSIS

  use Test::LogFile;

  my $file = log_file;

  my $pid = fork();
  if ($pid == 0) {
    # run any worker
  }
  elsif ($pid) {
    # wait for worker
    sleep 2;
    # testing
    count_ok(
      file  => $file,
      str   => "any text for searching in logfile",
      count => 1, # count that appear str arg in logfile
      hook  => sub {
          my $line = shift;
          # other test when hitting str arg
      }
    );
  }

=head1 DESCRIPTION

Test::LogFile is testing with shared logfile.

This module aim testing worker, server, and any daemonize program with log output.

=head1 AUTHOR

Koji Takiguchi E<lt>kojiel {at} gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
