#!/usr/bin/perl

# downstripped for automatic build - bodo@boone-schulz.de

# Check for Module::Build at the right version or use or own bundled one
# if the available one does not fit.
my $Minimal_MB = 0.34;

my $Installed_MB =
  `$^X -e "eval q{require Module::Build; print Module::Build->VERSION} or exit 1"`;
chomp $Installed_MB;

$Installed_MB = 0 if $?;

# Use our bundled copy of Module::Build if it's newer than the installed.
unshift @INC, "inc/Module-Build" if $Minimal_MB > $Installed_MB;

require Module::Build;
use strict;
use Data::Dumper;

my %REQS = (
            "JSON" => "2.12",
            "LWP::UserAgent" => 0,
            "URI" => "1.35",
            "Data::Dumper" => 0,
            "Getopt::Long" => 0,
            "Carp" => 0,
            "Module::Find" => 0,
            "Scalar::Util" => 0,
            "base" => 0,
            "Sys::SigAction" => 0,
            "IO::Socket::Multicast" => 0 # opt
           );

my %SCRIPTS = ();

add_script("scripts/jmx4perl" => 1);
add_script("scripts/check_jmx4perl" => 1);
# add_script("scripts/cacti_jmx4perl" => 1);
add_script("scripts/j4psh" => 1);
# add_script("scripts/jolokia" => 1);


# Add extra requirements
sub add_reqs {
    my %to_add = @_;
    for my $k (keys %to_add) {
        $REQS{$k} = $to_add{$k};
    }
}

sub add_script {
    my $script = shift;
    $SCRIPTS{$script} = 1;
}

sub y_n {
    Module::Build->y_n(@_);
}

# ================================================================================

my $build = Module::Build->new
  (
   dist_name => "jmx4perl",
   dist_version_from => "lib/JMX/Jmx4Perl.pm",
   dist_author => 'Roland Huss (roland@cpan.org)',
   dist_abstract => 'Easy JMX access to Java EE applications',
   #sign => 1,
   installdirs => 'site',
   license => 'gpl',

   requires => \%REQS,
   script_files => \%SCRIPTS,

   build_requires => {
                      "Module::Build" => "0.34",
                      "Test::More" => "0",
                     },
   configure_requires => { 'Module::Build' => 0.34 },
   keywords => [  "JMX", "JEE", "Management", "Nagios", "Java", "Jolokia", "OSGi", "Mule" ],
  );

$build->create_build_script;

# ===================================================================================
