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

    # Prompt the user to select a certified and licensed food truck
    print "Would you like to select a random certified and licensed food truck to visit (Yes/No)? ";
    my $user_input = <STDIN>;
    chomp $user_input;
 
    if (lc($user_input) eq 'yes') {
        # Create a FoodTruckDB object to establish a database connection
        my $db = FoodTruckDB->new;

        # Fill our database with the data from the API call
        $db->populate_database(@$trucks);  # Pass the $trucks array to the method

        # Get a random certified and licensed food truck
        my $food_truck = $db->get_random_food_truck();

        if ($food_truck) {
            # Create a FoodTruck object from the retrieved data
            my $truck = FoodTruck->new(%$food_truck);
        
            # Display the selected food truck
            print $truck->display_info();
        } else {
            print "No certified and licensed food trucks found in the database.\n";
        }

        # Disconnect from the database
        $db->DESTROY;
    } else {
        print "You chose not to select a food truck.\n";
    }
} else {
    die "Failed to retrieve data from the API: " . $response->status_line;
}
