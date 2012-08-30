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
	import isohill.IsoMovieClip;
	import isohill.IsoSprite;
	import isohill.loaders.ImgLoader;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import isohill.starling.HitMovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * Loads a spritesheet Texture image and cuts out Textures for each sprite
	 * @author Jonathan Dunlap
	 */
	public class SpriteSheetLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		private var textures:Vector.<Texture>;
		private var hitMap:Vector.<GridBool>;
		private var offset:Point;
		private static var proxyTexture:Vector.<Texture>;

		/**
		 * Constructor
		 * @param url URL location of the image
		 * @param frames Areas of the sprites in the image
		 * @param offset Position offset of each of the textures if needed
		 * @param hitMapTest Use pixel collision (default true)
		 * 
		 */
		public function SpriteSheetLoader(url:String, frames:Vector.<Rectangle>, offset:Point=null, hitMapTest:Boolean=true) 
		{
			this.url = url;
			this.frames = frames;
			this.offset = offset?offset:new Point();
			if(hitMapTest) hitMap = new Vector.<GridBool>();
		}
		/** @inheritDoc */
		public function getDisplay():DisplayObject {
			if(proxyTexture==null) proxyTexture = new <Texture>[Texture.empty(25, 25, false, false)];
			var mc:HitMovieClip = new HitMovieClip(proxyTexture);
			mc.smoothing = TextureSmoothing.NONE;
			return mc;
		}
		/** @inheritDoc */
		public function load():void {
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		private function onLoad(bd:BitmapData):void {
			if (textures) return;
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			var i:int = 0;
			textures = new <Texture>[];
			
			for each (var frame:Rectangle in frames) {
				var texture:Texture = Texture.fromTexture(bigTexture, frame);
				textures.push( texture );
				if (hitMap != null) hitMap.push(GridBool.fromBitMapDataAlpha(bd, frame));
				i++;
			}
			bd.dispose();
		}
		/** @inheritDoc */
		public function get id():String { return url; }
		/** @inheritDoc */
		public function setTexture(sprite:IsoDisplay):void {
			IsoMovieClip(sprite).setTexture(offset, textures);
			IsoMovieClip(sprite).setHitmap(hitMap);
		}
		/** @inheritDoc */
		public function get isLoaded():Boolean {
			return textures !== null;
		}
	}

}
