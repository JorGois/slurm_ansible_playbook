#!/usr/bin/perl -w
#
# Script takes template, prompts for variables, and outputs a configuration
#
#
# check to make sure the user specified a template and output file
#
#use Sys::Hostname

if($#ARGV!=1) {
  die("Syntax Error: makemyconfig configfile\n");
}

# take note of the file name for the template file
# and the configuration file
$TEMPLATEFILE=$ARGV[0];
$CONFIGFILE=$ARGV[1];


# read in the template
#
open(SOURCE,$TEMPLATEFILE) ||
die("Cannot open template file $TEMPLATEFILE.");
@lines=<SOURCE>;
close(SOURCE);
chomp(@lines);

# search for all the tags, and put them into the subs array
#
for($i=0;$i<=$#lines;$i++) {
  while($lines[$i]=~/(%.*?%)/g)
  {
    print "$lines[$i]\n";
    if (!exists $subs{$1}) {
      $subs{$1}="";
    }
  }
}

# prompt the user for the value of all tags,
# allowing them to press enter if a default
# value was specified in makemyconfig.conf
foreach $key (sort((keys %subs))) {

  if ($key eq '%hostname%'){
    $host = `hostname -s`;
    #chomp($host);
    $subs{$key}=$host;
  }elsif ($key eq '%cpu%'){
    $cpu = 1;#qx(less /proc/cpuinfo | grep -c processor);
    #chomp($cpu);
    $subs{$key}=$cpu;

  }elsif ($key eq '%ram%'){
    $ram = 1;#qx(free -m | grep Mem | cut -b 5-24 | xargs);
    #chomp($ram);
    $subs{$key}=$ram;
  }elsif ($key eq '%ip%'){
	 $ip = 1;#qx(ifconfig | grep "inet addr:192" | cut -c 21-32);
    #chomp($ip);
    $subs{$key}=$ip;
  }
print "$key ($subs{$key})";
}

# create the configuration file and open it for writing
open(TARGET,">$CONFIGFILE") ||
die("cannot create config file $CONFIGFILE");

# write the configuration file, substituting the proper
# values for each tag that is encountered
for($i=0;$i<=$#lines;$i++) {
  while($lines[$i]=~/(%.*?%)/g) {
    $val=$subs{$1};
    $lines[$i]=~s/$1/$val/g;
  }
  print TARGET "$lines[$i]\n";
}

# close the configuration file, script is complete.
close(TARGET);
