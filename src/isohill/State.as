package isohill 
{
	/**
	 * State represents a basic "state" data of a game isosprite.
	 * These couple properties can handle most game entity required information
	 * @author Jonathan Dunlap
	 */
	public class State 
	{
		public var name:String; // name of the state ("flee", "attack", "walkTo")
		public var targetPt:Point3; // point targeted area (useful for a target pixel location)
		public var target:IsoSprite; // used for moving/using/targeting to another IsoSprite
		public var start:int; // start time of the state
		public var end:int; // end time of the state (-1 for no end)
		
		public function State(name:String="", start:int = 0, end:int = 0) 
		{
			this.name = name;
			this.start = start;
			this.end = end;
		}
		
	}

}