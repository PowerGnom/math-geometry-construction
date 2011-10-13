#!perl -T

use Test::More tests => 8;

BEGIN {
    use_ok('Math::Geometry::Construction')         || print "Bail out!\n";
    use_ok('Math::Geometry::Construction::Point')  || print "Bail out!\n";
    use_ok('Math::Geometry::Construction::Line')   || print "Bail out!\n";
    use_ok('Math::Geometry::Construction::Circle') || print "Bail out!\n";
    use_ok('Math::Geometry::Construction::Derivate' )
	|| print "Bail out!\n";
    use_ok('Math::Geometry::Construction::Derivate::IntersectionLineLine')
	|| print "Bail out!\n";
    use_ok('Math::Geometry::Construction::DerivedPoint')
	|| print "Bail out!\n";
    use_ok('Math::Geometry::Construction::TemporaryPoint')
	|| print "Bail out!\n";
}

diag( "Testing Math::Geometry::Construction $Math::Geometry::Construction::VERSION, Perl $], $^X" );
