package isohill.tmx 
{
	import flash.utils.Dictionary;
	/**
	 * TMX objectgroup element
	 * @author Jonathan Dunlap
	 */
	public class TMXObjectgroup 
	{
		public var name:String;
		public var width:Number;
		public var height:Number;
		
		public var properties:Dictionary = new Dictionary();
		public var objects:Vector.<TMXObject> = new <TMXObject>[];
		public var objectsHash:Dictionary = new Dictionary();
		
		public function TMXObjectgroup() 
		{
			
		}
		
	}

}