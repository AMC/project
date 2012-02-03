﻿package  {	import flash.display.Loader;	import flash.events.Event;	import flash.net.URLRequest;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.system.LoaderContext;	import flash.display.LoaderInfo;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.SecurityErrorEvent;	import flash.events.IOErrorEvent;	import flash.errors.IOError;		public class ProfileNode {		public var Name:String;		public var ID:String;		public var ImageURL:String;		public var FinalImageURL:String;				public var isLoading:Boolean = false;		public var isLoaded:Boolean = false;				private var myIndex:int = 0;				public var Next:ProfileNode = null;				private var loader:Loader;				public function ProfileNode(Name:String, ID:String, ImageURL:String, Next:ProfileNode = null)		{			this.Name = Name;			this.ID = ID;			this.ImageURL = ImageURL;						this.Next = Next;		}				public function LoadProfile()		{			if (isLoading || isLoaded) return;						Game.Message("Loading profile data from Facebook...please wait...");						isLoading = true;						//loader = new Loader();			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);			//loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);			//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);			//loader.load(new URLRequest(ImageURL));			//return;						loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onUrlLoaded);			var lc:LoaderContext = new LoaderContext();			lc.checkPolicyFile = true;			loader.load(new URLRequest(ImageURL), lc);		}		private function loader_securityErrorHandler(event:SecurityErrorEvent) { trace(event.toString()); }				private function loader_ioErrorHandler(event:IOErrorEvent) { trace(event.toString()); }				private function loader_completeHandler(event:Event):void		{			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);					isLoading = false;			isLoaded = true;		} 				public function GetBitmap() : Bitmap		{			var bitmapData:BitmapData = new BitmapData(loader.width,loader.height,true,0xFFFFFF);			bitmapData.draw(loader);			var bitmap:Bitmap = new Bitmap(bitmapData);			return bitmap;		}				private function onUrlLoaded(event:Event)		{			// CODE OBTAINED FROM http://www.stevensacks.net/2008/12/23/solution-as3-security-error-2122-with-300-redirects/			// to solve the Security Error 2122 given by Facebook!						loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onUrlLoaded);						var path:String = LoaderInfo(event.target).url;						FinalImageURL = path;			if (FinalImageURL == "REMOVE ME ... http://profile.ak.fbcdn.net/")			{				path = "http://graph.facebook.com/"+Game.FB_ID+"/picture?type=large";				loader = new Loader();				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onUrlLoaded);				var lc:LoaderContext = new LoaderContext();				lc.checkPolicyFile = true;							loader.load(new URLRequest(path), lc);			}			else			{				loader = new Loader();				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onReallyComplete);				lc = new LoaderContext();				lc.checkPolicyFile = true;								loader.load(new URLRequest(path), lc);			}		}		private function onReallyComplete(event:Event)		{			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onReallyComplete);						isLoaded = true;			isLoading = false;		}	}	}