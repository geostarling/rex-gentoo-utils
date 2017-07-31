package Rex::Gentoo::Utils;

use Rex -base;

use Term::ANSIColor;

sub optional {
  my ( $command, $question ) = @_;

  print colored(['bold blue'], "$question [No]\n");
  print colored(['bold yellow'], "[Yy]es/[Nn]o: ");
  while  ( <STDIN> ) {
    if ( /[Yy]es/ ) {
      $command->();
      last;
    } elsif ( /[Nn]o/ || // ) {
      say "Skipping...";
      last;
    } else {
      print "Sorry, response '" . $_ =~ s/\s+$//r . "' was not understood. \n";
      print colored(['bold yellow'], '[Yy]es/[Nn]o: ');
    }
  }
}

sub _eselect {
  my ( $module, $param_name, $default_target ) = @_;
  my $desired_target = param_lookup $param_name, $default_target;
  my @available_targets = run "eselect --brief $module list";
  my $targets_count = scalar @available_targets;
  my ( $target_index ) = grep { @available_targets[$_] eq $desired_target } 0..$targets_count;

  # NOTE: targets are numbered from 1
  run "eselect $module set " . ($target_index + 1);
}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Rex::Gentoo::Install/;

 task yourtask => sub {
    Rex::Gentoo::Install::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
