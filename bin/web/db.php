<?php

$dbName = "mugshotdb";
$dbUsername = "msdbu";
$dbPassword = "j9b5de5PhLYzzr9s";

$numTables = 0;

function GetTables()
{	
	mysql_connect("localhost",$dbUsername, $dbPassword);
	
	$res = mysql_query("SHOW TABLES FROM ".$dbName);
	
	$row = mysql_fetch_array($res, MYSQL_NUM);
	
	$numTables = count($row);
	echo("Number of Tables: ".count($row)."<br />");
	
	if ($numTables == 0) CreateTables();
	else ListTables();
}
function CreateTables()
{
}
function ListTables()
{
}
function DeleteAll()
{
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MugShot Casino Database Management</title>
</head>

<body>
<b><font size="5">MugShot Casino Database Management</font></b><br />
  <a href="DeleteAll();">Delete Tables</a><br />
<?php GetTables(); ?>

</body>
</html>