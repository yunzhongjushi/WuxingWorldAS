package com.model{
	
	public class ApplicationFacade{
//		public static const STARTUP:String="STARTUP";

		
		
//		public static function getInstance():ApplicationFacade{
//			if(instance==null) instance=new ApplicationFacade;
//			return instance as ApplicationFacade;
//		}
		
//		public function startup(app:Object):void{
//			sendNotification( STARTUP, app );
//		}
		
//		override protected function initializeController():void{
//			super.initializeController();
			
//			registerCommand(ApplicationFacade.STARTUP, StartupCommand);
//		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * 新的关卡战斗,玩家选择关卡开始事件
		 * @author xie
		 */
		public static const LEVEL_GAME_START:String = "LEVEL_GAME_START";
		
		/**
		 * 玩家选择世界地图上的关卡
		 */
		public static const WORLD_MAP_LEVEL_CHOOSE:String = "WORLD_MAP_LEVEL_CHOOSE";
		/**
		 * 玩家选择世界地图上的建筑物
		 */
		public static const WORLD_MAP_BUILD_CHOOSE:String = "WORLD_MAP_BUILD_CHOOSE";
		
		/**
		 * 
		 */
		public static const UPDATE_MAIN_INFO:String="updateMainInfo";
//		/**
//		 * 元件外面点击事件
//		 */
//		public static const ON_PRESS_OUTSIDE:String="onPressOutside";			
//		/**
//		 * 元件外面放开事件
//		 */
//		public static const ON_RELEASE_OUTSIDE:String="onReleaseOutside";
//		public static const INIT_LOAD:String="initLoad";							//初始化加载（获取用户形象、地图坐标、职业技能等信息后）
		/**
		 * 
		 */
		public static const TEST_INFO_SHOW:String="testInfoShow";
		
		/**
		 * 创建用户事件-弹出创建用户面板
		 */
		public static const CREATE_ROLE:String="createRole";
		
		/**
		 * 创建用户成功
		 */
		public static const CREATE_ROLE_SUCCESS:String="createRoleSuccess";
		
		/**
		 * 创建用户失败
		 */
		public static const CREATE_ROLE_FAIL:String="createRoleFail";
		
		/**
		 * 显示登录面板
		 */
		public static const SHOW_LOGIN_PANEL:String="SHOW_LOGIN_PANEL";
		
		/**
		 * 初始化游戏（用户登录成功，初始化地图、人物形象加载成功）
		 */
		public static const LOGIN_SUCCESS:String="LOGIN_SUCCESS";
		
		/**
		 * 建立后台连接
		 * @author xie
		 */
		public static const SOCKET_CONN:String="socketConn";
		
		/**
		 * 退出游戏指令（登录冲突或者变速齿轮判定结果）
		 */
		public static const OUT_THE_GAME:String="outTheGame";
		
		/**
		 * 显示/关闭面板
		 * @author xie
		 */
		public static const SHOW_PANEL:String="SHOW_PANEL";
		public static const SHOW_PANEL_SUCCESS:String="SHOW_PANEL_SUCCESS";
		public static const CLOSE_PANEL:String="CLOSE_PANEL";
		
		/**
		 * 用户选择了某个关卡，用于记录用户选择，下次登录时再次展示？
		 */
		public static const LEVEL_CHOOSED:String="LEVEL_CHOOSED";
		/**
		 * 收到解谜关结束信息
		 */
//		public static const PUZZLE_RESULT:String="PUZZLE_RESULT";
		/**
		 * 收到对战结束信息(server)
		 * @author xie
		 */
		public static const SHOW_FIGHT_RESULT:String="SHOW_FIGHT_RESULT";
		
		/**
		 * 关卡结束信息
		 */
		public static const ONE_LEVEL_RESULT:String="ONE_LEVEL_RESULT";
		
		/**
		 * 五行开启展示结束，需要实际开启了
		 * @see 五行(String)
		 */
		public static const FRAGMENT_ACTIVATING_OVER:String="FRAGMENT_ACTIVATING_OVER";
		
		
		/**
		 * 显示操作面板
		 * @author xie
		 */
		public static const SHOW_OPERATE_PANEL:String="showOperatePanel";
		
		/**
		 * 注册操作层面板（输入文本、升级控制、选择使用物品等）
		 * @author xie
		 */
		public static const REGISTER_OPERATE_PANEL:String="registerOperatePanel";
		
		/**
		 * 小红点提示事件
		 * @see com.model.vo.PanelPointShowVO
		 */
		public static const SHOW_PANEL_POINT_GUIDE:String="SHOW_PANEL_POINT_GUIDE";
		
		
		//=====================================================================================
		/**
		 * 购买请求指令
		 */
		public static const BUY_REQUEST:String="buyRequest";
		
		/**
		 * 系统加载信息进度
		 * @see com.view.UI.tip.LoadingVO
		 */
		public static const SYS_LOAD_PROCESS:String="sysLoadProcess";
				
		/**
		 * 连接SOCKET服务器成功
		 */
		public static const CONNECT_SUCCESS:String="CONNECT_SUCCESS";
		
		/**
		 * 收到从socket服务器过来的转化后的信息
		 * @ServerVO_1	根据一级协议打包好的数据
		 */
		public static const SERVER_INFO_OBJ:String="SERVER_INFO_OBJ";
		
		/**
		 * 显示新手指导面板
		 * @author xie
		 */
		public static const SHOW_GUIDE_MISSION_PANEL:String="showGuideMissionPanel";	
		
		/**
		 * 新提示信息
		 * @author xie
		 */
		public static const NEW_TIP_INFO:String="newTipInfo";	
		
		/**
		 * 清除提示信息
		 * @author xie
		 */
		public static const CLEAR_TIP_INFO:String="clearTipInfo";	
		
		/**
		 * 新操作面板信息
		 * @author xie
		 */
		public static const NEW_OPERATE_INFO:String="newOperateInfo";
		
		/**
		 * 清除操作面板信息
		 * @author xie
		 */
		public static const CLEAR_OPERATE_INFO:String="clearOperateInfo";
		
		
		/**
		 * 登出
		 * @author xie
		 */
		public static const LOGIN_OUT:String="loginOut";	
		
		/**
		 * 新建角色
		 * @author xie
		 */
		public static const CREATE_NEW_PLAYER:String="createNewPlayer";	
		
		/**
		 * 更新用户信息
		 * @author xie
		 */
		public static const UPDATE_USER_INFO:String="UPDATE_USER_INFO";
		
		/**
		 * 更新地图关卡信息
		 * @author xie
		 */
		public static const UPDATE_LEVEL_INFO:String="UPDATE_LEVEL_INFO";
		
		/**
		 * 更新用户精灵信息
		 * @author xie
		 */
//		public static const UPDATE_USER_FAIRY_INFO:String="UPDATE_USER_FAIRY_INFO";
		
		/**
		 * 更新战斗用户信息
		 * @author xie
		 */
		public static const UPDATE_FIGHT_USER_INFO:String="UPDATE_FIGHT_USER_INFO";
		
		/**
		 * 收到用户操作信息
		 * @author xie
		 */
		public static const SHOW_FIGHT_ACTION:String="SHOW_FIGHT_ACTION";
		
		
		/**
		 * 防沉迷事件
		 */
		public static const TOTAL_PLAY_TIME_JUDGE:String="totalPlayTimeJudge";	
		
		/**
		 * GM相关通知
		 */ 
		public static const GM_RESULT:String = "gm_result";
		
		/**
		 * 排行榜相关通知
		 */ 
		public static const RANK_RESULT:String = "rank_result";
		
		/**
		 * 物品信息加载完毕
		 */ 
		public static const GOODS_LOADED:String = "goods_loaded";
		
		/**
		 * 用户钻石更新事件
		 */ 
		public static const MONEY_UPDATE:String = "money_update";
			
		/**
		 * 战斗事件
		 */ 
		public static const BATTLE_RESULT:String = "battle_result";
		
		/**
		 * 潜能加点事件
		 */ 
		public static const POTENTIAL_POINTS:String = "potential_points";
		
		/**
		 * 任务事件通知
		 */ 
		public static const MISSION_EVENT:String = "mission_event";
		
		/**
		 * 道具使用事件
		 */ 
		public static const GOODS_USING_EVENT:String = "goods_using_event";
		
		/**
		 * 道具购买并使用事件
		 */ 
		public static const GOODS_BUY_USING_EVENT:String = "GOODS_BUY_USING_EVENT";
		
		/**
		 * BUFF事件
		 */ 
		public static const BUFF_LIST_UPDATE:String = "buff_event";
		
		
		public static const SHOW_TREASURE_BAG:String = "SHOW_TREASURE_BAG";
		
		public static const SHOW_TREASURE_BAG_AUTO:String = "SHOW_TREASURE_BAG_AUTO";
		
		
		/**
		 * 展示动画效果
		 * @see com.model.vo.animation.AnimationShowVO
		 */
		public static const SHOW_ANIMIATION:String = "SHOW_ANIMIATION";
		
		
		
		
		
		
		//========引导相关事件==============================================================================
		/**
		 * 引导关卡结束
		 * @see com.model.vo.fight.FightOverVO
		 * @author xie
		 */
		public static const GUIDE_MISSION_COMPLETE:String="GUIDE_MISSION_COMPLETE";
		/**
		 * 展示某个引导动画
		 */
		public static const GUIDE_MISSION_SHOW:String="GUIDE_MISSION_SHOW";
		/**
		 * 片头动画展示结束
		 */
		public static const GUIDE_CUTSCENE_MOVIE_SKIP:String="GUIDE_CUTSCENE_MOVIE_SKIP";
		/**
		 * 新手片头引导结束
		 */
		public static const GUIDE_NEW_SHOW_OVER:String="GUIDE_NEW_SHOW_OVER";
		/** 引导进入大地图 */
		public static const GUIDE_BIG_MAP_ENTER:String="GUIDE_BIG_MAP_ENTER";
		/** 捡到宝盒进入地图前 */
		public static const GUIDE_GET_WUXING_BOX:String="GUIDE_GET_WUXING_BOX";
		/** 展示激活动画 */
		public static const GUIDE_ELEMENT_ACTIVATING:String="GUIDE_ELEMENT_ACTIVATING";
		/**
		 * 精灵话框结束关闭（战斗继续），由用户点击操作触发
		 */
		public static const GUIDE_MISSION_CONVERSATION_COMPLETE:String="GUIDE_MISSION_CONVERSATION_COMPLETE";
		/**
		 * 引导对话框交互确认（关闭），由用户点击操作触发
		 */
		public static const GUIDE_MISSION_CONFIRM:String="GUIDE_MISSION_CONFIRM";
		/**
		 * 引导展示五行面板
		 */
		public static const GUIDE_WUXING_PANEL_SHOW:String = "GUIDE_WUXING_PANEL_SHOW";
		/**
		 * 首次引导展示五行面板动画结束（继续展示引导）
		 */
		public static const GUIDE_WUXING_PANEL_SHOW_OVER:String = "GUIDE_WUXING_PANEL_SHOW_OVER";
		
		
		
		//******************   以下由Jim添加   ******************
		/**
		 * 送体力事件
		 */ 
		public static const MAIL_SEND_ENERGY:String = "MAIL_SEND_ENERGY";
		/**
		 * 成就收到数据，更新任务
		 */		
		public static const ACHIEVEMENT_UPDATE_TASK:String = "ACHIEVEMENT_UPDATE_TASK";
		/**
		 * 好友->成就:获取好友成就的请求
		 */		
		public static const FRIEND_GET_ACHI_INFO:String = "FRIEND_GET_ACHI_INFO";
		/**
		 * 成就和任务显示小红点
		 */		
		public static const QUEST_INFO_UPDATE:String = "QUEST_SHOW_POINT";
		
		
		
	}
}