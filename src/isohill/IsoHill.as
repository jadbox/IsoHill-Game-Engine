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
	import starling.events.Event;
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
		
		private var layers:Vector.<GridDisplay>; // it's a plugin too, but it's special and gets its own property
		private var layersHash:Dictionary; // indexed my layer name (key:*, value:GridDisplay)
		private var plugins:Vector.<IPlugin>;
		private var _juggler:Juggler;
		private var displayArea:Sprite = new Sprite();
		private var container:Sprite = new Sprite();
		private var position:Point;
		
		/**
		 * Constructor
		 * 
		 */
		public function IsoHill() 
		{
			layers = new <GridDisplay>[];
			plugins = new <IPlugin>[];
			layersHash = new Dictionary();
			_juggler = new Juggler();
			position = new Point(1, 1);
			instance = this;
			addChild(displayArea);
			displayArea.addChild(container);
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:*):void {
			setSize(stage.stageWidth, stage.stageHeight);
		}
		/**
		 * By default, the size of the engine is the stage bounds. To manually set the size, use this method.
		 * @param width Width of the viewable bounds of the engine
		 * @param height Height of the viewable bounds of the engine
		 * 
		 */		
		public function setSize(width:Number, height:Number):void {
			displayArea.x = width * .5;
			displayArea.y = height * .5;
		}
		/**
		 * A shared juggler instance for systems that depend on the engine running
		 */		
		public function get juggler():Juggler {
			return _juggler;
		}
		/**
		 * Manually set the zoom level 
		 */		
		public function set currentZoom(val:Number):void {
			container.scaleX = container.scaleY = val;
		}
		/**
		 *  Returns zoom level
		 */		
		public function get currentZoom():Number {
			return container.scaleX;
		}
		/**
		 * Returns the x position of its layers
		 */		
		public function get positionX():Number {
			return position.x;
		}
		/**
		 * Returns the y position of its layers
		 */	
		public function get positionY():Number {
			return position.y;
		}
		/**
		 * Sets the x position of its layers
		 */	
		public function set positionX(val:Number):void {
			position.x = val;
		}
		/**
		 * Sets the y position of its layers
		 */
		public function set positionY(val:Number):void {
			position.y = val;
		}
		/**
		 * Absolute position move of its layers
		 * @param x X Position
		 * @param y Y Position
		 * 
		 */		
		public function moveTo(x:Number, y:Number):void {
			position.setTo(x, y);
		}
		/**
		 *  Offsets the position of its layers
		 * @param x Offset by X amount
		 * @param y Offset by Y amount
		 * 
		 */		
		public function offset(x:Number, y:Number):void {
			position.offset(x, y);
		}
		/** @inheritDoc */
		public override function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point
        {
			return container.localToGlobal(globalPoint, resultPoint);
		}
		/** @inheritDoc */
		public override function localToGlobal(localPoint:Point, resultPoint:Point=null):Point
        {
			return container.globalToLocal(localPoint, resultPoint);
		}
		/**
		 * Adds a GridDisplay layer to the engine 
		 * @param index Render index location of the layer (0 is bottom)
		 * @param layer GridDisplay object to add
		 * 
		 */		
		public function addLayer(index:int, layer:GridDisplay):void {
			if (layer.name == "" || layer.name == null) throw new Error("invalid layer name");
			if (layersHash[layer.name] != null) throw new Error("layer "+layer.name+" already added");
			for (var i:int = 0; i <= index; i++) {
				if (i == index) { layers[i] = layer; break; }
				else if (i == layers.length) layers.push(null);
			}
			layersHash[layer.name] = layer;
			if(layer!=null) container.addChild(layer.display);
		}
		/**
		 * Removes a render layer from the engine 
		 * @param layer
		 * 
		 */		
		public function removeLayer(layer:GridDisplay):void {
			var index:int = layers.indexOf(layer);
			layers.splice(index, 1);
			delete layersHash[layer.name];
			container.removeChild(layer.display);
		}
		/**
		 * Returns the number of layers added to the engine
		 */		
		public function get numberOfLayers():int { return layers.length; }
		/**
		 * Get a layer by its render index 
		 * @param index Index value of the layer
		 * @return GridDisplay object of the located layer
		 * 
		 */		
		public function getLayerByIndex(index:int):GridDisplay {
			return layers[index];
		}
		/**
		 * Get a layer by its name
		 * @param name String name of the layer
		 * @return GridDisplay object of the located layer
		 * 
		 */
		public function getLayerByName(name:String):GridDisplay {
			return layersHash[name];
		}
		/**
		 * Locates a sprite by its containing layer name and sprite name 
		 * @param layerName Name of the layer that the sprite is located
		 * @param spriteName Name of the sprite
		 * @return resulting IsoDisplay or null
		 * 
		 */		
		public function getSpriteByLayerName(layerName:String, spriteName:String):IsoDisplay {
			var layer:GridDisplay = getLayerByName(layerName); if(layer==null) return null;
			var result:IsoDisplay = layer.getByName(spriteName);
			return result;
		}
		/**
		 * Locates a sprite by its containing layer index and sprite name 
		 * @param layerIndex Render index of the layer that the sprite is located
		 * @param spriteName Name of the sprite
		 * @return resulting IsoDisplay or null
		 * 
		 */	
		public function getSpriteByLayerIndex(layerIndex:int, spriteName:String):IsoDisplay {
			var layer:GridDisplay = layers[layerIndex];
			return layer.getByName(spriteName);
		}
		/**
		 * Adds a IPlugin entity to the rendering system. Useful for engine-wide mutations like cameras. 
		 * @param plugin Plugin entity
		 * 
		 */		
		public function addPlugin(plugin:IPlugin):void {
			plugins.push(plugin);
			plugin.onSetup(this);
		}
		/**
		 * Removes a plugin by reference 
		 * @param plugin
		 * 
		 */		
		public function removePlugin(plugin:IPlugin):void {
			var index:int = plugins.indexOf(plugin);
			if (index != -1) plugins.splice(index, 1);
			plugin.onRemove();
		}
		/**
		 * Start rendering per frame 
		 * 
		 */		
		public function start():void {
			Starling.juggler.remove(this);
			Starling.juggler.add(this);
		}
		/**
		 * Stop rendering per frame 
		 * 
		 */		
		public function stop():void {
			Starling.juggler.remove(this);
		}
		/**
		 * Internal use only for the main render loop 
		 * @param time Time difference from last frame
		 * 
		 */		
		public function advanceTime(time:Number):void {
			juggler.advanceTime(time);
			// update plugins
			for each(var plugin:IPlugin in plugins) plugin.advanceTime(time);
			// update sprites
			for each(var layer:GridDisplay in layers) {
				if (layer != null)  {
					if (layer.autoPosition) layer.moveTo(position.x, position.y);
					layer.advanceTime(time, this);
				}
			}

		}
		/**
		 * Internal only, Tell the starling juggler that the engine never "completes"
		 */		
        public function get isComplete():Boolean { return false; }
	}

}
