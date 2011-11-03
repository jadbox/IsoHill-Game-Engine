package  
{
	import fr.kouma.starling.utils.Stats;
	import isohill.GridIsoSprites;
	import isohill.IsoHill;
	import isohill.plugins.IsoCamera;
	import isohill.plugins.XRayLayers;
	import isohill.Point3;
	import isohill.tmx.TMX;
	import isohill.tmx.TMXPlugin;
	import isohill.utils.Point3Input;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * This is a testing implementation of the IsoHill engine.
	 * + Loads a TMX file
	 * + Creates layers in the engine based on the data
	 * + Adds in engine plugins
	 * + starts the engine
	 * 
	 * "A or Z" to zoom
	 * @author Jonathan Dunlap
	 */
	public class IsoHillDemo extends Sprite 
	{
		public var isoHill:IsoHill;
		private var tmx:TMX;
		
		public function IsoHillDemo() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded); // let's wait for Flash to get setup
		}
		private function onStageAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			TMX.loadTMX("./assets/", "isohilldemo.tmx", onTMXLoad); // Load the TMX map for use in the engine
		}
		private function onTMXLoad(tmx:TMX):void {
			this.tmx = tmx;
			setup();
		}
		// Once the TMX data has been loaded, let's setup the engine now
		private function setup():void {
			isoHill = new IsoHill(); // instance that engine
			addChild(isoHill); // add the engine to starling
			addPlugins(isoHill);
			isoHill.start(); // start all the runtime logic
			
			addChild(new Stats()); // Mrdoob's performance monitor
		}
		private function addPlugins(isoHill:IsoHill):void {
			var tmxPlugin:TMXPlugin = new TMXPlugin(tmx); // plugin to bind the TMX data to the engine
			// link the TMX layers to engine layers (allows for optional "in-between" layers)
			var i:int = 0;
			for (var layerName:String in tmx.layersHash) {
				var grid:GridIsoSprites = tmxPlugin.makeEmptyGridOfSize(i);
				if (layerName=="Tile Layer 1") grid.sort = false; // disable sorting of the ground as it doesn't need it
				isoHill.addLayer(i, layerName, grid); // add the layer to the engine
				i++;
			}
			isoHill.addPlugin(new XRayLayers());
			isoHill.addPlugin(tmxPlugin); // adding the plugin
			isoHill.addPlugin(new IsoCamera(new Point3Input(stage, 0, 600)));
		}
	}

}