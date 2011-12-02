/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill 
{
	/**
	 * State represents a basic "state" data of a game isosprite.
	 * These couple properties can handle most game entity required information
	 * @author Jonathan Dunlap
	 */
	public class State 
	{
		/**
		 * name of the state ("flee", "attack", "walkTo")
		 */
		public var name:String;
		/**
		 * point targeted area (useful for a target pixel location)
		 */
		public var targetPt:Point3;
		/**
		 * used for moving/using/targeting to another IsoSprite
		 */
		public var target:IsoSprite; 
		/**
		 * start time of the state
		 */
		public var start:int; 
		/**
		 * end time of the state (-1 for no end)
		 */
		public var end:int;
		/**
		 * Collision flag
		 */
		public var collidable:Boolean = false;
		 
		/**
		 * Constructor 
		 * @param name  name of the state
		 * @param start start time of the state
		 * @param end end time of the state (-1 for no end)
		 * 
		 */
		public function State(name:String="", start:int = 0, end:int = 0, collidable:Boolean=false) 
		{
			this.name = name;
			this.start = start;
			this.end = end;
			this.collidable = collidable;
		}
		
	}

}
