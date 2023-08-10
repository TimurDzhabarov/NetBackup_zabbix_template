# !/bin/sh -- #use perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
  if 0;

use strict;

    my @job_type = (0,1);       # Backup or Archive
    my @job_status = (0,1,2,4); # Queued, active, requested, suspended

    my @job_list = `/usr/bin/sudo /usr/openv/netbackup/bin/admincmd/bpdbjobs -report -most_columns`;
    foreach my $l (@job_list) {
        my @f = split /,/,$l;
        next if $#f < 10;
        next if ($f[1] eq "");
        next if ($f[2] eq "");
        next if ($f[9] eq "");
        ## Find backup job that active more than 96 hours (345600 seconds)
        if ((grep /^$f[1]$/, @job_type) && ( grep /^$f[2]$/, @job_status) && ($f[9] > 86400)) {
            my $h = int($f[9]/3600);
            print "Job ID $f[0], policy \"$f[4]\" is active for more than $h hours on client \"$f[6]\"\n";
        }
    }
