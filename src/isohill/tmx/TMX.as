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
	import flash.utils.Dictionary;
	import isohill.loaders.ImgLoader;
	import isohill.AssetManager;
	import isohill.loaders.SpriteSheetLoader;
	import isohill.utils.Base64;
	/**
	 * TMX parser
	 * Use the static method loadTMX for a quicker setup (does the TMX loading for you)
	 * @author Jonathan Dunlap
	 */
	//<map version="1.0" orientation="isometric" width="10" height="10" tilewidth="128" tileheight="64">	
	public class TMX 
	{
		public var orientation:String;
		public var width:int=0; // number of cells across
		public var height:int=0; // number of cells down
		public var tileWidth:int=0; // pixel size of cell width
		public var tileHeight:int = 0; // pixel size of cell height
		// --- layer data accessibile by both vector and dictionary
		public var layersArray:Vector.<TMXLayer>; // layers of a grid of ints
		public var layersHash:Dictionary; // key is the layer name; values are TMXLayer
		// --- object layer data accessibile by both vector and dictionary
		public var objectsArray:Vector.<TMXObjectgroup>; // layers of TMXObjectgroup
		public var objectsHash:Dictionary; // key is the layer name; values are TMXObjectgroup
		// ---
		public var tilesets:Vector.<TMXTileset>; // all asset ids are indexed here
		public var uniqueTilesets:Vector.<TMXTileset>; // unique tilesets
		public var data:XML; // raw TMX data
		// prefix for the image urls based on where the tmx map is loaded from
		private var imgsURL:String;
		private var maxGid:int = 0; // used for settting up indexing for tilesets
		public function TMX(data:*, imgsURL:String) 
		{
			this.data = XML(data);
			this.imgsURL = imgsURL;
			// read root
			orientation = String(data.@orientation);
			if (orientation == "") orientation = "isometric";
			width = int( data.@width );
			height = int (data.@height);
			tileWidth = int (data.@tilewidth);
			tileHeight = int (data.@tileheight);
			// ---
			
			parseLayers();
			parseObjects();
			parseTilesets();
		}
		public function getImgSrc(gid:int):String {
			return imgsURL + tilesets[gid].source.source;
		}
		public function getImgFrame(gid:int):int {
			return gid - tilesets[gid].firstgid
		}
		public function hasFullyLoaded():Boolean {
			for each(var tile:TMXTileset in uniqueTilesets) {
				if (tile.loaded == false) return false;
			}
			return true;
		}
		private function parseTilesets():void {
			var tileSetBlocks:XMLList = data.tileset;
			uniqueTilesets = new Vector.<TMXTileset>(tileSetBlocks.length(), true);
			tilesets = new Vector.<TMXTileset>(maxGid+1, true);
			var tileIndex:int=0;
			for each(var tileBlock:XML in tileSetBlocks) {
				var tileset:TMXTileset = uniqueTilesets[tileIndex++] = new TMXTileset(tileBlock);
			}
			var tilesetIndex:int = 0;
			for (var i:int = 1; i <= maxGid; i++) {
				var nextGid:int = (tilesetIndex < (uniqueTilesets.length - 1))?uniqueTilesets[tilesetIndex + 1].firstgid:-1;
				var tilesetReference:TMXTileset = uniqueTilesets[tilesetIndex];
				if (i == nextGid) tilesetReference = uniqueTilesets[++tilesetIndex];
				tilesets[i] = tilesetReference;
			}
			trace("done parsing tilsets");
		}
		private function parseObjects():void {
			var layerObjectGroups:XMLList = data.objectgroup;
			objectsArray = new <TMXObjectgroup>[];
			objectsHash = new Dictionary();
			for each(var groupBlock:XML in layerObjectGroups) {
				var group:TMXObjectgroup = new TMXObjectgroup();
				group.height = groupBlock.@height;
				group.width = groupBlock.@width;
				group.name = groupBlock.@name;
				// parse those properties
				for each(var propBlock:XML in groupBlock.elements("properties").elements("property")) {
					group.properties[String(propBlock.@name)] = String(propBlock.@value);
				}
				// parse those nested object elements
				for each(var objBlock:XML in groupBlock.elements("object")) {
					var obj:TMXObject = new TMXObject();
					obj.gid = objBlock.@gid;
					maxGid = Math.max(obj.gid, maxGid);
					obj.x = Number(objBlock.@x);
					obj.y = Number(objBlock.@y);
					obj.type = objBlock.@type;
					obj.name = objBlock.@name;
					for each(var propObjBlock:XML in objBlock.elements("properties").elements("property")) {
						obj.properties[String(propObjBlock.@name)] = String(propObjBlock.@value);
					}
					group.objects.push(obj);
					group.objectsHash[obj.name] = obj;
				}
				objectsArray.push(group);
				objectsHash[group.name] = group;
			}
		}
		private function parseLayers():void {
			var layerBlocks:XMLList = data.layer;
			layersArray = new Vector.<TMXLayer>(layerBlocks.length(), true);
			layersHash = new Dictionary();
			var y:int = 0;
			for each(var layerBlock:XML in layerBlocks) {
				var w:int = int(layerBlock.@width);
				var h:int = int(layerBlock.@height);
				var name:String = layerBlock.@name;
				var encoding:String = layerBlock.data.@encoding;
				var layer:TMXLayer;
				if (encoding == "base64") {
					var compression:String = layerBlock.data.@compression; 
					if (compression != "zlib" && compression.length > 0)
						throw new Error("Invalid tmx compression type: " + compression);
					layer = Base64.base64ToTMXLayer(layerBlock.data[0], w, h, compression == "zlib");
				}
				else if (encoding == "csv") {
					layer = TMXLayer.fromCSV(layerBlock, w, h);
				}
				else throw new Error("Invalid tmx encoding: " + encoding);
				
				maxGid = Math.max(layer.maxGid, maxGid);
				layersArray[y++] = layer;
				layersHash[name] = layer;
				layer.name = name;
			}
		}
		// Handlers loading the TMX file for you
		static public function loadTMX(basePath:String, file:String, tmxCallback:Function):void {
			ImgLoader.instance.getXML(basePath + file, function(val:XML):void {
				tmxCallback( new TMX(val, basePath) );
			});
		}
	}
}
