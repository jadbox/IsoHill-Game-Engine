/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package isohill.components 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import isohill.IsoDisplay;
	import isohill.GridBool;
	import isohill.IsoSprite;
	/**
	 * This component wraps the Starling Touch events but takes into account transparency
	 * @author Jonathan Dunlap
	 */
	public class TouchComponent implements IComponent 
	{
		public var transparentArea:GridBool;
		public function TouchComponent(bmd:BitmapData) 
		{
			
		}
		public static function fromBitmap(b:Bitmap):TouchComponent {
			return new TouchComponent(b.bitmapData);
		}
		/* INTERFACE isohill.components.IComponent */
		
		public function advanceTime(time:Number, sprite:IsoDisplay):void 
		{
			
		}
	}

}