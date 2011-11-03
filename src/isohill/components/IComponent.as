package isohill.components 
{
	import isohill.IsoSprite;
	
	/**
	 * This is an interface to add component logic to IsoSprite entities. Components either mutates/changes individual entities.
	 */
	public interface IComponent 
	{
		function advanceTime(time:Number, sprite:IsoSprite):void;
		function requiresImage():Boolean;
	}
	
}