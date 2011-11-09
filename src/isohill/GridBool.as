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
	 * Fixed two directional Boolean vector 
	 * + using single vector math for performance
	 * @author Jonathan Dunlap
	 */
	public class GridBool
	{
		private var data:Vector.<Boolean>;
		private var width:int=0;
		private var height:int=0;
		public function GridInt(width:int, height:int) 
		{
			this.width = width;
			this.height = height;
			if (width == 0 && height == 0) throw new Error("Invalid starting size of 0,0");
			width = Math.max(width, 1); // ensure that it's not zero as an example of 0 width times 1 height would be zero
			height = Math.max(height, 1); // same here
			data = new Vector.<Boolean>(width * height, true); // make a prefined fixed sized array for performance
		}
		public function getCell(x:int, y:int):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index];
		}
		public function setCell(x:int, y:int, value:Boolean):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index] = value;
		}
	}

}
