package FoodTruck;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {
        objectid           => $args{objectid},
        applicant          => $args{applicant},
        facilitytype       => $args{facilitytype},
        locationdescription => $args{locationdescription},
        address            => $args{address},
        latitude           => $args{latitude},
        longitude          => $args{longitude},
        permit             => $args{permit},
        status             => $args{status},
    };
    bless($self, $class);
    return $self;
}

# accessors
sub objectid {
    my ($self) = @_;
    return $self->{objectid};
}

sub applicant {
    my ($self) = @_;
    return $self->{applicant};
}

sub facilitytype {
    my ($self) = @_;
    return $self->{facilitytype};
}

sub locationdescription {
    my ($self) = @_;
    return $self->{locationdescription};
}

sub address {
    my ($self) = @_;
    return $self->{address};
}

sub latitude {
    my ($self) = @_;
    return $self->{latitude};
}

sub longitude {
    my ($self) = @_;
    return $self->{longitude};
}

sub permit {
    my ($self) = @_;
    return $self->{permit};
}

sub status {
    my ($self) = @_;
    return $self->{status};
}

sub display_info {
    my ($self) = @_;
    my $info = "";

    foreach my $property (sort keys %$self) {
        my $value = $self->{$property};
        if (defined $value) {
            $info .= "$property: $value\n";
        } else {
            $info .= "Warning: Missing Property: '$property' at " . __PACKAGE__ . " Line " . __LINE__ . "\n";
        }
    }

    return $info;
}


1;
