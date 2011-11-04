/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
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
