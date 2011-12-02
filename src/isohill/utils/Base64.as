/*******************************************************************************
 * This util was forked from:
 * Copyright (c) 2010 by Thomas Jahn
 * This content is released under the MIT License.
 ******************************************************************************/
package isohill.utils 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	import isohill.GridInt;
	import isohill.tmx.TMXLayer;
	/**
	 * Base64 utils
	 */
	public class Base64 
	{
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		public static function base64ToTMXLayer(chunk:String, width:int, height:int, compressed:Boolean):TMXLayer
		{
			var result:TMXLayer = new TMXLayer(width, height);
			var data:ByteArray = base64ToByteArray(chunk);
			if(compressed)
				data.uncompress();
			data.endian = Endian.LITTLE_ENDIAN;
			var y:int = 0;
			while(data.position < data.length)
			{
				for (var x:int = 0; x < width; x++) {
					var val:int = data.readInt();
					result.setCell(x, y, val);
					result.maxGid = Math.max(val, result.maxGid);
				}
				y++;
			}
			return result;
		}
		
		public static function base64ToByteArray(data:String):ByteArray 
		{
			var output:ByteArray = new ByteArray();
			//initialize lookup table
			var lookup:Array = [];
			for(var c:int = 0; c < BASE64_CHARS.length; c++)
				lookup[BASE64_CHARS.charCodeAt(c)] = c;

			var outputBuffer:Array = new Array(3);
			
			for (var i:uint = 0; i < data.length - 3; i += 4) 
			{
				//read 4 bytes and look them up in the table
				var a0:int = lookup[data.charCodeAt(i)];
				var a1:int = lookup[data.charCodeAt(i + 1)];
				var a2:int = lookup[data.charCodeAt(i + 2)];
				var a3:int = lookup[data.charCodeAt(i + 3)];
			
				// convert to and write 3 bytes
				if(a1 < 64)
					output.writeByte((a0 << 2) + ((a1 & 0x30) >> 4));
				if(a2 < 64)
					output.writeByte(((a1 & 0x0f) << 4) + ((a2 & 0x3c) >> 2));
				if(a3 < 64)
					output.writeByte(((a2 & 0x03) << 6) + a3);
			}
			
			// Rewind & return decoded data
			output.position = 0;
			return output;
		}
		
	}

}
