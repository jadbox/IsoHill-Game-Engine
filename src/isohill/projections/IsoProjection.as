/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.projections 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import isohill.GridDisplay;
	import isohill.IsoDisplay;
	import isohill.IsoSprite;
	import isohill.Point3;
	import starling.display.DisplayObject;
	import starling.display.Image;
	/**
	 * Converts an entity's position to isometric and updates it's raw image position
	 * @author Jonathan Dunlap
	 */
	public class IsoProjection implements IProjection
	{
		public static var TYPE_ISOMETRIC:String = "isometric";
		public static var TYPE_ORTHOGONAL:String = "orthogonal";
		
		//public static var instance:IsoProjection = new IsoProjection(); // not needed
		private var projection:Matrix;
		private var projectionInverse:Matrix;
		private var pt:Point;
		
		/**
		 * This class projects points to and from isometric/orthogonal
		 * @param type Can be either "isometric" or "orthogonal"
		 * @param xScale usually 1
		 * @param yScale the compression of the y axis (usally .5)
		 * 
		 */
		public function IsoProjection(type:String, cellWidth:Number, cellHeight:Number) 
		{

			pt = new Point();
			projection = new Matrix();
			
			var scale:Number = 1;		
			var length:Number = Math.sqrt(cellWidth * cellWidth + cellHeight * cellHeight);
		
			
			
			if (type == TYPE_ISOMETRIC) {
				projection.rotate(45 * (Math.PI / 180) );
				scale = 1.4142137000082988; // not sure why this magic number is needed- now working on a "real" solution
				projection.scale(scale * 1, scale * .5);
			}
			else if (type == TYPE_ORTHOGONAL) {
				projection.rotate(0);
				scale = 1.24;
				projection.scale(scale * 1, scale * 1);
			}
			else throw new Error("Invalid projection type: " + type);
			
			
			//var sx:Number = cellWidth / length;
			//var sy:Number = cellHeight / length;
			//projection.scale(sx, sy);
			//trace("t", cellWidth, cellHeight, length, "sx:" + sx, "sy:"+sy);
			projectionInverse = (projection.clone());
			projectionInverse.invert();
			projection.translate(-cellHeight, cellHeight);
		}
		public function onSetup(grid:GridDisplay):void {
		
		}
		public function onRemove():void {
			
		}
		public function perSprite(sprite:IsoDisplay):void {
			var isoPt:Point = sprite.pt;
			var image:DisplayObject = sprite.display;
			pt = projection.transformPoint(isoPt);
			image.x = pt.x;
			image.y = pt.y;
		}
		public function layerToScreen(isoPt:Point3):Point {
			return projection.transformPoint(isoPt);
		}
		public function screenToLayer(pt:Point):Point3 {
			var pt:Point = projectionInverse.transformPoint(pt);
			//trace("s", pt);
			return new Point3(pt.x, pt.y);
		}
	}

}
