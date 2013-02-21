package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.themes.MetalWorksMobileTheme;
	
	import screens.AboutScreen;
	import screens.GameScreen;
	import screens.OverScreen;
	import screens.StartScreen;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class Main extends Sprite
	{
		public var _navigator:ScreenNavigator;
		public var _stats:Object = new Object();
		protected var theme:MetalWorksMobileTheme;
		private static var assetManager:AssetManager;
		protected var selectSound:Sound;
		
		
		public function Main()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			if(Capabilities.cpuArchitecture=="ARM")
			{
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, handleActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, handleDeactivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}
		}
		
		protected function handleKeys(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.BACK){
				exitTriggered();
			}
		}
		
		protected function handleDeactivate(event:flash.events.Event):void {
			exitTriggered();
		}
		
		protected function handleActivate(event:flash.events.Event):void {
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		protected function addedToStageHandler(event:starling.events.Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			
			
			this.theme = new MetalWorksMobileTheme(this.stage);
			assetManager = new AssetManager();
			assetManager.enqueue(EmbeddedAssets);
			assetManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1.0){
					startGame();
				}
			});
		}
		
		private function startGame():void 
		{
			
			CootieCrush.splashBitmap.parent.removeChild(CootieCrush.splashBitmap);
			CootieCrush.splashBitmap = null;
			
			selectSound = assets.getSound("select");
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen("Game Screen", new ScreenNavigatorItem(GameScreen));
			this._navigator.addScreen("Start Screen", new ScreenNavigatorItem(StartScreen));
			this._navigator.addScreen("Over Screen", new ScreenNavigatorItem(OverScreen));
			this._navigator.addScreen("About Screen", new ScreenNavigatorItem(AboutScreen));
			
			this._navigator.showScreen("Start Screen");
		}
		
		public function gameTriggered():void 
		{
			selectSound.play(0,1);
			this._navigator.showScreen("Game Screen");
		}
		
		public function startTriggered():void 
		{
			selectSound.play(0,1);
			this._navigator.showScreen("Start Screen");
		}
		
		public function overTriggered():void 
		{
			selectSound.play(0,1);
			this._navigator.showScreen("Over Screen");
		}
		
		public function aboutTriggered():void 
		{
			selectSound.play(0,1);
			this._navigator.showScreen("About Screen");
		}
		
		public function exitTriggered():void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
		public static function get assets():AssetManager { return assetManager; }
		
	}
}