/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.tmx 
{
	import isohill.AssetManager;
	import isohill.components.AsyncTexture;
	import isohill.GridDisplay;
	import isohill.IsoHill;
	import isohill.IsoMovieClip;
	import isohill.IsoSprite;
	import isohill.projections.IsoProjection;
	import isohill.loaders.TextureLoader;
	import isohill.loaders.SpriteSheetLoader;
	import isohill.plugins.IPlugin;
	import isohill.Point3;
	import isohill.State;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * The TMX plugin for the engine to bind the data to the renderer.
	 * @author Jonathan Dunlap
	 */
	public class TMXPlugin implements IPlugin
	{
		private static const TILE_PROPERTY_HIT_MAP:String = "hitmap";
		private static const TILE_PROPERTY_HIT_MAP_VALUE:String = "true";
		private var tmx:TMX;
		private var linkedLayer:Vector.<GridDisplay>;
		private var iSprite:int=0;
		/**
		 * Constructor 
		 * @param tmx Requiers a loaded TMX object
		 * 
		 */
		public function TMXPlugin(tmx:TMX) 
		{
			this.tmx = tmx;
			linkedLayer = new <GridDisplay>[];
		}
		public function get tmxData():TMX { return tmx;}
		/**
		 * Internal use only
		 */
		public function onSetup(engine:IsoHill):void {
			loadTiles();
			for (var x:int = 0; x < tmx.width; x++) {
				for (var y:int = 0; y < tmx.height; y++) {
					makeSprites(x, y);
				}
			}
			trace("layers created");
		}
		/**
		 * Internal use only
		 */
		public function onRemove():void {
			
		}
		private var steps:int=0; // TODO: add async asset tmx sprite creation for when its texture is loaded
		/**
		 * Internal use only
		 */
		public function advanceTime(time:Number):void {

		}
		private function loadTiles():void {
			for each(var tile:TMXTileset in tmx.uniqueTilesets) {
				var loader:SpriteSheetLoader = new SpriteSheetLoader(tmx.getImgSrc(tile.firstgid), tile.areas, null, tile.getPropsByID(TILE_PROPERTY_HIT_MAP)==TILE_PROPERTY_HIT_MAP_VALUE);
				AssetManager.instance.addLoader(loader);
			}
		}
		private function makeSprites(cellX:int, cellY:int):void {
			// in layers
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer = tmx.layersArray[i]; if (layer == null) continue;
				var _cell:int = layer.getCell(cellX, cellY); // temp
				if (_cell == 0 || isNaN(_cell)) continue;
				var grid:GridDisplay = linkedLayer[i];
				var pt3:Point3 = grid.toLayerPt(cellX, cellY);
				var name:String = tmx.getImgSrc(_cell) + "_" + (iSprite++);
				var assetID:String = tmx.getImgSrc(_cell);
				var sprite:IsoMovieClip = new IsoMovieClip(assetID, name, pt3, new State("", 0, 0, true));//IsoSprite = new IsoSprite(assetID, name, pt3);
				sprite.currentFrame = tmx.getImgFrame(_cell);
				
				grid.add(sprite);
			}
			// in object layers
			
		}
		/**
		 * Converts a TMX object layer into a existing grid layer 
		 * @param grid
		 * @param group
		 * 
		 */
		public function addObjectsToLayer(grid:GridDisplay, group:TMXObjectgroup):void {
			for each(var obj:TMXObject in group.objects) {
				var tile:TMXTileset = tmx.tilesets[obj.gid];
				// TODO: this is not working as the texture hasn't loaded yet when this method is called
				//var texure:Texture = AssetManager.instance.getTexture(tmx.imgsURL + tile.source.source, obj.gid - tile.firstgid); 
				var id:String = tmx.getImgSrc(obj.gid);
				var sprite:IsoMovieClip = new IsoMovieClip(id, String(grid.numChildren), new Point3(obj.x, obj.y));
				sprite.name = obj.name; 
				sprite.type = obj.type;
				sprite.currentFrame = tmx.getImgFrame( obj.gid );
				grid.add(sprite);
			}
		}
		/**
		 * Creates a GridDisplay layer that is like the layer found in the TMX format with correct projection and sizing
		 * @param tmxLayerIndex Layer index
		 * @param name Name of the layer to create
		 * @return created GridDisplay
		 * 
		 */
		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):GridDisplay {
			
			var layer:GridDisplay = new GridDisplay(name, tmx.width, tmx.height, tmx.tileWidth, tmx.tileHeight, tmx.orientation);
			for (var i:int = 0; i <= tmxLayerIndex; i++) {
				if (i == linkedLayer.length) linkedLayer.push(null);
			}
			return linkedLayer[tmxLayerIndex] = layer;
		}
	}

}
