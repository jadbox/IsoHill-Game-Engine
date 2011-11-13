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
	import flash.geom.Point;
	import isohill.components.AsyncTexture;
	import isohill.components.IComponent;
	import isohill.components.IsoProjection;
	import isohill.loaders.ITextureLoader;
	import isohill.loaders.TextureLoader;
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
	public class IsoSprite 
	{
		public var name:String; // Identifier
		public var type:String; // type label
		public var image:Image; // the actual Starling asset
		public var pt:Point3; // x, y, z location
		public var state:State; // state of the asset (directives used for AI, player controlling, etc)
		public var components:Vector.<IComponent>; // collection of sprite manipulators (including projection)
		internal var layer:GridIsoSprites; // backward reference to the container (internal use only)
		internal var layerIndex:int=-1; // cell index container (internal use only)
		
		// Must be given a texture or set with setTexture before use
		public function IsoSprite(assetID:String, name:String, pt:Point3=null, state:State=null) 
		{
			this.name = name;
			this.state = state!=null?state:new State();
			this.pt = pt != null?pt:new Point3();
			
			components = new <IComponent>[IsoProjection.instance];
			addComponent(new AsyncTexture(assetID));
		}
		public function addEventListener(event:String, callBackFunction:Function):void {
			if (image == null) throw new Error("Texture not set on IsoSprite yet");
			image.addEventListener(event, callBackFunction);
			image.touchable = true;
		}
		public function removeEventListener(event:String, callBackFunction:Function):void {
			if (!ready) return; // TODO: remove the ASyncEventHandler from the components
			image.removeEventListener(event, callBackFunction);
		}
		// Remove IsoSprite from it's GridIsoSprites layer
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
		// Internal use for setting the base Image or MovieClip
		public function setImage(img:Image):void {
			if (img == null) throw new Error("img is null");
			if (image != null && img != image) {
				if (image.parent) image.parent.removeChild(image);
			}

			this.image = img;
			image.touchable = false;
		}
		// Class is ready to be used and added to the display list
		public function get ready():Boolean {
			return image !== null;
		}
		// Advanced time on the components if the sprite is ready
		public function advanceTime(time:Number):void {
			var component:IComponent;
			if (ready==false) 
			for each (component in components) {
				if(component.requiresImage()==false) component.advanceTime(time, this); // run the components that don't require an image reference on the IsoSprite if it hasn't been loaded yet
			}
			else
			for each (component in components) { // run all components if the image is loaded and ready
				component.advanceTime(time, this); 
			}
		}
	}	
}
