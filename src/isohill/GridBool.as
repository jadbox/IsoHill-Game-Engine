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
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
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
		public function GridBool(width:int, height:int) 
		{
			this.width = width;
			this.height = height;
			if (width == 0 && height == 0) throw new Error("Invalid starting size of 0,0");
			width = Math.max(width, 1); // ensure that it's not zero as an example of 0 width times 1 height would be zero
			height = Math.max(height, 1); // same here
			data = new Vector.<Boolean>(width * height, true); // make a prefined fixed sized array for performance
		}
		public function getCell(x:int, y:int):Boolean {
			var index:int = y * width + x; // get the index of the single array for the grid position
			if (index >= data.length) return false;
			return data[index];
		}
		public function setCell(x:int, y:int, value:Boolean):Boolean {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index] = value;
		}
		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < height; y++) {
				for (var x:int = 0; x < width; x++) {
					result += getCell(x, y)==true?1:0;
				}
				result += "\n";
			}	
			return result; 
		}
		public static function fromBitMapDataAlpha(data:BitmapData, area:Rectangle = null):GridBool {
			var sx:int = area?Math.floor(area.x):0;
			var sy:int = area?Math.floor(area.y):0;
			var sw:int = area?Math.ceil(area.width):data.width;
			var sh:int = area?Math.ceil(area.height):data.height;

			//var toX:int = sx+sw;
			//var toY:int = sy+sh;
			var result:GridBool = new GridBool(sw, sh); // correct mapping for BitmapData

			var hadTransparency:Boolean = false; // flag if there was any transparency in the frame
			for (var x:int = 1; x < sw; x++) {
				for (var y:int = 1; y < sh; y++) {
					var val:uint = data.getPixel32(x+sx, y+sy);
					var alpha:uint = val >> 24 & 0xFF;
					var flag:Boolean = (alpha > 0);
					if (flag) hadTransparency = true;
					result.setCell(x, y, flag);
				}
			}
			if (hadTransparency == false) { 
				result = null; data = null;
			}
			return result;
		}
	}

}
