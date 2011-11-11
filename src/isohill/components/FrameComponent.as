/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.components 
{
	import isohill.IsoHill;
	import isohill.IsoSprite;
	import starling.display.MovieClip;
	/**
	 * Manipulates frames for an IsoSprite with a MovieClip
	 * @author Jonathan Dunlap
	 */
	public class FrameComponent implements IComponent 
	{
		private var mc:MovieClip;
		public var loop:Boolean  = false;
		private var _frame:int = -1;
		private var _play:Boolean = false;
		private var fps:int;
		
		public function FrameComponent(loop:Boolean=false, fps:int=12) 
		{
			this.loop = loop;
			setFPS(fps);
		}
		public function onSetup(sprite:IsoSprite):void {
			
		}
		public function onRemove():void {
			
		}
		public function setFPS(fps:int):void {
			this.fps = fps;
			if (mc) mc.fps = fps;
		}
		public function getMovieClip():MovieClip {
			return mc;
		}
		public function play():void {
			_play = true;
			if (mc) mc.play();
		}
		public function stop():void {
			_play = false;
			if (mc) mc.stop();
		}
		public function pause():void {
			_play = false;
			if (mc) mc.pause();
		}
		public function setFrame(val:int):void {
			_frame = val;
			if (mc!=null) mc.currentFrame = _frame;
		}
		public function get frame():int {
			if (mc != null) return mc.currentFrame;
			return _frame;
		}
		
		/* INTERFACE isohill.components.IComponent */
		
		public function advanceTime(time:Number, sprite:IsoSprite):void 
		{
			if (mc == null) {
				if (sprite.image is MovieClip) {
					mc = MovieClip(sprite.image);
					onMCLoaded();
				}
				else return;
			}
			
			//mc.currentFrame++;
			//sprite.frame = sprite.frame % mc.numFrames;
		}
		private function onMCLoaded():void {
			if (frame != -1) mc.currentFrame = frame;
			mc.loop = loop;
			mc.fps = fps;
			if (_play) mc.play();
			IsoHill.instance.juggler.add(mc);
		}
		public function requiresImage():Boolean 
		{
			return true;
		}
		
	}

}