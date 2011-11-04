package isohill.components 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import isohill.IsoSprite;
	import isohill.Point3;
	import starling.display.Image;
	/**
	 * Converts an entity's position to isometric and updates it's raw image position
	 * @author Jonathan Dunlap
	 */
	public class IsoProjection implements IComponent
	{
		public static var instance:IsoProjection = new IsoProjection();
		private var projection:Matrix;
		private var projectionInverse:Matrix;
		private var pt:Point;
		
		public function IsoProjection() 
		{
			pt = new Point();
			projection = new Matrix()
			projection.rotate(45 * (Math.PI / 180) );
			var scale:Number = 1.4;
			projection.scale(scale, scale / 2);
			projectionInverse = (projection.clone());
			projectionInverse.invert();
		}
		public function advanceTime(time:Number, sprite:IsoSprite):void {
			var isoPt:Point = sprite.pt;
			var image:Image = sprite.image;
			pt = projection.transformPoint(isoPt);
			image.x = pt.x;
			image.y = pt.y;
		}
		public function isoToScreen(isoPt:Point):Point {
			return projection.transformPoint(isoPt);
		}
		public function screenToIso(pt:Point):Point {
			return projectionInverse.transformPoint(pt);
		}
		public function requiresImage():Boolean { 
			return true;
		}
	}

}