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
	import isohill.AssetManager;
	import isohill.IsoSprite;
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
		private var frame:int;
		private var obj:Object;
		public function AsyncTexture(assetManagerKey:String, frame:int=0, obj:Object=null) 
		{
			i = ++I;
			this.assetManagerKey = assetManagerKey;
			this.frame = frame;
			this.obj = obj;
		}
		public function advanceTime(time:Number, sprite:IsoSprite):void {
			var image:Image = AssetManager.instance.getImage(assetManagerKey, frame);
			if (image == null) return; 
			for (var prop:String in obj) {
				image[prop] = obj[prop];
			}
			sprite.components.splice(sprite.components.indexOf(this), 1);
			sprite.setImage(image);
		}
		public function requiresImage():Boolean { 
			return false;
		}
	}

}
