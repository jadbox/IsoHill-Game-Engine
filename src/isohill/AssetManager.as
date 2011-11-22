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
	 * AssetManager accepts ITextureLoader classes and indexes them for reference when making IsoSprites. This class is mostly needed for just adding loaders for the game/application.
	 * @author Jonathan Dunlap
	 */
	public class AssetManager
	{
		/**
		 * Global handler to the Asset Manager instance 
		 */		
		public static var instance:AssetManager = new AssetManager();
		
		private var assetLoaders:Dictionary = new Dictionary();
		/**
		 * Constructor 
		 */		
		public function AssetManager() 
		{
			
		}
		/**
		 * Add a Texture Loader to the AssetManger
		 * @param loader ITextureLoader object to load from
		 * 
		 */		
		public function addLoader(loader:ITextureLoader):void {
			if (hasLoader(loader.id)) return; // prevent duplicate loaders from being added
			assetLoaders[loader.id] = loader;
			loader.load();
		}
		/**
		 * Creates a type of Starling display depending on the loader (example: a swf loader will create a Starling MovieClip)
		 * @param id Unique identifier for the asset from the ITextureLoader's "get id()"
		 * @return Starling display object
		 * 
		 */		
		public function getImage(id:String):DisplayObject {
			var loader:ITextureLoader = assetLoaders[id];
			if (loader == null) throw new Error("loader not added for asset ID: " + id);
			return loader.getDisplay();
		}
		/**
		 * This method returns true or false depending if the added loader is finished
		 * @param id Unique identifier for the asset from the ITextureLoader's "get id()"
		 * @return True if the loader object has finished
		 * 
		 */		
		public function isLoaded(id:String):Boolean {
			var loader:ITextureLoader = getLoader(id);
			if (loader===null) return false;
			return loader.isLoaded;
		}
		/**
		 * This method returns a ITextureLoader object that has been given to AssetManager
		 * @param id Unique identifier for the asset from the ITextureLoader's "get id()"
		 * @return ITextureLoader object
		 * 
		 */		
		public function getLoader(id:String):ITextureLoader {
			return assetLoaders[id];
		}
		/**
		 * Searches if a ITextureLoader has been added to the AssetManager
		 * @param id Unique identifier for the asset from the ITextureLoader's "get id()"
		 * @return True if the loader ID is found
		 * 
		 */		
		public function hasLoader(id:String):Boolean {
			return getLoader(id) != null;
		}
	}

}
