use v5.14;
use warnings;
use Module::Build;

my @build_flags = (
    '-Wall',
    #'-fPIC',
);
my @link_flags = (
);

my $build = Module::Build->new(
    module_name       => 'Device::Linux::I2C',
    dist_abstract     => 'Link into the Linux i2c userspace library',
    dist_author       => q{Timm Murray <tmurray@wumpus-cave.net>},
    version           => 0.108358966260315,
    license           => 'bsd',
    needs_compiler    => 0,
    build_requires    => {
        'ExtUtils::CBuilder' => 0,
    },
    requires          => {
        perl         => '>= 5.14.0',
        'Moose'      => 0,
        'Test::More' => 0,
    },

    include_dirs         => ['.'],
    dynamic_config       => 1,
    allow_pureperl       => 0,
    extra_compiler_flags => join( ' ', @build_flags ),
    extra_linker_flags   => join( ' ', @link_flags ),

    meta_merge => {
        resources => {
            repository => 'https://github.com/frezik/Device-Linux-I2C',
        },
    },
);

$build->create_build_script;
