﻿package {		public class DateSelectionNavigation extends EventDispatcher {				private var _SCRIPT_LOC		:String = "http://127.0.0.1/Tweetcatcha/getData/";		private var _FILE_NAME		:String = "getAvailableDates.php";		private var _loader			:URLLoader;				private var _xml			:XML;						public function setup($sLoc:String = ""):void {			if ($sLoc != "") _SCRIPT_LOC = $sLoc;					}		public function load():void {			_loader = new URLLoader();			_loader.addEventListener(Event.COMPLETE, _onDatesLoaded, false, 0, true);			_loader.load(_SCRIPT_LOC+_FILE_NAME);		}				private function _onDatesLoaded($e:Event):void {			_loader.removeEventListener(Event.COMPLETE, _onDatesLoaded);			_xml = new XML(_loader.data);			_loader = null;			dispatchEvent($e);		}					}}