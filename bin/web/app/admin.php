<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MugShot Casino Administrator Panel</title>

<script type="text/javascript">

function onClearDatabase()
{
	var xmlhttp = new XMLHttpRequest();
	
	//xmlhttp.onreadystatechange = function()
	//{
	//	if (xmlhttp.readystate == 4 && xmlhttp.status == 200)
	//	{
	//		alert("Database has been cleared!");
	//		document.getElementById("clearButton").disabled = false;
	//	}
	//}
	document.getElementById("clearButton").disabled = true;
	xmlhttp.open("GET","http://www.fatesoftware.com/casino/index.php?action=clearDB",false);
	xmlhttp.send();
	
	alert("Database has been cleared!");
	document.getElementById("clearButton").disabled = false;
}

</script>

</head>

<body>

<button onclick="onClearDatabase()" id="clearButton">Clear Database</button>

<script type="text/javascript">
document.getElementById("clearButton").disabled = false;
</script>

</body>
</html>