package isohill.loaders 
{
	import starling.textures.Texture;
	
	/**
	 * Defines a method to be called when a texture has finished loading
	 * @author Jonathan Dunlap
	 */
	public interface IOnTextureLoaded 
	{
		function onTextureLoaded(url:String, frame:int, texture:Texture):void;
	}
	
}