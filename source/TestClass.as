﻿package  {		import flash.display.MovieClip;	import flash.events.Event;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.utils.Timer;	import flash.events.TimerEvent;			public class TestClass extends MovieClip {				private var debug:TextField;		private var debugTF:TextFormat;				private var front:MovieClip;				public function TestClass() 		{			debug = new TextField();			debugTF = new TextFormat(null, null, 0x000000);			debug.setTextFormat(debugTF);						debug.selectable = false;			debug.wordWrap = true;						front = new Front();						if (1 == 2-1 == 3-2 == 1) trace("BAM!")									 			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(e:Event)		{			addChild(debug);			addChild(front);						debug.x = 20; debug.y = 20; debug.width = stage.width - 40; debug.height = stage.height - 40;			front.x = stage.width/2 - front.width/2; front.y = stage.height/2 - front.height/2;						var timer:Timer = new Timer(0,0);			timer.addEventListener(TimerEvent.TIMER, onTick);			timer.start();		}		private function onTick(e:Event)		{			front.scaleY -= 0.01;			if (front.scaleY < -1) front.scaleY = -1;						debug.text = "Width: "+front.width+"\nRotationY: "+front.rotationY;			debug.setTextFormat(debugTF);		}	}	}