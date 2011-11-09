package isohill.loaders 
{
	import com.emibap.textureAtlas.DynamicAtlas;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import isohill.components.FrameComponent;
	import isohill.IsoSprite;
	import isohill.Point3;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * Takes a configuration MovieClipAssemblerItem to load and assemble a texture
	 * @author Jonathan Dunlap
	 */
	public class MovieClipAssembler implements ITextureLoader 
	{
		private var items:MovieClipAssemblerItem;
		private var onLoadCallback:IOnTextureLoaded;
		
		private var _id:String;
		private var fps:int;
		public function MovieClipAssembler(items:MovieClipAssemblerItem, fps:int=12) 
		{
			this.items = items;
			_id = items.id;
			this.fps = fps;
		}
		// Initializes a newly created sprite with the asset ID and FrameComponent for animation
		public function setupSprite(sprite:IsoSprite, loop:Boolean=false):FrameComponent {
			sprite.setTextureLoader(this);
			var component:FrameComponent = new FrameComponent(loop, fps);
			sprite.addComponent(component);
			return component;
		}
		/* INTERFACE isohill.loaders.ITextureLoader */
		
		public function load(onLoadCallback:IOnTextureLoaded):void 
		{
			this.onLoadCallback = onLoadCallback;
			items.load(onLoad);
		}
		private function onLoad(mc:MovieClip):void {
			if (mc == null) throw new Error("failed to load MovieClipAssemblerItem");
			//var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(mc);
			var textures:Vector.<Texture> = getTextures(mc);
			onLoadCallback.onTexturesLoaded(_id, textures);
		}
		// Converts a MovieClip to a series of Textures in a Vector
		public static function getTextures(mc:MovieClip):Vector.<Texture> {
			var target:MovieClip = mc;
			var textures:Vector.<Texture> = new Vector.<Texture>();
			// retarget if the first child is the container with all the frames
			var frames:int = findLongestFrame(mc);
			var matrix:Matrix = new Matrix();
			var rect:Rectangle = findBiggestFrame(mc, frames);
			for (var i:int = 1; i <= frames; i++) {
				nextFrame(mc);

				var bounds:Rectangle = mc.getBounds(mc);
				var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				matrix.tx = -rect.x;
				matrix.ty = -rect.y;
				bmd.draw(mc, matrix, null, null, null, true);
				textures.push(Texture.fromBitmapData(bmd));
			}
			return textures;
		}
		private static function findLongestFrame(mc:MovieClip):int {
			var current:int = mc.totalFrames;
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) current = Math.max(current, findLongestFrame(MovieClip(child)));
			}
			return current;
		}
		private static function findBiggestFrame(mc:MovieClip, frames:int):Rectangle {
			var rect:Rectangle = new Rectangle();
			for (var i:int = 1; i <= frames; i++) {
				nextFrame(mc);
				var frameRect:Rectangle = mc.getBounds(mc);
				rect.width = Math.max(rect.width, frameRect.width);
				rect.height = Math.max(rect.width, frameRect.height);
				rect.x = Math.min(rect.x, frameRect.x);
				rect.y = Math.min(rect.y, frameRect.y);
			}
			resetFrame(mc);
			return rect;
		}
		private static function nextFrame(mc:MovieClip):void {
			mc.nextFrame();
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) nextFrame(MovieClip(child));
			}
		}
		private static function resetFrame(mc:MovieClip):void {
			mc.gotoAndStop(1);
			for (var i:int = 0; i < mc.numChildren; i++) {
				var child:DisplayObject = mc.getChildAt(i);
				if (child is MovieClip) resetFrame(MovieClip(child));
			}
		}
		public function get id():String 
		{
			return _id;
		}
		
	}

}