/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
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
