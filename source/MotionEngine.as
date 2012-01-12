﻿package  {	import flash.display.MovieClip;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.Event;	import flash.display.DisplayObject;	import flash.utils.getTimer;	import flash.filters.GlowFilter;	import flash.filters.BlurFilter;		public class MotionEngine 	{		private var objects:Array		private var numObjects:int;				private var updateTimer:Timer;				public function MotionEngine() 		{			objects = new Array();			numObjects = 0;						updateTimer = new Timer(0);			updateTimer.addEventListener(TimerEvent.TIMER, onTimer);			updateTimer.start();		}				public function createMove(objToMove:DisplayObject, destX:Number, destY:Number, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "move";			m.object = objToMove;			m.originX = objToMove.x;			m.originY = objToMove.y;			m.destinationX = destX;			m.destinationY = destY;			m.durationInMillis = durationInMillis;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();			m.onComplete = onCompleteCallback;						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createFadeIn(objToFade:DisplayObject, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "fadeIn";			m.object = objToFade;			m.originAlpha = objToFade.alpha;			m.destinationAlpha = 1.0;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createFadeOut(objToFade:DisplayObject, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			for (var t:int = 0; t < objects.length; t++)			{				var o:MotionObject = objects[t] as MotionObject;				if (o.object == objToFade && o.motionType == "fadeOut")				{					o.originAlpha = 1.0;					o.destinationAlpha = 0.0;					o.durationInMillis = durationInMillis;					o.onComplete = onCompleteCallback;					o.delayedStartInMillis = delayedStartInMillis;					o.killOnComplete = killOnComplete;					o.startTime = getTimer();					return t;				}			}						var m:MotionObject = new MotionObject();						m.motionType = "fadeOut";			m.object = objToFade;			m.originAlpha = objToFade.alpha;			m.destinationAlpha = 0.0;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createRotationX(objToRotate:DisplayObject, degrees:Number, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "rotateX";			m.object = objToRotate;			m.originRotation = objToRotate.rotationX;			m.destinationRotation = degrees;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createRotationY(objToRotate:DisplayObject, degrees:Number, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "rotateY";			m.object = objToRotate;			m.originRotation = objToRotate.rotationX;			m.destinationRotation = degrees;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createRotationZ(objToRotate:DisplayObject, degrees:Number, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "rotateZ";			m.object = objToRotate;			m.originRotation = objToRotate.rotationX;			m.destinationRotation = degrees;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();									objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createFlip(objToFlip:DisplayObject, durationInMillis:int, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "flipA";			m.originX = objToFlip.x;			m.originY = objToFlip.y;			m.originWidth = objToFlip.width;			m.originHeight = objToFlip.height;			m.object = objToFlip;			m.durationInMillis = durationInMillis;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createBlink(objToBlink:DisplayObject, durationInMillis:int, blinkSpeedInMillis:int = 333, blinkColor:uint = 0xFFFFFF, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			for (var t:int = 0; t < objects.length; t++)			{				var o:MotionObject = objects[t] as MotionObject;				if (o.object == objToBlink && o.motionType == "blink") return -1;			}			var m:MotionObject = new MotionObject();						m.motionType = "blink";			m.object = objToBlink;			m.originFilters = objToBlink.filters;			m.durationInMillis = durationInMillis;			m.blinkSpeedInMillis = blinkSpeedInMillis;			m.blinkColor = blinkColor;			m.blinkGlow = new GlowFilter(m.blinkColor,1.0,9.0,9.0,3,1,false,false);			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();			m.lastBlink = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createInnerBlink(objToBlink:DisplayObject, durationInMillis:int, blinkSpeedInMillis:int = 333, blinkColor:uint = 0xFFFFFF, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			for (var t:int = 0; t < objects.length; t++)			{				var o:MotionObject = objects[t] as MotionObject;				if (o.object == objToBlink && o.motionType == "innerBlink") return -1;			}			var m:MotionObject = new MotionObject();						m.motionType = "innerBlink";			m.object = objToBlink;			m.originFilters = objToBlink.filters;			m.durationInMillis = durationInMillis;			m.blinkSpeedInMillis = blinkSpeedInMillis;			m.blinkColor = blinkColor;			m.blinkGlow = new GlowFilter(m.blinkColor,1.0,9.0,9.0,3,1,true,false);			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();			m.lastBlink = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function createSpin(objToSpin:DisplayObject, speed:Number, blur:MovieClip, onCompleteCallback:Function = null, delayedStartInMillis:int = 0, killOnComplete:Boolean = false) : int		{			var m:MotionObject = new MotionObject();						m.motionType = "spin";			m.object = objToSpin;			m.spinSpeed = speed;			m.spinBlur = blur;			m.originX = objToSpin.x;			m.originY = objToSpin.y;			m.onComplete = onCompleteCallback;			m.delayedStartInMillis = delayedStartInMillis;			m.killOnComplete = killOnComplete;			m.startTime = getTimer();						objects[numObjects] = m;			numObjects++;						return numObjects - 1;		}		public function stopSpin(objToStop:DisplayObject, yOffset:int, delayedStopInMillis:int = 0, onCompleteCallback:Function = null, killOnComplete:Boolean = false)		{			for (var n:int = 0; n < objects.length; n++)			{				if (objects[n].object == objToStop)				{					var m:MotionObject = objects[n];					m.motionType = "spinStop";					m.yOffset = yOffset;					m.startTime = getTimer();					m.delayedStartInMillis = delayedStopInMillis;					m.onComplete = onCompleteCallback;					m.killOnComplete = killOnComplete;					m.durationInMillis = 1000;					m.destinationY = -(10 * 128) + yOffset;				}			}		}				private function onTimer(e:Event)		{			for (var n:int = 0; n < numObjects; n++)			{				var o:MotionObject = objects[n] as MotionObject;								// If the time elapsed is greater than or equal to the total time allotted for this motion				if (o.durationInMillis > 0 && getTimer() - o.startTime >= o.durationInMillis + o.delayedStartInMillis)				{					var newArray:Array = new Array();					// Then let's remove it from the list of objects we're watching					if (numObjects == 1)					{						objects = [];					}					else					{						var newArrayIndex:int = 0;						for (var i:int = 0; i < objects.length; i++)						{							if (i != n)							{								newArray[newArrayIndex] = objects[i];								newArrayIndex++;							}						}						objects = newArray;					}					numObjects--;					n--;										// If it's supposed to be killed on complete, then kill it.					if (o.killOnComplete)					{						MovieClip(o.object.parent).removeChild(o.object);					}					// Else let's ensure it's at its final state					else					{						switch (o.motionType)						{							case "move":								o.object.x = o.destinationX;								o.object.y = o.destinationY;								break;							case "fadeIn":								o.object.alpha = 1.0;								break;							case "fadeOut":								o.object.alpha = 0.0;								break;							case "flip":								break;							case "rotateX":								o.object.rotationX = o.originRotation + o.destinationRotation;								break;							case "rotateY":								o.object.rotationY = o.originRotation + o.destinationRotation;								break;							case "rotateZ":								o.object.rotationZ = o.originRotation + o.destinationRotation;								break;							case "flipA":								o.motionType = "flipB";								var c:Card = o.object as Card;								c.flip();							case "flipB":								o.object.rotationY = 180;								//o.object.x = o.originX + o.object.width;								//o.object.y = o.originY;								break;							case "blink":								o.object.filters = o.originFilters;								break;							case "innerBlink":								o.object.filters = o.originFilters;								break;							case "spin":								o.object.y = o.destinationY;								break;							case "spinStop":								o.object.y = o.destinationY;								break;						}					}										if (o.onComplete != null) { o.onComplete(); }										continue;				}								// Now that we've checked all that .. let's see if we need to update our object's state				var pctComplete:Number = 0.0;				if (getTimer() - o.startTime < o.delayedStartInMillis)					pctComplete = 0;				else if (o.durationInMillis > 0)				{					pctComplete = (getTimer() - o.startTime)/(o.durationInMillis + o.delayedStartInMillis);				}				switch (o.motionType)				{					case "move":						var newX:int = o.originX + Number(o.destinationX - o.originX) * pctComplete;						var newY:int = o.originY + Number(o.destinationY - o.originY) * pctComplete;						o.object.x = newX;						o.object.y = newY;						break;					case "fadeIn":						o.object.alpha = pctComplete;						break;					case "fadeOut":						o.object.alpha = 1.0 - pctComplete;						break;					case "flip":						break;					case "rotateX":						o.object.rotationX = o.originRotation + (o.destinationRotation - o.originRotation) * pctComplete;						break;					case "rotateY":						o.object.rotationY = o.originRotation + (o.destinationRotation - o.originRotation) * pctComplete;						break;					case "rotateZ":						o.object.rotationZ = o.originRotation + (o.destinationRotation - o.originRotation) * pctComplete;						break;					case "flipA":						var rX:Number = o.object.rotationZ;						o.object.rotationX = 0;						o.object.rotationZ = 0;												o.object.rotationY = pctComplete * 180;												//o.object.x = (o.originX + o.originWidth/2) - o.object.width/2;						//o.object.y = (o.originY + o.originHeight/2) - o.object.height/2;												if (o.object.rotationY > 90)						{							o.motionType = "flipB";							var cc:Card = o.object as Card;							cc.flip();						}												o.object.rotationZ = rX;						break;					case "flipB":						var oX:Number = o.object.rotationZ;						o.object.rotationX = 0;						o.object.rotationZ = 0;												o.object.rotationY = pctComplete * 180;												//o.object.x = (o.originX + o.originWidth/2) + o.object.width/2;						//o.object.y = (o.originY + o.originHeight/2) - o.object.height/2;												o.object.rotationZ = oX;						break;					case "innerBlink":						if (getTimer() - o.lastBlink > o.blinkSpeedInMillis)						{							if (o.object.filters.length > 0) o.object.filters = [];							else o.object.filters = [o.blinkGlow];														o.lastBlink = getTimer();						}						break;					case "blink":						if (getTimer() - o.lastBlink > o.blinkSpeedInMillis)						{							if (o.object.filters.length > 0) o.object.filters = [];							else o.object.filters = [o.blinkGlow];														o.lastBlink = getTimer();						}						break;					case "spin":						if (getTimer() - o.startTime < o.delayedStartInMillis) break;												if (getTimer() - (o.startTime + o.delayedStartInMillis) < 1000)						{							var angle:Number = Math.PI * ((getTimer() - (o.startTime + o.delayedStartInMillis))/1000);							o.object.y = o.originY - Math.sin(angle) * 64;						}						else						{							//if (o.object.filters.length == 0)							//{							//	o.object.filters = [new BlurFilter(0,o.spinBlur)];							//}							if ((MovieClip)(o.object).contains(o.spinBlur) == false) (MovieClip)(o.object).addChild(o.spinBlur);														o.object.y += o.spinSpeed;							if (o.object.y > 0) o.object.y -= o.object.height/3;						}						break;					case "spinStop":						if (getTimer() - o.startTime < o.delayedStartInMillis)						{							//if (o.object.filters.length == 0)							//{							//	o.object.filters = [new BlurFilter(0,o.spinBlur)];							//}							if ((MovieClip)(o.object).contains(o.spinBlur) == false) (MovieClip)(o.object).addChild(o.spinBlur);														o.object.y += o.spinSpeed;							if (o.object.y > 0) o.object.y -= o.object.height/3;						}						else						{							//if (o.object.filters.length > 0) o.object.filters = [];							if ((MovieClip)(o.object).contains(o.spinBlur) == true) (MovieClip)(o.object).removeChild(o.spinBlur);														if (getTimer() - (o.startTime + o.delayedStartInMillis) < 1000)							{								var pangle:Number = Math.PI * ((getTimer() - (o.startTime + o.delayedStartInMillis))/1000);								o.object.y = o.destinationY + Math.sin(pangle) * 64;							}						}						break;				}			}		}	}}