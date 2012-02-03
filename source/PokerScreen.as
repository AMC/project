﻿package  {	import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextFormat;	import flash.text.TextField;	import flash.net.URLLoader;	import flash.text.TextFormatAlign;	import flash.geom.Point;	import flash.net.URLRequest;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.text.TextFieldAutoSize;	import flash.filters.GlowFilter;		public class PokerScreen extends MovieClip	{		private var contentManager:ContentManager;		private var motion:MotionEngine;				private var bid:int;				private var profileIndexes:Array;		private var cards:Array;				private var bidPlate:MovieClip;		private var bidText:TextField;		private var bidTextFormat:TextFormat;				private var minus1:Button;		private var minus5:Button;		private var minus10:Button;		private var minus25:Button;		private var plus1:Button;		private var plus5:Button;		private var plus10:Button;		private var plus25:Button;		private var reset:Button;		private var playBtn:Button;				private var backBtn:Button;				private var boardObjects:Array;				private var playStartTime:int;		private var net:URLLoader;				private var rollID:String;		private var rollResult:String;				private var isLoadDone:Boolean = false;		private var isPlayDone:Boolean = true;		public function PokerScreen(pokerManager:ContentManager) 		{			contentManager = pokerManager;			motion = new MotionEngine();			boardObjects = new Array();			profileIndexes = new Array();			cards = new Array();						bidPlate = Game.GetMovieClip("BidPlate");			minus1 = new Button(Button.MINUS1);			minus5 = new Button(Button.MINUS5);			minus10 = new Button(Button.MINUS10);			minus25 = new Button(Button.MINUS25);			plus1 = new Button(Button.PLUS1);			plus5 = new Button(Button.PLUS5);			plus10 = new Button(Button.PLUS10);			plus25 = new Button(Button.PLUS25);			reset = new Button(Button.RESET);			playBtn = new Button(Button.PLAY);			backBtn = new Button(Button.BACK_ARROW);			bidText = new TextField();			bidTextFormat = new TextFormat("Impact",48,0xFFFFFF,null,null,null,null,null, TextFormatAlign.CENTER);			bidText.selectable = false;						addChild(playBtn);			addChild(bidPlate);			bidPlate.addChild(minus1);			bidPlate.addChild(minus5);			bidPlate.addChild(minus10);			bidPlate.addChild(minus25);			bidPlate.addChild(plus1);			bidPlate.addChild(plus5);			bidPlate.addChild(plus10);			bidPlate.addChild(plus25);			bidPlate.addChild(reset);			bidPlate.addChild(bidText);			addChild(backBtn);						playBtn.SetOnClick(onPlay);			reset.SetOnClick(onReset);			minus1.SetOnClick(onMinus1);			minus5.SetOnClick(onMinus5);			minus10.SetOnClick(onMinus10);			minus25.SetOnClick(onMinus25);			plus1.SetOnClick(onPlus1);			plus5.SetOnClick(onPlus5);			plus10.SetOnClick(onPlus10);			plus25.SetOnClick(onPlus25);						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);		}				public function SetBackCallback(f:Function)		{			backBtn.SetOnClick(f);		}		public function Shatter(callback:Function)		{			if (boardObjects.length > 0)			{				for (var n:int = 0; n < boardObjects.length; n++)				{					motion.createMove(boardObjects[n],0,-400,300,null,0,true);				}				boardObjects = new Array();			}						motion.createFadeOut(bidText, 300);			motion.createMove(playBtn,260,300,300);			motion.createMove(bidPlate, 900, -100, 500);			motion.createMove(reset, -100, 900, 500);			motion.createMove(minus1, 900, 900, 500);			motion.createMove(minus5, -100, -100, 500);			motion.createMove(minus10, 900, -100, 500);			motion.createMove(minus25, -100, 900, 500);			motion.createMove(plus1, 900, 900, 500);			motion.createMove(plus5, -100, -100, 500);			motion.createMove(plus10, 900, -100, 500);			motion.createMove(plus25, -100, 900, 500, callback);		}						//======================================//		// PRIVATE FUNCTIONS					//		//======================================//				private function onAddedToStage(e:Event)		{			setBid(10);						disableButtons();						profileIndexes = [];			profileIndexes[0] = 0;						loadNewProfiles();						var p:Point = new Point(360,310);			var a:Number = Math.random()*Math.PI*2;						playBtn.x = 240;					playBtn.y = 360;			bidPlate.x = p.x+Math.cos(a)*1000;	bidPlate.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			reset.x = p.x+Math.cos(a)*1000;		reset.y = p.x+Math.sin(a)*1000;		a = Math.random()*Math.PI*2;			minus1.x = p.x+Math.cos(a)*1000;	minus1.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			minus5.x = p.x+Math.cos(a)*1000;	minus5.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			minus10.x = p.x+Math.cos(a)*1000;	minus10.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			minus25.x = p.x+Math.cos(a)*1000;	minus25.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			plus1.x = p.x+Math.cos(a)*1000; 	plus1.y = p.y+Math.sin(a)*1000;		a = Math.random()*Math.PI*2;			plus5.x = p.x+Math.cos(a)*1000;		plus5.y = p.y+Math.sin(a)*1000;		a = Math.random()*Math.PI*2;			plus10.x = p.x+Math.cos(a)*1000;	plus10.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			plus25.x = p.x+Math.cos(a)*1000;	plus25.y = p.y+Math.sin(a)*1000;	a = Math.random()*Math.PI*2;			backBtn.x = p.x+Math.cos(a)*1000;	backBtn.y = p.y+Math.sin(a)*1000;	backBtn.scaleX = backBtn.scaleY = 0.5;						bidText.text = String(bid);			bidText.setTextFormat(bidTextFormat);			bidText.x = 64;	bidText.width = 88;	bidText.y = (33+64) - bidText.textHeight/2;						//motion.createMove(bidPlate,508,215,500);			motion.createMove(bidPlate,32,360,500);			motion.createMove(backBtn,4,530,500);			motion.createMove(reset,8,33,500);			motion.createMove(minus1,33,33,500);			motion.createMove(minus5,33,65,500);			motion.createMove(minus10,33,97,500);			motion.createMove(minus25,33,129,500);			motion.createMove(plus1,160,33,500);			motion.createMove(plus5,160,65,500);			motion.createMove(plus10,160,97,500);			motion.createMove(plus25,160,129,500);			motion.createFadeIn(bidText, 500, null, 500);						var timer:Timer = new Timer(0,0);			timer.addEventListener(TimerEvent.TIMER, onCheckForProfilesLoaded);			timer.start();		}		private function onRemovedFromStage(e:Event)		{					}		private function loadNewProfiles()		{			isLoadDone = false;						profileIndexes = [];			profileIndexes[0] = 0;						for (var n:int = 1; n < 13; n++)			{				var found:Boolean = false;				var pI:int = int(Math.random()*(Game.Profiles.length-1))+1								for (var t:int = 1; t < profileIndexes.length; t++)					if (profileIndexes[t] == pI)						found = true;										if (!found)					profileIndexes[n] = pI;				else n--;			}						for (n = 0; n < profileIndexes.length; n++)			{				Game.Profiles.Get(profileIndexes[n]).LoadProfile();			}						var timer:Timer = new Timer(0,0);			timer.addEventListener(TimerEvent.TIMER, onCheckForProfilesLoaded);			timer.start();		}		private function onCheckForProfilesLoaded(e:Event)		{			var b:Boolean = true;						for (var n:int = 0; n < profileIndexes.length; n++)			{				var profile:ProfileNode = Game.Profiles.Get(profileIndexes[n]);				if (profile.isLoaded == false) b = false;			}			if (b)			{				e.target.stop();				e.target.removeEventListener(TimerEvent.TIMER, onCheckForProfilesLoaded);				//e.target = null;								cards = [];							var deck:String = "A234567890JQKA234567890JQKA234567890JQKA234567890JQK";				for (n = 0; n < 13; n++)				{					var c1:Card = new Card(Game.Profiles.Get(profileIndexes[n]));					var c2:Card = new Card(Game.Profiles.Get(profileIndexes[n]));					var c3:Card = new Card(Game.Profiles.Get(profileIndexes[n]));					var c4:Card = new Card(Game.Profiles.Get(profileIndexes[n]));										c1.setCard("1",deck.charAt(n)); cards[n] = c1;					c2.setCard("2",deck.charAt(n)); cards[n+13] = c2;					c3.setCard("3",deck.charAt(n)); cards[n+26] = c3;					c4.setCard("4",deck.charAt(n)); cards[n+39] = c4;				}				isLoadDone = true;								if (isPlayDone) enableButtons();			}		}		private function onPlay(e:Event=null)		{			isPlayDone = false;			isLoadDone = false;						if (Game.GetVirtualCoins() < bid)			{				MessageBox.Okay("Insufficient funds to play.");				return;			}						Game.SetVirtualCoins(Game.GetVirtualCoins() - bid);						disableButtons();			if (boardObjects.length > 0)			{				for (var n:int = 0; n < boardObjects.length; n++)				{					motion.createMove(boardObjects[n],0,-400,300,null,n*50,true);				}				boardObjects = [];			}						net = new URLLoader();			net.addEventListener(Event.COMPLETE, onPlayReceived);			try			{				net.load(new URLRequest(Game.NET+"?action=play&mode=poker&bid="+bid));			}			catch (e:Error)			{							}		}		private function onPlayReceived(e:Event)		{			net.removeEventListener(Event.COMPLETE, onPlayReceived);						if (String(net.data).indexOf("<error>") >= 0)			{				MessageBox.Okay(Game.ParseXML(net.data,"error"));				enableButtons();				return;			}						rollID = Game.ParseXML(net.data,"rollID");			rollResult = Game.ParseXML(net.data,"result");						//	abcdefghijklmnopqrstuvwxyzBCDEFGHILMNOPRSTUVWXYZ!@#$						var res:String = "" + rollResult;						while (res.indexOf("1") >= 0) res = res.replace("1", "_0");			while (res.indexOf("2") >= 0) res = res.replace("2", "_J");			while (res.indexOf("3") >= 0) res = res.replace("3", "_Q");			while (res.indexOf("4") >= 0) res = res.replace("4", "_K");			while (res.indexOf("a") >= 0) res = res.replace("a","^A");				while (res.indexOf("o") >= 0) res = res.replace("o", "+A");			while (res.indexOf("b") >= 0) res = res.replace("b","^2");				while (res.indexOf("p") >= 0) res = res.replace("p", "+2");			while (res.indexOf("c") >= 0) res = res.replace("c","^3");				while (res.indexOf("q") >= 0) res = res.replace("q", "+3");			while (res.indexOf("d") >= 0) res = res.replace("d","^4");				while (res.indexOf("r") >= 0) res = res.replace("r", "+4");			while (res.indexOf("e") >= 0) res = res.replace("e","^5");				while (res.indexOf("s") >= 0) res = res.replace("s", "+5");			while (res.indexOf("f") >= 0) res = res.replace("f","^6");				while (res.indexOf("t") >= 0) res = res.replace("t", "+6");			while (res.indexOf("g") >= 0) res = res.replace("g","^7");				while (res.indexOf("u") >= 0) res = res.replace("u", "+7");			while (res.indexOf("h") >= 0) res = res.replace("h","^8");				while (res.indexOf("v") >= 0) res = res.replace("v", "+8");			while (res.indexOf("i") >= 0) res = res.replace("i","^9");				while (res.indexOf("w") >= 0) res = res.replace("w", "+9");			while (res.indexOf("j") >= 0) res = res.replace("j","^0");				while (res.indexOf("x") >= 0) res = res.replace("x", "+0");			while (res.indexOf("k") >= 0) res = res.replace("k","^J");				while (res.indexOf("y") >= 0) res = res.replace("y", "+J");			while (res.indexOf("l") >= 0) res = res.replace("l","^Q");				while (res.indexOf("z") >= 0) res = res.replace("z", "+Q");			while (res.indexOf("m") >= 0) res = res.replace("m","^K");				while (res.indexOf("B") >= 0) res = res.replace("B", "+K");			while (res.indexOf("n") >= 0) res = res.replace("n","-A");				while (res.indexOf("C") >= 0) res = res.replace("C", "_A");			while (res.indexOf("D") >= 0) res = res.replace("D","-2");				while (res.indexOf("S") >= 0) res = res.replace("S", "_2");			while (res.indexOf("E") >= 0) res = res.replace("E","-3");				while (res.indexOf("T") >= 0) res = res.replace("T", "_3");			while (res.indexOf("F") >= 0) res = res.replace("F","-4");				while (res.indexOf("U") >= 0) res = res.replace("U", "_4");			while (res.indexOf("G") >= 0) res = res.replace("G","-5");				while (res.indexOf("V") >= 0) res = res.replace("V", "_5");			while (res.indexOf("H") >= 0) res = res.replace("H","-6");				while (res.indexOf("W") >= 0) res = res.replace("W", "_6");			while (res.indexOf("I") >= 0) res = res.replace("I","-7");				while (res.indexOf("X") >= 0) res = res.replace("X", "_7");			while (res.indexOf("L") >= 0) res = res.replace("L","-8");				while (res.indexOf("Y") >= 0) res = res.replace("Y", "_8");			while (res.indexOf("M") >= 0) res = res.replace("M","-9");				while (res.indexOf("Z") >= 0) res = res.replace("Z", "_9");			while (res.indexOf("N") >= 0) res = res.replace("N","-0");				while (res.indexOf("O") >= 0) res = res.replace("O","-J");				while (res.indexOf("P") >= 0) res = res.replace("P","-Q");				while (res.indexOf("R") >= 0) res = res.replace("R","-K");										while (res.indexOf("^") >= 0) res = res.replace("^","1");			while (res.indexOf("-") >= 0) res = res.replace("-","2");			while (res.indexOf("_") >= 0) res = res.replace("_","3");			while (res.indexOf("+") >= 0) res = res.replace("+","4");						var angle:Number = 0;						for (var n:int = 0; n < 5; n++)			{				var card:Card;				for (var t:int = 0; t < 52; t++)				{					var rSuit:String = res.charAt(n*2);					var rNumber:String = res.charAt(n*2+1);										if (cards[t].number==rNumber && cards[t].suit==rSuit)					{						var cc:Card = cards[t] as Card;						card = cc.clone();						card.setCard(rSuit,rNumber);					}				}								addChild(card);				card.x = 800;				card.y = 300;				boardObjects[n] = card;				var dX:int = playBtn.x + playBtn.width/2;				var dY:int = playBtn.y + playBtn.height/2;				card.scaleX = 1.25;				card.scaleY = 1.25;								dX = dX + Math.cos(angle)*280;				dY = dY + Math.sin(angle)*280;				angle -= Math.PI/5;								motion.createMove(card,dX,dY,300,null,n*100);				var rand:int = int(Math.floor(Math.random()*24));				rand -= 12;				motion.createRotationZ(card,rand,300,n==4?checkWin:null,n*100);			}		}		private var checkTimer:Timer;		private function checkWin()		{			if (checkTimer != null)			{				checkTimer.removeEventListener(TimerEvent.TIMER, onCheckWin);				checkTimer.stop();				checkTimer = null;			}			for (var n:int = 0; n < 5; n++)			{				if (boardObjects[n].isLoaded == false)				{					checkTimer = new Timer(100,1);					checkTimer.addEventListener(TimerEvent.TIMER, onCheckWin);					checkTimer.start();					return;				}			}			for (n = 0; n < 5; n++)			{				motion.createFlip(boardObjects[n],200,n==4?onFlipComplete:null,n*50);			}		}		private var winAmount:int;		private function onFlipComplete()		{			winAmount = 0;						// Pay table courtesy of http://casinogambling.about.com/od/videopoker/a/vppaytable.htm			sort(boardObjects);									var n1:int = boardObjects[0].getPokerValue();			var n2:int = boardObjects[1].getPokerValue();			var n3:int = boardObjects[2].getPokerValue();			var n4:int = boardObjects[3].getPokerValue();			var n5:int = boardObjects[4].getPokerValue();						// Check for royal flush		// 250			if ((boardObjects[0].suit == boardObjects[1].suit && boardObjects[1].suit == boardObjects[2].suit && boardObjects[2].suit == boardObjects[3].suit && boardObjects[3].suit == boardObjects[4].suit) &&				(boardObjects[0].number=="0" && boardObjects[1].number=="J" && boardObjects[2].number=="Q" && boardObjects[3].number=="K" && boardObjects[4].number=="A"))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0x00FF00);				motion.createBlink(boardObjects[2], 5000, 333, 0x0000FF);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF00FF);				motion.createBlink(boardObjects[4], 5000, 333, 0xFFFF00);								winAmount = bid * 250;				if (bid == 999) winAmount += (4000/5)*999;								display("ROYAL FLUSH!");			}			// Check for straight flush		// 50			else if ((boardObjects[0].suit == boardObjects[1].suit && boardObjects[1].suit == boardObjects[2].suit && boardObjects[2].suit == boardObjects[3].suit && boardObjects[3].suit == boardObjects[4].suit) &&					 (boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue()-1 && boardObjects[0].getPokerValue() == boardObjects[2].getPokerValue()-2 && boardObjects[0].getPokerValue() == boardObjects[3].getPokerValue()-3 && boardObjects[0].getPokerValue() == boardObjects[4].getPokerValue()-4))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 50;								display("Straight Flush");			}			// Check for Four of a Kind		// 25			else if (boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue() && boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue() && boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue())			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);								winAmount = bid * 25;								display("Four of a Kind");			}			else if (boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue() && boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue() && boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue())			{				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 25;								display("Four of a Kind");			}			// Check for Full House			// 6			else if (((boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue() && boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue()) && (boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue())) ||					 ((boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue()) && (boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue() && boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue())))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 6;								display("Full House");			}			// Check for Flush				// 5			else if (boardObjects[0].suit == boardObjects[1].suit && boardObjects[1].suit == boardObjects[2].suit && boardObjects[2].suit == boardObjects[3].suit && boardObjects[3].suit == boardObjects[4].suit)			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 5;								display("Flush");			}			// Check for Straight			// 4			else if ((boardObjects[0].number == "0" && boardObjects[1].number == "J" && boardObjects[2].number == "Q" && boardObjects[3].number == "K" && boardObjects[4].number == "A") ||					 (boardObjects[0].number == "A" && boardObjects[1].number == "2" && boardObjects[2].number == "3" && boardObjects[3].number == "4" && boardObjects[4].number == "5") ||					 (boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue()-1 && boardObjects[0].getPokerValue() == boardObjects[2].getPokerValue()-2 && boardObjects[0].getPokerValue() == boardObjects[3].getPokerValue()-3 && boardObjects[0].getPokerValue() == boardObjects[4].getPokerValue()-4))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 4;								display("Straight");			}			// Check for Three of a Kind	// 3			else if (boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue() && boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue())			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);								winAmount = bid * 3;								display("Three of a Kind");			}			else if (boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue() && boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue())			{				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);								winAmount = bid * 3;								display("Three of a Kind");			}			else if (boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue() && boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue())			{				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);								winAmount = bid * 3;								display("Three of a Kind");			}			// Check for Two Pair			// 2			else if ((boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue()) &&					 (boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue()))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0x00FF00);				motion.createBlink(boardObjects[3], 5000, 333, 0x00FF00);								winAmount = bid * 2;								display("Two Pair");			}			else if ((boardObjects[0].getPokerValue() == boardObjects[1].getPokerValue()) &&					 (boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue()))			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0x00FF00);				motion.createBlink(boardObjects[4], 5000, 333, 0x00FF00);								winAmount = bid * 2;								display("Two Pair");			}			else if ((boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue()) &&					 (boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue()))			{				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0x00FF00);				motion.createBlink(boardObjects[4], 5000, 333, 0x00FF00);								winAmount = bid * 2;								display("Two Pair");			}			// Check for Jacks				// 1			else if (boardObjects[4].getPokerValue() > 10 && boardObjects[3].getPokerValue() == boardObjects[4].getPokerValue())			{				motion.createBlink(boardObjects[4], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);								winAmount = bid;								if (boardObjects[4].getPokerValue() == 11) display("Jacks!");				if (boardObjects[4].getPokerValue() == 12) display("Queens!");				if (boardObjects[4].getPokerValue() == 13) display("Kings!");				if (boardObjects[4].getPokerValue() == 14) display("ACES!");			}			else if (boardObjects[3].getPokerValue() > 10 && boardObjects[2].getPokerValue() == boardObjects[3].getPokerValue())			{				motion.createBlink(boardObjects[3], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);								winAmount = bid;								if (boardObjects[3].getPokerValue() == 11) display("Jacks!");				if (boardObjects[3].getPokerValue() == 12) display("Queens!");				if (boardObjects[3].getPokerValue() == 13) display("Kings!");				if (boardObjects[3].getPokerValue() == 14) display("ACES!");			}			else if (boardObjects[2].getPokerValue() > 10 && boardObjects[1].getPokerValue() == boardObjects[2].getPokerValue())			{				motion.createBlink(boardObjects[2], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);								winAmount = bid;								if (boardObjects[2].getPokerValue() == 11) display("Jacks!");				if (boardObjects[2].getPokerValue() == 12) display("Queens!");				if (boardObjects[2].getPokerValue() == 13) display("Kings!");				if (boardObjects[2].getPokerValue() == 14) display("ACES!");			}			else if (boardObjects[0].getPokerValue() > 10 && boardObjects[1].getPokerValue() == boardObjects[0].getPokerValue())			{				motion.createBlink(boardObjects[0], 5000, 333, 0xFF0000);				motion.createBlink(boardObjects[1], 5000, 333, 0xFF0000);								winAmount = bid;								if (boardObjects[0].getPokerValue() == 11) display("Jacks!");				if (boardObjects[0].getPokerValue() == 12) display("Queens!");				if (boardObjects[0].getPokerValue() == 13) display("Kings!");				if (boardObjects[0].getPokerValue() == 14) display("ACES!");			}						if (winAmount > 0)			{				net = new URLLoader();				net.addEventListener(Event.COMPLETE, onWinConfirmation);				net.load(new URLRequest(Game.NET+"?action=win&rollID="+rollID+"&bid="+bid+"&result="+rollResult+"&winAmount="+winAmount));			}			else finishWinConfirmation();		}		private function display(s:String)		{			var t:TextField = new TextField();			var tf:TextFormat = new TextFormat("Bangla", 72, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);			t.selectable = false;			t.text = s;			t.setTextFormat(tf);			t.filters = [new GlowFilter(0x0000FF,1.0,12.0,12.0,2,1,false,false)];						// 200, 280			addChild(t);			t.x = 50;			t.y = 220;			t.width = 620;						motion.createMove(t,50,0,3000);			motion.createFadeOut(t,3000,null,0,true);		}		private function sort(a:Array)		{			if (a.length < 2) return;						for (var n:int = 0; n < a.length-1; n++)			{				for (var t:int = n+1; t<a.length; t++)				{					if (a[n].getPokerValue() > a[t].getPokerValue())					{						var c:Card = a[n] as Card;						a[n] = a[t];						a[t] = c;					}				}			}		}		private function onWinConfirmation(e:Event)		{						net.removeEventListener(Event.COMPLETE, onWinConfirmation);						var error:String = Game.ParseXML(net.data,"error");			if (error != null && error.length > 0)			{				MessageBox.Okay(error);				finishWinConfirmation();			}						var win:int = int(Game.ParseXML(net.data,"coins"));			Game.SetVirtualCoins(win);						var numCoins = (winAmount/bid)*2;			if (numCoins > 50) numCoins = 50;						var curX:int = 0;						for (var n:int = 0; n < numCoins; n++)			{				var coin:MovieClip = Game.GetMovieClip("Coin");				addChild(coin);								coin.x = bidPlate.x + 112 + curX;				coin.y = bidPlate.y + 126;				curX += 2;								motion.createMove(coin,586,12,500,playCoinSound,n*100,true);			}						finishWinConfirmation();		}		private function playCoinSound(e:Event=null)		{			if (Game.IsSoundEnabled())			{				// TODO: Play sound!!			}		}		private function finishWinConfirmation()		{			isPlayDone = true;			loadNewProfiles();						if (isLoadDone == true) enableButtons();		}		private function onCheckWin(e:Event) { checkWin(); }		private function disableButtons()		{			backBtn.Disable();			reset.Disable();			minus1.Disable();			minus5.Disable();			minus10.Disable();			minus25.Disable();			plus1.Disable();			plus5.Disable();			plus10.Disable();			plus25.Disable();			playBtn.Disable();		}		private function enableButtons()		{			backBtn.Enable();			reset.Enable();			minus1.Enable();			minus5.Enable();			minus10.Enable();			minus25.Enable();			plus1.Enable();			plus5.Enable();			plus10.Enable();			plus25.Enable();			playBtn.Enable();		}		private function onReset() { setBid(1); }		private function onMinus1() { setBid(bid-1); }		private function onMinus5() { setBid(bid-5); }		private function onMinus10() { setBid(bid-10); }		private function onMinus25() { setBid(bid-25); }		private function onPlus1() { setBid(bid+1); }		private function onPlus5() { setBid(bid+5); }		private function onPlus10() { setBid(bid+10); }		private function onPlus25() { setBid(bid+25); }		private function setBid(n:int)		{			bid = n;			if (bid < 10) bid = 10;			if (bid > 100) bid = 100;			if (bid > Game.GetVirtualCoins()) 			{				if (Game.GetVirtualCoins() == 0)				{					//TODO: Message box that says you're out of currency ...				}				else bid = Game.GetVirtualCoins();			}			bidText.text = String(bid);			bidText.setTextFormat(bidTextFormat);		}	}	}