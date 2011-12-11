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
	import isohill.loaders.ITextureLoader;
	import isohill.loaders.TextureLoader;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import isohill.starling.HitImage;
	import flash.utils.getTimer;
	/**
	 * This IsoHill class acts as a simple entity for a Starling display with one non-animating Texture
	 * 
	 * @author Jonathan Dunlap
	 */
	public class IsoSprite extends IsoDisplay
	{	
		private var _display:HitImage;
		// Must be given a texture or set with setTexture before use
		public function IsoSprite(assetID:String, name:String, pt:Point3=null, state:State=null) 
		{
			super(assetID, name, pt, state);
		}
		/** @inheritDoc */
		public override function get display():DisplayObject {
			return _display;
		}
		/** @inheritDoc */
		public override function set display(val:DisplayObject):void {
			if (val == null) throw new Error("img is null");
			if (!(val is HitImage)) throw new Error("Starling DisplayObject is not an Image.");
			if (_display != null && val != _display) {
				if (_display.parent) _display.parent.removeChild(_display);
			}
			_display = HitImage(val);
		}
		/**
		 * Sets the collision hitMap for pixel perfect collisions 
		 * @param hitMap GridBool representing hit areas (0 is none, 1 is hit)
		 * 
		 */
		public function setHitmap(hitMap:GridBool):void {
			 _display.hitMap = hitMap;
		}
		/**
		 * Sets the Texture, usually done by the ITextureLoader object.
		 * @param offset manual position location offset
		 * @param val Texture object
		 * 
		 */
		public function setTexture(offset:Point, val:Texture):void {
			_display.texture = val;
			if (!offset.y) offset.y = 0;
			if (!offset.x) offset.x = 0;
			_display.readjustSize();
			_display.pivotY = _display.height + offset.y;
			_display.pivotX = 0 + offset.x;
			if (layer) layer.forceUpdate();
		}
	}	
}
