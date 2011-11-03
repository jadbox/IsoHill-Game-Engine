package isohill 
{
	import flash.utils.Dictionary;
	import isohill.loaders.IOnTextureLoaded;
	import isohill.loaders.ITextureLoader;
	import starling.textures.Texture;
	/**
	 * Indexer for Textures
	 * @author Jonathan Dunlap
	 */
	public class AssetManager implements IOnTextureLoaded
	{
		public static var instance:AssetManager = new AssetManager();
		
		private var textures:Dictionary = new Dictionary();
		private var assetLoaders:Dictionary = new Dictionary();
		public function AssetManager() 
		{
			
		}
		public function addLoader(loader:ITextureLoader):void {
			if (hasLoader(loader.id)) return;
			assetLoaders[loader.id] = loader;
			loader.load(this);
		}
		public function onTextureLoaded(url:String, frame:int, texture:Texture):void {
			textures[url + "@" + frame] = texture;
		}
		public function getTexture(url:String, frame:int):Texture {
			return textures[url + "@" + frame];
		}
		public function getLoader(id:String):ITextureLoader {
			return assetLoaders[id];
		}
		public function hasLoader(id:String):Boolean {
			return getLoader(id) != null;
		}
	}

}