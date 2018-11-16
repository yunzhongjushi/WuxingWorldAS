package com.model.vo.user {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.TaskLogic;
	import com.model.vo.BaseObjectVO;
	import com.model.vo.GameSO;
	import com.model.vo.SettingVO;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.lvs.LVCheckVO;
	import com.model.vo.config.lvs.LVsConfig;
	import com.model.vo.conn.player.TotalInfoReturnVO;
	import com.model.vo.editor.EditListVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.guide.ElementActiveVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.level.LevelChooseEnterVO;
	import com.model.vo.level.LevelListVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.task.taskListVO;
	import com.model.vo.tip.TipVO;
	import com.utils.TimerFactory;
	import com.view.UI.tip.TipNotEnoughResourceVO;

	/**
	 * 用户总信息
	 * @author hunterxie
	 */
	public class UserVO extends BaseObjectVO{
		public static const NAME:String = "UserVO";
		public static const SINGLETON_MSG:String = "single_UserVO_only";
		protected static var instance:UserVO;
		public static function getInstance():UserVO{
			if ( instance == null ) instance = new UserVO();
			return instance;
		}
		
		
		public static const UPDATE_USER_INFO:String = "UPDATE_USER_INFO";
		public static const USER_ENERGY_MAX:int = 480;
		/**
		 * 精力增长频率
		 */
		public static const USER_ENERGY_UPDATE_TIME:int = 5*60*1000;


		
		public static function saveToSO(e:ObjectEvent=null):void{
			GameSO.save();
		}
		/**
		 * 激活所有五行模块（变为1级）
		 */
		public static function testActivation(kind:int=5):void{
			if(kind<5){
				if(instance.wuxingInfo.getWuxingProperty(kind)==0){
					instance.wuxingInfo.setProperty(kind, 1);
				}
			}else{
				for(var i:int=0; i<5; i++){
					if(instance.wuxingInfo.getWuxingProperty(i)==0){
						instance.wuxingInfo.setProperty(i, 1);
					}
				}
			}
		}
		
		
		
		public static function testAddExp(value:int):void{
			instance.EXP_cu += value;
			instance.dispatchUpdate();
		}
		public static function testAddGold(value:int):Boolean{
			if(instance.gold+value<0){//判断是否有足够钻石
				TipVO.showChoosePanel(new TipVO("您的钻石不足", "您的钻石不足，请去商城购买！", TipNotEnoughResourceVO.NOT_ENOUGH_GOLD));
				return false;
			}
			instance.gold += value;
			instance.dispatchUpdate();
			return true;
		}
		public static function testAddEnergy(value:int):void{
			instance.energy += value;
			instance.dispatchUpdate();
		}
		public static function testAddResource(kind:int, value:int):Boolean{
			var result:int = instance.wuxingInfo.addResource(kind, value);
			instance.dispatchUpdate();
			return true;//result>0;
		}
		/**
		 * 前端模拟充值信息
		 * @param value	当次充值的钻石数量
		 */
		public static function testBuyGold(value:int):void{
			if(value<0) return;
			
			instance.totalCharge += value;
			testAddGold(value);
		}
		
		/**
		 * 后台信息
		 */ 
		//		public var serverUserInfo:Object;
		
		public function UserVO():void {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			wuxingInfo = new WuxingVO();//, true);
			wuxingInfo.on(WuxingVO.WUXING_RESOURCE_UPDATE, this, saveToSO);
			
			EventCenter.on(ApplicationFacade.GUIDE_ELEMENT_ACTIVATING, this, onGuideActivating);
			EventCenter.on(ApplicationFacade.WORLD_MAP_LEVEL_CHOOSE, this, levelChoosed);
		}
		
		private function levelChoosed(e:ObjectEvent):void{
			this.chooseLevel = (e.data as LevelVO).id;
		}
		
		private function onGuideActivating(e:ObjectEvent):void{
			wuxingInfo.setProperty((e.data as ElementActiveVO).wuxing, 1);
		}
		
		/**
		 * 成就和任务的数据
		 */		
		public var achAndTaskData:TaskLogic = TaskLogic.getInstance();
		
		/**
		 * 可分配属性点/潜能
		 */
		public var allPoint:int;
		/**
		 * 生日
		 */
		public var birthday:String="";
		
		/**
		 * 用户buff信息
		 * 用户buff,结构和buff接口的一样    $user['info']['buff_list']
		 */
		public var buffInfo:Array;
		
		/**
		 * 五座挑战塔闯关数，0为未开启
		 */
		public var challenges:Array = [0,0,0,0,0];
		public var chooseLevel:int;
		
		/**
		 * 玩家自创关卡的谜题棋盘ID
		 * 
		 */
		public var editorDefencePuzzleID:int = -1;
		
		/**
		 * 玩家自创关卡的本地保存（未经测试）
		 * @see com.model.vo.fairy.BaseFairyVO
		 */
		public var editorLocalPuzzles:Array = [];
		
		/**
		 * 玩家自创关卡的本地保存（测试过可用于对战）
		 * {puzzleID:1,xmlInfo:xml,isLock:true}
		 * @see com.model.vo.fairy.BaseFairyVO
		 */
		public var editorSavePuzzles:Array = [];
		
		
		/**
		 * 精灵数据
		 */
		public var fairyInfo:FairyListVO = FairyListVO.getInstance();
		/**
		 * 开启的作战精灵槽位
		 */
		public var fairyOpenNum:int=1;
		
		/**
		 * 闯关信息
		 */
		public var levelInfo:LevelListVO = LevelListVO.getInstance();
		
		/**
		 * 角色物品列表
		 */
		public var itemInfo:ItemListVO = ItemListVO.getInstance();
		
		/**
		 * 玩家自创关卡
		 */
		public var editInfo:EditListVO = EditListVO.getInstance();
		
		/**
		 * 新手引导提示完成记录
		 */
		public var guides:Array = [];
		//==================================================================================================
		/**荣誉*/
		public var honor:int;
		/**是否首次登录，用于展示片头动画*/
		public var isFirstLogin:Boolean = true;
		
		
		/**
		 * 上次登录时间
		 */
		public var lastLoginTime:Number;
		
		public var levelChoiceVO:LevelChooseEnterVO = new LevelChooseEnterVO();
		
		
		/**竞技场排名*/
//		public var listsRank:int;
		/**声望排名*/
//		public var reputeRank:int;
		/**联盟/家族详细信息*/
//		private var leagueInfo:LeagueVO;
		
		/**当天已经购买的精力的次数*/
		public var energyBuyTime:int = 0;
		/**新信件状态*/
		public var messageStage:Boolean;
		
		/**玩家已经充值过的RMB*/
		public var payedMoney:int;
		
		/**记录的玩家对引导提示的选择，如“是否熟悉三消游戏”、“是否喜欢战斗”*/
//		public var guideAskChoice:Array = [];
		
		/**
		 * 玩家激活的面板，展示按钮，可以点击
		 */
		public var openPanelBtns:Object = {"ItemPanel":1, "FairyPanel":1};
		
		/**
		 * 玩家设置面板设置信息
		 */
		public var settingInfo:SettingVO = SettingVO.getInstance();
		
		//===========================================================================================================
		
		
		/**
		 * 已经开启的五行模块
		 */
		public var openWuxing:Array = [];
		
		/**
		 * 已分配属性点
		 */
		public var pointArr:Array=[];
		
		/**声望*/
		public var repute:int;
		/**性别*/
		public var sex:String="";
		
		/**
		 * 当前开启的技能槽位
		 */
		public var skillOpenNum:int = 1;
		
		/**
		 * 玩家技能
		 */
		public var skillInfo:SkillListVO = SkillListVO.getInstance();
		
		/**
		 * 玩家成就
		 */
		public var achievementInfo:taskListVO = taskListVO.getInstance();
			
		
		/**
		 * 状态 0:离线 1:在线
		 */
		public var state:int;
		
		/**
		 * 称号/头衔
		 */
		public var title:String="";
		
		/**
		 * 总战斗力数值(防守队伍)
		 */
		public var fightPower:int=0;
		
		/**
		 * 玩家充值的总数
		 */
		public var totalCharge:int = 0;
		
		/**
		 * 防沉迷剩余时间
		 */
		public var antiAddictionTime:int;
		
		/**
		 * 用户ID
		 */
		public var userID:int = 10001;
		/**用户名*/
		public var userName:String="";
		/**用户密码*/
		public var userPwd:String="";
		
		/**形象URL*/
		public function get visualURL():String{
			return _visualURL;
		}
		public function set visualURL(value:String):void{
			if(!(value==null || value=="null")){
				_visualURL = value;
			}
		}
		private var _visualURL:String = "木鹿head";
		
		/**
		 * 五行数值
		 */
		public var wuxingInfo:WuxingVO;
		
		/**
		 * 经验
		 */
		public function get EXP_cu():Number{
			return _EXP_cu;
		}
		public function set EXP_cu(value:Number):void{
			var vo:LVCheckVO = LVsConfig.checkLvInfo(value, "playerExp");
			_EXP_cu = vo.cu;
			this.LV = vo.LV;
			this.EXP_last = vo.last;
			this.EXP_max = vo.max;
		}
		private var _EXP_cu:Number;
		/**
		 * 最高经验（升级所需经验）
		 */
		public function get EXP_max():Number{
			return _EXP_max;
		}
		public function set EXP_max(value:Number):void{
			_EXP_max = value;
		}
		private var _EXP_max:Number;
		/**
		 * 等级
		 */
		public function get LV():int{
			return _LV;
		}
		public function set LV(value:int):void{
			_LV = value;
			allPoint = (LV-1)*4-wuxingInfo.allAddProperty;
		}
		private var _LV:int=1;
		
		/**
		 * 钻石
		 */
		public function get gold():int{
			return _gold;
		}
		public function set gold(value:int):void{
			_gold = value;
			instance.dispatchUpdate();
		}
		private var _gold:int;
		
		/** 精力*/
		public function get energy():int{
			return _energy;
		}
		public function set energy(value:int):void{
			_energy = value;
			TimerFactory.loop(USER_ENERGY_UPDATE_TIME, this, onEnergyTimer);
			dispatchUpdate();
		}
		private var _energy:int = USER_ENERGY_MAX;
		/** 精力增长速度 */
		public var growthEnergy:Number;
		
		/**昵称*/
		public function get nickName():String{
			return _nickName;
		}
		public function set nickName(value:String):void{
			_nickName = value;
		}
		private var _nickName:String="";
		
		
		
		/**
		 * 上一级目标经验值
		 */
		public var EXP_last:Number;
		
		
		//=======================================================================================================
		
		
		public function dispatchUpdate():void{
			event(UPDATE_USER_INFO);
		}
		
		/**
		 * 精灵最大等级(不超过角色等级)
		 */
		public function get fairyMaxLV():int{
			return this.LV;
		}
		public function getGuide(id:int):int{
			return guides[id];
		}
		public function getOpenBtn(name:String):int{
			if(BaseInfo.isShowMainBtns) return 1;
			if(!openPanelBtns.hasOwnProperty(name)){
				openPanelBtns[name] = 0;
			}
			return openPanelBtns[name];
		}
		/**
		 * 获取玩家五行等级
		 * @return 
		 */
		public function getWuxingLV(wuxing:int):int{
			return wuxingInfo.getWuxingProperty(wuxing);
		}
		
		public function guideOver(id:int):void{
			guides[id] = guides[id]+1;
		}
		//===============================================================================================
		
		
		/**
		 * 最大精力
		 */
		public function get energy_max():int{
			return LV+USER_ENERGY_MAX;
		}
		public function setOpenBtn(name:String):void{
			openPanelBtns[name] = 1;
		}
		
		public function showLastLoginTime():void{
			var date:Date = new Date(lastLoginTime);
			trace("上次登录时间:"+date.fullYear+"年"+date.month+"月"+date.date+"日"+date.hours+"时"+date.minutes+"分"+date.seconds+"秒");
		}
		
		/**
		 * 本次提升的等级
		 * @param num
		 */
		public function testLVUPAddEnergy(num:int):void{
			this.energy += this.LV*num+5;
		}
		/**
		 * 模拟闯关减少精力值
		 * @param num		需要扣除的关卡精力点
		 * @param isStart	是否进入关卡，进入关卡扣1点，关卡成功扣剩下的
		 * @return 
		 */
		public function testReleaseEnergy(num:int, isStart:Boolean):Boolean{
			if(this.energy>=num || (!isStart && this.energy>=(num-1))){
				this.energy -= isStart ? 1 : (num-1);
				EventCenter.event(ApplicationFacade.UPDATE_USER_INFO);
				return true;
			}
			TipVO.showChoosePanel(new TipVO("精力不足", "你的精力不足，请去商城购买", TipNotEnoughResourceVO.NOT_ENOUGH_ENERGY));
			return false
		}
		
		/**
		 * 更新从服务器收到的角色信息
		 * @param info
		 */
		public function updateBySocketInfo(info:TotalInfoReturnVO):void{
			this.updateObj(info.serverInfo);
			for(var i:int=0; i<WuxingVO.wuxingNum; i++){
				this.wuxingInfo.setProperty(i, info.wuxingPropertyArr[i]);
				this.wuxingInfo.setResource(i, info.wuxingResourceArr[i]);
			}
//			this.levelInfo.updateLevels(info.levels);
//			this.userID = info.userID;
//			this.nickName = info.nickName;
//			this.EXP_cu = info.EXP_cu;
//			this.energy = info.energy;
//			this.gold = info.Money;//info.gold;
//			this.sex = String(info.sex);//sex:false
//			this.allPoint = info.GainElement;
//			this.title = info.CurTitle;
//			this.repute = info.Renown;
//			this.birthday = String(info.Birthday);
//			this.antiAddictionTime = info.AntiAddictionTime;
//			this.payedMoney = info.Money; 
//			this.LV = info.grade;
//			this.visualURL = (info.UserImage==null || info.UserImage=="null") ? "木鹿head" : info.UserImage;
//			this.state = info.state;
//			this.fightPower = info.fightPower;
//			this.lastLoginTime = Number(info.LastLoginTime);
//			var time:Date = new Date(lastLoginTime);//	<Thu Jan 1 00:00:00 GMT+0800 1970> (@8fbba61)
			
			wuxingInfo.increaseStart();//更新后执行一次资源模拟增长，并且计时开始
			dispatchUpdate();
		}
		
		override public function updateObj(info:Object):void{
//			TextFactory.outputFile(JSON.stringify(info), "userVO.json");//导出存储的数据
			super.updateObj(info);
			var nowDate:Date = new Date;
//			var date:Date = new Date(lastLoginTime);
//			trace("上次登录时间:"+date.fullYear+"年"+date.month+"月"+date.date+"日"+date.hours+"时"+date.minutes+"分"+date.seconds+"秒");
//			if(date.fullYear<nowDate.fullYear || date.month<nowDate.month || date.date<nowDate.date || date.hours<nowDate.hours){
//				initNewDay();
//			}
			wuxingInfo.increaseStart();//更新后执行一次资源模拟增长，并且计时开始
			lastLoginTime = nowDate.time;
//			skillInfo.updateBySO([new BaseSkillVO(33,3), new BaseSkillVO(2,1), new BaseSkillVO(41,1)]);//模拟几个技能
			saveToSO();
		}
		
		/**
		 * 新的一天该刷新的数据（后台执行） 
		 */
		private function initNewDay():void{
//			this.energy = this.energy_max;
			this.antiAddictionTime = 3600*4;
		}
		
		private function onEnergyTimer(e:*):void{
			if(_energy<energy_max){
				this.energy+=1;
			}
		}
	}
}