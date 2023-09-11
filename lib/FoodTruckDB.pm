package FoodTruckDB;

use strict;
use warnings;
use DBI;

# Constructor for initializing the database connection
sub new {
    my ($class) = @_;

    my $self = {
        db_file => '../data/food_truck.db',
        dbh     => undef,  # Database handle
    };

    # Connect to the database
    $self->{dbh} = DBI->connect("dbi:SQLite:dbname=$self->{db_file}", "", "");
    die "Database connection failed: " . $DBI::errstr unless $self->{dbh};

    bless($self, $class);
    return $self;
}

# Insert a food truck into the database
sub insert_food_truck {
    my ($self, $name, $address, $type, $price, $reviews) = @_;

    my $insert_sql = "
        INSERT INTO food_trucks (name, address, type, price, reviews)
        VALUES (?, ?, ?, ?, ?)
    ";
	
    $self->{dbh}->do($insert_sql, undef, $name, $address, $type, $price, $reviews);
	return;
}

# Retrieve a random food truck based on user's location
sub get_random_food_truck {
    my ($self, $user_lat, $user_lon) = @_;

    # Implement logic to calculate distances and select a random food truck
    # You can use the Haversine formula or other methods here.

    # Example: selecting a random food truck for demonstration purposes
    my $select_random_sql = "
        SELECT name, address, type, price, reviews
        FROM food_trucks
        ORDER BY RANDOM()
        LIMIT 1
    ";

    my $sth = $self->{dbh}->prepare($select_random_sql);
    $sth->execute();

    return $sth->fetchrow_hashref();
}

# Destructor to disconnect from the database when the object is destroyed
sub DESTROY {
    my ($self) = @_;

    if ($self->{dbh}) {
        $self->{dbh}->disconnect();
    }
	return;
}

1;
