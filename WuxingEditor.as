package {
	import com.model.LoadProxy;
	
	import editor.WuxingWorldEditorPanel;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	 
	[SWF(width="960", height="640", frameRate="30", backgroundColor="0x000000")]
	public class WuxingEditor extends MovieClip {
		private var loadProxy:LoadProxy = LoadProxy.getInstance();
		
		public function WuxingEditor() {
			var gamedomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var lc:LoaderContext = new LoaderContext(false, gamedomain);
			lc.allowCodeImport=true;
			BaseInfo.isLoadConfig = false;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, initGame);
			loader.load(new URLRequest("editor.swf"), lc); 
		}
		
		private function initGame(e:Event):void {
			addChild(new WuxingWorldEditorPanel);
		}
		
	}
}
