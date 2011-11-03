package isohill.plugins 
{
	import isohill.IsoHill;
	
	/**
	 * This is an interface to perform engine-wide mutations/changes to the rendering phases
	 * @author Jonathan Dunlap
	 */
	public interface IPlugin 
	{
		function advanceTime(time:Number, engine:IsoHill):void;
	}
	
}