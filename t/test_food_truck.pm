use strict;
use warnings;
use Test::More;
use FoodTruckDB;

# Initialize the database for testing
my $db = FoodTruckDB->new;

# Test inserting a food truck
subtest 'Insert Food Truck' => sub {
    my $name = 'Test Truck';
    my $address = '123 Test St';
    my $type = 'Test Cuisine';
    my $price = 10.99;
    my $reviews = 'Good food!';

    $db->insert_food_truck($name, $address, $type, $price, $reviews);

    my $truck = $db->get_food_truck_by_name($name);
    is($truck->{name}, $name, 'Name matches');
    is($truck->{address}, $address, 'Address matches');
    is($truck->{type}, $type, 'Type matches');
    is($truck->{price}, $price, 'Price matches');
    is($truck->{reviews}, $reviews, 'Reviews match');
};

# Test getting a random food truck
subtest 'Get Random Food Truck' => sub {
    my $truck = $db->get_random_food_truck();
    ok($truck, 'Got a random food truck');
};

# Clean up the database
$db->DESTROY;

done_testing;