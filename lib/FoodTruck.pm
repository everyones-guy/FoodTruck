package FoodTruck;

use strict;
use warnings;

# Constructor for creating a new FoodTruck object
sub new {
    my ($class, %args) = @_;

    my $self = {
        name    => $args{name}    || '',
        address => $args{address} || '',
        type    => $args{type}    || '',
        price   => $args{price}   || 0.00,
        reviews => $args{reviews} || '',
    };

    bless($self, $class);
    return $self;
}

# Getter methods for accessing object attributes
sub get_name {
    my ($self) = @_;
    return $self->{name};
}

sub get_address {
    my ($self) = @_;
    return $self->{address};
}

sub get_type {
    my ($self) = @_;
    return $self->{type};
}

sub get_price {
    my ($self) = @_;
    return $self->{price};
}

sub get_reviews {
    my ($self) = @_;
    return $self->{reviews};
}

# Setter methods for updating object attributes
sub set_name {
    my ($self, $name) = @_;
    $self->{name} = $name;
}

sub set_address {
    my ($self, $address) = @_;
    $self->{address} = $address;
}

sub set_type {
    my ($self, $type) = @_;
    $self->{type} = $type;
}

sub set_price {
    my ($self, $price) = @_;
    $self->{price} = $price;
}

sub set_reviews {
    my ($self, $reviews) = @_;
    $self->{reviews} = $reviews;
}

1;
