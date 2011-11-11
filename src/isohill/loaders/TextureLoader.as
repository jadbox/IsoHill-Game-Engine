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
	import flash.geom.Rectangle;
	import isohill.AssetManager;
	import isohill.IsoSprite;
	import isohill.loaders.ImgLoader;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * Loads one texture for one frame
	 * @author Jonathan Dunlap
	 */
	public class TextureLoader implements ITextureLoader
	{
		private var url:String;
		
		private var frames:Vector.<Rectangle>;
		private var texture:Texture;
		private static var proxyTexture:Texture;
		
		// onLoadCallback(url:String, index:Int, texture:Texture);
		public function TextureLoader(url:String) 
		{
			this.url = url;
			this.frames = frames;
		}
		public function getImage():Image {
			if(proxyTexture==null) proxyTexture = Texture.empty(1,1);
			return new starling.display.Image(proxyTexture);
		}		
		private function onLoad(bd:BitmapData):void {
			texture = Texture.fromBitmapData(bd);
		}
		public function setTexture(sprite:IsoSprite):void {
			if (texture == null) return;
			sprite.image.texture = texture;
			sprite.image.pivotY = sprite.image.height;
			sprite.image.pivotX = 0;
		}
		public function get isLoaded():Boolean {
			return texture !== null;
		}
		public function get id():String {
			return url;
		}
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
	}

}
