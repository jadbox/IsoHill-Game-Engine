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
	import isohill.IsoHill;
	/**
	 * This is a "showcase" plugin. Fades each layer out in order of layers and repeats.
	 * @author Jonathan Dunlap
	 */
	public class XRayLayers implements IPlugin
	{
		public static const SPEED:int = 2;
		public var counter:int;
		public var layerIndex:int;
		public var alpha:Number = 1;
		public var paused:Boolean = true;
		private var engine:IsoHill;
		
		public function XRayLayers() 
		{
			layerIndex = -1; //start flag
		} 
		public function onSetup(engine:IsoHill):void {
			this.engine = engine;
		}
		public function onRemove():void {
			
		}
		public function advanceTime(time:Number):void {
			if (layerIndex == -1) { layerIndex = engine.numberOfLayers - 1; alpha = 1; return; }
			//trace(time);
			engine.getLayerByIndex(layerIndex).display.alpha = alpha;
			counter += 1;
			if (paused && counter < SPEED) return;
			paused = false;
			counter = 0;
			alpha -= .01;
			if (alpha <= -.4) {
				engine.getLayerByIndex(layerIndex).display.alpha = 1;
				layerIndex--;
				alpha = 1;
				paused = true;
			}
		}
		
	}

}
