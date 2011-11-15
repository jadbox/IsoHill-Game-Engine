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
	public class IsoDisplay
	{
		public var name:String; // Identifier
		public var type:String; // type label
		public var pt:Point3; // x, y, z location
		public var state:State; // state of the asset (directives used for AI, player controlling, etc)
		public var components:Vector.<IComponent>; // collection of sprite manipulators (including projection)
		internal var layer:GridDisplay; // backward reference to the container (internal use only)
		internal var layerIndex:int = -1; // cell index container (internal use only)
		
		// Must be given a texture or set with setTexture before use
		public function IsoDisplay(assetID:String, name:String, pt:Point3=null, state:State=null) 
		{
			this.name = name;
			this.state = state!=null?state:new State();
			this.pt = pt != null?pt:new Point3();
			
			components = new <IComponent>[IsoProjection.instance];
			addComponent(new AsyncTexture(assetID));
		}
		// Abstract method for getting the display
		public function get display():DisplayObject {
			throw new Error("method get display() must be overridden");
		}
		// Internal use for setting the base Image or MovieClip
		public function set display(val:DisplayObject):void {
			throw new Error("method set display() must be overridden");
		}
		// Remove IsoSprite from it's GridDisplay layer
		public function remove():void {
			if (layer != null) layer.remove(this);
		}
		// Adds a component to this IsoSprite
		public function addComponent(c:IComponent):IComponent {
			c.onSetup(this);
			components.push(c); return c;
		}
		// Removes component by reference
		public function removeComponent(component:IComponent):void {
			component.onRemove();
			var index:int = components.indexOf(component);
			if (index != -1) components.splice(index, 1);
		}	
		// Advanced time on the components if the sprite is ready
		public function advanceTime(time:Number):void {
			var component:IComponent;
			for each (component in components) {
				component.advanceTime(time, this); // run the components that don't require an image reference on the IsoSprite if it hasn't been loaded yet
			}
		}
	}	
}
