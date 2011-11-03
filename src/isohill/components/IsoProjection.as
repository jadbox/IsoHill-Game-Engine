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
			image.x = pt.x;///isoToScreenX(isoPt.x, isoPt.y);
			image.y = pt.y;//isoToScreenY(isoPt.x, isoPt.y);	
		}
		/*
		public function isoToScreenX(x:Number, y:Number, z:Number = 0):Number {
			return x - y;
		}
		public function isoToScreenY(x:Number, y:Number, z:Number = 0):Number {
			return (x + y) * .5 - z;
		}
		public function screenToIsoX(x:Number, y:Number, z:Number = 0):Number {
			return x * .5 + y;// + screenPt.z;
		}
		public function screenToIsoY(x:Number, y:Number, z:Number = 0):Number {
			return y - x * .5;
		}
		*/
		public function isoToScreen(isoPt:Point):Point {
			return projection.transformPoint(isoPt);
		}
		public function screenToIso(pt:Point):Point {
		/*
			var p:Point = new Point();
			p.x = screenToIsoX(pt.x, pt.y);
			p.y = screenToIsoY(pt.x, pt.y); */
			return projectionInverse.transformPoint(pt);
			//return p;
		}
		public function requiresImage():Boolean { 
			return true;
		}
	}

}