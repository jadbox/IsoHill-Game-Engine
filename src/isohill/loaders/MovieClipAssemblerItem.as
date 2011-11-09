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
	/**
	 * Items for MovieClipAssembler that specifies how items should be loaded and assembled
	 * @author Jonathan Dunlap
	 */
	public class MovieClipAssemblerItem
	{
		public var x:Number;
		public var y:Number;
		public var scaleX:Number=1;
		public var scaleY:Number=1;
		public var rotation:Number;
		public var file:String;
		public var linkage:String;
		public var children:Vector.<MovieClipAssemblerItem>;
		
		private var mc:MovieClip;
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
			if (o.linkage) item.linkage = String(o.linkage);
			if (o.children)
			for each(var child:Object in o.children) {
				item.children.push(make(child));
			}
			return item;
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
			ImgLoader.instance.getMovieClip(file, linkage, onLoad);
		}
		private function onLoad(mc:MovieClip):void {
			mc.x = x;
			mc.y = y;
			mc.scaleX = scaleX;
			mc.scaleY = scaleY;
			mc.rotation = rotation;
			this.mc = mc;
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