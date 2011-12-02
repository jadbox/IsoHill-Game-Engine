/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.components 
{
	import isohill.IsoDisplay;
	import isohill.AssetManager;
	import isohill.components.IComponent;
	import isohill.IsoSprite;
	import isohill.loaders.ITextureLoader;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * This class will set a Starling image onto an IsoSprite once it is loaded and ready in the AssetManager
	 * @author Jonathan Dunlap
	 */
	public class AsyncTexture implements IComponent
	{
		private var assetManagerKey:String;
		private static var I:int = 0; // current global async index
		private var i:int = 0; // global index for debugging
		private var sprite:IsoDisplay;

		public function AsyncTexture(assetManagerKey:String) 
		{
			i = ++I;
			this.assetManagerKey = assetManagerKey;	
		}
		public function onSetup(sprite:IsoDisplay):void {
			this.sprite = sprite;
			if(!sprite.display) sprite.display = AssetManager.instance.getImage(assetManagerKey);
			advanceTime(0);
		}
		public function onRemove():void {
		}
		public function advanceTime(time:Number):void {
			var loader:ITextureLoader = AssetManager.instance.getLoader(assetManagerKey);
			if (loader.isLoaded == false) return;
			loader.setTexture(sprite);

			sprite.removeComponent(this);
		}
	}

}
