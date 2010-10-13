package Love::Match::Calc;
use strict;
use warnings;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/lovecalc lovecalc2/;
our $VERSION = '0.1';
use Params::Validate qw( :all );
use Math::Cephes qw(:utils);

use constant STRING => {
    type => SCALAR,
};
use constant INTEGER => {
    type => SCALAR,
    regex => qr{^\d+$}
};

sub NUMBER_RANGE ($$) {
    my ($min, $max) = @_;
    return {
        %{+INTEGER},
        callbacks => {
            "Number between $min and $max" => sub {
                $_[0] =~ /^\d+$/ and $min <= $_[0] and $_[0] <= $max
            }
        }
    };
}

sub lovecalc2 ($$){
	my @n1 = split(//,shift);
	my @n2 = split(//,shift);
	my $s1 = 0;
	my $s2 = 0;

	for(my $i=0; $i<@n1; $i++){
		$s1 += ord($n1[$i])/($i+1);
	}

	for(my $i=0; $i<@n2; $i++){
		$s2 += ord($n2[$i])/($i+1);
	}

	my $m = ($s1+$s2)/(($s1-$s2)+1);
	$m = substr($m*1000, 2,2);
	return $m;
} 

sub lovecalc ($$){
	my $firstname = shift;
	my $secondname = shift;
	my $lovename = lc($firstname.$secondname);

	my @calc;
	my %alp = count_chars($lovename);

	for(my $i=97;$i<=122;$i++){
		if($alp{$i} != 0){
		        my $anz = length($alp{$i});
		        if($anz<2){
				push(@calc,$alp{$i});
			}else{
				for(my $x=0;$x<$anz;$x++){
					push(@calc,substr($alp{$i},$x,1));
				}
			}
		}
	}

	my @calcmore;
	while((my $anzletter = scalar(@calc))>2) {
		my $lettermitte = ceil($anzletter/2);
		for(my $i=0;$i<$lettermitte;$i++){
	        	my $sum = shift(@calc) + shift(@calc);
		        my $anz = length($sum);
		        if($anz<2){
				push(@calcmore,$sum);
			}else{
				for(my $x=0;$x<$anz;$x++){
					push(@calcmore,substr($sum,$x,1));
				}
			}
		}
		my $anzc = scalar(@calcmore);
		for(my $c=0;$c<$anzc;$c++){
			push(@calc,$calcmore[$c]);
		}
		splice(@calcmore,0);
	}
	return $calc[0].$calc[1];
}

sub count_chars {
	my ( $input, $mode ) = validate_pos( @_, STRING,
	{
		%{+NUMBER_RANGE( 0, 4 )},
		optional => 1,
		default => 0
		},
	);

	if($mode < 3){
		use bytes;
		my %freq;
		my @freq;
		@freq{0..255} = (0) x 256 if $mode != 1;
		$freq{ord $_}++ for split //, $input;
		if($mode == 2){
			$freq{$_} and delete $freq{$_} for keys %freq;
		}
		return %freq;
	}else{
		my %freq = count_chars( $input, $mode-2 );
		return join '', map chr, sort keys %freq;
	}
}


=pod

=head1 NAME

Love::Match::Calc - Calculate the love factor between two names

=head1 SYNOPSIS

	use Love::Match::Calc;
	my $firstname = "Kirk";
	my $secondname = "Sandy";
	my $m = lovecalc($firstname,$secondname);# or lovecalc2
	print "Lovematch for $firstname and $secondname: $m%\n";


=head1 DESCRIPTION

Love::Match::Calc - Calculate the love factor between two names

=head1 AUTHOR

    Stefan Gipper <stefanos@cpan.org>, http://www.coder-world.de/

=head1 COPYRIGHT

	Love::Match::Calc is Copyright (c) 2010 Stefan Gipper
	All rights reserved.

	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO



=cut
