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
	import isohill.components.EventHandlerProxy;
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
		public function IsoSprite(name:String, pt:Point3=null, state:State=null) 
		{
			this.name = name;
			this.state = state!=null?state:new State();
			this.pt = pt != null?pt:new Point3();

			components = new <IComponent>[IsoProjection.instance];
		}
		public function setTextureID(id:String, frame:int = 0, imageDecorator:Object=null):void {
			if (ready) return;
			//TODO: for each(var item:IComponent in components.filter(function(t:IComponent):Boolean { return t is AsyncTexture; } )) components.splice(components.indexOf(item), 1);
			components.push(new AsyncTexture(id, frame, imageDecorator));
		}
		public function setTextureLoader(loader:ITextureLoader):void {
			setTextureID(loader.id);
			AssetManager.instance.addLoader(loader);
		}
		public function addEventListener(event:String, callBackFunction:Function):void {
			if (!ready) components.push(new EventHandlerProxy(this, event, callBackFunction));
			else image.addEventListener(event, callBackFunction);
		}
		public function removeEventListener(event:String, callBackFunction:Function):void {
			if (!ready) return; // TODO: remove the ASyncEventHandler from the components
			image.removeEventListener(event, callBackFunction);
		}
		public function remove():void {
			if (layer != null) layer.remove(this);
		}
		public function addComponent(c:IComponent):IComponent {
			components.push(c); return c;
		}
		public function removeComponent(component:IComponent):void {
			var index:int = components.indexOf(component);
			if (index != -1) components.splice(index, 1);
		}
		// Set the texture- this can only be done once
		public function setImage(img:Image):void {
			if (img == null) throw new Error("img is null");
			if (image != null) return;

			this.image = img;
			image.touchable = false;
			image.pivotY = image.texture.height;
			image.pivotX = 0;//image.texture.width / 2;
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
