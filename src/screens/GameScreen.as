package screens
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import entities.Cootie;
	
	import feathers.controls.Screen;
	
	import org.kissmyas.utils.loanshark.LoanShark;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	public class GameScreen extends Screen
	{
		private var currentLevel:int = 1;
		private var overallScore:int = 0;
		private var maxNumCooties:int = 10;
		private var cootieCount:int = 0;
		private var countdown:Timer;
		private var lose:Boolean;
		private var cootiesField:TextField;
		private var countdownField:TextField;
		private var levelField:TextField;
		private var scoreField:TextField;
		private var timeToWin:int = 60;
		private var transImage:Image;
		private var topBar:Image;
		private var bottomBar:Image;
		private var bloodSplats:RenderTexture;
		private var bgmSound:Sound;
		private var musicChannel:SoundChannel;
		private var squishSound:Sound;
		private var levelSound:Sound;
		private var timeupSound:Sound;
		private var deadCootie:Image;
		private var cootiePool:LoanShark;
		protected var ps:PDParticleSystem;
		
		[Embed(source="/assets/fonts/ITCKRIST.TTF", embedAsCFF="false", fontFamily="Kristen")]
		private static const Kristen:Class;
		
		[Embed(source="/assets/particles/burst.pex", mimeType="application/octet-stream")]
		private static const particle:Class;
		
		public function GameScreen()
		{
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE, playGame);
			bgmSound = Main.assets.getSound("bgm");
			squishSound = Main.assets.getSound("squish");
			levelSound = Main.assets.getSound("level");
		}
		
		private function playGame():void {
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, playGame);
			
			var st:SoundTransform = new SoundTransform(0.5);
			musicChannel = bgmSound.play(0, int.MAX_VALUE, st);
			
			setupParticles();
			
			cootiePool = new LoanShark(Cootie);
			
			bloodSplats = new RenderTexture(stage.stageWidth, stage.stageHeight);
			var bloodSplatsImage:Image = new Image(bloodSplats);
			/*bloodSplatsImage.blendMode = BlendMode.MULTIPLY;
			bloodSplatsImage.filter = new BlurFilter(4,4);*/
			addChild(bloodSplatsImage);
			
			var transTexture:Texture = Main.assets.getTexture("leveltrans");
			transImage = new Image(transTexture);
			//transImage.blendMode = BlendMode.SCREEN;
			transImage.alpha = 0;
			addChild(transImage);
			
			transImage.width = stage.stageWidth - 20;
			transImage.scaleY = transImage.scaleX;
			transImage.x = 10;
			transImage.y = stage.stageHeight/2 - transImage.height/2;
			transImage.touchable = false;
			
			
			var deadCootieTexture:Texture = Main.assets.getTexture("dead");
			deadCootie = new Image(deadCootieTexture);
			
			countdown = new Timer(1000, timeToWin);
			countdown.addEventListener(TimerEvent.TIMER, countdownTick);
			countdown.addEventListener(TimerEvent.TIMER_COMPLETE, countdownComplete);
			countdown.start();
			
			generateCooties();
			buildBars();
			setupFonts();
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, gameLoop);
		}
		
		private function setupParticles():void
		{
			var psConfig:XML = XML(new particle());
			var psTexture:Texture = Main.assets.getTexture("burst");
			ps = new PDParticleSystem(psConfig, psTexture);
			ps.y = stage.stageHeight/2 - ps.height/2;
			ps.x = stage.stageWidth/2 - ps.width/2;
			addChild(ps);
			Starling.juggler.add(ps);
		}
		
		private function buildBars():void
		{
			var barTexture:Texture = Main.assets.getTexture("bar");
			topBar = new Image(barTexture);
			topBar.alpha = 0.75;
			topBar.width = stage.stageWidth;
			topBar.touchable = false;
			addChild(topBar);
			
			bottomBar = new Image(barTexture);
			bottomBar.alpha = 0.75;
			bottomBar.width = stage.stageWidth;
			bottomBar.touchable = false;
			addChild(bottomBar);
			
			bottomBar.y = stage.stageHeight - bottomBar.height;
		}
		
		private function levelClear():void {
			currentLevel++;
			levelField.text = "LEVEL " + currentLevel;
			maxNumCooties += 15;
			levelSound.play(0,1);
			generateCooties();
			shiftUI();
			countdown.reset();
			countdown.start();
		}
		
		private function generateCooties():void
		{
			for(var i:int=0; i<maxNumCooties; i++){
				var c:Cootie = cootiePool.borrowObject();
				//var c:Cootie = new Cootie();
				var w:int = 45;
				//c.x = Math.round(0 + ((stage.stageWidth-w) - 0) * Math.random());
				//c.y = Math.round(0 + ((stage.stageHeight-w) - 0) * Math.random());
				c.x = (stage.stageWidth/2) - w;//(c.width/2);
				c.y = (stage.stageHeight/2) - w;//(c.height/2);
				c.addEventListener(starling.events.TouchEvent.TOUCH, cootieCrushed);
				addChild(c);
				cootieCount++;
			}
			ps.start(0.3);
		}
		
		private function shiftUI():void
		{
			this.setChildIndex(topBar, this.numChildren - 1);
			this.setChildIndex(bottomBar, this.numChildren - 1);
			this.setChildIndex(cootiesField, this.numChildren - 1);
			this.setChildIndex(countdownField, this.numChildren - 1);
			this.setChildIndex(levelField, this.numChildren - 1);
			this.setChildIndex(scoreField, this.numChildren - 1);
			//this.setChildIndex(transImage, this.numChildren);
			//ps.stop();
		}
		
		private function cootieCrushed(event:TouchEvent):void
		{
			if(event.touches[0].phase == "began"){
				var c:Cootie = event.currentTarget as Cootie;
				c.removeEventListener(starling.events.TouchEvent.TOUCH, cootieCrushed);
				
				var matrix:Matrix = c.transformationMatrix;
				bloodSplats.draw(deadCootie, matrix, 0.3);
				
				//removeChild(c);
				
				cootiePool.returnObject(this.removeChild(c));
				
				overallScore += 10;
				cootieCount--;
				
				squishSound.play(0,1);
			}
		}
		
		private function setupFonts():void
		{
			cootiesField = new TextField(200, 30, "text", "Kristen", 18, Color.SILVER);			
			cootiesField.hAlign = HAlign.LEFT;
			cootiesField.vAlign = VAlign.CENTER;
			cootiesField.border = false;
			cootiesField.x = 5;
			cootiesField.y = 5;
			cootiesField.text = "COOTIES: " + cootieCount;
			cootiesField.touchable = false;
			this.addChild(cootiesField);
			
			countdownField = new TextField(200, 30, "text", "Kristen", 18, Color.SILVER);			
			countdownField.hAlign = HAlign.RIGHT;
			countdownField.vAlign = VAlign.CENTER;
			countdownField.border = false;
			countdownField.x = stage.stageWidth - countdownField.width - 5;
			countdownField.y = 5;
			countdownField.text = "TIME: " + timeToWin;
			countdownField.touchable = false;
			this.addChild(countdownField);
			
			levelField = new TextField(200, 30, "text", "Kristen", 18, Color.SILVER);			
			levelField.hAlign = HAlign.LEFT;
			levelField.vAlign = VAlign.CENTER;
			levelField.border = false;
			levelField.x = 5;
			levelField.y = stage.stageHeight - levelField.height - 5;
			levelField.text = "LEVEL " + currentLevel;
			levelField.touchable = false;
			this.addChild(levelField);
			
			scoreField = new TextField(200, 30, "text", "Kristen", 18, Color.SILVER);			
			scoreField.hAlign = HAlign.RIGHT;
			scoreField.vAlign = VAlign.CENTER;
			scoreField.border = false;
			scoreField.x = stage.stageWidth - scoreField.width - 5;
			scoreField.y = stage.stageHeight - scoreField.height - 5;
			scoreField.text = "SCORE: " + overallScore;
			scoreField.touchable = false;
			this.addChild(scoreField);
		}
		
		private function gameLoop(event:EnterFrameEvent):void
		{
			if(!lose){
				cootiesField.text = "COOTIES: " + cootieCount;
				scoreField.text = "SCORE: " + overallScore;
				if(cootieCount == 0){
					countdown.stop();
					
					transImage.alpha = 1;
					var tween:Tween = new Tween(transImage, 3);
					tween.animate("alpha", 0);
					Starling.juggler.add(tween);
					
					levelClear();
				}
			}
		}
		
		protected function countdownTick(event:TimerEvent):void
		{			
			countdownField.text = "TIME: " + (event.target.repeatCount - event.target.currentCount);
		}
		
		protected function countdownComplete(event:TimerEvent):void
		{			
			lose = true;
			musicChannel.stop();
			var r:Main = this.root as Main;
			r._stats.level = currentLevel;
			r._stats.score = overallScore;
			r.overTriggered();
		}
		
	}
}