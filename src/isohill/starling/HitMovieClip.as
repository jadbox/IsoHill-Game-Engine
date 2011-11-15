/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.starling 
{	
	import flash.geom.Point;
	import isohill.GridBool;
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	/**
	 * MovieClip that is hitTest transparent aware
	 * @author Jonathan Dunlap
	 */
	public class HitMovieClip extends starling.display.MovieClip 
	{
		private var _hitMap:Vector.<GridBool>;
		public function HitMovieClip(textures:Vector.<Texture>, fps:int=12) 
		{
			super(textures, fps);
		}
		public function set hitMap(val:Vector.<GridBool>):void {
			_hitMap = val;
		}
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject 
		{
			var hitCase:DisplayObject = super.hitTest(localPoint, forTouch);
			if (hitCase==null || _hitMap==null) return hitCase;
			var x:int = Math.round(localPoint.x);
			var y:int = Math.round(localPoint.y);
			var grid:GridBool = _hitMap[currentFrame];
			return (grid!=null && grid.getCell(x, y)==true)?hitCase:null;
		}
	}

}