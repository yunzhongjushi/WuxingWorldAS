package com.view {
	import com.conn.MainNC;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.FightGameLogic;
	import com.model.vo.conn.ServerVO_91;
	import com.model.vo.tip.LoadingVO;
	import com.model.vo.tip.TipVO;
	import com.view.UI.chessboard.ChessboardPanel;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	
	import listLibs.Glog;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class DebugPanel extends BasePanel {
		private static const SINGLETON_MSG:String="single_DebugPanel_only";
		private static var instance:DebugPanel;
		public static function getInstance():DebugPanel{
			if ( instance == null ) instance=new DebugPanel();
			return instance;
		}
		
		public static var showInfoLength:int = 20000;
		public static var showInfo:String = "";
		
		/**
		 * 输出信息，不支持trace的带逗号信息
		 * @param arg
		 */
		public static function traceInfo(... arg):void {
			if(instance){
				showInfo+="\n"+String(arg);
				if(showInfo.length>showInfoLength){
					showInfo = showInfo.slice(showInfo.length-showInfoLength);
				}
//				instance.tf_debug.text = showInfo;//appendText();
			}
			trace(arg);
		}
		private function glogUpdate():void{
			
			tf_debug.htmlText = Glog.log;
			tf_debug.scrollV = int.MAX_VALUE
		}
		
		/**
		 * 展示调试面板，永远在最上层；
		 * 理论上系统中只允许调试面板拥有addChild到最上层的权利，其他面板都是在个子的层次内展示
		 */
		public static function show(stage:Stage):void{
			stage.addChild(instance);
		}
		
//==========================================================================================
		public var tf_debug:TextField;
		public var tf_input:TextField;
		public var tf_IP:TextField;
		public var btn_IP:MovieClip;
		public var btn_debug:MovieClip;
		public var btn_1:MovieClip;
		public var btn_2:MovieClip;
		public var btn_3:MovieClip;
		public var btn_4:MovieClip;
		public var btn_5:MovieClip;
		public var gmpanel:GMPanel;
		
//		private var nc:NetConnection=new NetConnection();
		private var myInfo:Object={
			userID:Math.floor(Math.random()*9999),
				userName:"玩家"+Math.floor(Math.random()*9999),
				view:"Role1",
				scene:"scene1",
				position:{x:1024, y:1024}
		};
		
		public function DebugPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = StageAlign.TOP_RIGHT;
			tf_debug.backgroundColor=0;
			tf_debug.textColor = 0xFFFFFF
			tf_input.text = "";
			tf_debug.visible = tf_input.visible = false;
			gmpanel.visible=false;
			
			tf_IP.text = BaseInfo.mainIP;
//			traceInfo("debugPanelInit");
			
//			nc.objectEncoding=flash.net.ObjectEncoding.AMF0;
//			nc.addEventListener(NetStatusEvent.NET_STATUS, Status);
//			nc.client=new Object();
			btn_debug.tf_name.text = "显示";
			btn_debug.addEventListener(MouseEvent.CLICK, tests);
			btn_IP.tf_name.text = "改IP";
			btn_IP.addEventListener(MouseEvent.CLICK, tests);
			btn_1.tf_name.text = "清除";
			btn_1.addEventListener(MouseEvent.CLICK, tests);
			btn_2.tf_name.text = "Profiler";
			btn_2.addEventListener(MouseEvent.CLICK, tests);
			btn_3.tf_name.text = "测试复盘"; 
			btn_3.addEventListener(MouseEvent.CLICK, tests);
			btn_4.tf_name.text = "测试接口";
			btn_4.addEventListener(MouseEvent.CLICK, tests);
			btn_5.tf_name.text = "GM";
			btn_5.addEventListener(MouseEvent.CLICK, tests);
			
//			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			EventCenter.getInstance().addEventListener(EventCenter.TRACE_INFO, infoTrace);
		}
		
//		private function onAddToStage(event:Event):void{
//				this.addEventListener(Event.ENTER_FRAME, onFrames);
//		}
		
		private function infoTrace(event:ObjectEvent):void{
			traceInfo(event.data);
		}
		
		private function tests(e:*=null):void{
			switch(e.target){
				case btn_debug:
					tf_debug.visible = tf_input.visible = !tf_debug.visible;
					tf_debug.htmlText = Glog.log;
					tf_debug.scrollV = int.MAX_VALUE
					
					Glog.onEnd = glogUpdate;
					break;
				case btn_IP:
					BaseInfo.mainIP = tf_IP.text;
					BaseInfo.mainURL = "http://"+BaseInfo.mainIP+"/Request/";
					break;
				case btn_1:
//					tf_debug.text=showInfo ="";
					
					instance.tf_debug.htmlText = Glog.o_log;
					instance.tf_debug.scrollV = int.MAX_VALUE
					break;
				case btn_2:
					if(stage){
						SWFProfiler.init(stage, this);
						SWFProfiler.onSelect();
					}
					break;
				case btn_3:
					var board:ChessboardPanel = ChessboardPanel.getInstance();
					var str:String = String(tf_input.text);
					if(board.parent && str) board.showTotalAction(str);
					break;
				case btn_4:
//					var itemInfo:AchievementInfo = AchievementInfo.getInstance();
//					itemInfo.updateByXML(BaseInfo.itemInfo);
//					var info:String = JSON.stringify(itemInfo);
//					TextFactory.outputFile(info, "achievementInfo.json");
//					BigMapS.testShowMoveToLevel(5);
					return;
					//=========================================================

					return;
//					var xml:XML = BaseInfo.getEquipInfo("0", 0, 5);
					var fightInfo:FightGameLogic = FightGameLogic.getInstance();
					MainNC.getInstance().sendInfo(MainNC.GAME_CMD,
						{
							code:ServerVO_91.FIGHT_MOVE, 
							gameType:ServerVO_91.FIGHT_TYPE_PVE,
							atId:fightInfo.attackUser.userID,
							deId:fightInfo.defendUser.userID,
							actions:String(tf_input.text),
							gameId:fightInfo.gameID,
							timeUse:120
						});
					TipVO.showChoosePanel(new TipVO("战  斗", "正在请求战斗结果......", "?!?!"));
//					LoadingVO.showLoadingInfo("LoadingVO", true, "LoadingVO");
//					PanelPointShowVO.showPointGuide(FairyPanel.NAME, true);
					
//					ServerVO_138.sendInfo();
					break;
				case btn_5:
					gmpanel.visible = !gmpanel.visible;
					break;
			}
		}
		
		private function testConnect(e:*):void {
			MainNC.httpConn("http://192.168.1.168:8080/Request/Login?LoginType=0", {username:"", password:"", logincode:"10086"});
			return;
			
//			nc.connect("rtmp://192.168.1.198/ddp", myInfo);
			traceInfo("\nstart_conn");
			LoadingVO.showLoadingInfo("debug_connect_socket", true, "正在连接服务器......");
		}
		
		private function Status(event:NetStatusEvent):void {
			traceInfo(event.info.code);
			if (event.info.code=="NetConnection.Connect.Success") {
				//initRole();
			}
			LoadingVO.closeLoadingInfo("debug_connect_socket");
		}
		
		/**
		 * 时刻保持在最上层
		 * @param e
		 */
		private function onFrames(e:*):void{
			if(this.stage && this.stage.getChildAt(this.stage.numChildren-1)!=this){
				trace(this.stage.numChildren-1,"时刻保持在最上层:this.stage.addChild(DebugPanel);")
				this.stage.addChild(this);
			}
		}
		
//		override private function close():void{
//			if(this.parent){
//				this.parent.removeChild(this);
//				this.removeEventListener(Event.ENTER_FRAME, onFrames);
//			}
//		}
		public static function sendTest(cmd:int,info:Object):void{
			for(var st:* in info){
				if(info[st] is String){
					var str:String = info[st];
					if(str.search("\r")!=-1){
						trace("警告:检验输入文本传递过来的变量是否含有'/r'字符");
					}
				}
			}
		}
	}
}