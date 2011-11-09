/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill 
{
	import flash.utils.Dictionary;
	import isohill.loaders.IOnTextureLoaded;
	import isohill.loaders.ITextureLoader;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * Indexer for Textures
	 * @author Jonathan Dunlap
	 */
	public class AssetManager implements IOnTextureLoaded
	{
		public static var instance:AssetManager = new AssetManager();
		
		private var textures:Dictionary = new Dictionary();
		private var assetLoaders:Dictionary = new Dictionary();
		//private var textureVectors:Dictionary = new Dictionary(); // value is <Textures>[]
		public function AssetManager() 
		{
			
		}
		public function addLoader(loader:ITextureLoader):void {
			if (hasLoader(loader.id)) return;
			assetLoaders[loader.id] = loader;
			loader.load(this);
		}
		public function onTextureLoaded(id:String, texture:Texture):void {
			if (texture == null) throw new Error("null texture set for id " + id);
			textures[id] = texture;
		}
		public function onTexturesLoaded(id:String, texture:Vector.<Texture>):void {
			if (texture == null) throw new Error("null texture set for id " + id);
			textures[id] = texture;
		}
		//, forceFrame:int=-1
		public function getImage(url:String, startingFrame:int = 0):Image {
			if (textures[url] == null) {
				return null; // texture unavailable for Image creation
			}
			var image:Image;
			if (textures[url] is Vector.<Texture>) {
				//if (forceFrame > -1) {
				//	image = new Image(textures[url][forceFrame]);
				//}
				//else 
				image = new MovieClip(textures[url]);
				MovieClip(image).currentFrame = startingFrame;
			}
			else {
				image = new Image(textures[url]);
			}
			return image;
		}
		//public function getTexture(url:String, frame:int):Texture {
		//	return textures[url + "@" + frame];
		//}
		//public function getTextures(url:String):Vector.<Texture> {
		//	var vector
		//	return textures[url + "@" + i];
		//}
		public function getLoader(id:String):ITextureLoader {
			return assetLoaders[id];
		}
		public function hasLoader(id:String):Boolean {
			return getLoader(id) != null;
		}
	}

}
