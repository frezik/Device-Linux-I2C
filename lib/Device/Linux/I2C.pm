# Copyright (c) 2016  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
package Device::Linux::I2C;
use v5.14;
use warnings;
use Moose;
use namespace::autoclean;

require DynaLoader;
our @ISA = qw(DynaLoader);
bootstrap Device::Linux::I2C;


has 'device_path' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);
has 'address' => (
    is => 'ro',
    isa => 'Int',
    required => 1,
);
has '_fd' => (
    is => 'ro',
);


sub BUILDARGS
{
    my ($class, $args) = @_;
    my $dev = $args->{device_path};
    my $addr = $args->{address};

    if( $dev =~ /\A\d+\z/ ) {
        $dev = '/dev/i2c-' . $dev;
    }
    $args->{device_path} = $dev;

    my $fd = $class->_open_i2c_dev( $dev, $addr );
    $args->{'_fd'} = $fd;

    return $args;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

  Device::Linux::I2C - Low-level interface to the Linux i2c userspace library

=head1 SYNOPSIS

  my $i2c = Device::Linux::I2C->new({
      device_path => '/dev/i2c-1', # Or just '1'
      address => 0x4C,
  });
  my $val = $i2c->smbus_read( 0x3D ); # Read 1 byte from register 0x3D via smbus
  $i2c->smbus_write( 0x3D, 0x1FB2 ] ); # Write 0x1FB2 to register 0x3D via smbus
  $i2c->write( 0x1E ); # Write to register 0x1E
  my $val2 = $i2c->read( 1 ); # Read 1 byte

=head1 DESCRIPTION

Linux provides direct access to i2c devices in userspace. These are usually associated 
with System on a Chip computers, such as the Raspberry Pi, though nearly all PCs have a few 
i2c devices internally.  Most of these are for temperature sensors on the motherboard. 

There is also an i2c port in many standard video output connectors.  If you're so inclined, 
you may be able to hack it for general use; see: L<http://www.paintyourdragon.com/?p=43>.

Sorry, Mac and Windows are not supported. I would encourage anyone who is interested to 
come up with low-level interfaces for those OSen which follow the same API here.

=head1 METHODS

=head1 LICENSE

Copyright (c) 2016  Timm Murray
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.

=cut
