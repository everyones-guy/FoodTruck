use strict;
use warnings;
use DBI;
use Getopt::Long;

# Default values for options
my $db_file = 'food_trucks.db';    # Default database name
my $db_dir  = '../data';           # Default database location

# Parse command-line options
GetOptions(
    'database=s' => \$db_file,     # Database name (string)
    'location=s' => \$db_dir,      # Database location (directory)
) or die "Usage: $0 [--database=NAME] [--location=DIR]\n";

# Construct the full path to the database file
my $db_path = "$db_dir/$db_file";

# Database connection parameters
my $db_driver = 'SQLite';
my $db_dsn    = "dbi:$db_driver:dbname=$db_path";
my $db_user   = '';
my $db_pass   = '';

# Create a database connection
my $dbh = DBI->connect(
    $db_dsn, $db_user, $db_pass,
    {
        PrintError => 0,
        RaiseError => 1,
        AutoCommit => 1,
    }
) or die "Database connection failed: $DBI::errstr";

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

# Execute the SQL statement to create the table
$dbh->do($create_table_sql);

# Disconnect from the database
$dbh->disconnect;

print "Database file '$db_file' created in '$db_dir'.\n";
