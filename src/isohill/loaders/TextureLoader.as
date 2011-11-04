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
	import isohill.loaders.ImgLoader;
	import starling.textures.Texture;
	/**
	 * Loads one texture for one frame
	 * @author Jonathan Dunlap
	 */
	public class TextureLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		public var textures:Vector.<Texture>;
		private var onLoadCallback:IOnTextureLoaded;
		
		// onLoadCallback(url:String, index:Int, texture:Texture);
		public function TextureLoader(url:String) 
		{
			this.url = url;
			this.frames = frames;
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		public function load(onLoadCallback:IOnTextureLoaded):void {
			this.onLoadCallback = onLoadCallback;
		}
		private function onLoad(bd:BitmapData):void {
			var texture:Texture = Texture.fromBitmapData(bd);
			if(onLoadCallback!==null) onLoadCallback.onTextureLoaded(url, 0, texture);
			onLoadCallback = null;
		}
		public function get id():String { return url; }
		
		public static function loaded(url:String):Boolean {
			return AssetManager.instance.hasLoader(url);
		}
	}

}
