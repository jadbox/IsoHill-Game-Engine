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
