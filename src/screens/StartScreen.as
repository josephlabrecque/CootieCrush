package screens
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class StartScreen extends Screen
	{
		protected var startButton:Button;
		protected var aboutButton:Button;
		protected var titleImage:Image;
		protected var ps:PDParticleSystem;
		
		[Embed(source="/assets/particles/bgparticles.pex", mimeType="application/octet-stream")]
		private static const particle:Class; 
		
		public function StartScreen()
		{
			setupParticles();
			
			var titleTexture:Texture = Main.assets.getTexture("splashtitle");
			titleImage = new Image(titleTexture);
			addChild(titleImage);
			
			startButton = new Button();
			startButton.label = "Crush Them!";
			startButton.addEventListener(Event.TRIGGERED, game_triggeredHandler);
			addChild(startButton);
			
			aboutButton = new Button();
			aboutButton.label = "About...";
			aboutButton.addEventListener(Event.TRIGGERED, about_triggeredHandler);
			addChild(aboutButton);
		}
		
		private function setupParticles():void
		{
			var psConfig:XML = XML(new particle());
			var psTexture:Texture = Main.assets.getTexture("bgparticletexture");
			ps = new PDParticleSystem(psConfig, psTexture);
			addChild(ps);
			Starling.juggler.add(ps);
			ps.start();
		}
		
		override protected function draw():void
		{
			ps.scaleX = 1.5;
			ps.scaleY = 1.5;
			ps.y = stage.stageHeight;
			ps.x = stage.stageWidth/2 - ps.width/2;
			
			titleImage.width = stage.stageWidth/1.15;
			titleImage.scaleY = titleImage.scaleX;
			titleImage.x = stage.stageWidth/2 - titleImage.width/2;
			titleImage.y = 0;
			
			startButton.validate();
			startButton.x = (stage.stageWidth - startButton.width) / 2;
			startButton.y = titleImage.height;

			aboutButton.validate();
			aboutButton.width = startButton.width;
			aboutButton.x = (stage.stageWidth - aboutButton.width) / 2;
			aboutButton.y = startButton.y + aboutButton.height + 20;
		}
		
		protected function game_triggeredHandler(event:Event):void
		{
			var r:Main = this.root as Main;
			r.gameTriggered();
		}
		
		protected function about_triggeredHandler(event:Event):void
		{
			var r:Main = this.root as Main;
			r.aboutTriggered();
		}
		
	}
}