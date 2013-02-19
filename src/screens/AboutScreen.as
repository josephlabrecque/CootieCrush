package screens
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	//import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	//import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class AboutScreen extends Screen
	{
		
		protected var button:Button;
		protected var titleImage:Image;
		protected var starlinglogoImage:Image;
		protected var logoImage:Image;
		//protected var ps:PDParticleSystem;
		
		//[Embed(source="/assets/particles/bgparticles.pex", mimeType="application/octet-stream")]
		//private static const particle:Class;
		
		public function AboutScreen()
		{
			//setupParticles();
			
			var titleTexture:Texture = Main.assets.getTexture("splashtitle");
			titleImage = new Image(titleTexture);
			addChild(titleImage);
			
			button = new Button();
			button.label = "Back to Menu";
			button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			addChild(button);
			
			var logoTexture:Texture = Main.assets.getTexture("logo");
			logoImage = new Image(logoTexture);
			addChild(logoImage);
			
			var starlinglogoTexture:Texture = Main.assets.getTexture("starlinglogo");
			starlinglogoImage = new Image(starlinglogoTexture);
			addChild(starlinglogoImage);
		}
		/*
		private function setupParticles():void
		{
			var psConfig:XML = XML(new particle());
			var psTexture:Texture = Main.assets.getTexture("bgparticletexture");
			ps = new PDParticleSystem(psConfig, psTexture);
			addChild(ps);
			Starling.juggler.add(ps);
			ps.start();
		}
		*/
		override protected function draw():void
		{
			/*ps.scaleX = 1.5;
			ps.scaleY = 1.5;
			ps.y = stage.stageHeight;
			ps.x = stage.stageWidth/2 - ps.width/2;
			*/
			titleImage.width = stage.stageWidth/1.15;
			titleImage.scaleY = titleImage.scaleX;
			titleImage.x = stage.stageWidth/2 - titleImage.width/2;
			titleImage.y = 0;
			
			button.validate();
			button.x = (stage.stageWidth - button.width) / 2;
			button.y = titleImage.height;
			
			starlinglogoImage.width = stage.stageWidth/1.5;
			starlinglogoImage.alpha = 0.8;
			starlinglogoImage.scaleY = starlinglogoImage.scaleX;
			starlinglogoImage.x = stage.stageWidth/2 - starlinglogoImage.width/2;
			starlinglogoImage.y = stage.stageHeight - starlinglogoImage.height - 10;
			
			logoImage.width = stage.stageWidth/1.5;
			logoImage.scaleY = logoImage.scaleX;
			logoImage.x = stage.stageWidth/2 - logoImage.width/2;
			logoImage.y = starlinglogoImage.y - logoImage.height - 10;
		}
		
		protected function button_triggeredHandler(event:Event):void
		{
			var r:Main = this.root as Main;
			r.startTriggered();
		}
		
	}
}