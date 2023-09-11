use strict;
use warnings;
use Test::More tests => 12;
use lib '../lib';
use FoodTruck;

# Test data
my %food_truck_data = (
    objectid           => 1,
    applicant          => 'Food Truck 1',
    facilitytype       => 'Mobile Food Facility',
    locationdescription => 'Downtown Square',
    address            => '123 Main St',
    latitude           => 37.123456,
    longitude          => -121.654321,
    permit             => '12345',
    status             => 'Approved',
);

# Create a FoodTruck object
my $food_truck = FoodTruck->new(%food_truck_data);  # Use FoodTruck module

# Test the constructor and getter methods
is($food_truck->get_objectid, 1, 'get_objectid');
is($food_truck->get_applicant, 'Food Truck 1', 'get_applicant');
is($food_truck->get_facilitytype, 'Mobile Food Facility', 'get_facilitytype');
is($food_truck->get_locationdescription, 'Downtown Square', 'get_locationdescription');
is($food_truck->get_address, '123 Main St', 'get_address');
is($food_truck->get_latitude, 37.123456, 'get_latitude');
is($food_truck->get_longitude, -121.654321, 'get_longitude');
is($food_truck->get_permit, '12345', 'get_permit');
is($food_truck->get_status, 'Approved', 'get_status');

# Test setter methods
$food_truck->set_objectid(2);
$food_truck->set_applicant('Food Truck 2');
$food_truck->set_facilitytype('Food Cart');
$food_truck->set_locationdescription('City Park');
$food_truck->set_address('456 Elm St');
$food_truck->set_latitude(38.789012);
$food_truck->set_longitude(-122.987654);
$food_truck->set_permit('67890');
$food_truck->set_status('Pending');

is($food_truck->get_objectid, 2, 'set_objectid');
is($food_truck->get_applicant, 'Food Truck 2', 'set_applicant');
is($food_truck->get_facilitytype, 'Food Cart', 'set_facilitytype');
is($food_truck->get_locationdescription, 'City Park', 'set_locationdescription');
is($food_truck->get_address, '456 Elm St', 'set_address');
is($food_truck->get_latitude, 38.789012, 'set_latitude');
is($food_truck->get_longitude, -122.987654, 'set_longitude');
is($food_truck->get_permit, '67890', 'set_permit');
is($food_truck->get_status, 'Pending', 'set_status');

done_testing();
