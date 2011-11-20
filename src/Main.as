/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	import fr.kouma.starling.utils.Stats;
	import isohill.tmx.TMX;
	import starling.core.Starling;
	
	/**
	 * This application acts as a tester for the IsoHill engine.
	 * See IsoHillDemo class for engine implementation
	 * @author Jonathan Dunlap
	 */
	[SWF(width="800", height="600", framerate="30", backgroundColor="#111111")]
	public class Main extends Sprite 
	{
		public static var instance:Main;
		private var mStarling:Starling;
		public function Main():void 
		{
			trace("main started");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			Security.allowInsecureDomain("localhost");
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			instance = this;
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			mStarling = new Starling(NatureDemo, stage);
			//mStarling = new Starling(BoulderDemo, stage);
			mStarling.antiAliasing = 2; 
			mStarling.start();
		}	
	}
	
}