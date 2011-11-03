package isohill 
{
	import flash.geom.Point;
	
	/**
	 * Basic isometric point with x y z
	 * 	+ extends Point
	 * @author Jonathan Dunlap
	 */
	public class Point3 extends Point 
	{
		public var z:Number;
		public function Point3(x:Number=1, y:Number=1, z:Number=1) 
		{
			super(x, y);
			this.z = z;
		}
		public function update(time:Number):void {
			// allows for self-updating points like Point3Mouse
		}
	}

}