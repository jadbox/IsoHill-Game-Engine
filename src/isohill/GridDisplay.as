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
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import isohill.components.IComponent;
	import isohill.plugins.IPlugin;
	import isohill.projections.IProjection;
	import isohill.projections.IsoProjection;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * Unbounded two directional vector (using single vector math)
	 * @author Jonathan Dunlap
	 */
	public class GridDisplay
	{
		private var data:Vector.<Vector.<IsoDisplay>>;
		private var flatData:Vector.<IsoDisplay>;
		private var w:int = 0;
		private var h:int = 0;
		private var tileWidth:int = 1;
		private var tileHeight:int = 1;
		
		private var tileWidthOffset:int = 1;
		
		private var tileHeightOffset:int = 1;
		
		private var sqEdgeSize:Number;
		
		private var projection:IProjection;
		private var ratio:Point = new Point(1, 1); //movement ratio for parallax
		private var spriteHash:Dictionary = new Dictionary(true); // sprite name -> IsoDisplay
		/**
		 * Name of this grid for lookups
		 */		
		public var name:String;
		/**
		 * Should the grid be sorted (default: true) 
		 */		
		public var sort:Boolean = true;
		/**
		 * Starling display container for the grid. Note, avoid using this as it may cause rendering issues.
		 */		
		public var display:Sprite;
		/**
		 * If the layer should be positioned when IsoHill wants to move the layers 
		 */		
		public var autoPosition:Boolean = true; // allow isoHill to position this layer when the cam moves
		
		/**
		 * Constructor 
		 * @param name Unique name of the grid
		 * @param w Numbers of cells wide of the grid
		 * @param h Numbers of cells height of the grid
		 * @param cellwidth Pixel width of each cell
		 * @param cellheight Pixel height of each cell
		 * @param projection IProjection class to project an <code>IsoDisplay</code> element from it's point location to screen space. Default of null uses IsoProjection.
		 * 
		 */		
		public function GridDisplay(name:String, w:int, h:int, cellwidth:Number, cellheight:Number, projectionType:String) 
		{
			this.name = name;
			this.w = w;
			this.h = h;
			this.tileWidth = cellwidth;
			this.tileHeight = cellheight;
			tileWidthOffset = tileWidth - 2;
			tileHeightOffset = tileHeight - 2;
			
			sqEdgeSize = tileHeightOffset;
			
			display = new Sprite();
			data = new Vector.<Vector.<IsoDisplay>>(w * h, true);
			flatData = new <IsoDisplay>[];
			
			this.projection = new IsoProjection(projectionType, cellwidth, cellheight);
			this.projection.onSetup(this);
			
			//trace(tileWidth, tileHeight);
		}
		/**
		 * Get an <code>IsoDisplay</code> element by its name 
		 * @param name name property of the element
		 * @return returns the element, otherwise null
		 * 
		 */		
		public function getByName(name:String):IsoDisplay {
			return spriteHash[name];
		}
		/**
		 * When IsoHill wants to move this layer, this sets the speed ratio that it moves. Default X,Y is 1.0,1.0.
		 * @param xRatio x movement speed
		 * @param yRatio y movement speed
		 * 
		 */		
		public function setMoveRatio(xRatio:Number=1, yRatio:Number=1):void {
			ratio.setTo(xRatio, yRatio);
		}
		public function get positionX():Number {
			return display.x;
		}
		public function get positionY():Number {
			return display.y;
		}
		public function set positionX(val:Number):void {
			display.x = val;
		}
		public function set positionY(val:Number):void {
			display.y = val;
		}
		/**
		 * Absolute move
		 * @param x x location
		 * @param y y location
		 * 
		 */		
		public function moveTo(x:Number, y:Number):void {
			display.x = x * ratio.x;
			display.y = y * ratio.y;
		}
		/**
		 * Relative move (offset)
		 * @param x x location
		 * @param y y location
		 * 
		 */	
		public function offset(x:Number, y:Number):void {
			display.x += x * ratio.x;
			display.y += y * ratio.y;
		}
		/**
		 * Returns the number of <code>IsoDisplay</code> children in the grid
		 */		
		public function get numChildren():int { return flatData.length; }
		/**
		 * This method allows access to grid elements sequentially (use with numChildren)
		 * @param index Child index
		 * @return IsoDisplay object, null if not found
		 * 
		 */		
		public function getChildAtIndex(index:int):IsoDisplay { return flatData[index];}
		/**
		 * Pretty printer 
		 * @return A string of the layout and elements of the GridDisplay
		 * 
		 */		
		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < h; y++) {
				for (var x:int = 0; x < w; x++) {
					result += getCell(x, y).toString();
				}
				result += "\n";
			}	
			return result; 
		}
		/**
		 * Flatten the layer, does not allow for updates but improves performance (see Starling flatten) 
		 */		
		public function flatten():void {
			sort = false;
			display.flatten();
		}
		/**
		 * Unflatten layer for updates (see Starling unflatten) 
		 */		
		public function unflatten():void {
			sort = true;
			display.unflatten();
		}
		/**
		 * force a sort and reflatten if the grid was set to flatten
		 */		
		public function forceUpdate():void {
			if (display.isFlattened == false) return;
			display.unflatten();
			display.flatten();
		}
		/**
		 * Returns if the grid is flattened
		 */		
		public function get isFlattened():Boolean {
			return display.isFlattened;
		}
		/**
		 * Get the collection of <code>IsoDisplay</code> in cell location
		 * @param x cell location x
		 * @param y cell location y
		 * @return Vector of <code>IsoDisplay</code> objects in that location
		 * 
		 */
		public function getCell(x:int, y:int):Vector.<IsoDisplay> {
			if (x >= w) x = w-1; // inlined bound checking for speed
			else if (x < 0) x = 0;
			if (y >= h) y = h - 1;
			else if (y < 0) y = 0;
			
			var index:int = (y*w)+x;
			return data[index];
		}
		/**
		 * Grid cell location to iso layer location
		 * @param x grid X position to convert to layer location
		 * @param y grid Y position to convert to layer location
		 * @param z
		 * @return Point3 object of the layer location
		 * 
		 */
		public function toLayerPt(x:int, y:int, z:int = 1):Point3 {
			return new Point3(x * sqEdgeSize, y * sqEdgeSize, z);
		}
		// 
		/**
		 * Layer pt to grid location
		 * @param x layer x position to convert to grid cell location
		 * @param y layer y position to convert to grid cell location
		 * @return cell Point location
		 * 
		 */		
		public function fromLayerPt(x:Number, y:Number):Point {
			var pt:Point = new Point(	Math.floor(x / sqEdgeSize), 
										Math.floor(y / sqEdgeSize)	);
			return pt;
		}
		/**
		 * Get the screen x,y location from this layer's point location 
		 * @param pt Layer location to convert to
		 * @return screen point location
		 * 
		 */		
		public function layerToScreen(pt:Point3):Point {
			var answer:Point = projection.layerToScreen(pt);
			return display.localToGlobal(answer);
		}
		/**
		 * Get this layer's point location from a screen point location 
		 * @param pt screen point location
		 * @return Layer location to convert to
		 * 
		 */		
		public function screenToLayer(pt:Point):Point3 {
			var localPt:Point = display.globalToLocal(pt);
			var pt3:Point3 = projection.screenToLayer(localPt);
			//trace("screenToLayer ", pt, localPt, pt3);
			return pt3;
		}
		private function updateLocation(val:IsoDisplay):void {
			var x:int = Math.floor(val.pt.x / sqEdgeSize);
			var y:int = Math.floor(val.pt.y / sqEdgeSize);
			if (x >= w) x = w-1; // inlined bound checking for speed
			else if (x < 0) x = 0;
			if (y >= h) y = h - 1;
			else if (y < 0) y = 0;
			
			var index:int = (y * w) + x;
			if (index == val.layerIndex) return; // no change needed
			removeFromGridData(val);
			
			var collection:Vector.<IsoDisplay> = data[index];
			if (collection == null) collection = data[index] = new Vector.<IsoDisplay>();
			collection.push(val);
			val.layerIndex = index;
		}
		private function removeFromGridData(val:IsoDisplay):void {
			if (val.layerIndex == -1) return;
			var arr:Vector.<IsoDisplay> = data[val.layerIndex];
			if (arr == null) { val.layerIndex = -1; return;}
			//throw new Error("invalid layer index " + val.layerIndex);
			var index:int = arr.indexOf(val);
			if (index == -1) { trace("Sprite '" + val.name + "' not found on array layer: " + name + ",  hash has:"+spriteHash[val.name]); return; }
			arr.splice(index, 1);
			val.layerIndex = -1;
		}
		/**
		 * Adds an element to the grid while self determining the IsoDisplay cell location
		 * @param val IsoDisplay object to add to layer
		 * @return IsoDisplay object
		 * 
		 */		
		public function add(val:IsoDisplay):IsoDisplay {
			if (val == null) return val;
			if (val.name == "" || val.name == null) {
				throw new Error("adding sprite with no name");
			}

			updateLocation(val);
			spriteHash[val.name] = val;
			val.layer = this;
			addStarlingChild(val.display);
			return val;
		}
		/**
		 * Removes an IsoDisplay element from the grid
		 * @param val IsoDisplay object to remove
		 * @return IsoDisplay object
		 * 
		 */		
		public function remove(val:IsoDisplay):IsoDisplay {
			if (val.layerIndex == -1 || val.layer==null) return val;
			display.removeChild(val.display);
			
			removeFromGridData(val);
			val.layer = null;
			delete spriteHash[val.name];
			return val;
		}
		/**
		 * Adds to the grid a Vector of <code>IsoDisplay</code> of objects
		 * @param val Vector of <code>IsoDisplay</code> list of objects to add
		 * @return Vector of <code>IsoDisplay</code> object
		 * 
		 */		
		public function setCell(val:Vector.<IsoDisplay>):Vector.<IsoDisplay> {
			for each (var sprite:IsoDisplay in val) add(sprite);
			return val;
		}
		/**
		 * Maps a function (Vector of IsoDisplay -> value|object) over every entry in the grid and returns a 2D array of those transformed elements
		 * @param func Function to execute on every IsoDisplay object in the grid and returns a value
		 * @return 2D map of elements returned from the input function
		 * 
		 */
		public function toMap(func:Function):Array {
			if (func == null) throw new Error("null function");
			var map:Array = [];
			for (var y:int = 0; y < h; y++) {
				for (var x:int = 0; x < w; x++) {
					if (map[y] == null) map[y] = [];
					map[y][x] = func(getCell(x, y));
				}
			}
			return map;
		}
		private function addStarlingChild(image:DisplayObject):void {
			var wasFlat:Boolean = display.isFlattened;
			if(wasFlat) display.unflatten();
			display.addChild(image);
			forceUpdate();
		}
		/**
		 * Internal use only 
		 * @param time
		 * @param engine
		 * 
		 */		
		public function advanceTime(time:Number, engine:IsoHill):void {
			var first:IsoDisplay;
			for each(var layer:Vector.<IsoDisplay> in data) {
				if (layer != null) for each(var sprite:IsoDisplay in layer) {
					if (sprite == null) continue;
					projection.perSprite(sprite);
					updateLocation(sprite);
					sprite.advanceTime(time);
				}
			}
			
			if (sort) sortSystem(time);
		}
		private function sortSystem(time:Number):void {
			var f:DisplayObject;
			var numSprites:int = display.numChildren;
			var c:DisplayObject;
			for (var i:int = 0; i < numSprites; i++) {
				c = display.getChildAt(i);
				if (f != null && sorterDisplay(f, c)) display.swapChildren(f, c);
				f = c;
			}
		}
		// Compare two entities and return true if they need to be depth swapped
		private function sorterDisplay(f:DisplayObject, s:DisplayObject):Boolean {
			var key:Number = f.y;
			var key2:Number = s.y;
			return key > key2;
		}
		/**
		 * Height of the grid in cells
		 */	
		public function get height():int { return h; }
		/**
		 * Width of the grid in cells
		 */	
		public function get width():int { return w; }
	}

}
