package isohill.loaders 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import isohill.AssetManager;
	import isohill.loaders.ImgLoader;
	import starling.textures.Texture;
	/**
	 * Loads one texture for one frame
	 * @author Jonathan Dunlap
	 */
	public class TextureLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		public var textures:Vector.<Texture>;
		private var onLoadCallback:IOnTextureLoaded;
		
		// onLoadCallback(url:String, index:Int, texture:Texture);
		public function TextureLoader(url:String) 
		{
			this.url = url;
			this.frames = frames;
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		public function load(onLoadCallback:IOnTextureLoaded):void {
			this.onLoadCallback = onLoadCallback;
		}
		private function onLoad(bd:BitmapData):void {
			var texture:Texture = Texture.fromBitmapData(bd);
			if(onLoadCallback!==null) onLoadCallback.onTextureLoaded(url, 0, texture);
			onLoadCallback = null;
		}
		public function get id():String { return url; }
		
		public static function loaded(url:String):Boolean {
			return AssetManager.instance.hasLoader(url);
		}
	}

}