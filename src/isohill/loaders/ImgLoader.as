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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * Simple remote asset loader system, for use in loading Textures
	 * @author Jonathan Dunlap
	 */
	public class ImgLoader 
	{
		/**
		 * Global handler for the ImgLoader 
		 */
		public static var instance:ImgLoader = new ImgLoader(); // singleton access
		
		private var loaderHash:Dictionary = new Dictionary(false); // cache
		private var loaderURLHash:Dictionary = new Dictionary(false); // cache
		public function ImgLoader() 
		{
			
		}
		/**
		 * BitmapData loader with simple caching based on url
		 * @param url
		 * @param onLoad
		 * 
		 */
		public function getBitmapData(url:String, onLoad:Function):void {			
			var onComplete:Function = function(loader:Loader):void {
				var bitmap:Bitmap = loader.content as Bitmap;
				if (bitmap == null) throw new Error("not a bitmap");
				onLoad(bitmap.bitmapData);
			}
			var loader:Loader = getLoader(url, onComplete);
		}
		/**
		 * Get a Loader object for a url location (or create it). 
		 * @param url URL location of the asset
		 * @param addOnComplete Callback function for when the loader completes
		 * @return The Loader object found (or created)
		 * 
		 */
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
		/**
		 * Get a URLLoader for a url location (or create it). 
		 * @param url URL location of the asset
		 * @param addOnComplete Callback function for when the loader completes
		 * @return The URLLoader object found (or created)
		 * 
		 */
		public function getURLLoader(url:String, addOnComplete:Function=null):URLLoader {
			if (loaderURLHash[url] != null) {
				if (addOnComplete !== null) addOnComplete( loaderURLHash[url] );
				return loaderHash[url];
			}
			var loader:URLLoader = new URLLoader();
			if (addOnComplete !== null) loader.addEventListener(Event.COMPLETE, function(e:Event):void { addOnComplete(loader); } );
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void { trace("URL:" + url, e.text) } );
			loader.load(new URLRequest(url));
			loaderURLHash[url] = loader;
			return loader;
		}
		/**
		 * Fetches a SWF by url location and returns a movieclip in the callback 
		 * @param url URL location
		 * @param linkage Linkage name of the asset to pull out of the SWF library
		 * @param onLoad Callback function when the asset is ready for use
		 * 
		 */
		public function getMovieClip(url:String, linkage:String, onLoad:Function):void {
			var onComplete:Function = function(loader:Loader):void {
				onLoad(getMovieClipFromLoader(loader, linkage));
			}
			var loader:Loader = getLoader(url, onComplete);	
		}
		/*
		public function getMovieClipProxy(url:String, linkage:String):Sprite {
			var sp:MovieClip = new MovieClip();
			getMovieClip(url, linkage, function(mc:MovieClip):void {
				sp.addChild(mc);
			});
			return sp;
		}*/
		private function getMovieClipFromLoader(loader:Loader, linkage:String = ""):MovieClip {
			if (loader.content == null) throw new Error("invalid asset loaded");
			if (linkage == "" || linkage == null) {
				if (loader.content.width == 0 || loader.content.height == 0) throw new Error("image size is zero");
				var mc:MovieClip = new MovieClip();
				mc.addChild(loader.content);
				return mc;
			}
			var Def:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var display:MovieClip = new Def();
			if (display.width == 0 || display.height == 0) throw new Error("image asset size is zero of linkage: "+linkage);
			if (display == null) throw new Error("not a bitmap");
			return display;
		}
		/**
		 * Fetches an XML file 
		 * @param url URL location of the file
		 * @param onLoad Callback for when the XML has been loaded with the XML reference
		 * 
		 */
		public function getXML(url:String, onLoad:Function):void {
			var onComplete:Function = function(loader:URLLoader):void {
				var data:* = loader.data;
				onLoad( new XML(data) );
			}
			getURLLoader(url, onComplete);
		}
	}
}
