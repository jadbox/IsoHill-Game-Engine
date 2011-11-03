package isohill.tmx 
{
	import flash.display.BitmapData;
	/**
	 * Represents the source of a tileset image element and loads the data
	 * @author Jonathan Dunlap
	 */
	public class TMXSource 
	{
		public var source:String;
		public var width:int;
		public var height:int;
		
	//	public var bitmapData:BitmapData;
		
		//<image source="PlaceholderWindCollector.png" width="1024" height="256"/>
		public function TMXSource(element:XML) 
		{
			source = element.@source;
			width = int(element.@width);
			height = int(element.@height);
		}
	}

}