# perl_critic test

use strict ;
use warnings ;
use Term::ANSIColor ;

#~ use Test::More skip_all => 'perl_critic' ;


use Test::Perl::Critic 
	-severity => 1,
	-format =>  "[%s] %m  at '%f:%l:%c' rule %p %e\n"
				. "\t%r",
	-exclude =>
		[
		'Miscellanea::RequireRcsKeywords',
		'NamingConventions::ProhibitMixedCaseSubs',
		'ControlStructures::ProhibitPostfixControls',
		'CodeLayout::ProhibitParensWithBuiltins',
		'Documentation::RequirePodAtEnd',
		'ControlStructures::ProhibitUnlessBlocks',
		'CodeLayout::RequireTidyCode',
		'CodeLayout::ProhibitHardTabs',
		
		], 
		
	-profile => 't/perlcriticrc' ;

my $alarm_reached = 0 ;
eval
	{
	local $SIG{ALRM} = sub {$alarm_reached++ ; die} ;
	alarm 1 ;
	
	eval
		{
		my $input = <STDIN> ;
		} ;
	
	alarm 0 ;
	} ;

alarm 0 ;

if($alarm_reached)
	{
	eval <<EOE ;
		{
		use Test::More qw(no_plan) ;
		SKIP:
			{
			skip("perl critics (press key to run)", 1) if($alarm_reached) ;
			}
		}
EOE
	}
else
	{
	all_critic_ok() ;
	}
	
