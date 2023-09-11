package FoodTruckDB;

use strict;
use warnings;
use DBI;
use Data::Dumper;

# Constructor for initializing the database connection
sub new {
    my ($class, %args) = @_;

    my $self = {
        db_file => $args{db_file} || '../data/food_trucks.db',
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

    # SQL statement to create the food_trucks table
    my $create_table_sql = <<SQL;
    CREATE TABLE IF NOT EXISTS food_trucks (
        objectid INTEGER PRIMARY KEY,
        applicant TEXT,
        facilitytype TEXT,
        locationdescription TEXT,
        address TEXT,
        latitude DECIMAL(8, 6),
        longitude DECIMAL(9, 6),
        permit TEXT,
        status TEXT
    );
SQL

    $self->{dbh}->do($create_table_sql);

    my $insert_sql = <<SQL;
        INSERT INTO food_trucks (objectid, applicant, facilitytype, locationdescription, address, latitude, longitude, permit, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
SQL

    my $sth = $self->{dbh}->prepare($insert_sql);

    my @inserted_ids;  # Array to store inserted objectids

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

        # Store the inserted objectid in the array
        push @inserted_ids, $truck_data->{objectid};
    }

    return \@inserted_ids;  # Return a reference to the inserted objectids
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

sub get_food_truck_by_objectid {
    my ($self, $objectid) = @_;

    my $sql = "SELECT * FROM food_trucks WHERE objectid = ?";
    my $sth = $self->{dbh}->prepare($sql);
    $sth->execute($objectid);

    my $food_truck = $sth->fetchrow_hashref;

    $sth->finish;

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
