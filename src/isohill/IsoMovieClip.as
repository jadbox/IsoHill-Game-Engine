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
	import flash.utils.Dictionary;
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
		private var frameCallbacks:Dictionary; // key is frame int, value is [Function]
		private var loaded:Boolean;
		public function IsoMovieClip(id:String, name:String, pt:Point3=null, state:State=null) 
		{
			super(id, name, pt, state);
			_display.stop();
			frameCallbacks = new Dictionary();
			frameCallbacks[-1] = []; // onComplete callback token
		}
		/** @inheritDoc */
		public override function get display():DisplayObject {
			return _display;
		}
		/** @inheritDoc */
		public override function set display(val:DisplayObject):void {
			if (val == null) throw new Error("img is null");
			if (!(val is HitMovieClip)) throw new Error("Starling DisplayObject is not a MovieClip");
			if (_display != null && val != display) {
				if (_display.parent) _display.parent.removeChild(_display);
			}

			_display = HitMovieClip(val);
		}
		/** @inheritDoc */
		override public function changeTo(assetID:String):void {
			if (_display) {
				currentFrame = 0;
				stop();
			}
			super.changeTo(assetID);
		}
		/**
		 * Sets the collision hitMap. This is usually done by the ITextureLoader object.
		 * @param hitMap Vector of GridBool, representing hit areas (0 is none, 1 is hit)
		 * 
		 */
		public function setHitmap(hitMap:Vector.<GridBool>):void {
			 _display.hitMap = hitMap;
		}
		/**
		 * Sets the Texture, usually done by the ITextureLoader object.
		 * @param offset manual position location offset
		 * @param textures Textures for each frame
		 * @param durations Durations of each Texture frame
		 * @param snds Sounds for each Texture frame
		 * 
		 */
		public function setTexture(offset:Point, textures:Vector.<Texture>, durations:Vector.<Number> = null, snds:Vector.<Sound> = null):void {
			if (textures == null) throw new Error("Textures were null");
			else if (_display == null) throw new Error("starling.display.MovieClip was null");
			var frame:int = _display.currentFrame;
			while (_display.numFrames > 1) _display.removeFrameAt(_display.numFrames-1); // remove all frames except for last one (cannot make container empty)

			for (var i:int = 0, length:int = textures.length; i < length; i++) {
				_display.addFrameAt(i, textures[i], snds?snds[i]:null, durations!=null?durations[i]:-1);
			}
			
			_display.removeFrameAt(_display.numFrames-1); // removes the last old frame
			
			if (_display.numFrames > frame) _display.currentFrame = frame; // Starling Texture update hack
			else _display.currentFrame = 0;
			
			if (!offset.y) offset.y = 0;
			if (!offset.x) offset.x = 0;
			
			_display.readjustSize();
			
			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;
		
			if (layer) layer.forceUpdate();
			loaded = true;
		}
		/**
		 * Sets the current frame
		 */
		public function set currentFrame(val:int):void {
			if (val < _display.numFrames) { 
				_display.currentFrame = val; 
				_currentFrame = -1; 
			}
			else _currentFrame = val;
		}
		/**
		 * Returns the current frame
		 */
		public function get currentFrame():int {
			return _display.currentFrame;
		}
		/**
		 * Play the Texture animation 
		 */		
		public function play():void {
			if (_display.isPlaying) return;
			_display.play();
			IsoHill.instance.juggler.add(_display);
		}
		/**
		 * Returns if in play() display mode
		 */
		public function get isPlaying():Boolean {
			return _display.isPlaying;
		}
		/**
		 * Stops the Texture animation from auto playing
		 */
		public function stop():void {
			_display.stop();
			IsoHill.instance.juggler.remove(_display);
		}
		/**
		 * Pause Texture animation if playing
		 */
		public function pause():void {
			_display.pause();
		}
		/**
		 * Returns number of Texture frames
		 */
		public function get numFrames():int {
			return _display.numFrames;
		}
		/**
		 * Fires a function when playhead reaches a target frame
		 * @param frame Target frame
		 * @param callback On target frame, callback is called with IsoMovieClip reference
		 */
		public function addFrameCallback(frame:int, callback:Function):void {
			if (!frameCallbacks[frame]) frameCallbacks[frame] = [];
			frameCallbacks[frame].push(callback);
		}
		/**
		 * Fires a function when playhead reaches a target frame
		 * @param callback On target frame, callback is called with IsoMovieClip reference
		 */
		public function addLastFrameCallback(callback:Function):void {
			frameCallbacks[-1].push(callback);
		}
		/** @inheritDoc */
		override public function remove():void {
			frameCallbacks = new Dictionary(); // clear out function references
			super.remove();
		}
		/**
		 * Removes a callback function for addFrameCallback
		 * @param frame Target frame
		 * @param callback Callback to be removed
		 */
		public function removeFrameCallback(frame:int, callback:Function):void {
			if (!frameCallbacks[frame]) return;
			var index:int = frameCallbacks[frame].indexOf(callback);
			if (index == -1) return;
			frameCallbacks[frame].splice(index, 1); 
		}
		/** @inheritDoc */
		public override function advanceTime(time:Number):void {
			if(!_display.isPlaying && _currentFrame !=-1) currentFrame = _currentFrame;
			super.advanceTime(time);
			if (_display.isPlaying) {
				_display.advanceTime(time);
			}
			var cb:Function;
			if(loaded) {
				if (frameCallbacks[currentFrame] )
					for each(cb in frameCallbacks[currentFrame]) cb(this);
				if (currentFrame == numFrames-1)
					for each(cb in frameCallbacks[ -1]) cb(this);
			}
		}
	}

}