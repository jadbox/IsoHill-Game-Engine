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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * Simple bitmapdata and xml loader util
	 * @author Jonathan Dunlap
	 */
	public class ImgLoader 
	{
		public static var instance:ImgLoader = new ImgLoader(); // singleton access
		
		private var loaderHash:Dictionary = new Dictionary(false); // cache
		private var loaderURLHash:Dictionary = new Dictionary(false); // cache
		public function ImgLoader() 
		{
			
		}
		// BitmapData loader with simple caching based on url
		public function getBitmapData(url:String, onLoad:Function):void {			
			var onComplete:Function = function(loader:Loader):void {
				var bitmap:Bitmap = loader.content as Bitmap;
				if (bitmap == null) throw new Error("not a bitmap");
				onLoad(bitmap.bitmapData);
			}
			var loader:Loader = getLoader(url, onComplete);
		}
		public function getLoader(url:String, addOnComplete:Function=null):Loader {
			if (loaderHash[url] != null) {
				if (addOnComplete !== null) addOnComplete( loaderHash[url] );
				return loaderHash[url];
			}
			var loader:Loader = new Loader();
			if (addOnComplete !== null) loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { addOnComplete(loader); } );
			loader.load(new URLRequest(url));
			loaderHash[url] = loader;
			return loader;
		}
		public function getURLLoader(url:String, addOnComplete:Function=null):URLLoader {
			if (loaderURLHash[url] != null) {
				if (addOnComplete !== null) addOnComplete( loaderURLHash[url] );
				return loaderHash[url];
			}
			var loader:URLLoader = new URLLoader();
			if (addOnComplete !== null) loader.addEventListener(Event.COMPLETE, function(e:Event):void { addOnComplete(loader); });
			loader.load(new URLRequest(url));
			loaderURLHash[url] = loader;
			return loader;
		}
		public function getDisplayObject(url:String, linkage:String, onLoad:Function):void {
			var onComplete:Function = function(loader:Loader):void {
				onLoad(getDisplayObjectFromLoader(loader, linkage));
			}
			var loader:Loader = getLoader(url, onComplete);	
		}
		public function getDisplayObjectProxy(url:String, linkage:String):Sprite {
			var sp:Sprite = new Sprite();
			getDisplayObject(url, linkage, function(displayObject:DisplayObject):void {
				sp.addChild(displayObject);
			});
			return sp;
		}
		private function getDisplayObjectFromLoader(loader:Loader, linkage:String=""):DisplayObject {
			if (linkage == null) linkage = "";
			var Def:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var display:DisplayObject = new Def();
			if (display == null) throw new Error("not a bitmap");
			return display;
		}
		public function getXML(url:String, onLoad:Function):void {
			var onComplete:Function = function(loader:URLLoader):void {
				var data:* = loader.data;
				onLoad( new XML(data) );
			}
			getURLLoader(url, onComplete);
		}
	}
}
