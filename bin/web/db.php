<?php

$dbName = "mugshotdb";
$dbUsername = "msdbu";
$dbPassword = "j9b5de5PhLYzzr9s";

function GetTables()
{
	echo "Getting tables...";
	
	mysql_connect("localhost",$dbUsername, $dbPassword);
	
	$res = mysql_query("SHOW TABLES FROM ".$dbName);
	
	$row = mysql_fetch_array($res, MYSQL_NUM);
	
	echo("Number of Tables: ".count($row)."<br />");
}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MugShot Casino Database Management</title>
</head>

<body>
Test.
<?php GetTables(); ?>

</body>
</html>