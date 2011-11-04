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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import isohill.loaders.ImgLoader;

	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * Tileset node data for the TMX file
	 * @author Jonathan Dunlap
	 */
	public class TMXTileset 
	{
		// <tileset firstgid="65" name="PlaceholderWindCollector" tilewidth="128" tileheight="256">
		// </tileset>
		
		public var firstgid:int;
		public var name:String;
		public var tileWidth:int;
		public var tileHeight:int;
		
		public var source:TMXSource;
		public var loaded:Boolean;
		
		private var tileProperties:Object = { }; // of Objects of props
		
		public var areas:Vector.<Rectangle>;
		
		public function TMXTileset(data:XML) 
		{
			firstgid = int(data.@firstgid);
			name = data.@name;
			tileWidth = int(data.@tilewidth);
			tileHeight = int(data.@tileheight);
			source = new TMXSource( XML( data.image[0] ) );
			
			// generate Rectangles for each area of the texture
			areas = new <Rectangle>[];
			for (var y:int = 0; y < source.height; y += tileHeight) {
				for (var x:int = 0; x < source.width; x += tileWidth) {
					var rect:Rectangle = new Rectangle(x, y, tileWidth, tileHeight);
					areas.push(rect);
				}
			}
			
			var tilePropBlocks:XMLList = data.elements('tile');
			for each(var tilePropBlock:XML in tilePropBlocks) {
				var id:String = tilePropBlock.@id;
				var propBlocks:XMLList = tilePropBlock.properties[0].elements('property');
				for each(var prop:XML in propBlocks) {
					var name:String = prop.@name.toString();
					var val:String = prop.@name.toString();
					if (tileProperties[ id ] == null) tileProperties[ id ] = {};
					tileProperties[ id ][ name ] = val;
				}
			}
		}
		public function getProps(gid:int):Object {
			return getPropsByID(int(gid - firstgid).toString());
		}
		public function getPropsByID(id:String):Object {
			var val:Dictionary = tileProperties[ id ];
			return val?val:{};
		}
	}

}
