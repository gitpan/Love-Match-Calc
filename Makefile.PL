use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Love::Match::Calc',
    'VERSION_FROM'	=> 'Calc.pm', # finds $VERSION
    'PREREQ_PM'		=> {Params::Validate => 0.95,Math::Cephes => 0.47},
    ($] >= 5.005 ? (
      ABSTRACT_FROM => 'Calc.pm', 
      AUTHOR     => '-',
    ) : ()),
);
