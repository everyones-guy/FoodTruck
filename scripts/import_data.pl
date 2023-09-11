use strict;
use warnings;
use LWP::UserAgent;
use JSON::XS;
use FoodTruckDB;    # Include your FoodTruckDB module

# API URL for fetching food truck data
my $api_url = 'https://data.sfgov.org/resource/rqzj-sfat.json';

# Create a user agent object to make the HTTP request
my $ua = LWP::UserAgent->new;

# Make the API request
my $response = $ua->get($api_url);

# Check for errors in the response
unless ( $response->is_success ) {
    die "Failed to fetch data: " . $response->status_line;
}

# Parse the JSON response
my $json_data = decode_json( $response->decoded_content );

# Create a FoodTruckDB object
my $db = FoodTruckDB->new;

# Iterate through the JSON data and insert it into the database
foreach my $truck_data (@$json_data) {
    my $objectid           = $truck_data->{objectid};
    my $applicant          = $truck_data->{applicant};
    my $facilitytype       = $truck_data->{facilitytype};
    my $locationdescription = $truck_data->{locationdescription};
    my $address            = $truck_data->{address};
    my $latitude           = $truck_data->{latitude};
    my $longitude          = $truck_data->{longitude};
    my $permit             = $truck_data->{permit};
    my $status             = $truck_data->{status};

    # Insert the food truck data into the database
    $db->insert_food_truck(
        $objectid, $applicant, $facilitytype, $locationdescription,
        $address, $latitude, $longitude, $permit, $status
    );
}

# Clean up the database connection
$db->DESTROY;

print "Data import completed.\n";
