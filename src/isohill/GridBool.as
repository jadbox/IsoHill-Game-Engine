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
	 * (WIP class)
	 * Fixed two directional Boolean vector 
	 * + using single vector math for performance
	 * @author Jonathan Dunlap
	 */
	public class GridBool
	{
		private var data:Vector.<Boolean>;
		private var _width:int=0;
		private var _height:int=0;
		/**
		 * Constructor 
		 * @param width The width bounds of the grid
		 * @param height the height bounds of the grid
		 * 
		 */		
		public function GridBool(gridWidth:int, gridHeight:int) 
		{
			_width = gridWidth;
			_height = gridHeight;
			if (gridWidth == 0 || gridHeight == 0) throw new Error("Invalid starting size of 0,0");
			_width = Math.max(gridWidth, 1); // ensure that it's not zero as an example of 0 width times 1 height would be zero
			_height = Math.max(gridHeight, 1); // same here
			data = new Vector.<Boolean>(gridWidth * gridHeight, true); // make a prefined fixed sized array for performance
		}
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		/**
		 * Returns the value from a specific cell location 
		 * @param x Cell x location
		 * @param y Cell y location
		 * @return Boolean value of cell
		 * 
		 */		
		public function getCell(x:int, y:int):Boolean {
			var index:int = y * width + x; // get the index of the single array for the grid position
			if (index >= data.length) return false;
			
			//var alpha:uint = data[index] >> 24 & 0xFF;
			//var flag:Boolean = (alpha > 0);
			return data[index];
		}
		/**
		 * Sets the cell value at a specific location 
		 * @param x Cell x location
		 * @param y Cell y location
		 * @param value Value of the cell
		 * @return Resulting value of the cell
		 * 
		 */		
		public function setCell(x:int, y:int, value:Boolean):Boolean {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index] = value;
		}
		public function setGrid(data:Vector.<Boolean>):void {
			this.data = data;
		}
		/**
		 * Pretty printer for the grid
		 * @return String containing a nice look at the grid
		 * 
		 */		
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
		/**
		 * This static method takes a Bitmapdata object and converts the transparency data into a GridBool. (0 is transparent, 1 is solid)
		 * @param data BitmapData object as a source
		 * @param area Area location in the bitmap to crop
		 * @return resulting GridBool
		 * 
		 */		
		public static function fromBitMapDataAlpha(data:BitmapData, area:Rectangle = null):GridBool {
			//var result:GridBool = new GridBool(data.width, data.height); // correct mapping for BitmapData
			//result.setGrid(data.getVector(data.rect));
			var result:GridBool;
			var sx:int = area?Math.floor(area.x):0;
			var sy:int = area?Math.floor(area.y):0;
			var sw:int = area?Math.ceil(area.width):data.width;
			var sh:int = area?Math.ceil(area.height):data.height;
			for (var x:int = 0; x < sw; x++) {
				for (var y:int = 0; y < sh; y++) {
					var val:uint = data.getPixel32(x+sx, y+sy);
					var alpha:uint = val >> 24 & 0xFF;
					if (alpha !== 0) {
						if (result === null) result = new GridBool(data.width, data.height);
						result.setCell(x, y, true);
					}
				}
			}
			
			return result;
		}
	}

}
