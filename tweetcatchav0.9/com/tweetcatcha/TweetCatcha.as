﻿package com.tweetcatcha {		import flash.display.MovieClip;	import flash.events.*;	import flash.net.URLRequest;	import flash.display.Loader;	import flash.system.ApplicationDomain;		import com.tweetcatcha.data.Newswire;	import com.tweetcatcha.data.objects.NewsItem;	import com.tweetcatcha.data.objects.Tweet;	import com.tweetcatcha.data.Constants;	//import com.tweetcatcha.nav.MainNav;	import com.tweetcatcha.visual.DreamweaverZoomView;		import com.tweetcatcha.events.TweetIDEvent;	import com.reintroducing.events.CustomEvent;		//HEADLINE VIEW	import com.tweetcatcha.visual.HeadlineView;		//BOTTOM NAV	import com.tweetcatcha.nav.BottomNavMain;		public class TweetCatcha extends MovieClip {				public static const SCRIPT_BASE_LOC		:String = "http://localhost:8888/Tweetcatcha/getData/"				private var NW				:Newswire;		private var DW				:DreamweaverZoomView;		//private var MN				:MainNav = new MainNav();				//HEADLINE VIEW		private var HV				:HeadlineView;				//BOTTOM NAV		private var BN				:BottomNavMain;				//constructor		public function TweetCatcha() {			stage.align = "TL";			stage.scaleMode = "noScale";						NW = new Newswire( SCRIPT_BASE_LOC );						DW = new DreamweaverZoomView();			DW.mc = dreamweaver_mc;			//MN.mc = mainMenuHolda_mc;			DW.onStageResize(stage.stageWidth, stage.stageHeight);			DW.setup();			dreamweaver_mc.mask = mainMask;						DW.addEventListener(Constants.HEADLINE_ID_SELECTED, _onHeadlineSelected, false, 0, true);			DW.addEventListener(Constants.ZOOM_IN_CLICK, _onZoomClick, false, 0, true);			DW.addEventListener(Constants.ZOOM_OUT_CLICK, _onZoomOutClick, false, 0, true);						NW.addEventListener(Event.COMPLETE, _onNewswireLoaded, false, 0, true);			NW.load("2009-11-12", 60);						stage.addEventListener(Event.RESIZE, _onStageResize);						//HEADLINE VIEW			HV = new HeadlineView();			addChild(HV);			HV.addEventListener(Constants.HEADLINE_ID_SELECTED, _onHeadlineSelected, false, 0, true);						//***************************************** TEMPORARY HEADLINE VIEW BUTTON ****************			//headlineviewBtn.addEventListener(MouseEvent.MOUSE_DOWN, _onHeadlineView, false, 0, true);						//zoom headline header text			zoomHeader.visible = false;			zoomHeader.alpha = 0;						//load the bottomnavigation			//BN = new BottomNavMain();			//BN.y = stage.stageHeight - BN.height;			//addChild(BN);			loadAssets();		}				public function loadAssets():void {			var loader:Loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onBNLoaded, false, 0, true);			loader.load(new URLRequest("_swf/BottomNav.swf"));		}		public function _onBNLoaded($e:Event):void {			BN = new BottomNavMain( MovieClip($e.target.content) );			$e.currentTarget.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _onBNLoaded);			BN.setup();			BN.onStageResize(stage.stageWidth, stage.stageHeight);			BN.addEventListener(Constants.LIST_VIEW_CLICKED, _onListViewClicked, false, 0, true);			addChild( BN.mc );			trace("The nav has loaded");		}				public function _onNewswireLoaded($e:Event):void {			trace("Total newsItems "+NW.newsItems.length);			//for (var i:int = 0; i < NW.newsItems.length; i++) {				//var ni:NewsItem = NW.newsItems[i];				//trace("\n\n\n****************************************************************");				//trace(ni.headline+" date: "+ni.month+"-"+ni.day+"-"+ni.year);				//trace("Tweets -------------------"+NW.newsItems[i].tweets.length);				//for (var j:int = 0; j < NW.newsItems[i].tweets.length; j++) {					//trace("          +"+NW.newsItems[i].tweets[j].user);				//}			//}						DW.reset();			DW.newsItems = NW.newsItems;			DW.configure();			DW.positionAllTweets();						//HEADLINE VIEW			HV.newsItems = NW.newsItems;			HV.setup();					}				public function _onHeadlineSelected($e:CustomEvent = null):void {			_onHeadlineClick( $e.params.ID );		}				public function _onHeadlineClick( $id:int ):void {			DW.headlineSelected( $id );			//trace("tweets = " + NW.newsItems[$id].totalTweets);			//set the headline and num tweets for the header on zoom in			zoomHeader.zoomHeadline.htmlText = NW.newsItems[$id].headline;			zoomHeader.zoomTweets.htmlText = NW.newsItems[$id].totalTweets;		}				private function _onStageResize( $e:Event ):void {			DW.onStageResize($e.target.stageWidth, $e.target.stageHeight);			BN.onStageResize($e.target.stageWidth, $e.target.stageHeight);			//MN.onStageResize($e.target.stageWidth, $e.target.stageHeight);		}				public function _onZoomClick($e:CustomEvent) {			zoomIn($e);		}		public function zoomIn($e:CustomEvent):void {			//trace("Main :: zoomIn : zoom in clicked");			//headlineviewBtn.visible = false;			//zoomHeader.visible = true;			DW.zoomIn($e);			DW.showZoomHeader(zoomHeader);		}				public function _onZoomOutClick($e:CustomEvent):void {			zoomOut($e);		}		public function zoomOut($e:CustomEvent):void {			//headlineviewBtn.visible = true;			//zoomHeader.visible = false;			DW.zoomOut( $e );			DW.hideZoomHeader(zoomHeader);		}				/*private function _onMouseMove($e:MouseEvent):void {			MN.checkMouse( mouseY );		}*/				public function _onListViewClicked($e:Event = null):void {			HV.openHV();		}		public function _onShowDateNavClicked($e:Event = null):void {			trace("Main :: _onShowDateNavClicked : show the dates");		}				}}