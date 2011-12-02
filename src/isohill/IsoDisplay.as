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
	import starling.display.Image;
	import flash.utils.getTimer;
	/**
	 * The primitive entity for IsoHill isometric sprites. It's a lightweight class with enough core functionality to fit most simple games.
	 * 
	 * @author Jonathan Dunlap
	 */
	public class IsoDisplay
	{
		/**
		 * Name identifier
		 */
		public var name:String; 
		/**
		 * Type identifier
		 */
		public var type:String;
		/**
		 * Local position
		 */
		public var pt:Point3; // x, y, z location
		/**
		 * State object for the object, useful for games 
		 */
		public var state:State; // state of the asset (directives used for AI, player controlling, etc)
		private var components:Vector.<IComponent>; // collection of sprite manipulators (including projection)
		internal var layer:GridDisplay; // backward reference to the container (internal use only)
		internal var layerIndex:int = -1; // cell index container (internal use only)
		private var async:AsyncTexture;
		/**
		 * Must be given a texture or set with setTexture before use
		 * @param assetID loader ID (see AssetManager)
		 * @param name name of the element
		 * @param pt location point
		 * @param state state object
		 * 
		 */
		public function IsoDisplay(assetID:String, name:String, pt:Point3=null, state:State=null) 
		{
			this.name = name;
			this.state = state!=null?state:new State();
			this.pt = pt != null?pt:new Point3();
			
			changeTo(assetID);
		}
		/**
		 * Changes to a new asset ID (must be from the same type of loader)
		 * @param assetID loader ID (see AssetManager)
		 */
		public function changeTo(assetID:String):void {
			if (async) removeComponent(async);
			addComponent(async = new AsyncTexture(assetID));
		}
		/**
		 * Abstract method for getting the display
		 */
		public function get display():DisplayObject {
			throw new Error("method get display() must be overridden");
		}
		/**
		 * Internal use for setting the base Starling Image
		 */
		public function set display(val:DisplayObject):void {
			throw new Error("method set display() must be overridden");
		}
		/**
		 * Removes this element from its container
		 */
		public function remove():void {
			if (layer != null) layer.remove(this);
		}
		/**
		 * Adds a component to this IsoSprite
		 * @param c IComponent
		 * @return IComponent
		 * 
		 */
		public function addComponent(c:IComponent):IComponent {
			if (components == null) components = new Vector.<IComponent>();
			c.onSetup(this);
			components.push(c); return c;
		}
		/**
		 * Removes component by reference
		 * @param component
		 * 
		 */
		public function removeComponent(component:IComponent):void {
			component.onRemove();
			var index:int = components.indexOf(component);
			if (index != -1) components.splice(index, 1);
			if (component == async) async = null;
		}	
		/**
		 * Internal use only, advanced time on the components
		 * @param time
		 * 
		 */
		public function advanceTime(time:Number):void {
			var component:IComponent;
			for each (component in components) {
				component.advanceTime(time); // run the components that don't require an image reference on the IsoSprite if it hasn't been loaded yet
			}
		}
	}	
}
