package isohill.loaders 
{
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * TODO: NON-FUNCTIONAL
	 * @author Jonathan Dunlap
	 */
	public class Asset 
	{
		public var loaded:Boolean;
		protected var _loading:Boolean;
		private var callBacks:Vector.<Array>
		
		private var texture:Texture;
		
		public function Asset(url:String) 
		{
			ImgLoader.instance.getBitmapData(url, onLoad);
		}
		private function onLoad(bd:BitmapData):void {
			texture = Texture.fromBitmapData(bd);
			onLoaded();
		}
		public function get loading():Boolean {
			return _loading;
		}
		public function onLoaded():void {
			do {
				var cbData = callBacks.pop();
				cbData[1].push(texture);
				cbData[0].apply(null, callBacks.pop()[1]);
			} while (callBacks.length > 0);
			//for (cb in callBacks) cb(texture);
		}
		public function getTexture(callBack:Function, ...rest):void {
			if (texture != null) {
				rest.push(texture);
				callBack.apply(null, rest);
			}
			else {
				callBacks.push([callBack, rest]);
			}
		}
	}

}