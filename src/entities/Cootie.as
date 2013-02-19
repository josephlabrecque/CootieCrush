package entities
{
	import flash.events.Event;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	
	public class Cootie extends Sprite
	{
		private var dampen:Number = 0.999;
		private var maxScale:Number = 2.3;
		private var minScale:Number = 1.3;
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var vz:Number = 0;
		private var cootieAnimation:MovieClip;
		private var cootieColors:Array = new Array("CootieRed", "CootieGreen", "CootieBlue");
		private var sh:int;
		private var sw:int;
		
		public function Cootie()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, cootieAdded);
		}
		
		private function cootieAdded():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, cootieAdded);
			sw = Math.round(stage.stageWidth);
			sh = Math.round(stage.stageHeight);
			skinCootie();
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, animateCootie);
		}		
		
		private function skinCootie():void
		{
			var cootieSelection:String = cootieColors[Math.round(0 + (2 - 0) * Math.random())];
			var frames:Vector.<Texture> = Main.assets.getTextures(cootieSelection);
			cootieAnimation = new MovieClip(frames, 24);
			cootieAnimation.currentFrame = Math.round(1 + (40 - 1) * Math.random());
			Starling.juggler.add(cootieAnimation);
			addChild(cootieAnimation);
			
			/* CANNOT STACK FILTERS - BOO!
			var sat:Number = Math.round(-0.5 + (1 - -0.5) * Math.random());
			var hue:Number = Math.round(-0.5 + (1 - -0.5) * Math.random());
			var filter:ColorMatrixFilter = new ColorMatrixFilter();
			filter.adjustSaturation(sat);
			filter.adjustHue(hue);
			cootieAnimation.filter = filter;
			*/
		}
		
		private function animateCootie(event:EnterFrameEvent):void
		{
			this.vx += Math.random() * 0.2 - 0.1;
			this.vy += Math.random() * 0.2 - 0.1;
			this.vz += Math.random() * 0.002 - 0.001;
			
			this.x += this.vx;
			this.y += this.vy;
			this.scaleX = this.scaleY += this.vz;
			this.vx *= dampen;
			this.vy *= dampen;
			this.vz *= dampen;
			
			if(this.x > sw) {
				this.x = 0 - this.width;
			}
			else if(this.x < 0 - this.width) {
				this.x = sw;
			}
			if(this.y > sh) {
				this.y = 0 - this.height;
			}
			else if(this.y < 0 - this.height) {
				this.y = sh;
			}
			
			if (this.scaleX > maxScale){
				this.scaleX = this.scaleY = maxScale;
			}
			else if (this.scaleX < minScale){
				this.scaleX = this.scaleY = minScale;
			}
			
		}
	}
}