/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.loaders 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	/**
	 * Items for MovieClipAssembler that specifies how items should be loaded and assembled
	 * @author Jonathan Dunlap
	 */
	public class MovieClipAssemblerItem
	{
		public var x:Number=0;
		public var y:Number=0;
		public var scaleX:Number=1;
		public var scaleY:Number=1;
		public var rotation:Number;
		public var file:String;
		public var alpha:Number = 1;
		public var linkage:String;
		public var children:Vector.<MovieClipAssemblerItem>;
		public var mc:MovieClip;
		public var filters:Array = new Array();
		
		private var onLoaderCallback:Function;
		private var parseChild:int = 0;
		
		public static function make(o:Object):MovieClipAssemblerItem {
			var item:MovieClipAssemblerItem = new MovieClipAssemblerItem();
			if(o.x) item.x = Number(o.x);
			if(o.y) item.y = Number(o.y);
			if(o.scaleX) item.scaleX = Number(o.scaleX);
			if(o.scaleY) item.scaleY = Number(o.scaleY);
			if (o.rotation) item.rotation = o.rotation;
			if (o.file) item.file = String(o.file);
			if (o.mc && o.mc is MovieClip) item.mc = o.mc;
			if (o.linkage) item.linkage = String(o.linkage);
			if (o.alpha) item.alpha = Number(o.alpha);
			if (o.red || o.green || o.blue) {
				var filter:ColorMatrixFilter = new ColorMatrixFilter(getBasicMatrix(o.red, o.green, o.blue));
				var filters:Array = new Array();
				item.filters.push(filter);
			}
			if (o.blur) {
				var blur:BlurFilter = new BlurFilter(o.blur, o.blur);
				item.filters.push(blur);
			}
			if (o.children)
			for each(var child:Object in o.children) {
				item.children.push(make(child));
			}
			return item;
		}
		private static function getBasicMatrix(red:Array=null, green:Array=null, blue:Array=null):Array {
			var matrix:Array = new Array();
			matrix = matrix.concat(red?red:[1, 0, 0, 0, 0]); // red
            matrix = matrix.concat(green?green:[0, 1, 0, 0, 0]); // green
            matrix = matrix.concat(blue?blue:[0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			return matrix;
		}
		public function MovieClipAssemblerItem() 
		{
			children = new <MovieClipAssemblerItem>[];
		}
		// ID is unique because of itself and children
		public function get id():String {
			var _id:String = "";
			_id += file + linkage;
			for each(var child:MovieClipAssemblerItem in children) _id += "," + child.id;
			return _id;
		}
		public function load(onLoaderCallback:Function):void 
		{
			this.onLoaderCallback = onLoaderCallback;
			if (this.mc) onLoad(mc);
			else ImgLoader.instance.getMovieClip(file, linkage, onLoad);
		}
		private function onLoad(mc:MovieClip):void {
			mc.x = x;
			mc.y = y;
			mc.alpha = alpha;
			mc.scaleX = scaleX;
			mc.scaleY = scaleY;
			mc.rotation = rotation;
			this.mc = mc;
			mc.filters = filters;
			loadChild(parseChild);
		}
		private function loadChild(index:int):void {
			if (index >= children.length) {
				onLoaderCallback(mc);
				return;
			}
			var child:MovieClipAssemblerItem = children[index];
			child.load(onChildLoad);
		}
		private function onChildLoad(childMC:MovieClip):void {
			mc.addChild(childMC);
			loadChild(++parseChild);
		}
	}

}