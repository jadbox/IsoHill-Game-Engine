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
	import isohill.loaders.ImgLoader;
	import starling.textures.Texture;
	/**
	 * Loads one texture for multiple frames
	 * @author Jonathan Dunlap
	 */
	public class TexturesLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		//public var textures:Vector.<Texture>;
		private var onLoadCallback:IOnTextureLoaded;
		
		// onLoadCallback(url:String, index:Int, texture:Texture);
		public function TexturesLoader(url:String, frames:Vector.<Rectangle>) 
		{
			this.url = url;
			this.frames = frames;
			
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		public function load(onLoadCallback:IOnTextureLoaded):void {
			this.onLoadCallback = onLoadCallback;
		}
		private function onLoad(bd:BitmapData):void {
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			//var textures:Vector.<Texture> = new Vector.<Texture>(frames.length, true);
			var i:int = 0;
			var textures:Vector.<Texture> = new <Texture>[];
			for each (var frame:Rectangle in frames) {
				textures.push( Texture.fromTexture(bigTexture, frame) );
			///	if(onLoadCallback!==null) onLoadCallback.onTextureLoaded(url, i++, Texture.fromTexture(bigTexture, frame));
			}
			onLoadCallback.onTexturesLoaded(url, textures);
			onLoadCallback = null;
		}
		public function get id():String { return url; }
	}

}
