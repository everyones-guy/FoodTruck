use strict;
use warnings;
use LWP::UserAgent;
use JSON::XS;
use FoodTruckDB;  # Include your FoodTruckDB module

# API URL for fetching food truck data
my $api_url = 'https://data.sfgov.org/resource/rqzj-sfat.json';

# Create a user agent object to make the HTTP request
my $ua = LWP::UserAgent->new;

# Make the API request
my $response = $ua->get($api_url);

# Check for errors in the response
unless ($response->is_success) {
    die "Failed to fetch data: " . $response->status_line;
}

# Parse the JSON response
my $json_data = decode_json($response->decoded_content);

# Create a FoodTruckDB object
my $db = FoodTruckDB->new;

# Iterate through the JSON data and insert it into the database
foreach my $truck_data (@$json_data) {
    my $name    = $truck_data->{applicant};
    my $address = $truck_data->{address};
    my $type    = $truck_data->{facilitytype};
    my $price   = $truck_data->{price};
    my $reviews = $truck_data->{reviews};

    # Insert the food truck data into the database
    $db->insert_food_truck($name, $address, $type, $price, $reviews);
}

# Clean up the database connection
$db->DESTROY;

print "Data import completed.\n";
