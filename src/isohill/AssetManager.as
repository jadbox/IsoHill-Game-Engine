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
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import isohill.loaders.ITextureLoader;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * Indexer for Textures
	 * @author Jonathan Dunlap
	 */
	public class AssetManager
	{
		public static var instance:AssetManager = new AssetManager();
		
		private var assetLoaders:Dictionary = new Dictionary();
		public function AssetManager() 
		{
			
		}
		// Add a Texture Loader to the AssetManger
		public function addLoader(loader:ITextureLoader):void {
			if (hasLoader(loader.id)) return; // prevent duplicate loaders from being added
			assetLoaders[loader.id] = loader;
			loader.load();
		}
		//, forceFrame:int=-1
		public function getImage(id:String):DisplayObject {
			var loader:ITextureLoader = assetLoaders[id];
			if (loader == null) throw new Error("loader not added for asset ID: " + id);
			return loader.getDisplay();
		}
		public function isLoaded(id:String):Boolean {
			var loader:ITextureLoader = getLoader(id);
			if (loader===null) return false;
			return loader.isLoaded;
		}
		public function getLoader(id:String):ITextureLoader {
			return assetLoaders[id];
		}
		public function hasLoader(id:String):Boolean {
			return getLoader(id) != null;
		}
	}

}
