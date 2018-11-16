package com.view.UI.loot{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.altar.FairyTemplateVO;
	import com.model.vo.conn.ServerVO_193;
	import com.model.vo.conn.ServerVO_32;
	import com.model.vo.friend.FriendVO;
	import com.model.vo.loot.LootOpponentVO;
	import com.model.vo.loot.LootVO;
	import com.model.vo.tip.LoadingVO;
	import com.model.vo.tip.TipVO;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.events.Event;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class LootPanel extends BasePanel{
		public static const NAME:String="LootPanel";
		public static function getShowName(vo:FriendVO):String{
//			update
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_LootPanel_only";
		private static var instance:LootPanel;
		public static function getInstance():LootPanel{
			if ( instance == null ) instance=new LootPanel();
			return instance as LootPanel;
		}
		
		
		public function LootPanel() {
			if (instance != null) throw Error(SINGLETON_MSG); 
			instance = this;
			init();
		}
		
		
		
		
		public var lootMainPanel:LootMainPanel;
		public var lootProtectorPanel:LootProtectorPanel
		public var lootOpponentPanel:LootOpponentPanel
		public var lootTopPanel:LootTopPanel
		public var lootSummonPanel:LootSummonPanel
		public var lootGuardInfoPanel:LootGuardInfoPanel
		
		public var isLoad:Boolean=false;
		
		private var running_changeSite:String;
		private var running_setFairyVO:FairyTemplateVO;
		private var running_lootVO:LootVO;
		
		
		private var serverVO_32:ServerVO_32;
		
		
		
		/**
		 * 
		 * 
		 */
		private function init():void{
			lootOpponentPanel.close();
			lootTopPanel.close();
			lootSummonPanel.close();
			lootGuardInfoPanel.close();
			
			lootMainPanel.addEventListener(LootMainPanel.E_TOP,onTop);
			
			lootProtectorPanel.addEventListener(LootProtectorPanel.E_CHANGE,onChange);
			lootProtectorPanel.addEventListener(LootProtectorPanel.E_FEED,onFeed);
			
			lootSummonPanel.addEventListener(LootSummonPanel.E_SUMMON,onSummon);
			
			this.addEventListener(Event.ENTER_FRAME,handle_MainUpdate);
			updateFnArr.push(lootOpponentPanel.update);
			this.addEventListener(MouseEvent.CLICK, onTopPlayer);
			
			
			serverVO_32 = ServerVO_32.getInstance();
			serverVO_32.on(ApplicationFacade.SERVER_INFO_OBJ, this, onServ32);
			
		}
			
		private function onServ32(e:ObjectEvent):void{
			if(ServerVO_32.GET_LOOT_INFO==serverVO_32.getCode()) {
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LootPanel.NAME);//收到数据，打开面板
				updateInfo(serverVO_32.getLootVO());
				LoadingVO.showLoadingInfo(NAME+"GET_INFO", false);
			}
			if(ServerVO_32.GET_MATCH_INFO==serverVO_32.getCode()) {
				updateOppo(serverVO_32.getOppoVO());
			}
			if(ServerVO_32.GET_LOOT_END_INFO==serverVO_32.getCode()) {
			}
			if(ServerVO_32.GET_GUARD_LIST==serverVO_32.getCode()) {
				updateGuardList(serverVO_32.getGuardList());
			}
			if(ServerVO_32.SET_GUARD==serverVO_32.getCode()) {
				updateSetGuard();
			}
		}
		public function onTopPlayer(e:*):void{
			if(e.target is LootTopBar){
				var bar:LootTopBar = e.target as LootTopBar
				var vo:FriendVO = bar.running_vo as FriendVO;
				
				updateGuardInfoPanel(getFakeOppoVO());
			}
		}
		private var updateFnArr:Array=[];
		private function handle_MainUpdate(e:Event):void{
			for(var i:int=0;i<updateFnArr.length;i++){
				updateFnArr[i].call(); 
			}
		}
		
		public function onChange(e:ObjectEvent):void{
			var changeSite:String =e.data as String;
			running_changeSite=changeSite;
			if(running_changeSite==LootVO.POS_1){
				ServerVO_193.getSendGetGuardList();
			}
			
		}
		
		public function onSummon(e:ObjectEvent):void{
			running_setFairyVO = e.data as FairyTemplateVO;
			if(running_changeSite==LootVO.POS_1){
				ServerVO_193.getSendSetGuard(running_setFairyVO);
			}else if(running_changeSite==LootVO.POS_2){
				ServerVO_193.getSendSetGuard(null, running_setFairyVO, running_lootVO.getFairyVO(LootVO.POS_3));
			}else if(running_changeSite==LootVO.POS_3){
				ServerVO_193.getSendSetGuard(null, running_lootVO.getFairyVO(LootVO.POS_2), running_setFairyVO);
			}
		}
		public function onFeed(e:ObjectEvent):void{
			var lootVO:LootVO=e.data as LootVO
			var date:Date=new Date();
			date.hours+=8;
			lootVO.setFeedTime(date);
			lootProtectorPanel.updateInfo(lootVO);
		}
		
		public function onTop(e:ObjectEvent):void{
			addChild(lootTopPanel);
			lootTopPanel.updateInfo(running_lootVO,getFakerPlayerVOList());
		}
		//回调函数
		//外调函数
		public function open():void{
			//点击打开条件下
			//
			if(!isLoad){
				ServerVO_193.getSendGetLootInfo();
			}else{
			}
		}
		public function updateInfo(lootVO:LootVO):void{
			//					isLoad=true;
			running_lootVO = lootVO; 
			this.addChild(lootMainPanel);
			this.addChild(lootProtectorPanel);
			lootMainPanel.updateInfo(running_lootVO);
			lootProtectorPanel.updateInfo(running_lootVO);
		}
		/**
		 * 收到打开防守阵容的请求，只打开防守阵容信息面板 
		 * @param oppoVO
		 * 
		 */				
		public function updateGuardInfoPanel(oppoVO:LootOpponentVO):void{
			addChild(lootGuardInfoPanel);
			lootGuardInfoPanel.updateInfo(oppoVO);
		}
		//loot guard info panel
		public function updateOppo(oppoVO:LootOpponentVO):void{ 
			addChild(lootOpponentPanel);
			lootOpponentPanel.updateInfo(oppoVO,running_lootVO);
		}
		public function updateGuardList(voList:Array):void{
			addChild(lootSummonPanel);
			lootSummonPanel.updateInfo(voList);
		}
		public function updateSetGuard():void{
			running_lootVO.setFairyVO(running_setFairyVO,running_changeSite);
			lootProtectorPanel.updateInfo(running_lootVO);
		}
		public function getFakeLootVO():LootVO{
			var f1:FairyTemplateVO = FairyTemplateVO.genProtectorFairyVO(2,9.98)
			var f2:FairyTemplateVO = new FairyTemplateVO(3,88,-1)
			var f3:FairyTemplateVO = new FairyTemplateVO(6,88,-1)
			var date1:Date=new Date(2014,4,31,18,0);
			var date2:Date=new Date(2014,4,31,18,0);
			var oppoVO:LootOpponentVO = new LootOpponentVO(-1,"哆啦A梦",[100,200,300,400,500],1500,2,3,6);
			var lootVO:LootVO = new LootVO(998,3,date1,date2,date2,2,3,6);
			return lootVO;
		}
		public function getFakeOppoVO():LootOpponentVO{
			var f1:FairyTemplateVO = FairyTemplateVO.genProtectorFairyVO(2,9.98)
			var f2:FairyTemplateVO = new FairyTemplateVO(3,88,-1)
			var f3:FairyTemplateVO = new FairyTemplateVO(6,88,-1)
			var date1:Date=new Date(2014,4,31,18,0);
			var date2:Date=new Date(2014,4,31,18,0);
			var oppoVO:LootOpponentVO = new LootOpponentVO(-1,"哆啦A梦",[100,200,300,400,500],1500,2,3,6);
			var lootVO:LootVO = new LootVO(998,3,date1,date2,date2,2,3,6);
			return oppoVO;
		}
		public function getFakerPlayerVOList():Array{
			var newArr:Array=[];
			for(var i:int = 0;i<10;i++){
				var playerVO:FriendVO = FriendVO.genTopPlayer("机器人_"+(i+1),i,i*-1+100,i*-10+3000,i+1);
				newArr.push(playerVO);
			}
			return newArr;
		}
	}
}
