package isohill.components 
{
	import isohill.AssetManager;
	import isohill.IsoSprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Jonathan Dunlap
	 */
	public class AsyncTexture implements IComponent 
	{
		private var assetManagerKey:String;
		public function AsyncTexture(assetManagerKey:String) 
		{
			this.assetManagerKey = assetManagerKey;
			AssetManager
		}
		public function advanceTime(time:Number, sprite:IsoSprite):void {
			var texture:Texture = AssetManager.instance.getTexture(assetManagerKey, sprite.frame);
			if (texture == null) return;
			sprite.components.splice(sprite.components.indexOf(this), 1);
			sprite.setTexture(texture);
		}
		public function requiresImage():Boolean { 
			return false;
		}
	}

}