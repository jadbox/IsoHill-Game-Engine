/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package  
{
	import fr.kouma.starling.utils.Stats;
	import isohill.GridIsoSprites;
	import isohill.IsoHill;
	import isohill.plugins.IsoCamera;
	import isohill.plugins.XRayLayers;
	import isohill.Point3;
	import isohill.tmx.TMX;
	import isohill.tmx.TMXLayer;
	import isohill.tmx.TMXPlugin;
	import isohill.utils.Point3Input;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * This is a testing implementation of the IsoHill engine.
	 * + Loads a TMX file
	 * + Creates layers in the engine based on the data
	 * + Adds in engine plugins
	 * + starts the engine
	 * 
	 * "A or Z" to zoom
	 */
	public class IsoHillDemo extends Sprite 
	{
		public var isoHill:IsoHill;
		private var tmx:TMX;
		
		public function IsoHillDemo() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded); // let's wait for Flash to get setup
		}
		private function onStageAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			TMX.loadTMX("./assets/", "isohilldemo.tmx", onTMXLoad); // Load the TMX map for use in the engine
		}
		private function onTMXLoad(tmx:TMX):void {
			this.tmx = tmx;
			setup();
		}
		// Once the TMX data has been loaded, let's setup the engine now
		private function setup():void {
			isoHill = new IsoHill(); // instance that engine
			addChild(isoHill); // add the engine to starling
			addPlugins(isoHill);
			isoHill.start(); // start all the runtime logic
			trace("setup"); 
			addChild(new Stats()); // Mrdoob's performance monitor
		}
		private function addPlugins(isoHill:IsoHill):void {
			var tmxPlugin:TMXPlugin = new TMXPlugin(tmx); // plugin to bind the TMX data to the engine
			// link the TMX layers to engine layers (allows for optional "in-between" layers)
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer = tmx.layersArray[i];
				var layerName:String = layer.name;
				var grid:GridIsoSprites = tmxPlugin.makeEmptyGridOfSize(i, layerName);
				if (layerName.indexOf("earth")!=-1) grid.flatten(); // disable sorting and flatten the ground as it is not dynamic (speed improvement)
				isoHill.addLayer(i, layerName, grid); // add the layer to the engine
			}
			tmxPlugin.init();
			//isoHill.addPlugin(new XRayLayers());
			isoHill.addPlugin(tmxPlugin); // adding the plugin
			isoHill.addPlugin(new IsoCamera(new Point3Input(stage, 0, 600)));
		}
	}

}