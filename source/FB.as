﻿package  {	import flash.net.URLLoader;	import flash.net.URLRequest;		public class FB 	{		public static var AccessToken:String = "";				public function FB() {			// constructor code		}				public static function GetID() : String		{			var l:URLLoader = new URLLoader();			l.load(new URLRequest("http://graph.facebook.com/me?access_token="+AccessToken));			return String(l.data);		}	}	}