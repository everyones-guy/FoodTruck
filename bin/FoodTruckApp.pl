use strict;
use warnings;
use FoodTruck;
use JSON;           
use LWP::UserAgent; 

# Setup endpoint
my $api_url = 'https://Whatever.com/api/foodtrucks'; #update with actual url

# Create a User
my $ua = LWP::UserAgent->new;

# Hit API
my $response = $ua->get($api_url);

# Successful?
if ($response->is_success) {
    my $json_data = $response->decoded_content;

    # Grab the data and parse
    my $trucks = decode_json($json_data);

    foreach my $truck_data (@$trucks) {
        my $truck = FoodTruck->new(%$truck_data);

        # Test if we're displaying the correct data
        print $truck->display_info();
    }
} else {
    die "Failed to retrieve data from the API: " . $response->status_line;
}
