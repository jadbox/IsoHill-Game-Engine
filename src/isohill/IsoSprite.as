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
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import isohill.components.AsyncTexture;
	import isohill.components.IComponent;
	import isohill.components.IsoProjection;
	import isohill.loaders.ITextureLoader;
	import isohill.loaders.TextureLoader;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.Image;
	import flash.utils.getTimer;
	/**
	 * The primitive entity for IsoHill isometric sprites. It's a lightweight class with enough core functionality to fit most simple games.
	 * 
	 * @author Jonathan Dunlap
	 */
	public class IsoSprite extends IsoDisplay
	{	
		private var _display:Image;
		// Must be given a texture or set with setTexture before use
		public function IsoSprite(assetID:String, name:String, pt:Point3=null, state:State=null) 
		{
			super(assetID, name, pt, state);
		}
		public override function get display():DisplayObject {
			return _display;
		}
		// Internal use for setting the base Image or MovieClip
		public override function set display(val:DisplayObject):void {
			if (val == null) throw new Error("img is null");
			if (!(val is Image)) throw new Error("Invalid Starling display object.");
			if (_display != null && val != _display) {
				if (_display.parent) _display.parent.removeChild(_display);
			}
			_display = Image(val);
		}
		public function setTexture(offset:Point, val:Texture):void {
			_display.texture = val;
			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;
		}
	}	
}
