<?php

$appID = "296144650405719";
$secret = "292e1d52a4f6dbc2d622da3ef849b4f7";

$fid = "524761447";

$action = $_REQUEST['action'];

class SQL
{
	var $open = false;
	var $connection;
	
	var $sqlServer = "jpcasino.db.7198379.hostedresource.com";
	var $sqlUsername = "jpcasino";
	var $sqlPassword = "BlackDragon83";
	
	function Get($command)
	{
		if ($this->open == true)
		{
			mysql_close($this->connection);
			$this->open = false;
		}
		
		$this->connection = mysql_connect($this->sqlServer, $this->sqlUsername, $this->sqlPassword);
		if (!$this->connection) die("<error>Failed to connect to the database.</error>");
		$this->open = true;
		mysql_select_db('jpcasino', $this->connection);
		
		$result = mysql_query($command, $this->connection);
		return mysql_fetch_array($result);
	}
	function Set($command)
	{
		if ($this->open == true)
		{
			mysql_close($this->connection);
			$this->open = false;
		}
		
		$this->connection = mysql_connect($this->sqlServer, $this->sqlUsername, $this->sqlPassword);
		if (!$this->connection) die("<error>Failed to connect to the database.</error>");
		mysql_select_db('jpcasino', $this->connection);
		
		mysql_query($command, $this->connection);
		mysql_close($this->connection);
	}
}

$sql = new SQL();

if ($action == "toggleSoundOn")
	$sql->Set("UPDATE users SET SoundEnabled = '1' WHERE FID='".$fid."'"); 
else if ($action == "toggleSoundOff")
	$sql->Set("UPDATE users SET SoundEnabled = '0' WHERE FID='".$fid."'");
else if ($action == "toggleMusicOn")
	$sql->Set("UPDATE users SET MusicEnabled = '1' WHERE FID='".$fid."'");
else if ($action == "toggleMusicOff")
	$sql->Set("UPDATE users SET MusicEnabled = '0' WHERE FID='".$fid."'");
else if ($action == "play")
{
	$mode = $_REQUEST["mode"];
	$bid = (int)$_REQUEST["bid"];
	
	if ($mode == "matrix")
	{
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
		
		if ($bid > (int)$row['VirtualCoins'])
			die ( "<error>Not enough currency to play!</error>" );
		else
		{
			$rollID = (int)($row['Rolls']) + 1;
			$coins = (int)$row['VirtualCoins'];
			$result = "";
			
			for ($n=0; $n<9; $n++)
			{
				$r = rand(0,1);
				$result = $result.(string)$r;
			}
			echo "<rollID>".$rollID."</rollID>";
			echo "<result>".$result."</result>";
			
			$sql->Set("INSERT INTO rolls (FID, RollID, Mode, Result, Confirmed, bid) VALUES ('".$fid."','".$rollID."','Matrix','".$result."','0','".$bid."')");
			
			$coins -= $bid;
			
			$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."' WHERE FID='".$fid."'");
		}
	}
	else if ($mode == "slots")
	{
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
		
		if ($bid > (int)$row['VirtualCoins'])
			die ( "<error>Not enough currency to play!</error>" );
		else
		{
			$rollID = (int)($row['Rolls']) + 1;
			$coins = (int)$row['VirtualCoins'];
			$result = rand(0,9)."".rand(0,9)."".rand(0,9);
			
			echo "<rollID>".$rollID."</rollID>";
			echo "<result>".$result."</result>";
			
			$tumblerConfig = $row['TumblerConfiguration'];
			
			$sql->Set("INSERT INTO rolls (FID, RollID, Mode, TumblerConfiguration, Result, Confirmed, bid) VALUES ('".$fid."','".$rollID."','Slots','".$tumblerConfig."','".$result."','0','".$bid."')");
			
			$coins -= $bid;
			
			$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."' WHERE FID='".$fid."'");
		}
	}
	else if ($mode == "poker")
	{
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
		
		if ($bid > (int)$row['VirtualCoins'])
			die ( "<error>Not enough currency to play! You bid ".$bid." but only have ".$row['VirtualCoins']."!!! GET MORE MONEY!</error>" );
		else
		{
			$rollID = (int)($row['Rolls']) + 1;
			$coins = (int)$row['VirtualCoins'];
			$result = substr(str_shuffle("abcdefghijklmnopqrstuvwxyzBCDEFGHILMNOPRSTUVWXYZ1234"),0,5);
				
			echo "<rollID>".$rollID."</rollID>";
			echo "<result>".$result."</result>";
			
			$sql->Set("INSERT INTO rolls (FID, RollID, Mode, Result, Confirmed, bid) VALUES ('".$fid."','".$rollID."','Poker','".$result."','0','".$bid."')");
			
			$coins -= $bid;
			
			$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."' WHERE FID='".$fid."'");
		}
	}
	// else if (future game mode....)
		
	//$minigame = rand(1,20);
	$minigame = 10;
	if ($minigame == 10)
	{
		echo "<minigame>1</minigame>";
	}
	else "<minigame>0</minigame>";
}
else if ($action == "win")
{
	$rollID = (int)$_REQUEST['rollID'];
	$bid = (int)$_REQUEST['bid'];
	$rollResult = $_REQUEST['result'];
	$winAmount = (int)$_REQUEST['winAmount'];
	
	$row = $sql->Get("SELECT * FROM rolls WHERE FID='".$fid."' AND RollID='".$rollID."'");
	
	if ((int)$row['FID'] > 0)
	{
		if ($bid != (int)$row['bid'] || $rollResult != $row['Result']) die ("<error>Roll data does not match</error>");
		if ($row['Confirmed'] == '1') die("<error>Roll already confirmed</error>");
		// TODO: CONFIRM THE RESULTS!!!
		$mode = $row['Mode'];
		
		if ($mode == "poker")
		{
		}
		else if ($mode == "slots")
		{
		}
		else if ($mode == "matrix")
		{
		}
		
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
		
		$coins = (int)$row['VirtualCoins'];
		$coins += (int)$winAmount;
		
		$sql->Set("UPDATE users SET VirtualCoins = '".$coins."' WHERE FID='".$fid."'");
		
		// TODO: Update rolls table to say Confirmed!!
		$sql->Set("UPDATE rolls SET Confirmed = '1' WHERE FID='".$fid."' AND RollID='".$rollID."'");
		
		die("<coins>".$coins."</coins>");
	}
	else die ("<error>The supplied roll does not exist.</error>");
}
else if ($action == "init")
{	
	$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
	
	// USER EXISTS
	if ((int)$row['FID'] > 0)
	{
		$virtualCoins = $row['VirtualCoins'];
		$soundEnabled = $row['SoundEnabled'];
		$musicEnabled = $row['MusicEnabled'];
		$rolls = $row['Rolls'];					// The current RollID for rolls to be passed in!
		$tumbler1 = str_shuffle("1223334444");
		$tumbler2 = str_shuffle("1223334444");
		$tumbler3 = str_shuffle("1223334444");
		
		echo "<virtualCoins>".$virtualCoins."</virtualCoins>";
		echo "<facebookCredits>123</facebookCredits>";
		echo "<soundEnabled>".$soundEnabled."</soundEnabled>";
		echo "<musicEnabled>".$musicEnabled."</musicEnabled>";
		echo "<rollID>".$rolls."</rollID>";
		echo "<tumbler1>".$tumbler1."</tumbler1>";
		echo "<tumbler2>".$tumbler2."</tumbler2>";
		echo "<tumbler3>".$tumbler3."</tumbler3>";
	
		$sql->Set("INSERT INTO users (TumblerConfiguration, LastLogin) VALUES ('".$tumbler1.$tumbler2.$tumbler3."',NOW()) WHERE FID='".$fid."'");
	}
	else
	// USER DOESN'T EXIST. CREATE ONE!
	{
		$tumbler1 = str_shuffle("1223334444");
		$tumbler2 = str_shuffle("1223334444");
		$tumbler3 = str_shuffle("1223334444");
		
		$sql->Set("INSERT INTO users (FID, VirtualCoins, SoundEnabled, MusicEnabled, Rolls, Wins, CollectiveWins, TumblerConfiguration, Flag, LastLogin) VALUES ('".$fid."','1000','1','1','0','0','0','".$tumbler1.$tumbler2.$tumbler3."','0',NOW())");
		
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$fid."'");
		
		$virtualCoins = $row['VirtualCoins'];
		$soundEnabled = $row['SoundEnabled'];
		$musicEnabled = $row['MusicEnabled'];
		$rolls = $row['Rolls'];					// The current RollID for rolls to be passed in!
		
		echo "\n<virtualCoins>".$virtualCoins."</virtualCoins>";
		echo "\n<facebookCredits>456</facebookCredits>";
		echo "\n<soundEnabled>".$soundEnabled."</soundEnabled>";
		echo "\n<musicEnabled>".$musicEnabled."</musicEnabled>";
		echo "\n<rollID>".$rolls."</rollID>";
		echo "<tumbler1>".$tumbler1."</tumbler1>";
		echo "<tumbler2>".$tumbler2."</tumbler2>";
		echo "<tumbler3>".$tumbler3."</tumbler3>";
	}
	
	echo "\n<numOfFriends>15</numOfFriends>";
	echo "\n<profile0Name>Jonathan Plumb</profile0Name>";
	echo "\n<profile0ID>11</profile0ID>";
	echo "\n<profile0Image>http://a2.sphotos.ak.fbcdn.net/hphotos-ak-snc7/298101_10150341496376448_524761447_8385705_2018013285_n.jpg</profile0Image>";
	echo "\n<profile1Name>Jason Noack</profile1Name>";
	echo "\n<profile1ID>22</profile1ID>";
	echo "\n<profile1Image>http://a1.sphotos.ak.fbcdn.net/hphotos-ak-snc7/303919_2216272278678_1003727906_32613510_6053300_n.jpg</profile1Image>";
	echo "\n<profile2Name>Kelly Joiner</profile2Name>";
	echo "\n<profile2ID>33</profile2ID>";
	echo "\n<profile2Image>http://a6.sphotos.ak.fbcdn.net/hphotos-ak-ash4/382803_2083095848034_1564250850_31620255_868376789_n.jpg</profile2Image>";
	echo "\n<profile3Name>James Ayala</profile3Name>";
	echo "\n<profile3ID>44</profile3ID>";
	echo "\n<profile3Image>http://a3.sphotos.ak.fbcdn.net/hphotos-ak-snc6/267865_10150313768459224_550144223_9484518_6276903_n.jpg</profile3Image>";
	echo "\n<profile4Name>Liam Barnett</profile4Name>";
	echo "\n<profile4ID>55</profile4ID>";
	echo "\n<profile4Image>http://a4.sphotos.ak.fbcdn.net/hphotos-ak-snc6/198739_252112581475735_100000309854001_939708_6668523_n.jpg</profile4Image>";
	echo "\n<profile5Name>Elizabeth Troh</profile5Name>";
	echo "\n<profile5ID>66</profile5ID>";
	echo "\n<profile5Image>http://a5.sphotos.ak.fbcdn.net/hphotos-ak-snc6/190353_119498664794773_100002039207511_138905_3975_n.jpg</profile5Image>";
	echo "\n<profile6Name>Bradley Plumb</profile6Name>";
	echo "\n<profile6ID>77</profile6ID>";
	echo "\n<profile6Image>http://a2.sphotos.ak.fbcdn.net/hphotos-ak-snc6/270345_10150702400005478_566275477_19259874_1893067_n.jpg</profile6Image>";
	echo "\n<profile7Name>Michael Lee</profile7Name>";
	echo "\n<profile7ID>88</profile7ID>";
	echo "\n<profile7Image>http://a2.sphotos.ak.fbcdn.net/hphotos-ak-snc6/268935_10150704710185302_854515301_19656621_6966028_n.jpg</profile7Image>";
	echo "\n<profile8Name>Adele Lordan</profile8Name>";
	echo "\n<profile8ID>99</profile8ID>";
	echo "\n<profile8Image>http://a1.sphotos.ak.fbcdn.net/hphotos-ak-snc6/168471_186229988062228_100000256857223_605884_7360714_n.jpg</profile8Image>";
	echo "\n<profile9Name>Mandi Pecora</profile9Name>";
	echo "\n<profile9ID>1010</profile9ID>";
	echo "\n<profile9Image>http://a2.sphotos.ak.fbcdn.net/photos-ak-snc1/v2678/101/82/1583933035/n1583933035_159861_7824962.jpg</profile9Image>";
	echo "\n<profile10Name>Jacob Dutton</profile10Name>";
	echo "\n<profile10ID>1111</profile10ID>";
	echo "\n<profile10Image>http://a7.sphotos.ak.fbcdn.net/hphotos-ak-ash4/315567_2169279804639_1626054506_2135763_4346500_n.jpg</profile10Image>";
	echo "\n<profile11Name>Rob Snead</profile11Name>";
	echo "\n<profile11ID>1212</profile11ID>";
	echo "\n<profile11Image>http://a6.sphotos.ak.fbcdn.net/hphotos-ak-ash2/46320_114338728627621_100001544836645_106221_6646368_n.jpg</profile11Image>";
	echo "\n<profile12Name>Jack Battlestag</profile12Name>";
	echo "\n<profile12ID>1313</profile12ID>";
	echo "\n<profile12Image>http://photos-g.ak.fbcdn.net/hphotos-ak-snc6/207373_1948223031830_1430209004_32252053_879099_a.jpg</profile12Image>";
	echo "\n<profile13Name>Robert Clark</profile13Name>";
	echo "\n<profile13ID>1414</profile13ID>";
	echo "\n<profile13Image>http://a1.sphotos.ak.fbcdn.net/hphotos-ak-ash4/374940_10150582229638625_705953624_11787425_1552219727_n.jpg</profile13Image>";
	echo "\n<profile14Name>Josette Rader</profile14Name>";
	echo "\n<profile14ID>1515</profile14ID>";
	echo "\n<profile14Image>http://a4.sphotos.ak.fbcdn.net/hphotos-ak-snc7/305845_10150774280010023_535330022_20398213_2795145_n.jpg</profile14Image>";
	echo "\n<profile15Name>Danielle Nicole Bauge</profile15Name>";
	echo "\n<profile15ID>1616</profile15ID>";
	echo "\n<profile15Image>http://a5.sphotos.ak.fbcdn.net/hphotos-ak-ash2/154952_1548420514845_1365046353_31393038_1601621_n.jpg</profile15Image>";
}
else
{
	// No action declared ... 
}
?>