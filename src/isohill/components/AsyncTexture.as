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
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Jonathan Dunlap
	 */
	public class AsyncTexture implements IComponent 
	{
		private var assetManagerKey:String;
		public function AsyncTexture(assetManagerKey:String) 
		{
			this.assetManagerKey = assetManagerKey;
			AssetManager
		}
		public function advanceTime(time:Number, sprite:IsoSprite):void {
			var texture:Texture = AssetManager.instance.getTexture(assetManagerKey, sprite.frame);
			if (texture == null) return;
			sprite.components.splice(sprite.components.indexOf(this), 1);
			sprite.setTexture(texture);
		}
		public function requiresImage():Boolean { 
			return false;
		}
	}

}
