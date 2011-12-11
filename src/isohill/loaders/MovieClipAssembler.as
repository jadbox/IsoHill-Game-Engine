/* IsoHill engine, http://www.isohill.com
 * Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
 * All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 */
package isohill.loaders
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.GridFitType;
	import isohill.GridBool;
	import isohill.GridBool;
	import isohill.IsoDisplay;
	import isohill.AssetManager;
	import isohill.IsoMovieClip;
	import isohill.IsoSprite;
	import isohill.Point3;
	import starling.core.Starling;
	import isohill.starling.HitMovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.display.DisplayObject;
	
	/**
	 * Takes a configuration MovieClipAssemblerItem to load and assemble a texture
	 * @author Jonathan Dunlap
	 */
	public class MovieClipAssembler implements ITextureLoader
	{
		private var items:MovieClipAssemblerItem;
		private static var proxyTexture:Vector.<Texture>;
		private var hitMap:Vector.<GridBool>;
		private var _id:String;
		private var fps:int;
		private var textures:Vector.<Texture>;
		private var offset:Point;
		
		public function MovieClipAssembler(items:MovieClipAssemblerItem, fps:int = 12, hitMapTest:Boolean = true)
		{
			this.items = items;
			_id = items.id;
			this.fps = fps;
			offset = new Point(items.x, items.y);
			if (hitMapTest)
				hitMap = new Vector.<GridBool>();
		}
		
		public function getDisplay():DisplayObject
		{
			if (proxyTexture == null)
				proxyTexture = new <Texture>[Texture.empty(15, 15, 0x25ff0000)];
			return new HitMovieClip(proxyTexture, fps);
		}
		
		/* INTERFACE isohill.loaders.ITextureLoader */
		public function setTexture(sprite:IsoDisplay):void
		{
			IsoMovieClip(sprite).setTexture(offset, textures);
			IsoMovieClip(sprite).setHitmap(hitMap);
		}
		
		public function get isLoaded():Boolean
		{
			return textures !== null;
		}
		
		public function load():void
		{
			items.load(onLoad);
		}
		
		private function onLoad(mc:MovieClip):void
		{
			if (mc == null)
				throw new Error("failed to load MovieClipAssemblerItem");
		//	var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(mc);
			var container:MovieClip = new MovieClip();
			container.addChild(mc);
			textures = getTextures(container, hitMap);
		}
		
		// Converts a MovieClip to a series of Textures in a Vector
		public static function getTextures(mc:MovieClip, hitMap:Vector.<GridBool> = null):Vector.<Texture>
		{
			var target:MovieClip = mc;
			var textures:Vector.<Texture> = new Vector.<Texture>();
			// retarget if the first child is the container with all the frames
			var frames:int = findLongestFrame(mc);
			var matrix:Matrix = new Matrix();
			var rect:Rectangle = findBiggestFrame(mc, frames);
			if (rect.width < 1 || rect.height < 1) throw new Error("Empty MC assembled object (zero width or zero height)");
			for (var i:int = 1; i <= frames; i++)
			{
				nextFrame(mc);
				
				var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				matrix.tx = -rect.x;
				matrix.ty = -rect.y;
				bmd.draw(mc, matrix, null, null, null, true);
				textures.push(Texture.fromBitmapData(bmd));
				if (hitMap != null)
				{
					var hitMapItem:GridBool = GridBool.fromBitMapDataAlpha(bmd);
					hitMap.push(hitMapItem);
				}
				bmd.dispose();
			}
			return textures;
		}
		
		private static function findLongestFrame(mc:MovieClip):int
		{
			var current:int = mc.totalFrames;
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip)
					current = Math.max(current, findLongestFrame(MovieClip(child)));
			}
			return current;
		}
		
		private static function findBiggestFrame(mc:MovieClip, frames:int):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			var lastRect:Rectangle;
			for (var i:int = 1; i <= frames; i++)
			{
				nextFrame(mc);
				lastRect = mc.getBounds(mc);
				rect = rect.union(lastRect);
			}
			resetFrame(mc);
			return rect;
		}
		
		private static function nextFrame(mc:MovieClip):void
		{
			mc.nextFrame();
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip)
					nextFrame(MovieClip(child));
			}
		}
		
		private static function resetFrame(mc:MovieClip):void
		{
			mc.gotoAndStop(0);
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				var child:flash.display.DisplayObject = mc.getChildAt(i);
				if (child is MovieClip)
					resetFrame(MovieClip(child));
			}
		}
		/** @inheritDoc */
		public function get id():String
		{
			return _id;
		}
	}

}