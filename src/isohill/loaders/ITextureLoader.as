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
		function setTexture(sprite:IsoDisplay):void;
		function get isLoaded():Boolean;
		function get id():String;
		function getDisplay():DisplayObject;
		function load():void;
	}
	
}
