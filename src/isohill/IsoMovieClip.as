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
	import isohill.IsoSprite;
	import isohill.Point3;
	import isohill.State;
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	/**
	 * This is an isometric movieclip sprite
	 * @author Jonathan Dunlap
	 */
	public class IsoMovieClip extends IsoSprite 
	{
		private var _currentFrame:int = -1; // flag for not set
		private var mc:MovieClip;
		public function IsoMovieClip(id:String, name:String, pt:Point3=null, state:State=null) 
		{
			super(id, name, pt, state);
			mc = MovieClip(image);
			mc.stop();
		}
		public function set currentFrame(val:int):void {
			if (val < mc.numFrames) { 
				mc.currentFrame = val; 
				_currentFrame = -1; 
			}
			else _currentFrame = val;
		}
		public function get currentFrame():int {
			return mc.currentFrame;
		}
		public function play():void {
			if (mc.isPlaying) return;
			mc.play();
			IsoHill.instance.juggler.add(mc);
		}
		public function get isPlaying():Boolean {
			return mc.isPlaying;
		}
		public function stop():void {
			mc.stop();
			IsoHill.instance.juggler.remove(mc);
		}
		public function pause():void {
			mc.pause();
		}
		public function get numFrames():int {
			return mc.numFrames;
		}
		public override function advanceTime(time:Number):void {
			if(!mc.isPlaying && _currentFrame !=-1) currentFrame = _currentFrame;
			super.advanceTime(time);
			if (mc.isPlaying) {
				mc.advanceTime(time);
			}
		}
	}

}