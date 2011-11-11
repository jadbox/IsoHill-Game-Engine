package isohill.loaders 
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import isohill.AssetManager;
	import isohill.IsoSprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * Loads a MovieClip and converts it to a Texture for AssetManager
	 * @author Jonathan Dunlap
	 */
	public class MovieClipLoader implements ITextureLoader 
	{
		private var _id:String;
		private var linkage:String;
		private var fileName:String;
		private var atlas:TextureAtlas;
		private var onLoadCallback:IOnTextureLoaded;
		private static var proxyTexture:Vector.<Texture>;
		private var textures:Vector.<Texture>;
		
		public function MovieClipLoader(fileName:String, linkage:String="") 
		{
			
			this.linkage = linkage;
			this.fileName = fileName;
			_id = linkage + "@" + fileName;
			ImgLoader.instance.getDisplayObject(fileName, linkage, onLoad);
		}
		private function onLoad(movieClip:MovieClip):void {
			if (movieClip == null) throw new Error("Null movieclip loaded from file: "+fileName+" linage: "+linkage);
			atlas = DynamicAtlas.fromMovieClipContainer(movieClip);
			textures = atlas.getTextures();
		}
		public function getImage():Image {
			if(proxyTexture==null) proxyTexture = new <Texture>[Texture.empty(1,1)];
			return new starling.display.MovieClip(proxyTexture);
		}
		public function setTexture(sprite:IsoSprite):void {
			var mc:starling.display.MovieClip = starling.display.MovieClip(sprite.image);
			AssetManager._setupMovieClip(sprite, textures);
			sprite.image.pivotY = sprite.image.height;
			sprite.image.pivotX = 0;
		}
		public function get isLoaded():Boolean {
			return textures !== null;
		}
		/* INTERFACE isohill.loaders.ITextureLoader */
		
		public function get id():String 
		{
			return _id;
		}
		
	}

}