#!/usr/bin/perl

use LWP::UserAgent;

use HTTP::Request::Common qw(GET);

use WWW::Mechanize;  

use Socket;

$mech = WWW::Mechanize->new(autocheck => 0);
$ag = LWP::UserAgent->new();

$ag->agent("Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801");

$ag->timeout(10);

sub getSites {
	for($count=10;$count<=1000;$count+=10)
	{
		$k++;
#		$url = "http://www.hotbot.com/search/web?pn=$k&q=ip%3A$ip&keyvol=01f9093871a6d24c0d94";
		$url = "https://www.bing.com/search?q=ip%3a$ip&go=Submit+Query&qs=ds&first=$count&FORM=PERE$k";
#		$url = "https://www.bing.com/search?q=ip%3A$ip+&count=50&first=$count";
		$resp = $ag->request(HTTP::Request->new(GET => $url));

		$rrs = $resp->content;



		while($rrs =~ m/<a href=\"?http:\/\/(.*?)\//g)
		{
	
			$link = $1;
		
			if ( $link !~ /overture|msn|live|bing|yahoo|duckduckgo|google|yahoo|microsof/)
			{
				if ($link !~ /^http:/)
				{
					$link = 'http://' . "$link" . '/';
				}
	
				if($link !~ /\"|\?|\=|index\.php/)
				{
					if  (!  grep (/$link/,@result))
					{
						push(@result,$link);
					}
				}
			} 
		}
	}
	$found = $#result + 1;
	print "found $found sites\n";
	
}
sub WPS {
	foreach $site (@result)
	{
		$url = $mech->get("$site");
		$Scont = $mech->content;
		if ($Scont =~ m/wp-content/g)
		{
			$license = $site."license.txt";
			$horse = $mech->get("$license");
			if ($horse->is_success)
			{
				$Scont = $mech->content;
				$login = $site."wp-login.php";
				$logUrl = $mech->get("$login");
	 	                if ($Scont =~ m/WordPress/)     
				{
					push @WPS,$site;
					print "$site\n";
				}
				elsif($logUrl->is_success) 
				{
					push @WPS,$site; 
					print "$site\n";
				}

			}

		}


	}

}
sub IP_id {
	print "Enter the IP of the server or a site hosted on the same server\n";
	print ">> ";
	$input =<stdin>;
	chomp($input);
	if ($input =~ m/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
	{
		$ip = $input;
		print "Searching The WebSites...\n";
		getSites();
	}
	elsif ($input =~ m/\D/g)
	{
		if ($input =~ m/https:\/\//)
		{
			$source = substr($input,8,length($input));
			print "Site : $source\n";
			print "Get IP Adress...\n";
                        $ip = inet_ntoa(inet_aton($source));
                        print "IP: $ip\n";
			print "Searching The WebSites...\n";
			getSites();
		}
                elsif ($input =~ m/http:\/\//)
                {
                        $source = substr($input,7,length($input));
                        print "Site : $source\n";
			print "Gett IP Adress...\n";
                        $ip = inet_ntoa(inet_aton($source));
                        print "IP: $ip\n";
			print "Searching The WebSites...\n";
			getSites();

                }
		else 
		{
			print "Site : $input\n";
			print "Get IP Adress...\n";
			$ip = inet_ntoa(inet_aton($input));
			print "IP : $ip\n";
			print "Searching The WebSites...\n";
			getSites();
		}
	}	
}
system(($^O eq 'MSWin32') ? 'cls' : 'clear');
sub Into {
	print qq(
                                                                                                                           
                                                                                                                           
M""MMM""MMM""M             M""MMM""MMM""M          dP                oo   dP                     
M  MMM  MMM  M             M  MMM  MMM  M          88                     88                     
M  MMP  MMP  M 88d888b.    M  MMP  MMP  M .d8888b. 88d888b. .d8888b. dP d8888P .d8888b. .d8888b. 
M  MM'  MM' .M 88'  `88    M  MM'  MM' .M 88ooood8 88'  `88 Y8ooooo. 88   88   88ooood8 Y8ooooo. 
M  `' . '' .MM 88.  .88    M  `' . '' .MM 88.  ... 88.  .88       88 88   88   88.  ...       88 
M    .d  .dMMM 88Y888P'    M    .d  .dMMM `88888P' 88Y8888' `88888P' dP   dP   `88888P' `88888P' 
MMMMMMMMMMMMMM 88          MMMMMMMMMMMMMM                                                        
               dP                                                                                
MM""""""""`M            dP                                dP                                     
MM  mmmmmmmM            88                                88                                     
M`      MMMM dP.  .dP d8888P 88d888b. .d8888b. .d8888b. d8888P .d8888b. 88d888b.                 
MM  MMMMMMMM  `8bd8'    88   88'  `88 88'  `88 88'  `""   88   88'  `88 88'  `88                 
MM  MMMMMMMM  .d88b.    88   88       88.  .88 88.  ...   88   88.  .88 88                       
MM        .M dP'  `dP   dP   dP       `88888P8 `88888P'   dP   `88888P' dP                       
MMMMMMMMMMMM                                                                                                                                                                                                                                                                                                                          
																		   Coded By : DR-IMAN
															               Guardiran Security Team ( Guardiran.org )
                                                                                                 
                                                                                                 
);


	print "\t\t\t    # Enter wp To Get Wordpress WebSites : ";
		$choice1 = <stdin>;
	chomp ($choice1);
	if ($choice1 eq "wp" or $choice1 eq "WP")
	{
		print "\nExtract Wp WebSites...\n";
		print "****************************\n";
		IP_id();
		print "Searching for Wordpress WebSites\n";
		WPS();
		$n_found = $#WPS+1;
		print "\t>> Found $n_found Wordpress sites\n\n";
		print "Save The Scan Result? (Y\\n): ";
		$save = <stdin>;
		chomp($save);
		if ($save eq "Y" or $save eq "" or $save eq "y")
		{
			open(wp, ">WP.txt");
			map {$_ = "$_\n"} (@WPS);
			print wp @WPS;
		print "\t>> Saved at WP.txt\n";
		}

	}
}
Into();