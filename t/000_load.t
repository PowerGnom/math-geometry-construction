#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'Math::Geometry::Construction' )        || print "Bail out!\n";
    use_ok( 'Math::Geometry::Construction::Point' ) || print "Bail out!\n";
    use_ok( 'Math::Geometry::Construction::Line' )  || print "Bail out!\n";
}

diag( "Testing Math::Geometry::Construction $Math::Geometry::Construction::VERSION, Perl $], $^X" );
