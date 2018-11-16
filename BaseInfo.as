package {
	import com.model.LoadProxy;
	import com.model.vo.config.board.BoardBaseVO;
	
	/**
	 * 配置信息，如果要本地测试qzone登录请修改_platform和mainIP
	 * @author hunterxie
	 */
	public class BaseInfo{
		public static var fullScreenWidth:int=960;
		public static var fullScreenHeight:int=640;
		public static function setFullScreen(width:int, height:int):void{
			if(width==2048 && height==1536){
				width=1024;
				height=768;
			}
			if(width<=1280 && width>=960 && height<=768 && height>=640){
				fullScreenWidth = width;
				fullScreenHeight = height;
			}
		}
		
		public static const PlatformType_default:String = "0";
		public static const PlatformType_weibo:String = "1";
		public static const PlatformType_wechat:String = "2";
		public static const PlatformType_qzone:String = "3";
		public static const PLATFORM_QZONE:String = "qzone";
		public static const PLATFORM_IOS:String = "ios";
		public static const PLATFORM_ANDROID:String = "android";
		
		public static const gameName:String = "WuxingWorld";
		public static const isLayaProject:Boolean = false;
		
		/**是否展示调试面板*/
		public static var isShowDebug:Boolean = true;
		/**是否展示所有菜单按钮*/
		public static var isShowMainBtns:Boolean = true;
		/**是否本地测试*/
		public static var isTestLogin:Boolean = false;
		/**是否展示引导任务*/
		public static var isTestGuide:Boolean = true;
		/**是否展示剧情任务*/
		public static var isTestPlot:Boolean = true;
		/**是否展示首次loading*/
		public static var isTestFirstLoading:Boolean = false;
		/**是否由前台提供随机种子进行测试*/
		public static var isTestRandom:Boolean = true;
		/**是否默认开启所有关卡，测试用*/
		public static var isOpenAllLevel:Boolean = true; 
		/**是否默认开启所有建筑，测试用*/
		public static var isOpenAllBuild:Boolean = false;
		/**请求后台信息时是否展示loading界面*/
		public static var isTestRequest:Boolean = true;
		/**是否加载外部配置文件，否则就从BaseInfo里读取*/
		public static var isLoadConfig:Boolean = false; 
		/**是否展示配置文件中的所有精灵*/
		public static var isTestShowAllFairy:Boolean = false;
		/**进行数据操作时(如五行加点)是否连续前台模拟后再合并发送给后台*/
		public static var iscontiuedSend:Boolean = true;
		
		/**展示匹配区域解谜成功后的动画时间*/
		public static var showFitMovieTime:Number = 2;
		
		/**可以参战的最大精灵数量*/
		public static var maxFairyNum:int = 3;
		
		/**一次闯关消耗的精力值*/
		public static const LEVEL_LIVE_USE:int = 5;
		
		/**单消得分（3消=4倍，4消8倍，5消16倍)*/
		public static var SINGLE_CLEAR_SCORE:int = 10;
		/**消除得分计算基数，N消就是基数的(N-1)次方*单消得分*/
		public static var CLEAR_MULTIPE_SCORE:Number = 1.73;
		
		/**复盘展示速度倍率 */
		public static var showActionBoardRunTimes:Number = 1;
		
		/**相同五行得分对基础攻击的加成倍率 */
		public static var baseAttackTimes:Number = 2;
		
		/**精灵模拟消除连击概率*/
		public static var AISequenceChance:Number = 0.5;

		/**属性克制系数*/
		public static const DAMEGE_FROME_KE_WO:Number = 1.2;
		/**属性被克制系数*/
		public static const DAMEGE_FROME_WO_KE:Number = 1;
		/**暴击加成系数*/
		public static const DAMEGE_FROME_CRIT:Number = 1.5;
		
		/**可配置的玩家技能总数(五行元素位每样一个）*/
		public static const TOTAL_USER_SKILL_NUM:Number = 5;
		
		/**棋盘上球占用的方形边长 */
		public static var boardWidth:int = 78;
		
		/**合成精灵需要的碎片数量*/
		public static const GEN_FAIRY_COST:int=20;
		
		/**精灵装备最多升级等级TODO:应该配置*/
		public static const EQUIP_UPGRADE_MAX:int = 9;
		
		
		
		/**
		 * 运行平台，qzone、IOS、android
		 */
		public static function get platform():String	{
			return _platform;
		}
		public static function set platform(value:String):void{
			_platform = value;
			if(_platform==PLATFORM_QZONE){
				isTestFirstLoading = false;//qzone为页游，会有前期进度条加载，所以隐藏了首次进度条
			}
		}
		private static var _platform:String = "0";//PLATFORM_QZONE;//
		
		/**登录类型(平台)*/
		public static var LoginType:int = 0;  
		public static var socketPort:int = 7001;
		public static var mainIP:String = "127.0.0.1:8080";//"203.195.187.240:9001";//
		public static var mainURL:String = "http://"+mainIP+"/Request/";
		public static const loginURL:String = "LoginInterior";//"Login";
		public static const registURL:String = "LoginInterior";//"CreateLogin";
		public static const friendURL:String = "GetFriend";
		public static const loadUserMail:String = "LoadUserMail";
		public static const sinaLoginURL:String = "VerificationOAuthLogin";
		/**
		 * qzone平台登录(后端判断创建角色)
		 * 请求参数:openid,openkey,pf
		 * 请求返回:ret,playerId,ip,port
		 */
		public static const LoginTM:String = "LoginTM";
		/**
		 * QQ互联授权登陆(游戏非QQ空间应用里)回调地址
		 * 首先参考:http://wiki.connect.qq.com/准备工作_oauth2-0
		 * 请求返回:ret,playerId,ip,port
		 */
		public static const LoginTokenTM:String = "LoginTokenTM";
		/**
		 * 账号密码登陆
		 * 请求参数:username,password,logincode   (logincode传 "")
   		 * 请求返回:ret,playerId,ip,port 
		 */
		public static const LoginInterior:String = "LoginInterior";
		/**
		 * 新浪微博授权登陆回调地址
		 * 参考:http://open.weibo.com/wiki/授权机制说明
   		 * 请求返回:ret,playerId,ip,port
		 */
		public static const LoginTokenSina:String = "LoginTokenSina";


		public static function getUrl(value:String):String{
			return mainURL+value+"?LoginType="+LoginType;
		}
		public static function get UDID():String{
			var str:String = "";
			try{
//				str = OpenUDID.UDID ? OpenUDID.UDID : "e6594f11abbc3672428e5468c02aa86c7210e1bb";
			}catch(e:*){
				str = "e6594f11abbc3672428e5468c02aa86c7210e1bb";
			}
			return str;
		}
		
		
		/**
		 * 玩家自创谜题信息
//		 */
//		private static var _puzzleEditorInfo:XML;
//		public static function getPuzzleEditorScale(lv:int):XMLList{
//			return puzzleEditorInfo.scale.(@playerLevel<=lv);
//		}
//		public static function getIsActiveMultipeSteps(lv:int):Boolean{
//			return (puzzleEditorInfo.multipleSteps[0].@unlockLevel<=lv);
//		}
//		public static function getEditorUnlockXMLByCuPuzzleID(cuPuzzleID:int):XML{
//			return puzzleEditorInfo.unlockLevel.(@cuPuzzleID==String(cuPuzzleID))[0];
//		}
//		public static function getPuzzleEditorDefaultLevel():XML{
//			return puzzleEditorInfo.defaultLevel[0].boardInfo[0];
//		}
//		//		public static function getEditorUnlockXMLByUpgradeID(upgradeID:int):XML{
//		//			return puzzleEditorInfo.unlockLevel.(@upgradeID==String(upgradeID))[0];
//		//		}
//		public static function getEditorTask(taskType:String):XML{
//			return puzzleEditorInfo.task.(@type==taskType)[0];
//		}
//		//*********************  以上内容由Jim添加  ********************	
		
		
		
//		private static var _wuxingLvInfo:XML;
//		private static var _wuxingLvInfoArr:Array;
//		public static function setWuxingLvInfo(info:XML):void{
//			_wuxingLvInfo = info;
//			_wuxingLvInfoArr = [];
//			for(var i:int=0; i<_wuxingLvInfo.wuxing.length(); i++){
//				var xml:XML = _wuxingLvInfo.wuxing[i][0];
//				_wuxingLvInfoArr[parseInt(xml.@lv)] = xml;
//			}
//		}
		
		
		/**
		 * 
		 * 
		 */
		public function BaseInfo() {
			
		}
		


		
		
		[Embed(source="../bin-debug/config/fairyInfo.json", mimeType="application/octet-stream")]       
		private static var fairyInfoClass:Class;
		public static function get fairyInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("fairyInfo.json")));
			}
			return JSON.parse(new fairyInfoClass);
		}
		
		[Embed(source="../bin-debug/config/skillInfo.json", mimeType="application/octet-stream")]       
		private static var skillInfoClass:Class;
		public static function get skillInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("skillInfo.json")));
			}
			return JSON.parse(new skillInfoClass);
		}
		
		[Embed(source="../bin-debug/config/LVsInfo.json", mimeType="application/octet-stream")]       
		private static var LVsInfo:Class;
		public static function get lvsInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("LVsInfo.json")));
			}
			return JSON.parse(new LVsInfo);
		}
		
		[Embed(source="../bin-debug/config/levelInfo.json", mimeType="application/octet-stream")]       
		private static var levelInfoClass:Class;
		public static function get levelInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("levelInfo.json")));
			}
			return JSON.parse(new levelInfoClass);
		}
		
		[Embed(source="../bin-debug/config/boardInfo.json", mimeType="application/octet-stream")]       
		private static var boardInfoClass:Class;
		public static function get boardInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("boardInfo.json")));
			}
			return JSON.parse(new boardInfoClass);
		}
		
		[Embed(source="../bin-debug/config/itemInfo.json", mimeType="application/octet-stream")]
		private static var itemInfoClass:Class;
		public static function get itemInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("itemInfo.json")));
			}
			return JSON.parse(new itemInfoClass);
		}
		
		[Embed(source="../bin-debug/config/achievementInfo.json", mimeType="application/octet-stream")]
		private static var achievementConfigVOClass:Class;
		public static function get achievementConfigVO():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("achievementInfo.json")));
			}
			return JSON.parse(new achievementConfigVOClass);
		}
		
		[Embed(source="../bin-debug/config/wuxingLvInfo.json", mimeType="application/octet-stream")]
		private static var wuxingLvInfoClass:Class; 
		public static function get wuxingLvInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("wuxingLvInfo.json")));
			}
			return JSON.parse(new wuxingLvInfoClass);
		}
		
		[Embed(source="../bin-debug/config/buyInfo.json", mimeType="application/octet-stream")]
		private static var buyInfoClass:Class;
		public static function get buyInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("buyInfo.json")));
			}
			return JSON.parse(new buyInfoClass);
		}
		
		[Embed(source="../bin-debug/config/guideInfo.json", mimeType="application/octet-stream")]
		private static var guideInfoClass:Class;
		public static function get guideInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("guideInfo.json")));
			}
			return JSON.parse(new guideInfoClass);
		}
		
		[Embed(source="../bin-debug/config/vipInfo.json", mimeType="application/octet-stream")]
		private static var vipInfoClass:Class;
		public static function get VIPInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("vipInfo.json")));
			}
			return JSON.parse(new vipInfoClass);
		}
		
		[Embed(source="../bin-debug/config/altarInfo.json", mimeType="application/octet-stream")]
		private static var AltarInfoClass:Class;
		public static function get altarInfo():Object{//祭坛抽宝箱配置
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("altarInfo.json")));
			}
			return JSON.parse(new AltarInfoClass);
		}
		
		[Embed(source="../bin-debug/config/PlunderConfig.json", mimeType="application/octet-stream")]
		private static var PlunderConfigClass:Class;
		public static function get plunderConfigInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("PlunderConfig.json")));
			}
			return JSON.parse(new PlunderConfigClass);
		}
		
		[Embed(source="../bin-debug/config/shopInfo.json", mimeType="application/octet-stream")]
		private static var shopInfoClass:Class;
		public static function get shopInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("shopInfo.json")));
			}
			return JSON.parse(new shopInfoClass);
		}
		
//		[Embed(source="../bin-debug/config/signReward.json", mimeType="application/octet-stream")]
//		private static var signRewardInfoClass:Class;
//		private static function get signRewardInfo():Object{
//			if(isLoadConfig){
//				return JSON.parse(String(LoadProxy.getLoadInfo("signReward.json")));
//			}
//			return JSON.parse(new signRewardInfoClass);
//		}
		
		[Embed(source="../bin-debug/config/playerEditConfig.json", mimeType="application/octet-stream")]
		private static var playerEditConfig:Class;
		public static function get playerEditConfigInfo():Object{
			if(isLoadConfig){
				return JSON.parse(String(LoadProxy.getLoadInfo("playerEditConfig.json")));
			}
			return JSON.parse(new playerEditConfig);
		}
		
	}
}