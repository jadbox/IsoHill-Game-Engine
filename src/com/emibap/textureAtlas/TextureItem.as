package com.emibap.textureAtlas{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class TextureItem extends Sprite{
		
		private var _graphic:BitmapData;
		private var _textureName:String = "";
		private var _frameName:String = "";
		
		public function TextureItem(graphic:BitmapData, textureName:String, frameName:String){
			super();
			
			_graphic = graphic;
			_textureName = textureName;
			_frameName = frameName;
			
			var bm:Bitmap = new Bitmap(graphic, "auto", false);
			addChild(bm);
		}
		
		public function get textureName():String{
			return _textureName;
		}
		
		public function get frameName():String{
			return _frameName;
		}
		
		public function get graphic():BitmapData{
			return _graphic;
		}
	}
}