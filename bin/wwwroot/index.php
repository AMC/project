<?php

require_once("facebook.php");

$appID = "296144650405719";
$secret = "292e1d52a4f6dbc2d622da3ef849b4f7";

$facebookURL = "http://apps.facebook.com/mugshotcasino/";
$canvasURL = "http://www.fatesoftware.com/casino/index.php";
$authURL = "https://www.facebook.com/dialog/oauth?client_id=".$appID."&redirect_uri=".urlencode($canvasURL);

class SQL
{
	var $open = false;
	var $connection;
	
	var $result;
	
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
		
		$this->result = mysql_query($command, $this->connection);
		return mysql_fetch_array($this->result);
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

$config = array();
$config['appId'] = $appID;
$config['secret'] = $secret;

session_start();

$signedRequest = $_REQUEST['signed_request'];
$code = $_REQUEST['code'];

$facebook = new Facebook($config);

if ($code)
{
	echo "<script>top.location.href='".$facebookURL."'</script>";
}

if ($signedRequest)
{	
	list($encoded_sig, $payload) = explode('.', $signedRequest, 2);
		
	$data = json_decode(base64_decode(strtr($payload, '-_', '+/')), true);
	
	if (empty($data["user_id"]))
	{
		echo "<script>top.location.href='".$authURL."'</script>";
	}
	else
	{	
		$_SESSION['FID'] = $facebook->getUser();
		$_SESSION['AccessToken'] = $facebook->getAccessToken();
		$_SESSION['SignedRequest'] = $facebook->getSignedRequest();
		
		echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Profile Casino</title><script src="../Scripts/swfobject_modified.js" type="text/javascript"></script></head><body><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="720" height="620" id="FlashID" title="Profile Casino">  <param name="movie" value="Client.swf" />  <param name="quality" value="high" />  <param name="wmode" value="opaque" />  <param name="swfversion" value="6.0.65.0" />  <!-- This param tag prompts users with Flash Player 6.0 r65 and higher to download the latest version of Flash Player. Delete it if you don\'t want users to see the prompt. -->  <param name="expressinstall" value="../Scripts/expressInstall.swf" />  <!-- Next object tag is for non-IE browsers. So hide it from IE using IECC. -->  <!--[if !IE]>-->  <object type="application/x-shockwave-flash" data="Client.swf" width="720" height="620">    <!--<![endif]-->    <param name="quality" value="high" />    <param name="wmode" value="opaque" />    <param name="swfversion" value="6.0.65.0" />    <param name="expressinstall" value="../Scripts/expressInstall.swf" />    <!-- The browser displays the following alternative content for users with Flash Player 6.0 and older. -->    <div>      <h4>Content on this page requires a newer version of Adobe Flash Player.</h4>      <p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" width="112" height="33" /></a></p>    </div>    <!--[if !IE]>-->  </object>  <!--<![endif]--></object><script type="text/javascript">swfobject.registerObject("FlashID");</script></body></html>';
	}
}
else
{
	$action = $_REQUEST['action'];

	if ($facebook->getUser() == 0) die($authURL);
	
	if($action == "clearDB")
	{
		$sql->Set("TRUNCATE TABLE users");
		$sql->Set("TRUNCATE TABLE rolls");
		die("SUCCESS");
	}

	if ($action == "toggleSoundOn")
		$sql->Set("UPDATE users SET SoundEnabled = '1' WHERE FID='".$facebook->getUser()."'"); 
	else if ($action == "toggleSoundOff")
		$sql->Set("UPDATE users SET SoundEnabled = '0' WHERE FID='".$facebook->getUser()."'");
	else if ($action == "toggleMusicOn")
		$sql->Set("UPDATE users SET MusicEnabled = '1' WHERE FID='".$facebook->getUser()."'");
	else if ($action == "toggleMusicOff")
		$sql->Set("UPDATE users SET MusicEnabled = '0' WHERE FID='".$facebook->getUser()."'");
	else if ($action == "play")
	{
		$mode = $_REQUEST["mode"];
		$bid = (int)$_REQUEST["bid"];
		
		if ($mode == "matrix")
		{
			$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
			if ($bid > (int)$row['VirtualCoins'])
				die ( "<error>Not enough currency to play!</error>" );
			else
			{
				$achievements = $row['Achievements'];
				
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
				
				$achieve = strpos($achievements,"[FirstMatrix:");
				if ($achieve === false) 
				{
					echo "<achievement>FirstMatrix</achievement>";
					$achievements = $achievements."[FirstMatrix:1]";
				}
				
				$sql->Set("INSERT INTO rolls (FID, RollID, Mode, Result, Confirmed, bid) VALUES ('".$facebook->getUser()."','".$rollID."','Matrix','".$result."','0','".$bid."')");
				
				$coins -= $bid;
				
				$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."', Achievements = '".$achievements."' WHERE FID='".$facebook->getUser()."'");
			}
		}
		else if ($mode == "slots")
		{
			$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
			if ($bid > (int)$row['VirtualCoins'])
				die ( "<error>Not enough currency to play!</error>" );
			else
			{
				$achievements = $row['Achievements'];
				
				$rollID = (int)($row['Rolls']) + 1;
				$coins = (int)$row['VirtualCoins'];
				$result = rand(0,9)."".rand(0,9)."".rand(0,9);
				
				echo "<rollID>".$rollID."</rollID>";
				echo "<result>".$result."</result>";
				
				$achieve = strpos($achievements,"[FirstSlots:");
				if ($achieve === false) 
				{
					echo "<achievement>FirstSlots</achievement>";
					$achievements = $achievements."[FirstSlots:1]";
				}
				
				$tumblerConfig = $row['TumblerConfiguration'];
				
				$sql->Set("INSERT INTO rolls (FID, RollID, Mode, TumblerConfiguration, Result, Confirmed, bid) VALUES ('".$facebook->getUser()."','".$rollID."','Slots','".$tumblerConfig."','".$result."','0','".$bid."')");
				
				$coins -= $bid;
				
				$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."', Achievements = '".$achievements."' WHERE FID='".$facebook->getUser()."'");
			}
		}
		else if ($mode == "poker")
		{
			$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
			if ($bid > (int)$row['VirtualCoins'])
				die ( "<error>Not enough currency to play! You bid ".$bid." but only have ".$row['VirtualCoins']."!!! GET MORE MONEY!</error>" );
			else
			{
				$achievements = $row['Achievements'];
				
				$rollID = (int)($row['Rolls']) + 1;
				$coins = (int)$row['VirtualCoins'];
				$result = substr(str_shuffle("abcdefghijklmnopqrstuvwxyzBCDEFGHILMNOPRSTUVWXYZ1234"),0,5);
					
				echo "<rollID>".$rollID."</rollID>";
				echo "<result>".$result."</result>";
				
				$achieve = strpos($achievements,"[FirstPoker:");
				if ($achieve === false) 
				{
					echo "<achievement>FirstPoker</achievement>";
					$achievements = $achievements."[FirstPoker:1]";
				}
				
				$sql->Set("INSERT INTO rolls (FID, RollID, Mode, Result, Confirmed, bid) VALUES ('".$facebook->getUser()."','".$rollID."','Poker','".$result."','0','".$bid."')");
				
				$coins -= $bid;
				
				$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Rolls = '".$rollID."', Achievements = '".$achievements."' WHERE FID='".$facebook->getUser()."'");
			}
		}
		// else if (future game mode....)
		
		$minigame = rand(1,10);
		/*COMMENT THIS OUT*/$minigame = 5;
		if ($minigame == 5)
		{
			echo "<minigame>1</minigame>";
		}
		else "<minigame>0</minigame>";
	}
	else if ($action == "minigame")
	{
		$winAmount = (int)$_REQUEST['winAmount'];
		
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
		$coins = (int)$row['VirtualCoins'];
		$coins += (int)$winAmount;
		
		$sql->Set("UPDATE users SET VirtualCoins = '".$coins."' WHERE FID='".$facebook->getUser()."'");
		die("");
	}
	else if ($action == "win")
	{
		$rollID = (int)$_REQUEST['rollID'];
		$bid = (int)$_REQUEST['bid'];
		$rollResult = $_REQUEST['result'];
		$winAmount = (int)$_REQUEST['winAmount'];
		
		$row = $sql->Get("SELECT * FROM rolls WHERE FID='".$facebook->getUser()."' AND RollID='".$rollID."'");
		
		if (strlen($row['FID']) > 0)
		{
			if ($bid != (int)$row['bid'] || $rollResult != $row['Result']) die ("<error>Roll data does not match\nFID: ".$facebook->getUser()."\nBid: ".$bid."\n".$rollResult."</error>");
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
			
			$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
			$coins = (int)$row['VirtualCoins'];
			$coins += (int)$winAmount;
			
			$numWins = (int)$row['Wins'];
			$numWins++;
			
			$collectiveWins = (int)$row['CollectiveWins'];
			$collectiveWins += $winAmount;
			
			$sql->Set("UPDATE users SET VirtualCoins = '".$coins."', Wins = '".$numWins."', CollectiveWins='".$collectiveWins."' WHERE FID='".$facebook->getUser()."'");
			
			$sql->Set("UPDATE rolls SET Confirmed = '1' WHERE FID='".$facebook->getUser()."' AND RollID='".$rollID."'");
			
			die("<coins>".$coins."</coins>");
		}
		else die ("<error>The supplied roll does not exist.</error>");
	}
	else if ($action == "init")
	{	
		$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
		
		// USER EXISTS
		if (strlen($row['FID']) > 0)
		{
			$virtualCoins = $row['VirtualCoins'];
			$diamonds = $row['Diamonds'];
			$soundEnabled = $row['SoundEnabled'];
			$musicEnabled = $row['MusicEnabled'];
			$rolls = $row['Rolls'];					// The current RollID for rolls to be passed in!
			$tumbler1 = str_shuffle("1223334444");
			$tumbler2 = str_shuffle("1223334444");
			$tumbler3 = str_shuffle("1223334444");
			
			echo "\n<firstLogin>0</firstLogin>";
			echo "<virtualCoins>".$virtualCoins."</virtualCoins>";
			echo "<facebookCredits>".$diamonds."</facebookCredits>";
			echo "<soundEnabled>".$soundEnabled."</soundEnabled>";
			echo "<musicEnabled>".$musicEnabled."</musicEnabled>";
			echo "<rollID>".$rolls."</rollID>";
			echo "<tumbler1>".$tumbler1."</tumbler1>";
			echo "<tumbler2>".$tumbler2."</tumbler2>";
			echo "<tumbler3>".$tumbler3."</tumbler3>";
			echo "<facebookID>".$facebook->getUser()."</facebookID>";
			echo "<facebookAccessToken>".$facebook->getAccessToken()."</facebookAccessToken>";
		
			$sql->Set("INSERT INTO users (TumblerConfiguration, LastLogin) VALUES ('".$tumbler1.$tumbler2.$tumbler3."', NOW()) WHERE FID='".$facebook->getUser()."'");
		}
		else
		// USER DOESN'T EXIST. CREATE ONE!
		{
			$tumbler1 = str_shuffle("1223334444");
			$tumbler2 = str_shuffle("1223334444");
			$tumbler3 = str_shuffle("1223334444");
			
			$sql->Set("INSERT INTO users (FID, VirtualCoins, Diamonds, SoundEnabled, MusicEnabled, Rolls, Wins, CollectiveWins, TumblerConfiguration, Flag, LastLogin) VALUES ('".$facebook->getUser()."','1000','0','1','1','0','0','0','".$tumbler1.$tumbler2.$tumbler3."','0',NOW())");
			
			$row = $sql->Get("SELECT * FROM users WHERE FID='".$facebook->getUser()."'");
			
			$virtualCoins = $row['VirtualCoins'];
			$diamonds = $row['Diamonds'];
			$soundEnabled = $row['SoundEnabled'];
			$musicEnabled = $row['MusicEnabled'];
			$rolls = $row['Rolls'];
			
			echo "\n<firstLogin>1</firstLogin>";
			echo "\n<virtualCoins>".$virtualCoins."</virtualCoins>";
			echo "\n<diamonds>".$diamonds."</diamonds>";
			echo "\n<soundEnabled>".$soundEnabled."</soundEnabled>";
			echo "\n<musicEnabled>".$musicEnabled."</musicEnabled>";
			echo "\n<rollID>".$rolls."</rollID>";
			echo "<tumbler1>".$tumbler1."</tumbler1>";
			echo "<tumbler2>".$tumbler2."</tumbler2>";
			echo "<tumbler3>".$tumbler3."</tumbler3>";
			echo "<facebookID>".$facebook->getUser()."</facebookID>";
			echo "<facebookAccessToken>".$facebook->getAccessToken()."</facebookAccessToken>";
		}
		
		$friends = $facebook->api('/me/friends?access_token='.$facebook->getAccessToken(),'GET');
		$me = $facebook->api('/me','GET');
		
		$myID = $facebook->getUser();
		

		$myProfilePicture = "http://graph.facebook.com/".$myID."/picture?type=large";
		
		echo "\n<numOfFriends>".sizeof($friends['data'])."</numOfFriends>";
		echo "\n<profile0Name>".$me['name']."</profile0Name>";
		echo "\n<profile0ID>".$me['id']."</profile0ID>";
		echo "\n<profile0Image>".$myProfilePicture."</profile0Image>";
		
		for ($n=0; $n<sizeof($friends['data']); $n++)
		{	
			echo "\n<profile".($n+1)."Name>".$friends['data'][$n]['name']."</profile".($n+1)."Name>";
			echo "\n<profile".($n+1)."ID>".$friends['data'][$n]['id']."</profile".($n+1)."ID>";
			echo "\n<profile".($n+1)."Image>http://graph.facebook.com/".$friends['data'][$n]['id']."/picture?type=large</profile".($n+1)."Image>";
		}
	}
	else
	{
		// No action declared ... 
	}
}
?>