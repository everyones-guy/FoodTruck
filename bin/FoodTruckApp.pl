use strict;
use warnings;
use lib '../lib';
use FoodTruck;
use FoodTruckDB;
use JSON;
use LWP::UserAgent;
use DBI;

# Setup endpoint to grab JSON Data
my $api_url = 'https://data.sfgov.org/resource/rqzj-sfat.json';

# Create a User Agent
my $ua = LWP::UserAgent->new;

# Hit API
my $response = $ua->get($api_url);

# Successful?
if ($response->is_success) {
    my $json_data = $response->decoded_content();

    # Parse the JSON data
    my $trucks = decode_json($json_data);

    # Create a FoodTruckDB object to establish a database connection
    my $db = FoodTruckDB->new;

    foreach my $truck_data (@$trucks) {
        my $truck = FoodTruck->new(%$truck_data);

        # Test if the truck has an approved status
        if ($truck->get_status() && $truck->get_status() =~ /approved/i) {
            print $truck->display_info();
            
            # Insert the FoodTruck object into the database
            $db->insert_food_truck(
                $truck->get_objectid(),
                $truck->get_applicant(),
                $truck->get_facilitytype(),
                $truck->get_locationdescription(),
                $truck->get_address(),
                $truck->get_latitude(),
                $truck->get_longitude(),
                $truck->get_permit(),
                $truck->get_status()
            );
        }
    }

    # Disconnect from the database
    $db->DESTROY;
} else {
    die "Failed to retrieve data from the API: " . $response->status_line;
}

# Rest of your script remains the same
