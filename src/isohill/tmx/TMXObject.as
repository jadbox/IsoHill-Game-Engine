package isohill.tmx 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * TMX object element
	 * @author Jonathan Dunlap
	 */
	public class TMXObject 
	{
		public var x:Number;
		public var y:Number;
		public var name:String;
		public var type:String;
		public var gid:int;
		
		public var properties:Dictionary = new Dictionary();
		public function TMXObject() 
		{
			
		}
		
	}

}