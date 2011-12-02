/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.utils 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * DynamicMovieClip is used to add frames dynamically to a basic MovieClip
	 * @author Jonathan Dunlap
	 */
	public class DynamicMovieClip extends MovieClip
	{
		private var frameClips:Dictionary; // key is int frame numbers, value is [DisplayObjects]
		private var lastFrame:int = 0;
		private var maxFrames:int = 0;
		private var _current:int = 0;
		public function DynamicMovieClip() 
		{
			frameClips = new Dictionary();
		}
		public override function get totalFrames():int {
			var total:int = super.totalFrames;
			return total > maxFrames?total:maxFrames;
		}
		public function addToFrame(frame:int, clip:DisplayObject):void {
			//trace("addToFrame", frame, clip);
			if (!frameClips[frame]) frameClips[frame] = [];
			frameClips[frame].push(clip);
			if (frame > maxFrames) maxFrames = frame;
			if (frame == _current) onFrameChange(); // initialize starting frame
		}
		override public function nextFrame():void {
			_current = Math.min(maxFrames, ++_current);
			super.nextFrame();
			if (_current != lastFrame) onFrameChange();
		}
		override public function prevFrame():void {
			_current = Math.max(0, --_current);
			super.prevFrame();
			if (_current != lastFrame) onFrameChange();
		}
		override public function play():void {
			throw new Error("Method not implemented, not required for implementation uses");
		}
		override public function stop():void {
			super.stop();
		}
		override public function gotoAndPlay(frame:Object, scene:String = null):void {
			throw new Error("Method not implemented, not required for implementation uses");
		}
		override public function gotoAndStop(frame:Object, scene:String = null):void {
			if (!(frame is int)) throw new Error("Frame number must be an int");
			var frameNum:int = int(frame);
			if (frameNum >= maxFrames) frameNum = maxFrames -1;
			if (frameNum < 0) frameNum = 0;
			_current = frameNum;
			super.gotoAndStop(frameNum, scene);
			if (_current != lastFrame) onFrameChange();
		}
		private function onFrameChange():void {
			var child:DisplayObject;
			//trace("onFrameChange", frameClips[_current], _current, "last:"+lastFrame);
			if (lastFrame >= 0 && frameClips[lastFrame]) 
				for each(child in frameClips[lastFrame]) if (child.parent) child.parent.removeChild(child);
			if ( frameClips[_current] )
				for each(child in frameClips[_current]) addChild(child);
			lastFrame = _current;
		}
	}

}