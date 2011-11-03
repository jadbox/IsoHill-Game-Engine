package isohill.plugins 
{
	import flash.geom.Point;
	import isohill.components.IsoProjection;
	import isohill.GridIsoSprites;
	import isohill.IsoHill;
	import isohill.Point3;
	/**
	 * TODO: isometric camera
	 * @author Jonathan Dunlap
	 */
	public class IsoCamera implements IPlugin
	{
		public static var instance:IsoCamera;
		public var pt:Point3; // x y z[zoom]
		private var engine:IsoHill;
		public function IsoCamera(pt:Point3) 
		{
			this.pt = pt;
			IsoCamera.instance = this;
		}
		public function advanceTime(time:Number, engine:IsoHill):void {
			this.engine = engine;
			pt.update(time); // update the point if it's dynamic like Point3Mouse
			engine.x = -pt.x + engine.stage.stageWidth >> 1;
			engine.y = -pt.y + engine.stage.stageHeight >> 1;
			engine.scaleX = engine.scaleY = pt.z > .015?pt.z:.016;
		}
		public function screenToIso(pt:Point):Point {
			if (!engine) return pt;
			pt.x -= engine.x;
			pt.y -= engine.y;
			pt.x /= engine.scaleX;
			pt.y /= engine.scaleX;
			return IsoProjection.instance.screenToIso(pt);
		}
	}

}