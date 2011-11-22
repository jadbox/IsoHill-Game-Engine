/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.utils 
{
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import isohill.Point3;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	/**
	 * Basic camera point location at which: mouse at corners of the screen moves the point and A/Z zooms
	 * @author Jonathan Dunlap
	 */
	public class Point3Input extends Point3
	{
		private var stage:Stage;
		private var velocity:Point3;
		private var hitArea:Number;
		public var speed:Number;
		public var zoom:Number = .05;
		
		public function Point3Input(stage:Stage, x:Number=1, y:Number=1, z:Number=1, hitArea:Number=22, speed:Number = 4) 
		{
			super(x, y, z);
			this.stage = stage;
			this.hitArea = hitArea; this.speed = speed;
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.stage.stage.addEventListener("mouseLeave", onMouseOut);
			stage.stage.addEventListener("mouseOut", onMouseOut);
			stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			velocity = new Point3(0, 0, 0); 
		}
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.A) velocity.z = zoom;
			else if (e.keyCode == Keyboard.Z) velocity.z = -zoom;
		}
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.A) velocity.z = 0;
			else if (e.keyCode == Keyboard.Z) velocity.z = 0;
		}
		private function onMouseOut(e:*):void
		{
				trace( "onMouseOut" );
				velocity.x = 0; velocity.y = 0;
		}
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage);
			if (touch == null) return;
			var _x:Number = touch.globalX;
			var _y:Number = touch.globalY;
			
			if (_x > stage.stageWidth - hitArea) velocity.x = speed;
			else if (_x < hitArea) velocity.x = -speed;
			else velocity.x = 0;
			
			if (_y > stage.stageHeight - hitArea) velocity.y = speed;
			else if (_y < hitArea) velocity.y = -speed;
			else velocity.y = 0;
		}
		override public function update(time:Number):void {
			var fasterPanWithZoom:Number = Math.max(z, 1);
			x += velocity.x;
			y += velocity.y;
			z += velocity.z;
		}
	}

}
