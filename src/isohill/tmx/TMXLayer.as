package isohill.tmx 
{
	import isohill.GridInt;
	/**
	 * Represents a TMX layer of ints
	 * @author Jonathan Dunlap
	 */
	public class TMXLayer extends GridInt
	{
		public var maxGid:int = 0; // what's the highest asset id referenced
		public var name:String;
		public function TMXLayer(w:int, h:int) 
		{
			super(w, h);
		}
		public static function fromCSV(layerBlock:XML, width:int, height:int):TMXLayer {
			var layerRaw:Array = layerBlock.data[0].toString().split(",");

			var layer:TMXLayer = new TMXLayer(width, height);
			var index:int = 0;
			for each(var cell:String in layerRaw) {
					cell = cell.replace("\n", ""); // remove those line breaks in the cvs data
					var cellVal:int = int(cell);
					layer.maxGid = Math.max(layer.maxGid, cellVal);
					layer.setCell(index % width, Math.floor(index / width), cellVal);
					index++;
			}
			trace("csv layer parsing done");
			return layer;
		}
	}

}