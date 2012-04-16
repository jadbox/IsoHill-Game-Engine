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
	import flash.geom.Point;
	
	/**
	 * Basic isometric point with x y z
	 * 	+ extends Point
	 * @author Jonathan Dunlap
	 */
	public class Point3 extends Point 
	{
		/**
		 * Z location 
		 */
		public var z:Number;
		public function Point3(x:Number=1, y:Number=1, z:Number=1) 
		{
			super(x, y);
			this.z = z;
		}
		
		public function copyFrom3(pt:Point3):Point3 {
			x = pt.x; y = pt.y; z = pt.z;
			return this;
		}
		public function clone3():Point3 {
			return new Point3(x, y, z);
		}
		/**
		 * Allows the point to update itself if used in an extended class 
		 * @param time
		 * 
		 */
		public function update(time:Number):void {
		}
	}

}
