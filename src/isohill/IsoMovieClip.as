/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill 
{
	import flash.geom.Point;
	import flash.media.Sound;
	import isohill.IsoSprite;
	import isohill.Point3;
	import isohill.State;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import isohill.starling.HitMovieClip;
	import starling.textures.Texture;
	
	/**
	 * This is an isometric movieclip sprite
	 * @author Jonathan Dunlap
	 */
	public class IsoMovieClip extends IsoDisplay
	{
		private var _currentFrame:int = -1; // flag for not set
		private var _display:HitMovieClip;
		public function IsoMovieClip(id:String, name:String, pt:Point3=null, state:State=null) 
		{
			super(id, name, pt, state);
			_display.stop();
		}
		public override function get display():DisplayObject {
			return _display;
		}
		// Internal use for setting the base Image or MovieClip
		public override function set display(val:DisplayObject):void {
			if (val == null) throw new Error("img is null");
			if (!(val is HitMovieClip)) throw new Error("Starling DisplayObject is not a MovieClip");
			if (_display != null && val != display) {
				if (_display.parent) _display.parent.removeChild(_display);
			}

			_display = HitMovieClip(val);
		}
		public function setHitmap(hitMap:Vector.<GridBool>):void {
			 _display.hitMap = hitMap;
		}
		public function setTexture(offset:Point, textures:Vector.<Texture>, durations:Vector.<Number> = null, snds:Vector.<Sound> = null):void {
			if (textures == null) throw new Error("Textures were null");
			else if (_display == null) throw new Error("starling.display.MovieClip was null");
			while (_display.numFrames > 0) _display.removeFrameAt(0);
			var num:int = textures.length;
			for (var i:int = 0; i < num; i++) {
				_display.addFrame(textures[i], snds?snds[i]:null, durations!=null?durations[i]:-1);
			}
			_display.currentFrame = _display.currentFrame; // Starling Texture update hack
			if (!offset.y) offset.y = 0;
			if (!offset.x) offset.x = 0;
			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;
		}
		public function set currentFrame(val:int):void {
			if (val < _display.numFrames) { 
				_display.currentFrame = val; 
				_currentFrame = -1; 
			}
			else _currentFrame = val;
		}
		public function get currentFrame():int {
			return _display.currentFrame;
		}
		public function play():void {
			if (_display.isPlaying) return;
			_display.play();
			IsoHill.instance.juggler.add(_display);
		}
		public function get isPlaying():Boolean {
			return _display.isPlaying;
		}
		public function stop():void {
			_display.stop();
			IsoHill.instance.juggler.remove(_display);
		}
		public function pause():void {
			_display.pause();
		}
		public function get numFrames():int {
			return _display.numFrames;
		}
		public override function advanceTime(time:Number):void {
			if(!_display.isPlaying && _currentFrame !=-1) currentFrame = _currentFrame;
			super.advanceTime(time);
			if (_display.isPlaying) {
				_display.advanceTime(time);
			}
		}
	}

}