package {
	import com.model.LoadProxy;
	import com.model.event.SourceLoadEvent;
	import com.model.vo.SourceLoaderVO;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.guide.ElementActiveVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.skill.UserSkillVO;
	import com.view.UI.animation.WuxingFragmentActivating;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.UI.fairy.FairyBarSmall;
	import com.view.UI.fairy.FairySkillBar;
	import com.view.UI.item.ItemBarMiddle;
	
	import flas.geom.Point;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[SWF(width="960", height="640", frameRate="30", backgroundColor="0x000000")]
	
	public class WuxingWorld extends WuxingWorldBase {
//		[Embed(source="../bin-debug/ddp.swf")]
//		private var MainClass:Class; 
		
//		[Embed(source="../bin-debug/puzzleEditorPanel.swf")]
//		private var PanelsClass:Class;
		
//		public static const SINGLETON_MSG:String="single_WuxingWorld_only";
//		protected static var instance:WuxingWorld;
//		public static function getInstance():WuxingWorld{
//			if ( instance == null ) instance=new WuxingWorld();
//			return instance as WuxingWorld;
//		}
		
		
		public function WuxingWorld():void {
//			if (instance != null) throw Error(SINGLETON_MSG);  
//			instance = this; 
			  
//			Security.allowDomain("*");
//			var xml:XML;
//			xml.appendChild();
			loadSource(true); 
		}
		override public function init(e:*=null):void{
//			var cbp:ChessboardPanel = new ChessboardPanel;
//			cbp.startNewGame();
//			this.addChild(cbp);
			super.init(); 
			
			return;
			var skill:FairySkillBar = new FairySkillBar;
			skill.updateInfo(new UserSkillVO(1,2),null);
			addChild(skill);
			trace("技能宽高：", skill.width, skill.height);
			
			var fairy:FairyBarSmall = new FairyBarSmall;
			fairy.x = 100;
			fairy.updateInfo(new BaseFairyVO(33222, 3));
			addChild(fairy); 
			trace("精灵宽高：", fairy.width, fairy.height);
			 
			var item:ItemBarMiddle = new ItemBarMiddle;
			item.x = 200;
			item.updateInfo(new ItemVO(1030, 3, Math.floor(Math.random()*99999))); 
			addChild(item);
			trace("物品宽高：", item.width, item.height);
		} 
	
		
		private var loadProxy:LoadProxy = LoadProxy.getInstance();  
//		private var loader:Loader=new Loader();
		private function loadSource(judge:Boolean):void { 
			var gamedomain : ApplicationDomain = ApplicationDomain.currentDomain;
			var lc:LoaderContext = new LoaderContext(false, gamedomain);
			lc.allowCodeImport=true;
			 
			loadProxy.addLoadInfo(new SourceLoaderVO("ddp.swf", SourceLoaderVO.SWF, "ddp.swf", false, lc));
			loadProxy.addLoadInfo(new SourceLoaderVO("img.swf", SourceLoaderVO.SWF, "img.swf", false, lc));
			loadProxy.addLoadInfo(new SourceLoaderVO("bigFairy.swf", SourceLoaderVO.SWF, "bigFairy.swf", false, lc));
//			loadProxy.addLoadInfo(new SourceLoaderVO("config.swf", SourceLoaderVO.ZIP, "config.swf", false, lc));
			loadProxy.addLoadInfo(new SourceLoaderVO("puzzleEditorPanel.swf", SourceLoaderVO.SWF, "puzzleEditorPanel.swf", false, lc));
			loadProxy.addEventListener(SourceLoadEvent.ALL_LOAD_COMPLETE, init);
//			if(judge){
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, init, false, 0, true);
//			}
//			loader.load(new URLRequest("ddp.swf"), lc);
//			loadurl("MailPanel.swf", lc);
			
//			loadswf((new PanelsClass).movieClipData, lc);
//			loadswf((new FriendPanelClass).movieClipData, lc); 
			  
			
//			loader.loadBytes((new MainClass).movieClipData, lc);
		}
		
		private function test(e:*=null):void{
			var fragment:WuxingFragmentActivating = WuxingFragmentActivating.getInstance();
			addChild(fragment);
			var vo:ElementActiveVO = ElementActiveVO.getInstance();
			vo.wuxing = 0;
			vo.point = new Point(50,50);
			vo.tarPoint = new Point(150,150);
			vo.event(ElementActiveVO.SHOW_ELEMENT_ACTIVE);
		}
		
	}
}

