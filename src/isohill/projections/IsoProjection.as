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
		
		public function IsoProjection(type:String = "isometric", xScale:Number = 1, yScale:Number = .5) 
		{
			pt = new Point();
			projection = new Matrix();
			
			var scale:Number = 1;
			
			if (type == TYPE_ISOMETRIC) {
				projection.rotate(45 * (Math.PI / 180) );
				scale = 1.4;
			}
			else if (type == TYPE_ORTHOGONAL) {
				projection.rotate(0);
				scale = 1.24;
			}
			else throw new Error("Invalid projection type: " + type);
			projection.scale(scale * xScale, scale * yScale);
			projectionInverse = (projection.clone());
			projectionInverse.invert();
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
			return new Point3(pt.x, pt.y);
		}
	}

}
