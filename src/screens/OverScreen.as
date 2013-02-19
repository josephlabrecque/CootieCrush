package screens
{
	import flash.events.Event;
	import flash.media.Sound;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	//import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	//import starling.extensions.PDParticleSystem;
	
	public class OverScreen extends Screen
	{
		protected var startButton:Button;
		protected var exitButton:Button;
		//protected var ps:PDParticleSystem;
		protected var titleImage:Image;
		protected var resultsField:TextField;
		protected var timeupSound:Sound;
		
		[Embed(source="/assets/fonts/ITCKRIST.TTF", embedAsCFF="false", fontFamily="Kristen")]
		private static const Kristen:Class;
		
		//[Embed(source="/assets/particles/bgparticles.pex", mimeType="application/octet-stream")]
		//private static const particle:Class; 
		
		public function OverScreen()
		{
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE, renderScreen);
		}
		
		private function renderScreen():void
		{
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, renderScreen);
			timeupSound = Main.assets.getSound("timeup");
			
			//setupParticles();
			setupFonts();
			
			var titleTexture:Texture = Main.assets.getTexture("overtitle");
			titleImage = new Image(titleTexture);
			addChild(titleImage);
			
			startButton = new Button();
			startButton.label = "Start the game over?";
			startButton.addEventListener(starling.events.Event.TRIGGERED, start_triggeredHandler);
			addChild(startButton);
			
			exitButton = new Button();
			exitButton.label = "No thanks... just go away";
			exitButton.addEventListener(starling.events.Event.TRIGGERED, exit_triggeredHandler);
			addChild(exitButton);
			
			timeupSound.play(0,1);
		}
		
		private function setupFonts():void
		{
			var r:Main = this.root as Main;
			
			resultsField = new TextField(stage.stageWidth, 500, "text", "Kristen", 30, Color.WHITE, true);			
			resultsField.hAlign = HAlign.CENTER;
			resultsField.vAlign = VAlign.TOP;
			resultsField.border = false;
			resultsField.x = stage.stageWidth - resultsField.width - 5;
			resultsField.y = 200;
			resultsField.text = "+ GAME RESULTS +\n\n";
			resultsField.text += "Score: " + r._stats.score + "\n";
			resultsField.text += "Level: " + r._stats.level + "\n\n";
			resultsField.text += "Thanks for Playing!";
			this.addChild(resultsField);
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
			titleImage.y = 10;
			
			exitButton.validate();
			exitButton.width = stage.stageWidth - 20;
			exitButton.x = 10;
			exitButton.y = stage.stageHeight - exitButton.height - 10;
			
			startButton.validate();
			startButton.width = stage.stageWidth - 20;
			startButton.x = 10;
			startButton.y = exitButton.y - startButton.height - 10;
		}
		
		protected function start_triggeredHandler(event:starling.events.Event):void
		{
			var r:Main = this.root as Main;
			r.startTriggered();
		}
		
		protected function exit_triggeredHandler(event:starling.events.Event):void
		{
			var r:Main = this.root as Main;
			r.exitTriggered();
		}
		
	}
}