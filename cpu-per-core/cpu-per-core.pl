#!/usr/bin/perl -w
# -*- cperl -*-

=head1 NAME

cpu_per_core - plugin to monitor CPU usage for each CPU core

=head1 CONFIGURATION


=head1 NOTES

modified to not require JSON

=head1 AUTHOR

Matija Grabnar
Tom Gordon

=head1 LICENSE

GPLv2

=head1 MAGIC MARKERS

 #%# family=system
 #%# capabilities=autoconf

=cut

use strict;
use Munin::Plugin;

my $cache = "/tmp/cpu_per_core.json";

my( $cpu,
    $user,
    $nice,
    $system,
    $idle,
    $iowait,
    $irq,
    $softirq,
    $steal,
    $guest,
    $guest_nice);
my @cpu;

sub print_values {
  print "multigraph cpu_per_core\n";
  open(INP,"<","/proc/stat") || die "Can not open /proc/stat/: $!\n";
  while (<INP>) {
    next unless /^cpu(\d+)\s+(\d+)(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?\s+/;
    $cpu     = $1;
    $user    = $2;
    $nice    = $3 || 0;
    $system  = $4 || 0;
    $idle    = $5 || 0;
    $iowait  = $6 || 0;
    $irq     = $7 || 0;
    $softirq = $8 || 0;
    $steal   = $9 || 0;
    $guest   = $10 || 0;
    $guest_nice = $11 || 0;
    push(@cpu,{
	       cpu     => $1,
	       user    => $2,
	       nice    => $3 || 0,
	       system  => $4 || 0,
	       idle    => $5 || 0,
	       iowait  => $6 || 0,
	       irq     => $7 || 0,
	       softirq => $8 || 0,
	       steal   => $9 || 0,
	       guest   => $10 || 0,
	       guest_nice => $11 || 0,
	      });
    $user = $cpu[$cpu]->{user};
    $nice = $cpu[$cpu]->{nice};
    $system = $cpu[$cpu]->{system};
    $idle = $cpu[$cpu]->{idle};
    $iowait = $cpu[$cpu]->{iowait};
    $irq = $cpu[$cpu]->{irq};
    $softirq = $cpu[$cpu]->{softirq};
    $steal = $cpu[$cpu]->{steal};
    $guest = $cpu[$cpu]->{guest};
    $guest_nice = $cpu[$cpu]->{guest_nice};
    my $usage = int(100-100*($idle/($user+$nice+$system+$idle+$iowait+
				    $irq+$softirq+$steal+$guest+$guest_nice)));
    print sprintf "cpu%d_usage.value %d\n",$cpu,$usage;
  }

  foreach my $cpu (sort {$a->{cpu}<=>$b->{cpu}} @cpu) {
  	$user       = $cpu->{user};
  	$nice       = $cpu->{nice};
  	$system     = $cpu->{system};
  	$idle       = $cpu->{idle};
  	$iowait     = $cpu->{iowait};
  	$irq        = $cpu->{irq};
  	$softirq    = $cpu->{softirq};
  	$steal      = $cpu->{steal};
  	$guest      = $cpu->{guest};
  	$guest_nice = $cpu->{guest_nice};
    my $total = $user + $nice + $system + $idle + $iowait + $irq +
      $softirq + $steal + $guest + $guest_nice;

    my $factor = 100/$total;

    print sprintf "multigraph cpu_per_core.cpu%d\n",$cpu->{cpu};
    print sprintf "cpu%d_system.value %3.6f\n",$cpu->{cpu},$system * $factor;
    print sprintf "cpu%d_user.value %3.6f\n",$cpu->{cpu},$user * $factor;
    print sprintf "cpu%d_nice.value %3.6f\n",$cpu->{cpu},$nice * $factor;
    print sprintf "cpu%d_idle.value %3.6f\n",$cpu->{cpu},$idle * $factor;
    print sprintf "cpu%d_iowait.value %3.6f\n",$cpu->{cpu},$iowait * $factor;
    print sprintf "cpu%d_irq.value %3.6f\n",$cpu->{cpu},$irq * $factor;
    print sprintf "cpu%d_softirq.value %3.6f\n",$cpu->{cpu},$softirq * $factor;
    print sprintf "cpu%d_steal.value %3.6f\n",$cpu->{cpu},$steal * $factor;
    print sprintf "cpu%d_guest.value %3.6f\n",$cpu->{cpu},$guest * $factor;
    print sprintf "cpu%d_guest_nice.value %3.6f\n",$cpu->{cpu},$guest_nice
       * $factor;
  }

}

need_multigraph();

$ARGV[0]='' unless defined($ARGV[0]);

if ( $ARGV[0] eq "autoconf" ) {
  if (open(INP,"<","/proc/stat")) {
    print "yes\n";
    exit 0;
  } else {
    print "no\n";
    exit 0;
  }
}

if ( $ARGV[0] eq "config" ) {

  # The headers
  print "multigraph cpu_per_core\n";
  print "graph_info Monitoring CPU per core\n";
  print "graph_title CPU per Core usage\n";
  print "graph_vlabel %\n";
  print "graph_category system\n";
  print "graph_scale no\n";
  print "graph_args --upper-limit 100 --lower-limit 0 --rigid\n";
  print "graph_vlabel %\n";

    open(INP,"<","/proc/stat") || die "Can not open /proc/stat/: $!\n";
  while (<INP>) {
    next unless /^cpu(\d+)\s+(\d+)(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?(\s+\d+)?\s+/;
    $cpu     = $1;
    $user    = $2;
    $nice    = $3 || 0;
    $system  = $4 || 0;
    $idle    = $5 || 0;
    $iowait  = $6 || 0;
    $irq     = $7 || 0;
    $softirq = $8 || 0;
    $steal   = $9 || 0;
    $guest   = $10 || 0;
    $guest_nice = $11 || 0;
    push(@cpu,{
	       cpu     => $1,
	       user    => $2,
	       nice    => $3 || 0,
	       system  => $4 || 0,
	       idle    => $5 || 0,
	       iowait  => $6 || 0,
	       irq     => $7 || 0,
	       softirq => $8 || 0,
	       steal   => $9 || 0,
	       guest   => $10 || 0,
	       guest_nice => $11 || 0,
	      });
    print "cpu${cpu}_usage.label CPU core $cpu - % busy\n";
    print "cpu${cpu}_usage.type GAUGE\n";
    print "cpu${cpu}_usage.max 100\n";
    print "cpu${cpu}_usage.warning 0:85\n";
    print "cpu${cpu}_usage.critical 0:90\n";
  }

  foreach my $cpu (sort {$a->{cpu}<=>$b->{cpu}} @cpu) {
    print sprintf "multigraph cpu_per_core.cpu%d\n",$cpu->{cpu};
    print sprintf "graph_info CPU core %d\n",$cpu->{cpu};
    print sprintf "graph_title CPU core %d usage\n",$cpu->{cpu};
    print "graph_scale no\n";
    print "graph_args --upper-limit 100 --lower-limit 0 --rigid\n";
    print "graph_vlabel %\n";
    print "graph_category mandarina\n";

    print sprintf "cpu%d_system.label system\n",$cpu->{cpu};    
    print sprintf "cpu%d_system.draw AREA\n",$cpu->{cpu};
    print sprintf "cpu%d_system.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_system.info CPU time spent in system state\n",$cpu->{cpu};

    print sprintf "cpu%d_user.label user\n",$cpu->{cpu};
    print sprintf "cpu%d_user.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_user.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_user.info CPU time spent in user state\n",$cpu->{cpu};

    print sprintf "cpu%d_nice.label nice\n",$cpu->{cpu};
    print sprintf "cpu%d_nice.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_nice.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_nice.info CPU time spent in nice state\n",$cpu->{cpu};

    print sprintf "cpu%d_idle.label idle\n",$cpu->{cpu};
    print sprintf "cpu%d_idle.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_idle.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_idle.info CPU time spent in idle state\n",$cpu->{cpu};

    print sprintf "cpu%d_iowait.label iowait\n",$cpu->{cpu};
    print sprintf "cpu%d_iowait.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_iowait.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_iowait.info CPU time spent in iowait state\n",$cpu->{cpu};

    print sprintf "cpu%d_irq.label irq\n",$cpu->{cpu};
    print sprintf "cpu%d_irq.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_irq.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_irq.info CPU time spent in irq state\n",$cpu->{cpu};

    print sprintf "cpu%d_softirq.label softirq\n",$cpu->{cpu};
    print sprintf "cpu%d_softirq.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_softirq.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_softirq.info CPU time spent in softirq state\n",$cpu->{cpu};

    print sprintf "cpu%d_steal.label steal\n",$cpu->{cpu};
    print sprintf "cpu%d_steal.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_steal.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_steal.info CPU time spent in steal state\n",$cpu->{cpu};

    print sprintf "cpu%d_guest.label guest\n",$cpu->{cpu};
    print sprintf "cpu%d_guest.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_guest.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_guest.info CPU time spent in guest state\n",$cpu->{cpu};

    print sprintf "cpu%d_guest_nice.label guest_nice\n",$cpu->{cpu};
    print sprintf "cpu%d_guest_nice.draw STACK\n",$cpu->{cpu};
    print sprintf "cpu%d_guest_nice.type GAUGE\n",$cpu->{cpu};
    print sprintf "cpu%d_guest_nice.info CPU time spent in guest_nice state\n",$cpu->{cpu};
  }

  exit 0;
}

print_values();
