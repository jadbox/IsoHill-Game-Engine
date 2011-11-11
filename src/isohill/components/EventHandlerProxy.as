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
	 * This component acts as a proxy to register events to an image that hasn't loaded yet
	 * @author Jonathan Dunlap
	 */
	public class EventHandlerProxy implements IComponent 
	{
		private var sprite:IsoSprite;
		private var eventName:String;
		private var callBackFunction:Function;
		public function EventHandlerProxy(sprite:IsoSprite, eventName:String, callBackFunction:Function) 
		{
			this.sprite = sprite;
			this.eventName = eventName;
			this.callBackFunction = callBackFunction;
		}
		public function onSetup(sprite:IsoSprite):void {
			
		}
		public function onRemove():void {
			
		}
		public function advanceTime(time:Number, sprite:IsoSprite):void {
			sprite.components.splice(sprite.components.indexOf(this), 1);
			sprite.image.touchable = true;
			sprite.image.addEventListener(eventName, callBackFunction);
			callBackFunction = null; // remove the reference
		}
		public function requiresImage():Boolean { 
			return true;
		}
	}

}