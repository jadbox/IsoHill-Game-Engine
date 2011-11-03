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
			mStarling = new Starling(IsoHillDemo, stage);
			mStarling.antiAliasing = 2; 
			mStarling.start();
		}	
	}
	
}