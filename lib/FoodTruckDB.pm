package FoodTruckDB;

use strict;
use warnings;
use DBI;

# Constructor for initializing the database connection
sub new {
    my ($class, %args) = @_;

    my $self = {
        db_file => $args{db_file} || '../data/food_truck.db',
        dbh     => undef,  # Database handle
    };

    # Connect to the database
    $self->{dbh} = DBI->connect("dbi:SQLite:dbname=$self->{db_file}", "", "", {
        RaiseError => 1,  # Automatically raise errors
        AutoCommit => 1,  # Enable auto-commit
    });

    bless($self, $class);
    return $self;
}

# Populate the database with food truck data from an array of data
sub populate_database {
    my ($self, @truck_data) = @_;

    my $insert_sql = "
        INSERT INTO food_trucks (objectid, applicant, facilitytype, locationdescription, address, latitude, longitude, permit, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ";

    my $sth = $self->{dbh}->prepare($insert_sql);

    foreach my $truck_data (@truck_data) {
        $sth->execute(
            $truck_data->{objectid},
            $truck_data->{applicant},
            $truck_data->{facilitytype},
            $truck_data->{locationdescription},
            $truck_data->{address},
            $truck_data->{latitude},
            $truck_data->{longitude},
            $truck_data->{permit},
            $truck_data->{status}
        );
    }
    return;
}

# Retrieve a random food truck from the database
sub get_random_food_truck {
    my ($self) = @_;

    my $select_random_sql = "
        SELECT objectid, applicant, facilitytype, locationdescription, address, latitude, longitude, permit, status
        FROM food_trucks
        WHERE status = 'APPROVED'
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
