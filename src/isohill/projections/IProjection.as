/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.projections 
{
	import flash.geom.Point;
	import isohill.GridDisplay;
	import isohill.IsoDisplay;
	import isohill.IsoSprite;
	import isohill.Point3;
	
	/**
	 * This is an interface to add component logic to IsoSprite entities. Components either mutates/changes individual entities.
	 */
	public interface IProjection
	{
		function onSetup(grid:GridDisplay):void;
		function perSprite(sprite:IsoDisplay):void;
		function layerToScreen(pt:Point3):Point
		function screenToLayer(pt:Point):Point3
	}
	
}
