﻿package  {		import flash.display.MovieClip;	import flash.events.Event;			public class Title extends MovieClip {				private var bg:Background;		private var footerBar:FooterBar;		private var headerBar:HeaderBar;		private var musicButton_Disabled:MusicButton_Disabled;		private var musicButton_Enabled:MusicButton_Enabled;		private var playButton_Disabled:PlayButton_Disabled;		private var playButton_Down:PlayButton_Down;		private var playButton_Normal:PlayButton_Normal;		private var playButton_Over:PlayButton_Over;		private var soundButton_Disabled:SoundButton_Disabled;		private var soundButton_Enabled:SoundButton_Enabled;				public function Title() 		{			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(e:Event)		{			bg = new Background();			footerBar = new FooterBar();			headerBar = new HeaderBar();			musicButton_Disabled = new MusicButton_Disabled();			musicButton_Enabled = new MusicButton_Enabled();			playButton_Disabled = new PlayButton_Disabled();			playButton_Down = new PlayButton_Down();			playButton_Normal = new PlayButton_Normal();			playButton_Over = new PlayButton_Over();			soundButton_Disabled = new SoundButton_Disabled();			soundButton_Enabled = new SoundButton_Enabled();						this.addChild(bg);			this.addChild(footerBar);			this.addChild(headerBar);			this.addChild(musicButton_Disabled);			this.addChild(musicButton_Enabled);			this.addChild(playButton_Disabled);			this.addChild(playButton_Down);			this.addChild(playButton_Normal);			this.addChild(playButton_Over);			this.addChild(soundButton_Disabled);			this.addChild(soundButton_Enabled);		}	}	}