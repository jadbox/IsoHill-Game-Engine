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
	import isohill.IsoDisplay;
	import isohill.IsoSprite;
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	/**
	 * Interface to start loading a texture
	 * @author Jonathan Dunlap
	 */
	public interface ITextureLoader 
	{
		/**
		 * Set the created Texture on a IsoDisplay object 
		 * @param sprite
		 * 
		 */
		function setTexture(sprite:IsoDisplay):void;
		/**
		 * Returns true if the Texture has been loaded and ready to use on an IsoDisplay
		 */
		function get isLoaded():Boolean;
		/**
		 * Returns the unique ID for this display asset
		 */
		function get id():String;
		/**
		 * Returns a Starling display object that should be used for this asset
		 */
		function getDisplay():DisplayObject;
		/**
		 * Instructs the loader to start loading. This is called by the AssetManager when a loader is added.
		 */
		function load():void;
	}
	
}
