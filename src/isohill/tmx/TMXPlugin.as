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
	import isohill.GridIsoSprites;
	import isohill.IsoHill;
	import isohill.IsoSprite;
	import isohill.loaders.TextureLoader;
	import isohill.loaders.TexturesLoader;
	import isohill.plugins.IPlugin;
	import isohill.Point3;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * The TMX plugin for the engine to bind the data to the renderer.
	 * @author Jonathan Dunlap
	 */
	public class TMXPlugin implements IPlugin
	{
		public var tmx:TMX;
		public var linkedLayer:Vector.<GridIsoSprites>;
		private var iSprite:int=0;
		public function TMXPlugin(tmx:TMX) 
		{
			this.tmx = tmx;
			linkedLayer = new <GridIsoSprites>[];
		}
		public function init():void {
			loadTiles();
			for (var x:int = 0; x < tmx.width; x++) {
				for (var y:int = 0; y < tmx.height; y++) {
					makeSprites(x, y);
				}
			}
			trace("layers created");
		}
		private var steps:int=0; // TODO: add async asset tmx sprite creation for when its texture is loaded
		public function advanceTime(time:Number, engine:IsoHill):void {

		}
		private function loadTiles():void {
			for each(var tile:TMXTileset in tmx.uniqueTilesets) {
				AssetManager.instance.addLoader(new TexturesLoader(tmx.getImgSrc(tile.firstgid), tile.areas));
			}
		}
		private function makeSprites(cellX:int, cellY:int):void {
			// in layers
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer = tmx.layersArray[i]; if (layer == null) continue;
				var _cell:int = layer.getCell(cellX, cellY); // temp
				if (_cell == 0 || isNaN(_cell)) continue;
				var grid:GridIsoSprites = linkedLayer[i];
				var pt3:Point3 = grid.toLayerPt(cellX, cellY);
				var name:String = tmx.getImgSrc(_cell) + "_" + (iSprite++);
				var sprite:IsoSprite = new IsoSprite(name, pt3);
				sprite.setTextureID(tmx.getImgSrc(_cell));
				sprite.frame = tmx.getImgFrame(_cell);
				grid.push(sprite);
			}
			// in object layers
			
		}
		public function addObjectsToLayer(grid:GridIsoSprites, group:TMXObjectgroup):void {
			for each(var obj:TMXObject in group.objects) {
				var tile:TMXTileset = tmx.tilesets[obj.gid];
				// TODO: this is not working as the texture hasn't loaded yet when this method is called
				//var texure:Texture = AssetManager.instance.getTexture(tmx.imgsURL + tile.source.source, obj.gid - tile.firstgid); 
				var sprite:IsoSprite = new IsoSprite(null, new Point3(obj.x, obj.y));
				sprite.name = obj.name; 
				sprite.type = obj.type;
				sprite.setTextureID(tmx.getImgSrc(obj.gid));
				//sprite.image.frame = , tmx.getImgFrame( obj.gid ;
				grid.push(sprite);
			}
		}
		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):GridIsoSprites {
			var layer:GridIsoSprites = new GridIsoSprites(name, tmx.width, tmx.height, tmx.tileWidth, tmx.tileHeight);
			for (var i:int = 0; i <= tmxLayerIndex; i++) {
				if (i == linkedLayer.length) linkedLayer.push(null);
			}
			return linkedLayer[tmxLayerIndex] = layer;
		}
	}

}
