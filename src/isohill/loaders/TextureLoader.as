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
	import isohill.GridBool;
	import isohill.IsoDisplay;
	import isohill.AssetManager;
	import isohill.IsoSprite;
	import isohill.loaders.ImgLoader;
	import isohill.starling.HitImage;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * Loads one texture for one frame
	 * @author Jonathan Dunlap
	 */
	public class TextureLoader implements ITextureLoader
	{
		private var url:String;
		private var offset:Point;
		private var texture:Texture;
		private var hitMap:GridBool;
		private var hitMapTest:Boolean;
		private static var proxyTexture:Texture;
		/**
		 * Loads a single Texture from an image url
		 * @param url URL location of the image
		 * @param offet Offset the texture location if needed
		 * @param hitMapTest Use pixel collision (default true)
		 * 
		 */		
		public function TextureLoader(url:String, offet:Point=null, hitMapTest:Boolean=true) 
		{
			this.url = url;
			this.offset = offset?offset:new Point();
			this.hitMapTest = hitMapTest;
		}
		/** @inheritDoc */
		public function getDisplay():DisplayObject {
			if (proxyTexture == null) proxyTexture = Texture.empty(15, 15, 0x25ff0000);
			var image:HitImage = new HitImage(proxyTexture);
			image.smoothing = TextureSmoothing.NONE;
			return image;
		}		
		private function onLoad(bd:BitmapData):void {
			texture = Texture.fromBitmapData(bd);
			if (hitMapTest) hitMap = GridBool.fromBitMapDataAlpha(bd);
			bd.dispose();
		}
		/** @inheritDoc */
		public function setTexture(sprite:IsoDisplay):void {
			if (texture == null) return;
			if(!(sprite is IsoSprite)) throw new Error("sprite "+sprite.name+" was created as a "+sprite+" but it's asset was for an IsoSprite");
			IsoSprite(sprite).setTexture(offset, texture);
			IsoSprite(sprite).setHitmap(hitMap);
		}
		/** @inheritDoc */
		public function get isLoaded():Boolean {
			return texture !== null;
		}
		/** @inheritDoc */
		public function get id():String {
			return url;
		}
		/** @inheritDoc */
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
	}

}
