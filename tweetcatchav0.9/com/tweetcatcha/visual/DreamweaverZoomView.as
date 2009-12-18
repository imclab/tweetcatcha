﻿package com.tweetcatcha.visual {	import flash.events.Event;	import flash.events.MouseEvent;	import com.reintroducing.events.CustomEvent;		import com.caurina.transitions.*;		import com.tweetcatcha.data.Constants;	import com.NickHardeman.utils.MathUtils;		import flash.display.MovieClip;		// used for the zooming and rotating of the canvas //		public class DreamweaverZoomView extends Dreamweaver {		protected var _headlinBtnHolda		:MovieClip;		protected var _tweetsHolda			:MovieClip;				protected var _minRadius			:Number = 25;				public var bZoomedIn				:Boolean = false;				public function DreamweaverZoomView() {					}				override public function setup():void {			super.setup();			_headlinBtnHolda = MovieClip(_circleClip.getChildByName("headlineBtnHolda"));			_tweetsHolda = _mc.tweetsHolda_mc;			var zoomBtn:MovieClip = MovieClip(_circleClip.getChildByName("circleContent_mc")).zoomBtn;			zoomBtn.addEventListener(MouseEvent.CLICK, _onZoomClick, false, 0, true);			zoomBtn.buttonMode = true;			_mc.zoomOutBtn.visible = false;			_mc.zoomOutBtn.addEventListener(MouseEvent.CLICK, _onZoomOutClick, false, 0, true);			_mc.zoomOutBtn.buttonMode = true;								}				private function _onZoomClick($e:MouseEvent):void {			dispatchEvent( new CustomEvent(Constants.ZOOM_IN_CLICK,										   {headlineID:_activeHeadlineID, 										   baseAngle:_headlineBtns[_activeHeadlineID].baseAngle, parentIndex:_activeHeadlineID}, true ) );		}		public function zoomIn($e:CustomEvent):void {			bZoomedIn = true;			_tm.showTweets($e.params.parentIndex);			// _mc is Dreamweaver_mc on root timeline //			var tarX:Number = _minRadius*2 + 10;			var tarY:Number = _minRadius*2 + 10;			var dx:Number = _mc.x - _sw;			var dy:Number = _mc.y - _sh;			var tarAngle:Number = Math.atan2(dy, dx);			tarAngle = MathUtils.toDegrees( tarAngle );			var angle:Number = 180 + (tarAngle - $e.params.baseAngle);			//trace("DreamweaverZoomView :: zoomIn : rotation = "+tarAngle);			Tweener.addTween( _mc, {x:tarX, y:tarY, time:.5, transition:"easeInOutCubic"});			Tweener.addTween(_headlinBtnHolda, {rotation:angle, time:.5, transition:"easeOutQuint"});			Tweener.addTween(_tweetsHolda, {rotation:angle, time:.5, transition:"easeOutQuint", 							 onComplete:_onZoomInPositionComplete, onCompleteParams:[$e] });					}		private function _onZoomInPositionComplete($e:CustomEvent):void {			_mc.circleClip.visible = _mc.circleClip.visible = false;			//_mc.circleClip.iMask.visible = _mc.circleClip.iMask.visible = false;			//_mc.circleClip.headlineBtnHolda.visible = false;			_tcm.minRadius = _minRadius;			_tcm.addEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomInCirclesComplete, false, 0, true);			_tcm.configureCircles(_mc.x);			_tcm.animatePositionsIn();			trace("DreamweaverZoomView :: _onZoomInPositionComplete : parentIndex = "+$e.params.parentIndex);			animateTweetsZoomIn($e.params.parentIndex, 2.5);					}		private function _onZoomInCirclesComplete($e:Event):void {			_tcm.removeEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomInCirclesComplete);			_mc.zoomOutBtn.visible = true;		}		private function _onZoomInComplete($e:CustomEvent):void {					}				public function _onZoomOutClick($e:MouseEvent):void {			_mc.zoomOutBtn.visible = false;			dispatchEvent( new CustomEvent(Constants.ZOOM_OUT_CLICK,										   {headlineID:_activeHeadlineID, 										   baseAngle:_headlineBtns[_activeHeadlineID].baseAngle, parentIndex:_activeHeadlineID}, true ) );		}		public function zoomOut($e:CustomEvent):void {			bZoomedIn = false;			_mc.zoomOutBtn.visible = false;			//_mc.circleClip.headlineBtnHolda.visible = true;			_tcm.minRadius = _radius;			_tcm.configureCircles(_sw*.5);			_tcm.addEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomOutCirclesComplete, false, 0, true);			_tcm.animatePositionsIn();			Tweener.addTween( _mc, {x:_sw*.5, y:_sh*.5, time:.5, transition:"easeInOutCubic"});			animateTweetsZoomIn($e.params.parentIndex, .25, false);		}		private function _onZoomOutCirclesComplete($e:Event):void {			_mc.circleClip.visible = _mc.circleClip.visible = true;			_tcm.removeEventListener(Constants.ANIMATE_IN_COMPLETE, _onZoomOutCirclesComplete);						Tweener.addTween(_headlinBtnHolda, {rotation:0, time:1.5, transition:"easeOutQuint"});			Tweener.addTween(_tweetsHolda, {rotation:0, time:1.5, transition:"easeOutQuint", 							 onComplete:_onZoomOutPositionComplete, onCompleteParams:[$e] });		}		private function _onZoomOutPositionComplete($e:Event):void {			_tm.showAllTweets();					}				//fade the zoom header in and out		public function showZoomHeader($e):void {			//trace($e);			$e.visible = true;			Tweener.addTween( $e, {alpha:1, time:0.5, transition:"linear"});		}				public function hideZoomHeader($e):void {			Tweener.addTween( $e, {alpha:0, time:0.5, transition:"linear", onComplete:removeZoomHeader($e)});		}				public function removeZoomHeader($e):void {			$e.visible = false;		}			}}