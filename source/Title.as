﻿package  {		import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;		public class Title extends MovieClip 	{				private var contentManager:ContentManager;				private var playBtn:Button;		private var fader:MovieClip;		private var slotsBtn:Button;		private var matrixBtn:Button;		private var pokerBtn:Button;		private var backBtn:Button;				private var bgCoins:MovieClip;		private var bgBars:MovieClip;				private var matrixCallback:Function;		private var pokerCallback:Function;		private var slotsCallback:Function;				private var motion:MotionEngine;				private var addedToStage:Boolean = false;				public function Title(titleContent:ContentManager) 		{			contentManager = titleContent;			motion = new MotionEngine();						bgCoins = Game.GetMovieClip("BG_Coins");			bgBars = Game.GetMovieClip("BG_Bars");						fader = Game.GetMovieClip("Fader");			slotsBtn = new Button(Button.SLOTS);			matrixBtn = new Button(Button.MATRIX);			pokerBtn = new Button(Button.POKER);			playBtn = new Button(Button.PLAY);			backBtn = new Button(Button.BACK);						addChild(bgCoins);			addChild(bgBars);							addChild(playBtn);						playBtn.SetOnClick(onPlay);			backBtn.SetOnClick(onBack);			matrixBtn.SetOnClick(onMatrix);			slotsBtn.SetOnClick(onSlots);			pokerBtn.SetOnClick(onPoker);						this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);		}		private function onAddedToStage(e:Event)		{			if (!addedToStage)			{				playBtn.x -= 500;			playBtn.y = 210;								motion.createMove(playBtn,260,300,300);							bgCoins.x = 0; bgCoins.y = 800;				bgBars.x = 0; bgBars.y = -800;								motion.createMove(bgCoins,0,300,1000);				motion.createMove(bgBars,0,0,1000);								addedToStage = true;			}		}		private function onRemovedFromStage(e:Event=null)		{					}		private function onPlay()		{			addChild(fader);			addChild(matrixBtn);			addChild(pokerBtn);			addChild(slotsBtn);			addChild(backBtn);						matrixBtn.x = 279;	matrixBtn.y = -200;			slotsBtn.y += 500; 	slotsBtn.x -= 500;			pokerBtn.x = 720;	pokerBtn.y = 620;			backBtn.y += 500;						motion.createFadeIn(fader,300);			motion.createMove(matrixBtn,453,218,300);			motion.createMove(slotsBtn,102,230,300);			motion.createMove(pokerBtn,245,130,300);			motion.createMove(backBtn,303,412,300);		}		private function onBack()		{			motion.createMove(matrixBtn,279,-200,300);			motion.createMove(slotsBtn,108-500,290+500,300);			motion.createMove(pokerBtn,720,620,300);			motion.createMove(backBtn,303,412+500,300,onBackComplete);		}		private function onBackComplete()		{			removeChild(fader);			removeChild(matrixBtn);			removeChild(pokerBtn);			removeChild(slotsBtn);			removeChild(backBtn);		}		public function SetMatrixCallback(f:Function) { matrixCallback = f; }		public function SetPokerCallback(f:Function) { pokerCallback = f; }		public function SetSlotsCallback(f:Function) { slotsCallback = f; }				public function matrixShatter(callback:Function)		{			onBack();			motion.createMove(playBtn,508,390,500);			motion.createMove(bgBars,0,-800,500);			motion.createMove(bgCoins,0,800,500);			motion.createFadeOut(fader,300,callback);		}		public function pokerShatter(callback:Function)		{			onBack();			motion.createMove(playBtn,240,360,500);			motion.createMove(bgBars,0,-800,500);			motion.createMove(bgCoins,0,800,500);			motion.createFadeOut(fader,300,callback);		}		public function slotsShatter(callback:Function) 		{			motion.createMove(playBtn,-300,360,500);			motion.createMove(bgBars,0,-800,500);			motion.createMove(bgCoins,0,800,500);			motion.createFadeOut(fader,300,callback);			onBack();		}		public function Reset()		{			if (playBtn.x == -300)			{				motion.createMove(playBtn,260,300,500);			}			else playBtn.x = 260; playBtn.y = 300;						motion.createMove(bgBars,0,0,500);			motion.createMove(bgCoins,0,300,500);		}				private function onPoker()		{			pokerCallback();		}		private function onSlots()		{			slotsCallback();		}		private function onMatrix()		{			matrixCallback();		}	}	}