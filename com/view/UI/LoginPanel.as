package com.view.UI {
	import com.model.ApplicationFacade;
	import com.conn.MainNC;
	import com.model.event.EventCenter;
	import com.model.vo.GameSO;
	import com.model.vo.WebParams;
	import com.model.vo.conn.login.LoginReturnVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.utils.TextFactory;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	
//	import so.cuo.platform.wechat.WeChat;

	
	/**
	 * 登录面板 
	 * 1.帐号密码登录；
	 * 2.设备码登录：帐号、密码、昵称都是设备码，对照昵称如果是设备码那么展示空，给玩家修改昵称的按钮
	 * 3.新浪微博登录：帐号为uid，密码为token，昵称为玩家新浪昵称
	 * 4.qq登录：帐号为QQ号，密码为token，昵称为玩家QQ昵称
	 * @author hunterxie
	 */
	public class LoginPanel extends BasePanel{
		public static const SINGLETON_MSG:String="single_LoginPanel_only";
		protected static var instance:LoginPanel;
		public static function getInstance():LoginPanel{
			if ( instance == null ) instance=new LoginPanel();
			return instance as LoginPanel;
		}
		
		public var inputAccount:String = "";
		public var inputPWD:String = "";
		public var inputNickname:String = "";
		private function setInputInfo():void{
			inputAccount = mc_account.tf_input.text;
			inputPWD = mc_pwd.tf_input.text;
			inputNickname = mc_nickName.tf_input.text;
			if(inputNickname=="输入昵称" || inputNickname=="") inputNickname = inputAccount;
		}
		
		public var mc_account:MovieClip;
		public var mc_pwd:MovieClip;
		public var mc_pwdConfirm:MovieClip;
		public var mc_nickName:MovieClip;
		
		public var btn_login:SimpleButton;
		public var btn_test_login:MovieClip;
		public var mc_regist:MovieClip;
		public var mc_changeLogin:MovieClip;
		public var mc_sina:MovieClip;
		public var btn_wechat:MovieClip;
		public var btn_wequan:MovieClip;
		
		public var mc_registConfirm:MovieClip;
		public var mc_goLogin:MovieClip;
		
		public var gameSO:GameSO = GameSO.getInstance();
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		private function get mainNC():MainNC{
			return MainNC.getInstance();
		}
		
//		private var loader:URLLoader = new URLLoader();
		private var isRegist:Boolean = false;
		
		
//		private var webView:StageWebView = new StageWebView;
//		private var myWeiboInfo:WeiboInfo = WeiboInfo.getInstance();
		
		/**
		 * 登录面板
		 */
		public function LoginPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			TextFactory.addDefaultShowInfo(mc_account.tf_input, "<font color='#959595'>输入邮箱地址</font>", "输入邮箱地址");
//			TextFactroy.addDefaultShowInfo(mc_pwd.tf_input, "<font color='#959595'>输入密码</font>", "输入密码");
//			TextFactroy.addDefaultShowInfo(mc_pwdConfirm.tf_input, "<font color='#959595'>输入密码</font>", "输入密码");
			TextFactory.addDefaultShowInfo(mc_nickName.tf_input, "<font color='#959595'>输入昵称</font>", "输入昵称");
			
			mc_pwd.visible = false;
			mc_account.visible = false;
			mc_pwdConfirm.visible = false;
			mc_nickName.visible = false;
			btn_login.addEventListener(MouseEvent.CLICK, onLogin);
			
			btn_test_login.tf_name.text="本地登录";
			btn_test_login.addEventListener(MouseEvent.CLICK, onTestLogin); 
			
			mc_registConfirm.tf_name.text="注  册";
			mc_registConfirm.visible = false;
			mc_registConfirm.addEventListener(MouseEvent.CLICK, onRegist);
			
			mc_goLogin.tf_name.text="登  录";
			mc_goLogin.visible = false;
			mc_goLogin.addEventListener(MouseEvent.CLICK, onLoginShow);
			
			mc_regist.tf_name.text="创建帐号";
			mc_regist.addEventListener(MouseEvent.CLICK, onRegistShow);
			
			mc_changeLogin.tf_name.text="切换帐号";
			mc_changeLogin.addEventListener(MouseEvent.CLICK, onLoginShow);
			
//			mc_sina.addEventListener(MouseEvent.CLICK, onSinaLogin);
//			btn_wechat.addEventListener(MouseEvent.CLICK, onShareWechat);
//			btn_wequan.addEventListener(MouseEvent.CLICK, onShareWequan);
			
			if(gameSO.lastLoginUser){
				mc_account.tf_input.text = gameSO.lastLoginUser;//userInfo.userName;
				mc_pwd.tf_input.text = gameSO.lastLoginPass;//userInfo.userPwd;
			}
			
//			loader.addEventListener(Event.COMPLETE, onRecive);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
//				trace(e);
//			});
		}
		
		protected function onTestLogin(event:*):void{
			BaseInfo.isTestLogin = true;
			setInputInfo();
			onLogin();
		}		
		
		/**
		 * 点击登录按钮
		 * @param e
		 */
		private function onLogin(e:*=null):void{
			if(e && mc_account.tf_input.text=="输入邮箱地址" || mc_account.tf_input.text==""){
				//todo 请输入正确的帐号
				TipVO.showTipPanel(new TipVO("注册提示","请输入正确的邮箱地址"));
				return;
			}
			
			if(gameSO.loadUserJudge && userInfo.userName==mc_account.tf_input.text){
//				event("start_old");
			}else if(!gameSO.getShareObject(mc_account.tf_input.text)){
				userInfo.userName = mc_account.tf_input.text;
				userInfo.userPwd = mc_pwd.tf_input.text;
				userInfo.userID = Math.floor(Math.random()*9999999);
				userInfo.nickName = inputNickname;
				gameSO.writInfo();
//				event("start_new");
			}
			
			if(BaseInfo.isTestLogin){
				EventCenter.event(ApplicationFacade.CONNECT_SUCCESS);
			}else{
				isRegist = false;
				setInputInfo();
				MainNC.httpConn(BaseInfo.getUrl(BaseInfo.loginURL), {type:"L", username:inputAccount, password:inputPWD}, onRecive, "正在登陆......");
			}
			
		}
		
		/**
		 * 展示注册面板
		 * @param e
		 */
		private function onRegistShow(e:*):void{
			mc_pwd.visible = true;
//			mc_pwd.tf_input.text="";
			mc_pwdConfirm.visible = true;
			mc_nickName.visible = true;
//			mc_pwdConfirm.tf_input.text="";
			
			mc_registConfirm.visible = true;
			mc_goLogin.visible = true;
			btn_login.visible = false;
			mc_regist.visible = false;
		}
		
		/**
		 * 展示登录面板
		 * @param e
		 */
		private function onLoginShow(e:*=null):void{
			mc_pwdConfirm.visible = false;
			mc_nickName.visible = false;
			
			mc_registConfirm.visible = false;
			mc_goLogin.visible = false;
			btn_login.visible = true;
			mc_regist.visible = true;
			mc_pwd.visible = true;
			mc_account.visible = true;
		}
		
		/**
		 * 点击注册按钮
		 * @param e
		 */
		private function onRegist(e:*):void{
			if(mc_pwd.tf_input.text != mc_pwdConfirm.tf_input.text){
				return;
			}
			isRegist = true;
			setInputInfo();
			MainNC.httpConn(BaseInfo.getUrl(BaseInfo.registURL), {type:"C", username:inputAccount, password:inputPWD, sex:1, nickname:mc_nickName.tf_input.text, logincode:BaseInfo.UDID}, onRecive, "正在注册......");
//			conn(BaseInfo.mainURL+BaseInfo.registURL+"?LoginType="+BaseInfo.LoginType);
		}
		
		
		/**
		 * 检查登录状态，如果有UDID或者微博token或者qzone信息就自动登录；
		 * 调用时机：片头动画完毕后
		 * PlatformType:0默认，1新浪，2腾讯
		 */
		public function checkLogin():void{
//			if(!sUI) sUI = new SocialUI(SocialServiceType.SINAWEIBO);
//			if(!wx) wx = WeChat.getInstance();
//			wx.registerApp("wxda6209fcfe99fa88");
//			if(myWeiboInfo.isLogin){
//				inputAccount = myWeiboInfo.uid;
//				inputPWD = myWeiboInfo.access_token;
//				MainNC.httpConn(BaseInfo.getUrl(BaseInfo.sinaLoginURL), {PlatformType:PlatformType_weibo, code:myWeiboInfo.access_token}, onRecive);
//			}else if(BaseInfo.UDID!=""){
//				isRegist = false;
//				inputAccount = BaseInfo.UDID;
//				inputPWD = BaseInfo.UDID;
//				MainNC.httpConn(BaseInfo.getUrl(BaseInfo.loginURL), {logincode:BaseInfo.UDID}, onRecive);
//			}else{
			switch(BaseInfo.platform){
				case BaseInfo.PLATFORM_QZONE:
					this.visible = false;
					inputAccount = WebParams.openid;
					inputPWD = WebParams.openid;
					MainNC.httpConn(BaseInfo.getUrl(BaseInfo.LoginTM), {openid:WebParams.openid, openkey:WebParams.openkey, pf:WebParams.pf}, onQzoneRecive, "正在连接服务器......");
					break;
				default:
					onLoginShow();
			}
				
//			}
		}
		
		private function onQzoneRecive(e:Event):void {
			var info:Object = JSON.parse(String(e.target.data));
			EventCenter.traceInfo(info);
			MainNC.socketIP = info.ip;
			MainNC.socketPort = info.port;
			userInfo.userID = info.playerId;
			userInfo.userName = inputAccount;
			userInfo.nickName = inputNickname;
			userInfo.userPwd = inputPWD;
			gameSO.getShareObject(inputAccount);
			gameSO.writInfo();
			
			mainNC.connect("", "", WebParams.openid);
		}
		
		/**
		 * 登陆结果/注册结果
		 * @param e
		 */
		private function onRecive(e:Event):void {
			var vo:LoginReturnVO = new LoginReturnVO(isRegist, String(e.target.data));
			if(vo.isSuccess){
				isRegist = false;
				MainNC.socketIP = vo.socketIP;
				MainNC.socketPort = vo.socketPort;
				userInfo.userName = inputAccount;
				userInfo.userPwd = inputPWD;
				userInfo.userID = vo.userID;
				userInfo.nickName = inputNickname;
				gameSO.writInfo();
				
				mainNC.connect(inputAccount, inputPWD, BaseInfo.UDID);
			}
		}
		
		
//		//=======以下是相关分享========================================================
//		private var shareBMD:BitmapData;
//		private var wx:WeChat;
//		private var sUI:SocialUI;
//		private var gameURL:String = "https://itunes.apple.com/us/app/xiao-hei-kuai-pao/id830411351";
//		private var shareInfo:String = "这个游戏好好玩哦，快来超越我吧！";
//		/**
//		 * 新浪微博分享
//		 * @param e
//		 */
//		private function onShareWeibo(e:*=null):void{
//			sUI.setMessage(shareInfo);
//			sUI.addURL(gameURL);
//			sUI.addImage(shareBMD);
//			sUI.launch();
//		}
//		
//		/**
//		 * 微信朋友圈分享
//		 * @param e
//		 */
//		private function onShareWequan(e:*):void{
//			var url:String = saveScrean(MovieShow.getMovieBMD(this.parent));
//			EventCenter.traceInfo(String(wx.sendLinkMessage(url, gameURL, "游戏分享" ,shareInfo, WeChat.WXSceneTimeline)));
//		}
//		
//		/**
//		 * 微信分享
//		 * @param e
//		 */
//		private function onShareWechat(e:*):void{
//			var url:String = saveScrean(MovieShow.getMovieBMD(this.parent));
//			EventCenter.traceInfo(String(wx.sendLinkMessage(url, gameURL, "游戏分享", shareInfo, WeChat.WXSceneSession)));
//		}
//		
//		//=======以下是新浪微博登录========================================================
//		private var webViewBar:Sprite;
//		/**
//		 * 新浪微博登录
//		 * @param e
//		 */
//		private function onSinaLogin(e:*):void{
//			if(!myWeiboInfo.isLogin){
//				myWeiboInfo.login();
//				StageWebViewExample();
//			}else{
//				onShareWeibo();
//			}
//		}
//		
//		private function StageWebViewExample():void {
//			webView.stage = this.stage;
//			if(!webViewBar){
//				var point:Point = this.localToGlobal(new Point);
//				webViewBar = utils.getDefinitionByName("WebViewBar");
//				webViewBar.x = -point.x;
//				webViewBar.y = -point.y;
//				webViewBar["btn_back"].addEventListener(MouseEvent.CLICK, closeWebView);
//			}
//			addChild(webViewBar);
//			if(!webView.viewPort){
//				webView.viewPort = new Rectangle(0, webViewBar.height-1, stage.stageWidth, stage.stageHeight-webViewBar.height+1);
//			}
////			webView.loadURL("https://api.weibo.com/oauth2/authorize?client_id=1461125758&redirect_uri=http://www.lingyuyou.com&response_type=code&scope=all&display=default");
//			webView.loadURL("https://open.weibo.cn/oauth2/authorize?client_id=1461125758&redirect_uri=http://www.lingyuyou.com&response_type=code&scope=all&display=mobile");
//			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onChanging);
//		}
//		private function onChanging(e:LocationChangeEvent):void{
//			var str:String = unescape(e.location);
//			trace("onWebViewChanging:", str);
//			if(str.indexOf("http://www.lingyuyou.com/?code=")!=-1){
//				var code:String = str.replace("http://www.lingyuyou.com/?code=", "");
//				myWeiboInfo.code = code;
//				MainNC.httpConn("https://api.weibo.com/oauth2/access_token", myWeiboInfo.getTokenVar(code), onAuthorize);
//			}
//		}
//		
//		private function onAuthorize(e:Event):void{
//			var info:Object = JSON.parse(String(e.target.data));
//			myWeiboInfo.updateInfo(info);
//			inputAccount = myWeiboInfo.uid;
//			inputPWD = myWeiboInfo.access_token;
//			MainNC.httpConn(BaseInfo.getUrl(BaseInfo.sinaLoginURL), {PlatformType:PlatformType_weibo, uid:myWeiboInfo.uid, code:myWeiboInfo.access_token}, onRecive);
//			closeWebView();
//		}
//		
//		private function closeWebView(e:*=null):void{
//			webView.loadString("");
//			webView.stage = null;
//			webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onChanging);
//			if(webViewBar.parent){
//				webViewBar.parent.removeChild(webViewBar);
//			}
//		}
//		
//		
//		/**
//		 * 保存到路径
//		 * @param bmd
//		 * @return 
//		 */
//		public function saveScrean(bmd:BitmapData):String {
//			shareBMD = bmd;
//			var bytes:ByteArray = bmd.encode(bmd.rect, new PNGEncoderOptions());
//			var date:Number = (new Date).time;
//			var file:File = File.applicationStorageDirectory.resolvePath(date+"temp.png");
//			var st:FileStream = new FileStream();
//			st.open(file, FileMode.WRITE);
//			st.writeBytes(bytes);
//			st.close();
//			EventCenter.traceInfo("保存图片文件："+file.nativePath);
////			EventCenter.traceInfo(File.applicationDirectory);
//			return file.nativePath;
//		}
	}
}
