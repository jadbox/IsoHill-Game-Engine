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
	import flash.utils.Dictionary;
	import isohill.plugins.IPlugin;
	import isohill.tmx.TMXLayer;
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
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
		
		public var layers:Vector.<GridDisplay>; // it's a plugin too, but it's special and gets its own property
		public var layersHash:Dictionary; // indexed my layer name (key:*, value:GridDisplay)
		private var plugins:Vector.<IPlugin>;
		private var _juggler:Juggler;
		private var container:Sprite = new Sprite();
		
		public function IsoHill() 
		{
			layers = new <GridDisplay>[];
			plugins = new <IPlugin>[];
			layersHash = new Dictionary();
			_juggler = new Juggler();
			instance = this;
			addChild(container);
		}
		public function get juggler():Juggler {
			return _juggler;
		}
		public function set currentZoom(val:Number):void {
			scaleX = scaleY = val;
		}
		public function get currentZoom():Number {
			return scaleX;
		}
		public function get position():Point {
			return new Point(container.x, container.y);
		}
		public function set position(val:Point):void {
			container.x = val.x;
			container.y = val.y;
		}
		public function move(x:Number, y:Number):void {
			container.x = x;
			container.y = y;
		}
		public override function localToGlobal(pt:Point):Point {
			return container.localToGlobal(pt);
		}
		public override function globalToLocal(pt:Point):Point {
			return container.globalToLocal(pt);
		}
		public function addLayer(index:int, name:String, layer:GridDisplay):void {
			for (var i:int = 0; i <= index; i++) {
				if (i == index) { layers[i] = layer; break; }
				else if (i == layers.length) layers.push(null);
			}
			layersHash[name] = layer;
			if(layer!=null) container.addChild(layer.display);
		}
		public function removeLayer(layer:GridDisplay):void {
			var index:int = layers.indexOf(layer);
			layers.splice(index, 1);
			delete layersHash[layer.name];
			container.removeChild(layer.display);
		}
		public function removeLayerByName(name:String):void {
			var layer:GridDisplay = layersHash[name];
			removeLayer(layer);
		}
		public function removeLayerByIndex(index:int):void {
			var layer:GridDisplay = layers[index];
			removeLayer(layer);
		}
		public function getLayerByIndex(index:int):GridDisplay {
			return layers[index];
		}
		public function getLayerByName(name:String):GridDisplay {
			return layersHash[name];
		}
		public function getSpriteByLayerName(layerName:String, spriteName:String):IsoDisplay {
			var layer:GridDisplay = getLayerByName(layerName);
			var result:IsoDisplay = IsoDisplay(layer.spriteHash[spriteName]);
			if (result == null) throw new Error("No sprite of name "+spriteName+" on layer: " + layerName);
			return result;
		}
		public function getSpriteByLayerIndex(layerIndex:int, spriteName:String):IsoDisplay {
			var layer:GridDisplay = layers[layerIndex];
			return IsoDisplay(layer.spriteHash[spriteName]);
		}
		public function addPlugin(plugin:IPlugin):void {
			plugins.push(plugin);
			plugin.onSetup(this);
		}
		public function removePlugin(plugin:IPlugin):void {
			var index:int = plugins.indexOf(plugin);
			if (index != -1) plugins.splice(index, 1);
			plugin.onRemove();
		}
		public function start():void {
			Starling.juggler.remove(this);
			Starling.juggler.add(this);
		}
		public function stop():void {
			Starling.juggler.remove(this);
		}
		public function advanceTime(time:Number):void {
			juggler.advanceTime(time);
			// update plugins
			for each(var plugin:IPlugin in plugins) plugin.advanceTime(time);
			// update sprites
			for each(var layer:GridDisplay in layers) {
				if (layer != null)  {
					layer.advanceTime(time, this);
				}
			}

		}
		// Tell the starling juggler that the engine never "completes"
        public function get isComplete():Boolean { return false; }
	}

}
