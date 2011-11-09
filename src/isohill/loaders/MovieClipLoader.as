package isohill.loaders 
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
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
			onLoadCallback(atlas.getTextures());
		}
		/* INTERFACE isohill.loaders.ITextureLoader */
		
		public function get id():String 
		{
			return _id;
		}
		
		public function load(onLoadCallback:IOnTextureLoaded):void {
			this.onLoadCallback = onLoadCallback;
		}
		
	}

}