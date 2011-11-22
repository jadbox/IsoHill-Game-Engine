/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.plugins 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import isohill.GridDisplay;
	import isohill.IsoHill;
	import isohill.Point3;
	/**
	 * Simple isometric camera
	 * @author Jonathan Dunlap
	 */
	public class IsoCamera implements IPlugin
	{
		public static var instance:IsoCamera;
		public var position:Point3; // x y z[zoom]
		private var engine:IsoHill;
		
		private static const ZOOM_IN_LIMIT:Number = 5;
		private static const ZOOM_OUT_LIMIT:Number = .1;
		public function IsoCamera(position:Point3) 
		{
			this.position = position;
			IsoCamera.instance = this;
		}
		public function onSetup(engine:IsoHill):void {
			this.engine = engine;
		}
		public function onRemove():void {
			
		}
		public function advanceTime(time:Number):void {
			position.update(time); // update the point if it's dynamic like Point3Mouse
			
			engine.moveTo( -position.x , -position.y);
			position.z = Math.min(ZOOM_IN_LIMIT, position.z);
			position.z = Math.max(ZOOM_OUT_LIMIT, position.z);
			engine.currentZoom = position.z;
		}			
	}

}
