/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.utils
{
	
	/**
	 * Utilities that involve Strings
	 * @author Jonathan Dunlap
	 */
	public class StringUtils
	{
		public static function padIntWithLeadingZeros(value:int, len:uint):String
		{
			var paddedValue:String = value.toString();
			
			if (paddedValue.length < len)
			{
				for (var i:int = 0, numOfZeros:int = (len - paddedValue.length); i < numOfZeros; i++)
				{
					paddedValue = "0" + paddedValue;
				}
			}
			
			return paddedValue;
		}
	}

}