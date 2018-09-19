#!/usr/bin/perl

#########################################################################
# Author: Hechuan Yang
# Created Time: 2016-08-07 16:11:19
# File Name: submit.pl
# Description: 
#########################################################################

use strict;
use warnings;
use File::Basename;
use Getopt::Std;

my $mem_free='10';
my $openMP=1;
my $h_rt='240';

my %opts;
getopts('bm:n:q:H:N:W:o:ph',\%opts);
die("
Description:
    A wrapper for submitting jobs to a SGE cluster.
Usage:
    $0  [options]  job1.sh [job2.sh [...]]
Options:
    -b      treat JOB as binary instead of script
    -m STR  submit to compute nodes with available memory in Gb [$mem_free]
    -n INT  submit to compute nodes with available CPU [$openMP]
    -q STR  submit to queue {short,medium,long,ionode}.q
    -H STR  time limit of the job in hours [$h_rt]
    -N STR  the name of the job [SCRIPT_NAME]
    -W STR  Execute the job from the specified directory [CURRENT_DIR]
    -o STR  other parameters pass to qsub, e.g.
            '-t 1-38' for array jobs (use \$SGE_TASK_ID in your job script) [null]
    -p      just print the qsub command without running
    -h      print this help
\n") if @ARGV==0 || $opts{h};

$openMP=$opts{n} if $opts{n};
$mem_free=$opts{m} if $opts{m};
$mem_free.='G';
$h_rt=$opts{H} if $opts{H};
$h_rt.=':00:00';

my $queue_par=$opts{q}?"-q $opts{q}.q":'';
my $others=$opts{o}?$opts{o}:'';
my $work_dir=$opts{W}?$opts{W}:$ENV{'PWD'};

if($opts{b}){
    my $command=join(' ',@ARGV);
    my $qsub;
    if($opts{N}){
        $qsub="qsub -V $queue_par -pe OpenMP $openMP -l mem_free=$mem_free -l h_rt=$h_rt -N $opts{N} -wd $work_dir -b y $others $command";
    }
    else{
        $qsub="qsub -V $queue_par -pe OpenMP $openMP -l mem_free=$mem_free -l h_rt=$h_rt -wd $work_dir -b y $others $command";
    }

    if($opts{p}){
        print $qsub,"\n\n";
    }
    else{
        system($qsub)==0 or die("$?");
    }
}
else{
    for(@ARGV){
        my $job_name=$opts{N}?$opts{N}:basename($_);
        my $qsub="qsub -V $queue_par -pe OpenMP $openMP -l mem_free=$mem_free -l h_rt=$h_rt -N $job_name -wd $work_dir $others < $_";

        if($opts{p}){
            print $qsub,"\n\n";
        }
        else{
            system($qsub)==0 or die("$?");
        }
    }
}
