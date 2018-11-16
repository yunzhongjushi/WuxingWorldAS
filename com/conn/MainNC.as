package com.conn{
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.conn.BaseAskVO;
	import com.model.vo.conn.level.LevelListReturnVO;
	import com.model.vo.conn.login.LoginAskVO;
	import com.model.vo.conn.player.TotalInfoReturnVO;
	import com.model.vo.tip.LoadingVO;
	import com.model.vo.tip.TipVO;
	
	import flas.events.Event;
	import flas.events.EventDispatcher;
	import flas.net.Socket;
	import flas.net.URLLoader;
	import flas.net.URLRequest;
	import flas.net.URLRequestMethod;
	import flas.net.URLVariables;
	import flas.utils.ByteArray;
	import flas.utils.utils;
	
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	

	/**
	 * 通用连接类，HTTP/TCP
	 * @author hunterxie
	 */
	public class MainNC extends EventDispatcher{
		public static const SINGLETON_MSG:String="single_MainNC_only";
		protected static var instance:MainNC;
		public static function getInstance():MainNC{
			if ( instance == null ) instance=new MainNC();
			return instance;
		}
		
		public static var socketIP:String = "192.168.1.168";//BaseInfo.mainIP;//
		public static var socketPort:int = 7001;//BaseInfo.socketPort;
		
		public static const CONN_SUCCESS:String="connSuccess";
		public static const CONN_INFO:String="connInfo";
//		public static const CONN_CLOSED:String="connClosed";
		public static const CONN_FAILED:String="connFailed";
		
		/**
		 * 重新连接指令
		 */
		public static const CONN_RECONN:String="CONN_RECONN";
		
		
		//TCP================================================================================
		private static var _nc:Socket = new Socket();

		/**
		 * 重连次数，为0后提示掉线
		 */
		private var reConnNum:int = 3;
		
		
		/**
		 * socket 连接
		 * @param url
		 * @param userName
		 * @param userPwd
		 * @param t
		 */
		public function MainNC():void{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			_nc.addEventListener(Event.CLOSE, closeHandler);
			_nc.addEventListener(Event.CONNECT, connectHandler);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_nc.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler_AMF3);
			
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, onTipChooseReconn);
		}
		private function onTipChooseReconn(e:ObjectEvent):void{
			var vo:TipVO = e.data as TipVO;
			if(vo && vo.key==CONN_RECONN)
				reconn();
		};
		
		/**
		 * 创建socket连接
		 * @param un
		 * @param pwd
		 * @param logincode
		 */
		public function connect(un:String, pwd:String, logincode:String=""):void{
			this.username = un;
			this.password = pwd;
			this.logincode = logincode;
			_nc.connect(socketIP, socketPort);
			
			LoadingVO.showLoadingInfo(LoadingVO.connect_socket, true, LoadingVO.connect_socket);
		}
		
		/**
		 * 掉线(3秒)重连，一般为提示用户XX秒后重连<br>
		 * 不过量大会造成服务器负担（本来就是有问题连不上时）
		 * @param e
		 */
		private function timerConnFunc(e:*=null):void{
			
		}
		
		
		private function closeHandler(event:*):void {
			EventCenter.traceInfo("连接关闭");
//			_nc.connect(socketIP, socketPort);
			loginSuccess = false;
			TipVO.showChoosePanel(new TipVO("断开连接", "您已经断开连接，请重新连接!", MainNC.CONN_RECONN));
			
//			TimerFactory.once(3000, this, timerConnFunc);
		}
		private function connectHandler(event:*):void {
			EventCenter.traceInfo("连接成功");
//			loginSuccess = true;
			reConnNum = 3;
			sendInfo1(new LoginAskVO(username, password));//socket连接成功后进行socket登录获取用户信息
//			EventCenter.event(MainNC.CONN_SUCCESS);
			LoadingVO.closeLoadingInfo(LoadingVO.connect_socket);
			LoadingVO.showLoadingInfo(LoadingVO.login_socket, true, LoadingVO.login_socket);
//			if(isLocalHttpLogin){
//				sendInfo1(new LoginAskVO(username, password, logincode));
//				sendInfo(1, {username:username, password:password, logincode:logincode, openid:WebParams.openid, openkey:WebParams.openkey, pf:WebParams.pf});
//			}
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			EventCenter.traceInfo("ioErrorHandler信息： "+event); 
			if(--reConnNum<=0){
				TipVO.showChoosePanel(new TipVO("连接错误", "连接错误，请重新连接!", MainNC.CONN_RECONN));
			}else{
				_nc.connect(socketIP, socketPort);
			}
			LoadingVO.closeLoadingInfo(LoadingVO.connect_socket);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			EventCenter.traceInfo("securityErrorHandler信息: "+event);
			LoadingVO.closeLoadingInfo(LoadingVO.connect_socket);
		}
		
		
		/**
		 * 获取的用于拼接的数据，拼包
		 */
		private var receveBTA:ByteArray = new ByteArray;
		/**
		 * 拼接完当前协议后剩余的数据，分包
		 */
		private var remaining:ByteArray;
		/**
		 * 当前接受的协议长度
		 */
		private var receveLength:int=0;
		/**
		 * 接收server过来的数据
		 * @param event
		 */
		private function dataHandler_AMF3(event:ProgressEvent):void {
			EventCenter.traceInfo("接收到数据段,加载长度:"+event.bytesLoaded+"======有效长度: "+_nc.bytesAvailable);
			var bta:ByteArray=new ByteArray  ;
			_nc.readBytes(bta);
			excuteReceveInfo(bta);
		}
		/**
		 * 拼包+分包
		 */
		private function excuteReceveInfo(bta:ByteArray):void{
			var bta1:ByteArray = new ByteArray;//临时存储的协议信息
			if(receveLength>receveBTA.length){//如果有长度就说明上一个包没接收完，需要拼包
				var n:int = receveLength-receveBTA.length;
				if(n<bta.length){
					receveBTA.writeBytes(bta, 0, n);
					readReceveInfo(receveBTA);
					bta1.writeBytes(bta, n, bta.length-n);//分包
					excuteReceveInfo(bta1);
				}else{
					receveBTA.writeBytes(bta, 0, bta.length);//拼包
					if(n==bta.length){
						readReceveInfo(receveBTA);
						return;
					}
				}
			}else{
				bta.position = 2;
				var len:int = bta.readShort();
				if(len>bta.length){
					receveLength = len;
					receveBTA = new ByteArray;
					receveBTA.writeBytes(bta);
				}else if(len<bta.length){
					var bta2:ByteArray = new ByteArray;
					bta2.writeBytes(bta, 0, len);//分包
					readReceveInfo(bta2);
					bta1.writeBytes(bta, len, bta.length-len);//分包
					excuteReceveInfo(bta1);
				}else{
					readReceveInfo(bta);
				}
			}
		}
		
		/**
		 * 处理一个收到的完整协议
		 * @param bta
		 */
		private function readReceveInfo(bta:ByteArray):void{
//			bta.position = 0;
//			if(bta.readShort()!=0x71ab){//合法性校验
//				throw Error("服务器数据不合法！！！！！");
//			}
			
			var obj:Object = {};
			bta.position = 2;
			var len:int = bta.readShort();
			bta.position = 6;
			var cmd:int = bta.readShort();
			EventCenter.traceInfo("接收到协议,长度:"+len+"__cmd&code1:0x"+cmd.toString(16)+":"+cmd);
			bta.position=20;
			if(bta.length>20){
				try{
					//解压=====================================================
//						var amfBta:ByteArray = new ByteArray  ;
//						amfBta.writeBytes(info1, 20, bta.length-20);
//						amfBta.uncompress();
//						obj = amfBta.readObject();
					//解压=====================================================
//					obj = bta.readObject();
					obj = JSON.parse(bta.readUTF());
				}catch(e:ReferenceError){
					throw Error("服务器数据格式解析出错——没有按照AMF格式封装");
				}
			}else{
				throw Error("服务器数据格式解析出错——协议长度小于包头20");
			}
			if(obj==null){
				throw Error("服务器数据格式解析出错——没有按照AMF格式封装");
			}
			obj.serverCMD = cmd;
			
			try{
				var cls:Class = utils.getDefinitionByName("com.model.vo.conn.ServerVO_"+cmd) as Class;
				if(cls){
					(cls.getInstance() as BaseConnProxy).updateObj(obj);
				}
//				execute();
			}catch(err:ReferenceError){
				throw Error("找不到对应的一级协议的CLASS:ServerVO_"+cmd);
			}
			LoadingVO.closeLoadingInfo(cmd+"_"+obj.code);//TODO:这里有问题，过来的协议号跟请求协议号不一定相同
		}
		
//		override public function execute(obj:Object):void{
//			if(obj is TotalInfoReturnVO){
//				userInfo.updateBySocketInfo(obj as TotalInfoReturnVO);
//				if(!loginSuccess){//第一次收到用户信息更新为成功登录，获取其他信息;TODO:为什么要多次请求呢？
//					onLoginSuccess();
//					EventCenter.event(ApplicationFacade.CONNECT_SUCCESS);
//					
////					LevelListReturnVO.sendInfo();
////					ServerVO_107.sendInfo();
//					ServerVO_68.get_fairys();
////					ServerVO_199.first_get_info(userInfo.userID);
//				} 
//			}else if(obj is LevelListReturnVO){
//				LevelListVO.updateServerList(obj as LevelListReturnVO);
//			}
//			return;
//			switch(obj.serverCMD){
//				case MainNC.SYS_NOTICE:
//					break;
////				case MainNC.UPDATE_PlAYER_INFO:
////					userInfo.updateBySocketInfo(obj as PlayerInfoReturnVO);
////					EventCenter.event(ApplicationFacade.UPDATE_USER_INFO);
////					if(!MainNC.loginSuccess){
////						MainNC.loginSuccess = true;
////						EventCenter.event(ApplicationFacade.CONNECT_SUCCESS);
////						LoadingVO.showLoadingInfo("login_socket", false);
////						
////						ServerVO_138.sendInfo();
////						ServerVO_107.sendInfo();
////						ServerVO_68.get_fairys();
////						ServerVO_199.first_get_info(userInfo.userID);
////					} 
////					break;
//				case MainNC.GAME_CMD:
//					switch(obj.code){
//						case ServerVO_91.FIGHT_CREATE:
//							EventCenter.traceInfo("房间创建成功！进入房间, ID:"+obj.players.UserId0+":"+obj.players.UserId1);
//							break;
//						case ServerVO_91.FIGHT_MOVE:
//							FightActionVO.show(obj.fairyID, obj.tarFairyID, obj.actions);
//							break;
//						case ServerVO_91.FIGHT_START:
//							var levelVO:LevelVO = LevelListVO.updateServerGame(obj);
//							if(obj.lastGameInfo){//如果携带了此信息说明上一场游戏未正常结束
//								EventCenter.event(ApplicationFacade.SHOW_FIGHT_RESULT, obj.lastGameInfo);
//							}
//							
//							if(obj.gameType==ServerVO_91.FIGHT_TYPE_PUZZLE){
//								LevelGameLogic.newVO(levelVO);
//								EventCenter.event(ApplicationFacade.SHOW_PANEL, , PuzzlePanel.NAME);
//							}else if(obj.gameType==ServerVO_91.FIGHT_TYPE_PVP || obj.gameType==ServerVO_91.FIGHT_TYPE_PVE){
//								var info:ServerGameStartVO = new ServerGameStartVO(obj);
//								var fightInfo:FightGameLogic = FightGameLogic.newVO(levelVO, info);//LevelVO.getLevelVO(LevelVO.LEVEL_KIND_UNIVERSAL, 3, 0, true)
//								EventCenter.event(ApplicationFacade.SHOW_PANEL, FightPanel.NAME);
//							}
//							break;
//						case ServerVO_91.FIGHT_OVER:
//							EventCenter.event(ApplicationFacade.SHOW_FIGHT_RESULT, obj);
//							break;
//						case ServerVO_91.FIGHT_RESET:
//							trace("棋子信息出错!!!");
//							break;
//						case ServerVO_91.FIGHT_ERROR:
//							trace("游戏出错:"+obj.error);
//							break;
//						case ServerVO_91.FIGHT_FAIL:
//							trace("闯关失败!!!");
//							break;
//					}
//					break;
//			}
//		}
		
		public static function closeLodingPanel(key:String):void{
			LoadingVO.closeLoadingInfo(key);
		}
		
		/**
		 * 临时存储的对应协议的loading信息，用于收到消息后关闭对应的loading界面
		 */
//		private var loadingInfoArr:Object = {};
		
		public function sendInfo1(info:BaseAskVO):Boolean {
			if(BaseInfo.isTestLogin || !_nc.connected){
//				TipPanel.showPanel("网络异常","网络未连接！");
				return false;
			}else if(info.loadingInfo!=""){
				LoadingVO.showLoadingInfo(info.cmd+"_"+info.code, true, info.loadingInfo);
			}
			
			var bta:ByteArray=new ByteArray  ;
			bta.writeShort(0x71ab);//分隔符
			bta.writeShort(0);//包长
			bta.writeShort(0);//校验和
			bta.writeShort(info.cmd);//协议号
			for (var i:int=8; i<20; i++) {//补满20位
				bta.writeByte(0);
			}
			bta.writeUTF(info.getJson());
			bta.position=2;
			bta.writeShort(bta.length);//补写包长 
			bta.position=4;
			bta.writeShort(getinfo(bta));//校验和
			bta.position=0;
			_nc.writeBytes(bta);
			EventCenter.traceInfo("发送数据,长度:"+_nc.bytesPending+"____info:"+info.description);
			_nc.flush(); 
			
			return true;
		}
		public function sendInfo(cmd:int, info:Object, loaderInfo:String=""):Boolean {
			if(BaseInfo.isTestLogin || !_nc.connected){
//				TipPanel.showPanel("网络异常","网络未连接！");
				return false;
			}else if(loaderInfo!=""){}

			var bta:ByteArray=new ByteArray  ;
			bta.writeShort(0x71ab);//分隔符
			bta.writeShort(0);//包长
			bta.writeShort(0);//校验和
			bta.writeShort(cmd);//协议号
			for (var i:int=8; i<20; i++) {//补满20位
				bta.writeByte(0);
			}
			
			bta.writeObject(info);//写入
			bta.position=2;
			bta.writeShort(bta.length);//补写包长 
			bta.position=4;
			bta.writeShort(getinfo(bta));//校验和
			bta.position=0;
			_nc.writeBytes(bta);
			EventCenter.traceInfo("发送数据,长度:"+_nc.bytesPending+"____code1:"+cmd+"____code2:"+info.code);
			_nc.flush(); 
			
			return true;
		}
		
		/**
		 * 校验和
		 * @param bta
		 * @return 
		 */
		private function getinfo(bta:ByteArray):int{
			var val:int = 0x77;
			var i:int = 6;
			var size:int = bta.length; 
			while (i < size){
				val += (bta[i++] & 0xFF);
			}
			return Math.floor(val & 0x7F7F);
		}
		
		public function closeSocket():void{
			if(_nc){
				_nc.close();
			}
		}
		
		public static function reconn():void{
			if(_nc){
				if(_nc.connected) _nc.close();
				_nc.connect(socketIP, socketPort);
			}
		}
		
		
		
		
		//HTTP================================================================================		
		public var username:String = "";
		public var password:String = "";
		public var logincode:String = "";
		/**
		 * 是否自动登录socket
		 */
		public var isLocalHttpLogin:Boolean = false;
		
		/**
		 * 是否登录成功，首次登录
		 */
		public static var loginSuccess:Boolean = false;
		public static function onLoginSuccess():void{
			loginSuccess = true;
			LoadingVO.closeLoadingInfo(LoadingVO.login_socket);
		}
		
		/**
		 * http连接
		 * @param url
		 * @param obj
		 * @param receive	返回函数
		 * @param loaderInfo进度条展示
		 * @return 
		 */
		public static function httpConn(url:String, obj:Object, receive:Function=null, loadingInfo:String=""):URLLoader{
			var dbVar:URLVariables = new URLVariables();
			for (var i:Object in obj) {
				dbVar[i]=obj[i];
			}
			var dbReq:URLRequest = new URLRequest(url);
			dbReq.method = URLRequestMethod.POST;
			dbReq.data = dbVar;
			
			var dbLoader:URLLoader=new URLLoader();
			//			dbLoader.dataFormat=URLLoaderDataFormat.VARIABLES;
			
			dbLoader.load(dbReq.info);
			dbLoader.addEventListener(Event.COMPLETE, receiveHanler);
			function receiveHanler(event:*):void{
				LoadingVO.showLoadingInfo(loadingInfo, false, loadingInfo);
				dbLoader.removeEventListener(Event.COMPLETE, receiveHanler);
				dbLoader=null;
			}
			dbLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			function ioErrorHandler(event:IOErrorEvent):void {
//				TipPanel.showPanel("网络错误", "网络错误，请刷新浏览器！ " + event);
				dbLoader.removeEventListener(Event.COMPLETE, receiveHanler);
				dbLoader=null;
			}
			if(receive!=null){
				dbLoader.addEventListener(Event.COMPLETE, receive, false, 0, true);
			}
			if(loadingInfo!=""){
				LoadingVO.showLoadingInfo(loadingInfo, true, loadingInfo);
			}
			return dbLoader;
		}
		
		
		
		
		
		
		
		
		//======协议相关=====================================================
		private static function setServerInfo(cmd:int, info:Object):Object{
			switch(cmd){
				case UPDATE_PlAYER_INFO:
					return new TotalInfoReturnVO(info);
				case LevelListReturnVO.ID:
					return new LevelListReturnVO(info);
			}
			return {};
		}
		
		
		/**
		 * 请求服务器缓存的钻石
		 * 一级协议0x0b
		 其他信息不用
		 ---------------
		 返回协议:0x0b
		 Money:钻石数
		 */
		public static const USER_GOLD:int = 0x0b;
		/**
		 * SNS分享信息提示
		 */
		public static const SNS_NOTICE:int = 0x11;
		/**
		 * 系统公告
		 */
		public static const SYS_NOTICE:int = 0x0a;
		/**
		 * 版本错误
		 */
		public static const EDITION_ERROR:int = 0x0c;
		/**
		 * 日常奖励
		 */
		public static const DAILY_AWARD:int = 0x0d;
		/**
		 * 获得物品提示
		 */
		public static const GET_ITEM_MESS:int = 0x0e;
		/**
		 * 新手引导进度
		 */
		public static const USER_GUIDE_PROGRESS:int = 0x0f;
		/**
		 * 更改昵称
		 */
		public static const CHANGE_NICKNAME:int = 0x21;
		/**
		 * 人物改变状态
		 */
		public static const CHANGE_STATE:int = 0x20;
		/**
		 * 个人聊天
		 */
		public static const CHAT_PERSONAL:int = 0x25;
		/**
		 * 游戏(战斗)数据:91
		 */
		public static const GAME_CMD:int = 0x5b;
		/**
		 * 购买物品
		 */
		public static const BUY_ITEM:int = 0x2c;
		/**
		 * 赠送物品
		 */
		public static const GOODS_PRESENT:int = 0x39; 
		/**
		 * 物品强化
		 */
		public static const ITEM_STRENGTHEN:int = 0x3b;
		/**
		 * 改变装备
		 */
		public static const EQUIP_CHANGE:int = 0x42;
		/**
		 * 更新具体属性
		 */
		public static const UPDATE_PLAYER_PROPERTY:int = 0xa4;
		/**
		 * 邀请进入游戏
		 */
		public static const GAME_INVITE:int = 0x46;
		/**
		 * 小喇叭
		 */
		public static const S_BUGLE:int = 0x47;
		/**
		 * 大喇叭
		 */
		public static const B_BUGLE:int = 0x48;
		/**
		 * 跨区大喇叭
		 */
		public static const A_BIG_BUGLE:int = 0x49;
		/**
		 * 获取装备
		 */
		public static const ITEM_EQUIP:int = 0x4a;
		/**
		 * 物品比较
		 */
		public static const LINKREQUEST_GOODS:int = 0x77;
		/**
		 * 使用改名卡
		 */
		public static const NickName_Card:int = 0xab;
		/**
		 * 获取其他用户成就记录
		 */
		public static const USER_ACHIEVEMENT_DATA:int = 0xcb;
		/**
		 * 删除邮件
		 */
		public static const DELETE_MAIL:int = 0x70;
		/**
		 * 修改邮件的已读未读标志
		 */
		public static const UPDATE_MAIL:int = 0x72;
		/**
		 * 发送邮件
		 */
		public static const SEND_MAIL:int = 0x74;
		/**
		 * 邮件响应
		 */
		public static const MAIL_RESPONSE:int = 0x75;
		
		
		/**
		 * 任务同步
		 */
		public static const QUEST_UPDATE:int = 0xc7;
		/**
		 * 完成
		 */
		public static const QUEST_FINISH:int = 0xb3;
		/**
		 * 完成
		 */
		public static const ACHIEVEMENT_FINISH:int = 0xe6;
		/**
		 * 初始化成就记录
		 */
		public static const ACHIEVEMENTDATA_INIT:int = 0xe7;
		/**
		 * 更新BUFF
		 */
		public static const BUFF_UPDATE:int = 0xb9;
		/**
		 * 获取全部
		 */
		public static const BUFF_OBTAIN:int = 0xba;
		
		
		/**
		 * 验证码
		 */
		public static const CHECK_CODE:int = 0xc8;
		/**
		 * 获取防沉迷系统状态
		 */
		public static const AAS_STATE_GET:int = 0xe0;
		/**
		 * 设置防沉迷系统信息
		 */
		public static const AAS_INFO_SET:int = 0xe0;
		/**
		 * 身份证信息验证
		 */
		public static const AAS_IDNUM_CHECK:int = 0xe2;
		/**
		 * 防沉迷系统开关
		 */
		public static const AAS_CTRL:int = 0xe3;
		
		
		/**
		 * 进入房间
		 */
		public static const SPA_ROOM_LOGIN:int = 0xca;
		/**
		 * 管理消息
		 */
		public static const MANAGER_MSG:int = 0xFD;
		/**
		 * VIP更新
		 */
		public static const VIP_UPDATE:int = 0x5c;
		/**
		 * 物品排序
		 */
		public static const GETITEMORDER:int = 0xf5;
		
		
		
		/**
		 * 后台发送小窗口(直接转发)
		 */
		public static const GMTips:int = 0x63;
		/**
		 * 更新玩家信息
		 */
		public static const UPDATE_PlAYER_INFO:int = 0x43;
		/**
		 * 宠物一级协议
		 */
		public static const PET_SOCKET:int = 0x44;//68
		/**
		 * 关卡积分查询返回结果
		 */
		public static const ReLoadLevelListInfo:int = 0x8a;//138
		/**
		 * 通知客户端重现加载用户信息
		 */
		public static const ReLoadInfo:int = 0x8b;
		/**
		 * 发送对话弹框
		 */
		public static const SEND_DIALOG:int = 0x9c;
		/**
		 * 快捷购买活力值
		 */
		public static const BUY_ENERGY:int = 0xE1;
		/**
		 * 加载资源
		 */
		public static const LOAD_RESOURCE:int = 0xdf;
		
		
		
		
		//
		/**
		 * 登陆
		 */
		public static const CLIENT_LOGIN:int = 0x01;
		/**
		 * 消息
		 */
		public static const CLIENT_MSG:int = 0x02;
		/**
		 * 下线
		 */
		public static const CLIENT_OFFLINE:int = 0x03;
		/**
		 * 房间相关一级协议
		 */
		public static const CLIENT_GAME_ROOM:int = 0x04;
		
		/**
		 * 宠物一级协议
		 */
		public static const CLIENT_PET_SOCKET:int = 0x44;
		
		/**
		 * 游戏数据
		 */
		public static const CLIENT_GAME_CMD:int = 0x5b;
		
		/**
		 * 玩家属性点增加
		 */
		public static const CLIENT_ELEATTRADD:int = 0x5c;
		
		/**
		 * 更新玩家属性，请求获取玩家信息
		 */
		public static const CLIENT_UPDATEPLAYEINFO:int = 0x5d;
		
		
		/**
		 * 请求一级协议:0xc9(无二级协议)
		    请求参数:playerId(request登陆的时候会返回),nickname,sex(0或1),birthday,userimage
		    返回一级协议:0xc9(无二级协议)
		    返回参数:ret(ret为0表示注册成功 1表示通用错误 3表示昵称重复)
		 */
		public static const CLIENT_CREATE_USER:int = 0xc9;
		
		/**
		 * 添加玩家经验 测试用 非正式
		 */
		public static const CLIENT_PLAYER_GP_ADD:int = 0xff;
		
		
	}	
}