﻿package {		import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextField;	import flash.events.MouseEvent;	import flash.net.URLRequest;	import flash.net.URLLoader;	import flash.display.Loader;	import flash.text.TextFormat;	import flash.text.Font;	import flash.text.TextFormatAlign;	import flash.filters.GlowFilter;	import flash.net.navigateToURL;	import flash.system.ApplicationDomain;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.text.TextFieldAutoSize;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.events.ProgressEvent;	import flash.display.DisplayObjectContainer;	import flash.display.DisplayObject;			public class Game extends MovieClip 	{		// 		public static var OFFLINE:Boolean = false;		public static var LOCAL:Boolean = false;				//==================================//		// GLOBAL VARIABLES					//		//==================================//		private static var MusicEnabled:Boolean = true;	// Is music on or off?		private static var SoundEnabled:Boolean = true;	// Is sound on or off?				private static var VirtualCoins:int = 1234;		// Number of Virtual Coins		private static var FacebookCoins:int = 5;		// Number of Facebook Coins				private static var _instance:MovieClip;			// A global reference to our Game instance				//public static var Profiles:Array;		public static var Profiles:ProfileList;				public static var GameMode:String;				public static var Tumbler1:String;		public static var Tumbler2:String;		public static var Tumbler3:String;				private static var motion:MotionEngine;				//==================================//		// LOCAL VARIABLES					//		//==================================//				// Layers		private var bgLayer:MovieClip;		private var gameLayer:MovieClip;		private var overLayer:MovieClip;		private var mbLayer:MovieClip;		private var systemLayer:MovieClip;				// Game mode variables		private var titleScreen:Title;		private var matrixScreen:MatrixScreen;		private var pokerScreen:PokerScreen;		private var slotsScreen:SlotsScreen;				private var titleNet:URLLoader;		private var matrixNet:URLLoader;		private var pokerNet:URLLoader;		private var slotsNet:URLLoader;				private var titleLoader:ContentManager;		private var matrixLoader:ContentManager;		private var slotsLoader:ContentManager;		private var pokerLoader:ContentManager;				private var isTitleLoaded:Boolean = false;		private var isMatrixLoaded:Boolean = false;		private var isSlotsLoaded:Boolean = false;		private var isPokerLoaded:Boolean = false;				private var titleScreenProgressBar:MovieClip;		private var titleScreenProgressBarFiller:MovieClip;		private var matrixScreenProgressBar:MovieClip;		private var matrixScreenProgressBarFiller:MovieClip;		private var pokerScreenProgressBar:MovieClip;		private var pokerScreenProgressBarFiller:MovieClip;		private var slotsScreenProgressBar:MovieClip;		private var slotsScreenProgressBarFiller:MovieClip;				// Loading screen variables		private var bg:Background;		private var loadingText:TextField;		private var loadingTextFormat:TextFormat;				// Overlay variables		private var headerBar:MovieClip;		private var footerBar:MovieClip;		private static var musicBtn:Button;		private static var soundBtn:Button;		private static var virtualCoinsText:TextField;		private static var facebookCoinsText:TextField;		private static var coinsTF:TextFormat;				private static var systemMessage:TextField;		private static var systemMessageTF:TextFormat;				// Variables dependant on offline/offline/local modes		private static var NET_ONLINE:String = "http://www.fatesoftware.com/casino/index.php";		private static var NET_OFFLINE:String = "http://www.fatesoftware.com/casino/ex.php";		public static var NET:String = "";				//==================================//		// PUBLIC LOCAL FUNCTIONS			//		//==================================//				public function Game() 		{			_instance = this; // This is just a global static reference to the Game class							  // in case we ever need to gain access to its members from							  // outside ... I've never had a need for it, but I have it							  // referenced nonetheless ...						// Initialize our animation engine			motion = new MotionEngine();						// Initialize our layers			bgLayer = new MovieClip();		// Background Layer			gameLayer = new MovieClip();	// Game Layer			overLayer = new MovieClip();	// Overlay Layer			mbLayer = new MovieClip();		// Message Box Layer			systemLayer = new MovieClip();	// System Messages (always on top ...)						systemMessage = new TextField();			systemMessageTF = new TextFormat("Impact", 16, 0xFFFFFF);						// Create our two fonts we use in the game			Font.registerFont(Impact);			Font.registerFont(Bangla);						// Initialize our Profile List			Profiles = new ProfileList();			// Now to initialize all our core variables			bg = new Background();			loadingText = new TextField();			loadingTextFormat = new TextFormat("Impact", 48, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);			loadingText.selectable = false;						virtualCoinsText = new TextField();			facebookCoinsText = new TextField();			coinsTF = new TextFormat("Impact", 18, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.RIGHT);			virtualCoinsText.selectable = facebookCoinsText.selectable = false;						titleScreenProgressBar = new ProgressBarBackground();			titleScreenProgressBarFiller = new ProgressBarFiller();			matrixScreenProgressBar = new ProgressBarBackground();			matrixScreenProgressBarFiller = new ProgressBarFiller();			pokerScreenProgressBar = new ProgressBarBackground();			pokerScreenProgressBarFiller = new ProgressBarFiller();			slotsScreenProgressBar = new ProgressBarBackground();			slotsScreenProgressBarFiller = new ProgressBarFiller();						titleLoader = new ContentManager();			matrixLoader = new ContentManager();			pokerLoader = new ContentManager();			slotsLoader = new ContentManager();						this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}				private function onAddedToStage(e:Event)		{			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);						addChild(bgLayer);			addChild(gameLayer);			addChild(overLayer);			addChild(mbLayer);			addChild(systemLayer);						systemLayer.addChild(systemMessage);			systemMessage.x = 8; systemMessage.y = 620 - 24;			systemMessage.height = 24; systemMessage.width = 720;						bgLayer.addChild(bg);			overLayer.addChild(titleScreenProgressBar);			overLayer.addChild(titleScreenProgressBarFiller);			overLayer.addChild(loadingText);						titleScreenProgressBar.x = 40;			titleScreenProgressBar.y = 365;			titleScreenProgressBarFiller.x = 58;	titleScreenProgressBarFiller.y = 380;			titleScreenProgressBarFiller.scaleX = 0;			matrixScreenProgressBar.x = 88;			matrixScreenProgressBar.y = 312;			matrixScreenProgressBarFiller.x = 96;	matrixScreenProgressBarFiller.y = 320;			matrixScreenProgressBarFiller.scaleX = 0;			pokerScreenProgressBar.x = 88;			pokerScreenProgressBar.y = 312;			pokerScreenProgressBarFiller.x = 96;	pokerScreenProgressBarFiller.y = 320;			pokerScreenProgressBarFiller.scaleX = 0;			slotsScreenProgressBar.x = 88;			slotsScreenProgressBar.y = 312;			slotsScreenProgressBarFiller.x = 96;	slotsScreenProgressBarFiller.y = 320;			slotsScreenProgressBarFiller.scaleX = 0;			//320			loadingText.x = 0;			loadingText.y = 250;		loadingText.width = 720;		loadingText.height = 100;						loadingText.text = "Loading ... please wait.";			loadingText.setTextFormat(loadingTextFormat);						titleScreenProgressBar.filters = [new GlowFilter(0xFFFFFF, 0.5, 16.0, 16.0, 2.0, 1, false, false)];			matrixScreenProgressBar.filters = [new GlowFilter(0xFFFFFF, 0.5, 16.0, 16.0, 2.0, 1, false, false)];			pokerScreenProgressBar.filters = [new GlowFilter(0xFFFFFF, 0.5, 16.0, 16.0, 2.0, 1, false, false)];			slotsScreenProgressBar.filters = [new GlowFilter(0xFFFFFF, 0.5, 16.0, 16.0, 2.0, 1, false, false)];						titleLoader.loadExternalSWF(ContentManager.TITLE, onTitleLoaded, onTitleProgress);		}				//==================================//		// PRIVATE LOCAL FUNCTIONS			//		//==================================//				// The onXXXProgress functions just update our loading progress bars associated		// with each game mode.		private function onTitleProgress(e:ProgressEvent)		{			var pctComplete:Number = e.bytesLoaded / e.bytesTotal;			titleScreenProgressBarFiller.scaleX = pctComplete;		}		private function onMatrixProgress(e:ProgressEvent)		{			var pctComplete:Number = e.bytesLoaded / e.bytesTotal;			matrixScreenProgressBarFiller.scaleX = pctComplete;		}		private function onPokerProgress(e:ProgressEvent)		{			var pctComplete:Number = e.bytesLoaded / e.bytesTotal;			pokerScreenProgressBarFiller.scaleX = pctComplete;		}		private function onSlotsProgress(e:ProgressEvent)		{			var pctComplete:Number = e.bytesLoaded / e.bytesTotal;			slotsScreenProgressBarFiller.scaleX = pctComplete;		}				private function onTitleLoaded()		{			titleScreenProgressBarFiller.scaleX = 1;						isTitleLoaded = true;			MessageBox.Initialize(mbLayer);						titleNet = new URLLoader();			titleNet.addEventListener(Event.COMPLETE, onTitleInitReceived);			try			{				titleNet.load(new URLRequest("http://www.fatesoftware.com/casino/index.php?action=init"));			}			catch (error:Error)			{				LOCAL = true;				MessageBox.Okay("A connection to the server could not be established. Profile Casino will now play in offline mode.",onTitleInitReceived);			}		}		private function onTitleInitReceived(e:Event=null)		{			titleNet.removeEventListener(Event.COMPLETE, onTitleInitReceived);						if (String(titleNet.data).indexOf("https://www.facebook.com/dialog/oauth?client_id=") >= 0)			{				MessageBox.Okay("Your client doesn't seem to be authorized. Proceeding to hard-coded results for testing.",onSetLocal);			}			else if (!LOCAL)			{				NET = NET_ONLINE;				parseTitleData();			}			else			{				parseTitleData();			}		}		private function onSetLocal()		{			OFFLINE = true;			NET = NET_OFFLINE;			titleNet = new URLLoader();			titleNet.addEventListener(Event.COMPLETE, parseTitleData);			titleNet.load(new URLRequest(NET+"?action=init"));		}		private function parseTitleData(e:Event=null)		{			if (LOCAL)			{				Tumbler1 = "4321432434";				Tumbler2 = "4321432434";				Tumbler3 = "4321432434";				SetVirtualCoins(1234);				SetFacebookCoins(5);				MusicEnabled = true;				SoundEnabled = true;			}			else			{				Tumbler1 = ParseXML(titleNet.data, "tumbler1");				Tumbler2 = ParseXML(titleNet.data, "tumbler2");				Tumbler3 = ParseXML(titleNet.data, "tumbler3");				SetVirtualCoins(int(ParseXML(titleNet.data, "virtualCoins")));				SetFacebookCoins(int(ParseXML(titleNet.data, "facebookCredits")));				ParseXML(titleNet.data, "musicEnabled")=="0"?MusicEnabled=false:MusicEnabled=true;				ParseXML(titleNet.data, "soundEnabled")=="0"?SoundEnabled=false:SoundEnabled=true;								var numFriends:int = int(ParseXML(titleNet.data, "numOfFriends"));				for (var n:int = 0; n < numFriends+1; n++)				{					Profiles.Add(ParseXML(titleNet.data, "profile"+n+"Name"), ParseXML(titleNet.data, "profile"+n+"ID"), ParseXML(titleNet.data, "profile"+n+"Image"));				}			}			Profiles.Get(0).LoadProfile();						overLayer.removeChild(titleScreenProgressBar);			overLayer.removeChild(titleScreenProgressBarFiller);			overLayer.removeChild(loadingText);						headerBar = Game.GetMovieClip("HeaderBar");			footerBar = Game.GetMovieClip("FooterBar");			soundBtn = new Button(Button.SOUND);			musicBtn = new Button(Button.MUSIC);						soundBtn.SetToggle(Game.IsSoundEnabled());			musicBtn.SetToggle(Game.IsMusicEnabled());			soundBtn.SetOnClick(onSoundClick);			musicBtn.SetOnClick(onMusicClick);						titleScreen = new Title(titleLoader);			gameLayer.addChild(titleScreen);						overLayer.addChild(headerBar);			overLayer.addChild(footerBar);			overLayer.addChild(virtualCoinsText);			overLayer.addChild(facebookCoinsText);			overLayer.addChild(soundBtn);			overLayer.addChild(musicBtn);						headerBar.x = 0;			headerBar.y = -100;			footerBar.x = 0;			footerBar.y = 620;			soundBtn.x = 688;			soundBtn.y = 30;			musicBtn.x = 660;			musicBtn.y = 29;			virtualCoinsText.x = 576;	virtualCoinsText.y = 2;		virtualCoinsText.width = 130;	virtualCoinsText.height = 24;			facebookCoinsText.x = 460;	facebookCoinsText.y = 2;	facebookCoinsText.width = 104;	facebookCoinsText.height = 24;						virtualCoinsText.alpha = 0.0;			facebookCoinsText.alpha = 0.0;			musicBtn.alpha = 0.0;			soundBtn.alpha = 0.0;						motion.createMove(headerBar,0,0,300);			motion.createMove(footerBar,0,596,300);			motion.createFadeIn(virtualCoinsText,300,null,300);			motion.createFadeIn(facebookCoinsText,300,null,300);			motion.createFadeIn(musicBtn,300,null,300);			motion.createFadeIn(soundBtn,300,null,300);							titleScreen.SetMatrixCallback(loadMatrix);			titleScreen.SetPokerCallback(loadPoker);			titleScreen.SetSlotsCallback(loadSlots);						Game.GameMode = "Title";						matrixLoader.loadExternalSWF(ContentManager.MATRIX, onMatrixLoaded, onMatrixProgress);			pokerLoader.loadExternalSWF(ContentManager.POKER, onPokerLoaded, onPokerProgress);			slotsLoader.loadExternalSWF(ContentManager.SLOTS, onSlotsLoaded, onSlotsProgress);		}		private function onMatrixLoaded()		{			matrixScreenProgressBarFiller.scaleX = 1;						matrixScreen = new MatrixScreen(matrixLoader);			matrixScreen.SetBackCallback(onMatrixBack);			isMatrixLoaded = true;		}		private function onSlotsLoaded()		{			slotsScreenProgressBarFiller.scalexX = 1;						slotsScreen = new SlotsScreen(slotsLoader);			slotsScreen.SetBackCallback(onSlotsBack);			isSlotsLoaded = true;		}		private function onPokerLoaded()		{			pokerScreenProgressBarFiller.scaleX = 1;						pokerScreen = new PokerScreen(pokerLoader);			pokerScreen.SetBackCallback(onPokerBack);			isPokerLoaded = true;		}				// CALLBACK FUNCTIONS		private var loadingTimer:Timer;		public function loadMatrix()		{			titleScreen.matrixShatter(onTitleShattered);		}		private function onTitleShattered()		{			if (!isMatrixLoaded)			{				gameLayer.removeChild(titleScreen);								gameLayer.addChild(loadingText);				gameLayer.addChild(matrixScreenProgressBar);				gameLayer.addChild(matrixScreenProgressBarFiller);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onMatrixWait);				loadingTimer.start();			}			else			{				if (gameLayer.contains(titleScreen)) gameLayer.removeChild(titleScreen);				GameMode = "Matrix";				gameLayer.addChild(matrixScreen);			}		}		private function onMatrixWait(e:Event)		{			if (isMatrixLoaded)			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onMatrixWait);				loadingTimer.stop();				loadingTimer = null;								gameLayer.removeChild(loadingText);				gameLayer.removeChild(matrixScreenProgressBar);				gameLayer.removeChild(matrixScreenProgressBarFiller);								onTitleShattered();			}			else			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onMatrixWait);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onMatrixWait);				loadingTimer.start();			}		}		public function loadSlots()		{			titleScreen.slotsShatter(onTitleShatteredForSlots);		}		private function onTitleShatteredForSlots()		{			if (!isSlotsLoaded)			{				gameLayer.removeChild(titleScreen);				gameLayer.addChild(loadingText);				gameLayer.addChild(slotsScreenProgressBar);				gameLayer.addChild(slotsScreenProgressBarFiller);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onPokerWait);				loadingTimer.start();			}			else			{				if (gameLayer.contains(titleScreen)) gameLayer.removeChild(titleScreen);				GameMode = "Slots";				gameLayer.addChild(slotsScreen);			}		}		private function onSlotsWait(e:Event)		{			if (isSlotsLoaded)			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onSlotsWait);				loadingTimer.stop();				loadingTimer = null;								gameLayer.removeChild(loadingText);				gameLayer.removeChild(slotsScreenProgressBar);				gameLayer.removeChild(slotsScreenProgressBarFiller);								onTitleShatteredForSlots();			}			else			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onSlotsWait);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onSlotsWait);				loadingTimer.start();			}		}		public function loadPoker()		{			titleScreen.pokerShatter(onTitleShatteredForPoker);		}		private function onTitleShatteredForPoker()		{			if (!isPokerLoaded)			{				gameLayer.removeChild(titleScreen);				gameLayer.addChild(loadingText);				gameLayer.addChild(pokerScreenProgressBar);				gameLayer.addChild(pokerScreenProgressBarFiller);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onPokerWait);				loadingTimer.start();			}			else			{				if (gameLayer.contains(titleScreen)) gameLayer.removeChild(titleScreen);				GameMode = "Poker";				gameLayer.addChild(pokerScreen);			}		}		private function onPokerWait(e:Event)		{			if (isPokerLoaded)			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onPokerWait);				loadingTimer.stop();				loadingTimer = null;								gameLayer.removeChild(loadingText);				gameLayer.removeChild(pokerScreenProgressBar);				gameLayer.removeChild(pokerScreenProgressBarFiller);								onTitleShatteredForPoker();			}			else			{				loadingTimer.removeEventListener(TimerEvent.TIMER, onPokerWait);				loadingTimer = new Timer(100,1);				loadingTimer.addEventListener(TimerEvent.TIMER, onPokerWait);				loadingTimer.start();			}		}		private function onMatrixBack()		{			matrixScreen.Shatter(onMatrixShattered);		}		private function onMatrixShattered()		{			GameMode = "Title";			gameLayer.removeChild(matrixScreen);			gameLayer.addChild(titleScreen);			titleScreen.Reset();		}		private function onPokerBack()		{			pokerScreen.Shatter(onPokerShattered);		}		private function onPokerShattered()		{			GameMode = "Title";			gameLayer.removeChild(pokerScreen);			gameLayer.addChild(titleScreen);			titleScreen.Reset();		}		private function onSlotsBack()		{			slotsScreen.Shatter(onSlotsShattered);		}		private function onSlotsShattered()		{			GameMode = "Title";			gameLayer.removeChild(slotsScreen);			gameLayer.addChild(titleScreen);			titleScreen.Reset();		}		private function onSoundClick()		{			Game.ToggleSound();			soundBtn.SetToggle(Game.IsSoundEnabled());		}		private function onMusicClick()		{			Game.ToggleMusic();			musicBtn.SetToggle(Game.IsMusicEnabled());		}				// GLOBAL FUNCTIONS				public static function GetVirtualCoins():int { return VirtualCoins; }		public static function GetFacebookCoins():int { return FacebookCoins; }				public static function SetVirtualCoins(n:int) { VirtualCoins = n; virtualCoinsText.text = "" + n; virtualCoinsText.setTextFormat(coinsTF); }		public static function SetFacebookCoins(n:int) { FacebookCoins = n; facebookCoinsText.text = "" + n; facebookCoinsText.setTextFormat(coinsTF); }				public static function IsSoundEnabled():Boolean { return SoundEnabled; }		public static function IsMusicEnabled():Boolean { return MusicEnabled; }				public static function SetSoundEnabled(b:Boolean) { if (SoundEnabled != b) ToggleSound(); }		public static function SetMusicEnabled(b:Boolean) { if (MusicEnabled != b) ToggleMusic(); }			public static function ToggleSound()		{			Game.SoundEnabled = !Game.SoundEnabled;						soundBtn.SetToggle(Game.SoundEnabled);						var l:URLLoader = new URLLoader();			l.addEventListener(Event.COMPLETE, onResponse);			if (SoundEnabled) l.load(new URLRequest(NET+"?action=toggleSoundOn"));			else l.load(new URLRequest(NET+"?action=toggleSoundOff"));		}		public static function ToggleMusic()		{			Game.MusicEnabled = !Game.MusicEnabled;						musicBtn.SetToggle(Game.MusicEnabled);						var l:URLLoader = new URLLoader();			l.addEventListener(Event.COMPLETE, onResponse);			if (MusicEnabled) l.load(new URLRequest(NET+"?action=toggleMusicOn"));			else l.load(new URLRequest(NET+"?action=toggleMusicOff"));		}		private static function onResponse(e:Event) { e.currentTarget.removeEventListener(Event.COMPLETE, onResponse); }				public static function ParseXML(xmlFile:String, tag:String):String		{			var startIndex:int = xmlFile.indexOf("<"+tag+">") + ("<"+tag+">").length;			var endIndex:int = xmlFile.indexOf("</"+tag+">");						if (startIndex >= 0 && endIndex >= 0)				return xmlFile.substr(startIndex, endIndex - startIndex);			else return null;		}		public static function GetInstance() : MovieClip { return _instance; }				public static function GetMovieClip(className:String) : MovieClip		{			var clip:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;						if (clip != null)			{				var movieClip:MovieClip = new clip() as MovieClip;				return movieClip;			}			else return null;		}		public static function Message(s:String)		{			systemMessage.htmlText = s;			systemMessage.setTextFormat(systemMessageTF);						systemMessage.alpha = 1;			motion.createFadeOut(systemMessage, 2000, null, 2000);		}	}	}