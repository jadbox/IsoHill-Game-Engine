package isohill.loaders 
{
	
	/**
	 * Interface to start loading a texture
	 * @author Jonathan Dunlap
	 */
	public interface ITextureLoader 
	{
		function load(onLoadCallback:IOnTextureLoaded):void;
		function get id():String;
	}
	
}