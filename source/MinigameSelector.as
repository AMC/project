﻿package  {	import flash.display.MovieClip;	import flash.events.Event;		public class MinigameSelector extends MovieClip	{		private var onCloseCallback:Function;		private var motion:MotionEngine;		private var minigame:MovieClip;				private var bid:int;				private var selectionPlate:MovieClip;		private var selectionNeedle:MovieClip;				private var gameMode:String;				public function MinigameSelector(bid:int, onMinigameClose:Function) 		{			onCloseCallback = onMinigameClose;			motion = new MotionEngine();						this.bid = bid;						selectionPlate = Game.GetMovieClip("MinigameSelection");			selectionNeedle = Game.GetMovieClip("MinigamePin");						this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(e:Event)		{			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);						addChild(selectionPlate);			addChild(selectionNeedle);						selectionPlate.x = 122;			selectionPlate.y = 74;			selectionNeedle.x = 360;		selectionNeedle.y = 330;						var r:Number = Math.random() * 3000 + 3000;						motion.createAcceleratedRotationZ(selectionNeedle, r/4, r, 15, onSelectionComplete);		}		private function onSelectionComplete()		{			gameMode = Game.GameMode;			Game.GameMode = "Minigame";			if (selectionNeedle.rotationZ >= 0 && selectionNeedle.rotationZ <= 180) 				minigame = new HighLowGame(bid, close);			else 				minigame = new MatchGame(bid, close);						addChild(minigame);			minigame.x = 800;			motion.createMove(minigame, 9, 63, 1000, moveInDone);		}		private function moveInDone()		{			motion.createFadeOut(selectionPlate, 1000, fadeDone);		}		private function fadeDone()		{			this.removeChild(selectionPlate);			this.removeChild(selectionNeedle);		}				private function close()		{			Game.GameMode = gameMode;			onCloseCallback();		}	}	}