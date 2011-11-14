/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.loaders 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import isohill.IsoDisplay;
	import isohill.AssetManager;
	import isohill.IsoMovieClip;
	import isohill.IsoSprite;
	import isohill.loaders.ImgLoader;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * Loads one texture for multiple frames
	 * @author Jonathan Dunlap
	 */
	public class TexturesLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		private var textures:Vector.<Texture>;
		private var offset:Point;
		private static var proxyTexture:Vector.<Texture>;

		public function TexturesLoader(url:String, frames:Vector.<Rectangle>, offset:Point=null) 
		{
			this.url = url;
			this.frames = frames;
			this.offset = offset?offset:new Point();
		}
		public function getDisplay():DisplayObject {
			if(proxyTexture==null) proxyTexture = new <Texture>[Texture.empty(22, 22, 0xff990000)];
			return new starling.display.MovieClip(proxyTexture);
		}
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		private function onLoad(bd:BitmapData):void {
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			var i:int = 0;
			textures = new <Texture>[];
			for each (var frame:Rectangle in frames) {
				textures.push( Texture.fromTexture(bigTexture, frame) );
			}
		}
		public function get id():String { return url; }
		public function setTexture(sprite:IsoDisplay):void {
			IsoMovieClip(sprite).setTexture(offset, textures);
		}
		public function get isLoaded():Boolean {
			return textures !== null;
		}
	}

}
