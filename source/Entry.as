﻿package  {		import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.Font;	import flash.text.TextFormatAlign;	import flash.filters.DropShadowFilter;			public class Entry extends MovieClip {				private var bgLayer:MovieClip;		private var gameLayer:MovieClip;		private var overLayer:MovieClip;		private var mbLayer:MovieClip;		private var systemLayer:MovieClip;				private var background:Background;		private var loadingBar:LoadingBar;		private var loadingBarFiller:LoadingBarFiller;		private var loadingText:TextField;				public static var NET_FACEBOOK:String = "http://www.fatesoftware.com/casino/index.php";		public static var NET_EXTERNAL:String = "http://www.fatesoftware.com/casino/ex.php";		public static var ONLINE:Boolean = false;				public function Entry() 		{			Font.registerFont(Bangla);			Font.registerFont(Impact);						background = new Background();			loadingBar = new LoadingBar();			loadingBarFiller = new LoadingBarFiller();			loadingText = new TextField();			loadingText.width = 720;			loadingText.height = 72;			loadingText.text = "Loading MugShot Casino ...";			loadingText.setTextFormat(new TextFormat("Impact", 32.0, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER));			loadingText.filters = [new DropShadowFilter(12.0, 45, 0x000000, 1.0, 8.0, 8.0, 1.0, 1, false, false, false)];						this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(e:Event)		{			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);						addChild(background);			addChild(loadingBar);			addChild(loadingBarFiller);			addChild(loadingText);						background.x = 0; 			background.y = 0;			loadingBar.x = 38; 			loadingBar.y = 262;			loadingBarFiller.x = 56;	loadingBarFiller.y = 280;			loadingText.x = 0;			loadingText.y = 200;		}	}	}