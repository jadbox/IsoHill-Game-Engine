package isohill.loaders 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
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
		
		private var data:Dictionary = new Dictionary(false); // cache
		public function ImgLoader() 
		{
			
		}
		// BitmapData loader with simple caching based on url
		public function getBitmapData(url:String, onLoad:Function):void {
			if (data[url] != null) {
				onLoad(data[url]);
			}
			var onComplete:Function = function(e:Event):void {
				var bd:BitmapData = e.currentTarget.content.bitmapData;
				if (bd == null) throw new Error("not a bitmap");
				data[url] = bd;
				onLoad(bd);
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			//loader.addEventListener(IOErrorEvent.ERROR, function(e:IOErrorEvent):void { 
			//	trace(e); 
			//} );
			loader.load( new URLRequest(url) );
		}
		public function getXML(url:String, onLoad:Function):void {
			if (data[url] != null) {
				onLoad(data[url]);
			}
			var onComplete:Function = function(e:Event):void {
				var bd:XML = XML(e.currentTarget.data);
				data[url] = bd;
				onLoad(bd);
			}
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load( new URLRequest(url) );
		}
	}
}