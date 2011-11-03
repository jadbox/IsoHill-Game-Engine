package isohill.loaders 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import isohill.loaders.ImgLoader;
	import starling.textures.Texture;
	/**
	 * Loads one texture for multiple frames
	 * @author Jonathan Dunlap
	 */
	public class TexturesLoader implements ITextureLoader
	{
		public var url:String;
		
		private var frames:Vector.<Rectangle>;
		//public var textures:Vector.<Texture>;
		private var onLoadCallback:IOnTextureLoaded;
		
		// onLoadCallback(url:String, index:Int, texture:Texture);
		public function TexturesLoader(url:String, frames:Vector.<Rectangle>) 
		{
			this.url = url;
			this.frames = frames;
			
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		public function load(onLoadCallback:IOnTextureLoaded):void {
			this.onLoadCallback = onLoadCallback;
		}
		private function onLoad(bd:BitmapData):void {
			var bigTexture:Texture = Texture.fromBitmapData(bd);
			//var textures:Vector.<Texture> = new Vector.<Texture>(frames.length, true);
			var i:int = 0;
			for each (var frame:Rectangle in frames) {
				//frames.push( Texture.fromTexture(bigTexture, frame) );
				if(onLoadCallback!==null) onLoadCallback.onTextureLoaded(url, i++, Texture.fromTexture(bigTexture, frame));
			}
			onLoadCallback = null;
		}
		public function get id():String { return url; }
	}

}