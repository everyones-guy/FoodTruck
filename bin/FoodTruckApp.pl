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
if ( $response->is_success ) {
    my $json_data = $response->decoded_content();

    # Parse the JSON data
    my $trucks = decode_json($json_data);

    # Prompt the user to select a certified and licensed food truck
    print
      "Discover a random certified and licensed food truck near you (Yes/No)? ";
    my $user_input = <STDIN>;
    chomp $user_input;

    if ( lc($user_input) eq 'yes' ) {

        # Create a FoodTruckDB object to establish a database connection
        my $db = FoodTruckDB->new;

        # Fill our database with the data from the API call and capture inserted objectids
        my $inserted_ids_ref = $db->populate_database(@$trucks);

        # Get a random certified and licensed food truck
        my $food_truck = $db->get_random_food_truck();

        if ($food_truck) {

            # Create a FoodTruck object from the retrieved data
            my $truck = FoodTruck->new(%$food_truck);

            # Display the selected food truck
            print "Great choice! Here's a delightful food truck near you:\n";
            print $truck->display_info();
        }
        else {
            print
"Oops! We couldn't find any certified and licensed food trucks nearby.\n";
        }

        # You can now use $inserted_ids_ref to query specific records if needed
        # Example: Fetch data for a specific objectid
        my $specific_food_truck = $db->get_food_truck_by_objectid('1660843')
          ; # can be a menu option or whatever...just want to verify i can search

        # Disconnect from the database
        $db->DESTROY;
    }
    else {
        print
"No problem! Feel free to explore food trucks whenever you're ready.\n";
    }
}
else {
    die
"Sorry, we couldn't retrieve the latest food truck information at the moment. Please try again later.";
}
