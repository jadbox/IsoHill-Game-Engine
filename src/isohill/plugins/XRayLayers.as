package isohill.plugins 
{
	import isohill.IsoHill;
	/**
	 * This is a "showcase" plugin. Fades each layer out in order of layers and repeats.
	 * @author Jonathan Dunlap
	 */
	public class XRayLayers implements IPlugin
	{
		public static const SPEED:int = 2;
		public var counter:int;
		public var layerIndex:int;
		public var alpha:Number = 1;
		public var paused:Boolean=true;
		
		public function XRayLayers() 
		{
			layerIndex = -1; //start flag
		} 
		public function advanceTime(time:Number, engine:IsoHill):void {
			if (layerIndex == -1) { layerIndex = engine.layers.length - 1; alpha = 1; return; }
			//trace(time);
			engine.layers[layerIndex].container.alpha = alpha;
			counter += 1;
			if (paused && counter < SPEED) return;
			paused = false;
			counter = 0;
			alpha -= .01;
			if (alpha <= -.4) {
				engine.layers[layerIndex].container.alpha = 1;
				layerIndex--;
				alpha = 1;
				paused = true;
			}
		}
		
	}

}