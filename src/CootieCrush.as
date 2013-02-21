package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60",backgroundColor="#000000")]

	
	public class CootieCrush extends Sprite
	{
		public static var splashBitmap:Bitmap;
		private var _starling:Starling;
		
		[Embed(source="/assets/images/splash.png")]
		public static const Splash:Class;
		
		public function CootieCrush()
		{
			var splashImage:Bitmap = new Splash();
			splashBitmap = new Bitmap(splashImage.bitmapData);
			
			if(this.stage)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			this.mouseEnabled = this.mouseChildren = false;
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		private function loaderInfo_completeHandler(event:Event):void
		{
			splashBitmap.width = stage.stageWidth - 50;
			splashBitmap.scaleY = splashBitmap.scaleX;
			splashBitmap.x = stage.stageWidth/2 - splashBitmap.width/2;
			splashBitmap.y = stage.stageHeight/2 - splashBitmap.height/2;
			this.addChild(splashBitmap);
			
			this._starling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			this._starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, startStarling);
		}
		
		protected function startStarling(event:Event):void
		{
			this._starling.start();
		}
		
	}
}