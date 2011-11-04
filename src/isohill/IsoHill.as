/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* 
*/
package isohill 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import isohill.plugins.IPlugin;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Sprite;
	/**
	 * IsoHill is a new isometric engine for Flash Player 11 [molehill] built on top of the open 2D framework Starling. 
	 * Features: 
		 * Plugins - engine-wide modifications
			* Includes a TMX [CVS export] parser
		 * Components - dynamic logic can be added and removed from IsoSprites
		 * Virtually unlimited layers
		 * Anti-aliasing of isometric tiles
		 * deterministic - all update/advanceTime functions take a numeric time offset since last frame
		 * Mipmapping - coming soon, sharpens textures
		 * Dynamic async texture loading - coming soon, will greatly improve startup speed and network usage
	 * @author Jonathan Dunlap, Oct. 2011
	 * http://www.jadbox.com
	 */
	public class IsoHill extends Sprite implements IAnimatable
	{
		public static var instance:IsoHill; // global handler for the engine, must be instanced first
		
		public var layers:Vector.<GridIsoSprites>; // it's a plugin too, but it's special and gets its own property
		public var layersHash:Dictionary; // indexed my layer name (key:*, value:GridIsoSprites)
		private var plugins:Vector.<IPlugin>;
			
		public function IsoHill() 
		{
			layers = new <GridIsoSprites>[];
			plugins = new <IPlugin>[];
			layersHash = new Dictionary();
			instance = this;
		}
		public function addLayer(index:int, name:String, layer:GridIsoSprites):void {
			for (var i:int = 0; i <= index; i++) {
				if (i == index) { layers[i] = layer; break; }
				else if (i == layers.length) layers.push(null);
			}
			layersHash[name] = layer;
			if(layer!=null) addChild(layer.container);
		}
		public function getLayerByIndex(index:int):GridIsoSprites {
			return layers[index];
		}
		public function getLayerByName(name:String):GridIsoSprites {
			return layersHash[name];
		}
		public function addPlugin(plugin:IPlugin):void {
			plugins.push(plugin);
		}
		public function removePlugin(plugin:IPlugin):void {
			var index:int = plugins.indexOf(plugin);
			if (index != -1) plugins.splice(index, 1);
		}
		public function start():void {
			Starling.juggler.remove(this);
			Starling.juggler.add(this);
		}
		public function stop():void {
			Starling.juggler.remove(this);
		}
		public function advanceTime(time:Number):void {
			// update plugins
			for each(var plugin:IPlugin in plugins) plugin.advanceTime(time, this);
			// update sprites
			for each(var layer:GridIsoSprites in layers) {
				if(layer!=null) layer.advanceTime(time, this);
			}
			x += .48;
		}
		// Tell the starling juggler that the engine never "completes"
        public function get isComplete():Boolean { return false; }
	}

}