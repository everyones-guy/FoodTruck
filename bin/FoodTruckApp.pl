use strict;
use warnings;
use lib '../lib';
use FoodTruck;
use JSON;           
use LWP::UserAgent;

use Data::Dumper;

# Setup endpoint to grab json Data
my $api_url = 'https://data.sfgov.org/resource/rqzj-sfat.json';


# Create a User
my $ua = LWP::UserAgent->new;

# Hit API
my $response = $ua->get($api_url);

# Successful?
if ($response->is_success) {
    my $json_data = $response->decoded_content();

    # Grab the data and parse
    my $trucks = decode_json($json_data);

    foreach my $truck_data (@$trucks) {
        my $truck = FoodTruck->new(%$truck_data);

        # Test if we're displaying the correct data		
		if( $truck->{'status'} =~ /approved/i){
			print $truck->display_info();
		}
	}	
} else {
    die "Failed to retrieve data from the API: " . $response->status_line;
}

=pod
We have our data, now it is time to do something fun with it. 

We can set up a randomizer and have it query the end user to see what their preferences are and suggest food trucks that they may like. 

We could use the food trucks' locations along with the end user's geo tag and find something close. 

If we're actively looking for food, then we should only be looking at food trucks with approved statuses.

If we want to see someone that is up and coming then we weill need to look for pending.

If we want to see what happened to that old food truck we loved so much and is nowhere to be found, we'll need to know status and actively look around for any news.
=cut
