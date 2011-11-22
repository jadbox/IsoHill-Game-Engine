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
		
		//<image source="PlaceholderWindCollector.png" width="1024" height="256"/>
		public function TMXSource(element:XML) 
		{
			source = element.@source;
			width = int(element.@width);
			height = int(element.@height);
		}
	}

}
