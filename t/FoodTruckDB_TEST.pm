use strict;
use warnings;
use Test::More tests => 8;
use lib '../lib';
use FoodTruckDB;

# Create a FoodTruckDB object with a temporary database file
my $db_file = 'test_food_trucks.db';
my $food_truck_db = FoodTruckDB->new(db_file => $db_file);

# Test database initialization
ok($food_truck_db, 'Database object created successfully');

# Test database population
my @test_data = (
    {
        objectid           => 1,
        applicant          => 'Truck 1',
        facilitytype       => 'Mobile',
        locationdescription => 'Downtown',
        address            => '123 Main St',
        latitude           => 37.123456,
        longitude          => -121.654321,
        permit             => 'ABC123',
        status             => 'APPROVED',
    },
    {
        objectid           => 2,
        applicant          => 'Truck 2',
        facilitytype       => 'Cart',
        locationdescription => 'Park',
        address            => '456 Elm St',
        latitude           => 38.789012,
        longitude          => -122.987654,
        permit             => 'XYZ789',
        status             => 'APPROVED',
    },
);

my $inserted_ids_ref = $food_truck_db->populate_database(@test_data);

is(scalar(@$inserted_ids_ref), 2, 'Database populated successfully');

# Test fetching a random food truck
my $random_food_truck = $food_truck_db->get_random_food_truck();
ok($random_food_truck, 'Random food truck fetched successfully');

# Test fetching a food truck by objectid
my $objectid_to_fetch = $inserted_ids_ref->[0];
my $retrieved_food_truck = $food_truck_db->get_food_truck_by_objectid($objectid_to_fetch);

ok($retrieved_food_truck, 'Food truck fetched by objectid successfully');
is($retrieved_food_truck->{objectid}, $objectid_to_fetch, 'Correct food truck fetched by objectid');

# Clean up by destroying the database object
undef $food_truck_db;

# Remove the temporary database file
unlink $db_file;

done_testing();
