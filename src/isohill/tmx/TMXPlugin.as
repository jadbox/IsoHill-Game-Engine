package isohill.tmx 
{
	import isohill.AssetManager;
	import isohill.components.AsyncTexture;
	import isohill.GridIsoSprites;
	import isohill.IsoHill;
	import isohill.IsoSprite;
	import isohill.plugins.IPlugin;
	import isohill.Point3;
	import starling.textures.Texture;
	/**
	 * The TMX plugin for the engine to bind the data to the renderer.
	 * @author Jonathan Dunlap
	 */
	public class TMXPlugin implements IPlugin
	{
		public var tmx:TMX;
		public var linkedLayer:Vector.<GridIsoSprites>;
		private var iSprite:int=0;
		public function TMXPlugin(tmx:TMX) 
		{
			this.tmx = tmx;
			linkedLayer = new <GridIsoSprites>[];
		}
		public function init():void {
			for (var x:int = 0; x < tmx.width; x++) {
				for (var y:int = 0; y < tmx.height; y++) {
					makeSprites(x, y);
				}
			}
			trace("layers created");
		}
		private var steps:int=0; // TODO: add async asset tmx sprite creation for when its texture is loaded
		public function advanceTime(time:Number, engine:IsoHill):void {
			//if (steps == -1 || ++steps < 80) return;
			//if (steps == -1) return;
			//steps = -1;
		}
		
		private function makeSprites(cellX:int, cellY:int):void {
			// in layers
			for (var i:int = 0; i < tmx.layersArray.length; i++) {
				var layer:TMXLayer = tmx.layersArray[i]; if (layer == null) continue;
				var _cell:int = layer.getCell(cellX, cellY); // temp
				if (_cell == 0 || isNaN(_cell)) continue;
				var grid:GridIsoSprites = linkedLayer[i];
				var pt3:Point3 = grid.toLayerPt(cellX, cellY);
				var name:String = tmx.getImgSrc(_cell)+"_"+(iSprite++);
				var sprite:IsoSprite = new IsoSprite(name, pt3);
				sprite.frame = tmx.getImgFrame(_cell); 
				sprite.components.push( new AsyncTexture( tmx.getImgSrc(_cell) ) );
				grid.push(sprite);
			}
			// in object layers
			
		}
		public function addObjectsToLayer(grid:GridIsoSprites, group:TMXObjectgroup):void {
			for each(var obj:TMXObject in group.objects) {
				var tile:TMXTileset = tmx.tilesets[obj.gid];
				// TODO: this is not working as the texture hasn't loaded yet when this method is called
				//var texure:Texture = AssetManager.instance.getTexture(tmx.imgsURL + tile.source.source, obj.gid - tile.firstgid); 
				var sprite:IsoSprite = new IsoSprite(null, new Point3(obj.x, obj.y));
				sprite.name = obj.name; 
				sprite.type = obj.type;
				sprite.frame = tmx.getImgFrame( obj.gid );
				sprite.components.push( new AsyncTexture( tmx.getImgSrc(obj.gid) ) );
				grid.push(sprite);
			}
		}
		public function makeEmptyGridOfSize(tmxLayerIndex:int, name:String):GridIsoSprites {
			var layer:GridIsoSprites = new GridIsoSprites(name, tmx.width, tmx.height, tmx.tileWidth, tmx.tileHeight);
			for (var i:int = 0; i <= tmxLayerIndex; i++) {
				if (i == linkedLayer.length) linkedLayer.push(null);
			}
			return linkedLayer[tmxLayerIndex] = layer;
		}
	}

}