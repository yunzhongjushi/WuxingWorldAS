package editor{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.fairy.FairyConfig;
	import com.model.vo.config.item.ItemConfig;
	import com.model.vo.config.level.LevelConfig;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.config.skill.SkillConfig;
	import com.utils.MainDispatcher;
	import com.utils.ObjectFactory;
	import com.utils.PoolFactory;
	import com.utils.TextFactory;
	import com.view.touch.CommonBtn;
	
	import fl.containers.ScrollPane;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flas.net.URLLoader;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 关卡编辑面板
	 * @author hunterxie
	 */
	public class LevelEditorPanel extends Sprite{
		public static const TEST_LEVEL:String = "TEST_LEVEL";
		
		public static const NAME:String = "LevelEditorPanel";
		public static const SINGLETON_MSG:String = "single_LevelEditorPanel_only";
		protected static var instance:LevelEditorPanel;
		public static function getInstance():LevelEditorPanel{
			if ( instance == null ) instance = new LevelEditorPanel();
			return instance;
		}
		
		public var tf_ID:TextField;
		public var tf_name:TextField;
		public var tf_star_1:TextField;
		public var tf_star_2:TextField;
		public var tf_star_3:TextField;
		public var tf_triggerLevel:TextField;
		
		public var btn_close:CommonBtn;
		public var btn_addLevel:CommonBtn;
		public var btn_test:CommonBtn;
		public var btn_export:CommonBtn;
		
		public var cb_canCarry:ComboBox;
		public var cb_crossTime:ComboBox;
		
		public var levelInfoVO:LevelConfig;// = LevelInfo.getInstance();
		public var cuLevel:LevelConfigVO;
		
		public var list_level:List;
		public var cb_wuxing:ComboBox;
		public var _itemData:DataProvider;
		public function get itemData():DataProvider{
			if(!_itemData){
				var arr:Array = [];
				arr = arr.concat(ItemConfig.getInstance().items);
				arr = arr.concat(FairyConfig.getInstance().fairys);
				arr = arr.concat(SkillConfig.getInstance().skills);
				_itemData = new DataProvider(arr);
			}
			return _itemData;
		}
		public var boardData:DataProvider = new DataProvider;
		public var tf_levelInfo:TextField;
		public var tf_levelTarget:TextField;
		public var tf_levelTargetInfo:TextField;
		
		/**
		 * 棋盘配置面板
		 */
		public var mc_boardConfig:BoardInfoConfigPanel;
		public var cb_boardID:ComboBox;
		
		
		public var mc_showSetBoard:MovieClip;
		public var setBoard:Bitmap = new Bitmap;
		
		
		public var loader:URLLoader;
		
		
		
		/*******************************
		 * 
		 * 
		 * 
		 * 
		 * 
		 *******************************/
		public function LevelEditorPanel():void{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			mc_boardConfig.onShow();
			mc_showSetBoard.addChild(setBoard);
			this.cb_crossTime.rowCount = 15;
			this.cb_wuxing.rowCount = 15;
			cb_boardID.rowCount = 15;
			cb_boardID.addEventListener(Event.CHANGE, selectBoardID);
			list_level.addEventListener(Event.CHANGE, selectLevel);
			cb_levelKind.rowCount = 15;
			cb_levelKind.addEventListener(Event.CHANGE, selectLevelKind);
			
			btn_close.setNameTxt("关闭");
			btn_close.addEventListener(MouseEvent.CLICK, closePanel);
			
			btn_addLevel.setNameTxt("增加关卡");
			btn_addLevel.addEventListener(MouseEvent.CLICK, addLevel);
			
			btn_test.setNameTxt("测试内容");
			btn_test.addEventListener(MouseEvent.CLICK, testLevel);
			
			btn_export.setNameTxt("导出内容");
			btn_export.addEventListener(MouseEvent.CLICK, export);
			
			btn_reward1_add.addEventListener(MouseEvent.CLICK, onRewardChange);
			btn_reward1_reduce.addEventListener(MouseEvent.CLICK, onRewardChange);
			btn_reward3_add.addEventListener(MouseEvent.CLICK, onRewardChange);
			btn_reward3_reduce.addEventListener(MouseEvent.CLICK, onRewardChange);
			btn_rewards_add.addEventListener(MouseEvent.CLICK, onRewardChange);
			btn_rewards_reduce.addEventListener(MouseEvent.CLICK, onRewardChange);
			
			if(parent) parent.addEventListener(WuxingWorldEditorPanel.BOARD_INFO_LOADED, onBoardInfoLoaded);
			
//			if(true){//BaseInfo.isLoadConfig){
//				loader = new URLLoader(new URLRequest("levelInfo.json"));
//				loader.addEventListener(Event.COMPLETE, onLoaded);
//			}else{
				TweenLite.to({}, 0.5, {onComplete:onLoaded});
//			}
		}
		
		
		public function selectBoardID(e:Event):void {
			setBoard.bitmapData = WuxingWorldEditorPanel.getInstance().getSetPanel(cb_boardID.selectedIndex);
		}
		
		public function selectLevel(e:Event):void {
			saveLevel();
			showLevel(LevelConfig.getLevelByID(list_level.selectedIndex));
		}
		
		/**
		 * 关卡类型
		 */
		public var cb_levelKind:ComboBox;
		public function selectLevelKind(e:Event):void {
			tf_levelTargetInfo.text = cb_levelKind.selectedItem.describe+";如：\n"+cb_levelKind.selectedItem.example;
			switch(cb_levelKind.selectedItem.value){
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_All:
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_SCORE:
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_POINT:
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_KIND:
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_CLEAR_NUM:
					break;
				case LevelConfigVO.KIND_GAME_PUZZLE_FIT_ELEMENTS:
					break;
				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
					break;
				case LevelConfigVO.KIND_GAME_FIGHT_PVE:
					break;
				case LevelConfigVO.KIND_GAME_FIGHT_PVE_GIVEN:
					break;
				case LevelConfigVO.KIND_GAME_FIGHT_PVP_REAL_TIME:
					break;
				case LevelConfigVO.KIND_GAME_FIGHT_PVP_ROUND:
					break;
			}
		}
		
		public function onLoaded(e:Event=null):void{
			levelInfoVO = LevelConfig.getInstance();
			levelInfoVO.updateObj(BaseInfo.levelInfo);//JSON.parse(String(LoadProxy.getLoadInfo("levelInfo.json")));
//			var info:XML;
//			if(true){//BaseInfo.isLoadConfig){
////				info = XML(loader.data);
////				BaseInfo.setLevelInfo(info);
//				levelInfoVO.updateObj(JSON.parse(e.target.data));
//			}else{
////				info = BaseInfo.levelInfo;
//			}
//			levelInfoVO.updateByXML(info);
			//trace(info.level[0])//.(@id == 1));
			
			boardData.addItem({label:"无"});
			list_level.dataProvider = new DataProvider(levelInfoVO.baseLevels);
//			for (var i:int=0; i<levelInfoVO.baseLevels.length; i++) {
//				dp.addItem({label:"关卡"+info.level[i].@id});
//			}
//			for(var i:int=0; i<BaseInfo.itemInfo.record.length(); i++){
//				var xml:XML = BaseInfo.itemInfo.record[i][0];
//				itemData.addItem({label:String(xml.@name), ID:parseInt(xml.@templateID)});
//				itemData.addItem(ItemInfo.getInstance().items)
//			}
//			for(i=0; i<FairyInfo.getInstance().fairys.length; i++){
////				xml = BaseInfo.fairyInfo.fairy[i][0];
////				itemData.addItem({label:String(xml.@name), ID:parseInt(xml.@templateID)});
//				itemData.addItem(FairyInfo.getInstance().fairys[i]);
//			}
//			for(i=0; i<SkillInfo.getInstance().skills.length; i++){
////				var skill:SkillConfigVO = SkillInfo.getInstance().skills[i] as SkillConfigVO;
//				itemData.addItem(SkillInfo.getInstance().skills[i]);
//			}
			
//			list_level.dataProvider = dp;
			cb_levelKind.dataProvider=new DataProvider(levelInfoVO.infos.levelKind);
			cb_wuxing.dataProvider=new DataProvider(WuxingVO.wuxingArr);//xmlinfo.levelKind.wuxing[0]);
			
//			cb_maxR.dataProvider = new DataProvider([5,6,7,8]);
//			cb_maxL.dataProvider = new DataProvider([5,6,7,8]);
//			cb_ActiveMode.dataProvider = new DataProvider(["回合驱动", "全回合制驱动", "时间驱动"]);
//			cb_isInitCanClear.dataProvider = new DataProvider(["不能", "能"]);
//			cb_isDelayFall.dataProvider = new DataProvider(["不能", "能"]);
//			cb_isCreateNew.dataProvider = new DataProvider(["不能", "能"]);
			cb_canCarry.dataProvider = new DataProvider(["不能", "能"]);
			cb_crossTime.dataProvider = new DataProvider(["不限", "1次", "每天1次", "每天2次", "每天3次", "每天4次", "每天5次", "每天6次", "每天7次", "每天8次", "每天9次", "每天10次"]);
			
			list_level.selectedIndex = 0;
			list_level.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
//		public function updateTotalInfo():void{
//			skillEffectContainer.initInfo(info);
//			
//			var skillp:DataProvider=new DataProvider(info.skills[0]);
//			list_level.dataProvider=skillp;
//			showLevel(info.skills.skill[info.skills.skill.length()-1]);
//		}
		
		
		/**
		 * 关闭当前面板
		 * @param e
		 */
		public function closePanel(e:*=null):void {
			//this.parent.removeChild(this);
			this.visible = false;
		}
		
		/**
		 * 增加关卡
		 * @param e
		 */
		public function addLevel(e:*=null):void {
			saveLevel();
			var level:LevelConfigVO = levelInfoVO.addLevel();
			list_level.dataProvider.addItem({label:level.label+"("+level.ID+")"});
			list_level.selectedIndex = list_level.dataProvider.length-1;
			showLevel(level);
		}
		
		/**
		 * 测试当前关卡内容
		 * @param e
		 */
		public function testLevel(e:*=null):void {
			if(!cuLevel) return;
			closePanel();
			MainDispatcher.dispatchInfo(new ObjectEvent(TEST_LEVEL, cuLevel));
		}
		
		/**
		 * 导出内容
		 * @param e
		 */
		public function export(e:*=null):void {
			saveLevel();
			var info:String = JSON.stringify(levelInfoVO);
			TextFactory.outputFile(info, "levelInfo.json");
		}
		
		
		public function saveLevel(e:*=null):void {
			if(!cuLevel) return;
			cuLevel.label = tf_name.text;
			cuLevel.star1 = tf_star_1.text;
			cuLevel.star2 = tf_star_2.text;
			cuLevel.star3 = tf_star_3.text;
			cuLevel.target = tf_levelTarget.text;
			cuLevel.describe = tf_levelInfo.text;
			cuLevel.wuxing = cb_wuxing.selectedIndex;
			cuLevel.kind = cb_levelKind.selectedItem.value;
			cuLevel.crossTime = cb_crossTime.selectedIndex-1;
			cuLevel.trigger = parseInt(tf_triggerLevel.text);
			cuLevel.skillCarry = cb_canCarry.selectedIndex;
			cuLevel.boardID = cb_boardID.selectedIndex;//==0 ? -1 : cb_boardID.selectedIndex;
			cuLevel.boardConfig = mc_boardConfig.saveInfo();
		}
		
		
		public function showLevel(levelInfo:LevelConfigVO):void{
			cuLevel = levelInfo;
			tf_ID.text = String(cuLevel.ID);
			tf_name.text = cuLevel.label;
			tf_levelInfo.text = cuLevel.describe;
			tf_star_1.text = cuLevel.star1;
			tf_star_2.text = cuLevel.star2;
			tf_star_3.text = cuLevel.star3;
			cb_crossTime.selectedIndex = cuLevel.crossTime+1;
			tf_triggerLevel.text = String(cuLevel.trigger);
			cb_canCarry.selectedIndex = cuLevel.skillCarry;
			updateRewards();
			
			cb_wuxing.selectedIndex = cuLevel.wuxing;
			cb_levelKind.selectedIndex= ObjectFactory.getDataproviderIndexByLabel(cb_levelKind.dataProvider, cuLevel.kind);
			cb_levelKind.dispatchEvent(new ObjectEvent(Event.CHANGE));
			tf_levelTarget.text = String(cuLevel.target);
			cb_boardID.selectedIndex = cuLevel.boardID;//=="-1" ? 0 : 1;
			cb_boardID.dispatchEvent(new ObjectEvent(Event.CHANGE));
			
			mc_boardConfig.updateInfo(cuLevel.boardConfig);
//			cb_maxR.selectedIndex = parseInt(cuLevel.boardInfo.@maxR)-5;
//			cb_maxL.selectedIndex = parseInt(cuLevel.boardInfo.@maxL)-5;
//			cb_ActiveMode.selectedIndex = cuLevel.boardInfo.@ActiveMode;
//			cb_isInitCanClear.selectedIndex = cuLevel.boardInfo.@isInitCanClear;
//			cb_isDelayFall.selectedIndex = cuLevel.boardInfo.@isDelayFall;
//			cb_isCreateNew.selectedIndex = cuLevel.boardInfo.@isCreateNew;
//			tf_exchangeTime.text = cuLevel.boardInfo.@exchangeTime;
//			tf_fallTime.text = cuLevel.boardInfo.@fallTime;
//			tf_clearTime.text = cuLevel.boardInfo.@clearTime;
//			tf_sequenceTime.text = cuLevel.boardInfo.@sequenceTime;
//			tf_kindArr.text = cuLevel.boardInfo.kindArr;
//			tf_chanceArr.text = cuLevel.boardInfo.chanceArr;
//			tf_maxKinds.text = cuLevel.boardInfo.@maxKinds;
		}
		
		public var container_target:MovieClip;
		public var sp_target:ScrollPane;
		
		public var container_reward1:MovieClip;
		public var btn_reward1_add:MovieClip;
		public var btn_reward1_reduce:MovieClip;
		public var sp_reward1:ScrollPane;
		
		public var container_reward3:MovieClip;
		public var btn_reward3_add:MovieClip;
		public var btn_reward3_reduce:MovieClip;
		public var sp_reward3:ScrollPane;
		
		public var container_rewards:MovieClip;
		public var btn_rewards_add:MovieClip;
		public var btn_rewards_reduce:MovieClip;
		public var sp_rewards:ScrollPane;
		
		
		public function onRewardChange(e:*):void{
			var item:RewardItem = PoolFactory.getPoolInfo(RewardItem, itemData) as RewardItem;
			var deItem:RewardItem;
			switch(e.target){
				case btn_reward1_add:
					item.updateInfo(cuLevel.setReward("reward1", true), container_reward1.numChildren);
					container_reward1.addChild(item);
					sp_reward1.source = container_reward1;
					break;
				case btn_reward1_reduce:
					if(cuLevel.rewards.reward1.length>0){
						cuLevel.setReward("reward1", false);
						deItem = container_reward1.removeChildAt(0) as RewardItem;
						sp_reward1.source = container_reward1;
					}
					break;
				case btn_reward3_add:
					item.updateInfo(cuLevel.setReward("reward3", true), container_reward3.numChildren);
					container_reward3.addChild(item);
					sp_reward3.source = container_reward3;
					break;
				case btn_reward3_reduce:
					if(cuLevel.rewards.reward3.length>0){
						cuLevel.setReward("reward3", false);
						deItem = container_reward3.removeChildAt(0) as RewardItem;
						sp_reward3.source = container_reward3;
					}
					break;
				case btn_rewards_add:
					item.updateInfo(cuLevel.setReward("rewards", true), container_rewards.numChildren);
					container_rewards.addChild(item);
					sp_rewards.source = container_rewards;
					break;
				case btn_rewards_reduce:
					if(cuLevel.rewards.rewards.length>0){
						cuLevel.setReward("rewards", false);
						deItem = container_rewards.removeChildAt(0) as RewardItem;
						sp_rewards.source = container_rewards;
					}
					break;
			}
			if(deItem){
				PoolFactory.setPoolObj(RewardItem, deItem);
			}
//			updateRewards();
		}
		public function updateRewards():void{
			var item:RewardItem;
			while(container_reward1.numChildren){
				item = container_reward1.getChildAt(0) as RewardItem;
				container_reward1.removeChildAt(0);
				PoolFactory.setPoolObj(RewardItem, item);
			}
			for(var i:int=0; i<cuLevel.rewards.reward1.length; i++){
				item = PoolFactory.getPoolInfo(RewardItem, itemData) as RewardItem;
				item.updateInfo(cuLevel.rewards.reward1[i], i);
				container_reward1.addChild(item);
			}
			
			while(container_reward3.numChildren){
				item = container_reward3.getChildAt(0) as RewardItem;
				container_reward3.removeChildAt(0);
				PoolFactory.setPoolObj(RewardItem, item);
			}
			for(i=0; i<cuLevel.rewards.reward3.length; i++){
				item = PoolFactory.getPoolInfo(RewardItem, itemData) as RewardItem;
				item.updateInfo(cuLevel.rewards.reward3[i], i);
				container_reward3.addChild(item);
			}
			
			while(container_rewards.numChildren){
				item = container_rewards.getChildAt(0) as RewardItem;
				container_rewards.removeChildAt(0);
				PoolFactory.setPoolObj(RewardItem, item);
			}
			for(i=0; i<cuLevel.rewards.rewards.length; i++){
				item = PoolFactory.getPoolInfo(RewardItem, itemData) as RewardItem;
				item.updateInfo(cuLevel.rewards[i], i);
				container_rewards.addChild(item);
			}
			sp_reward1.source = container_reward1;
			sp_reward3.source = container_reward3;
			sp_rewards.source = container_rewards;
		}
		
		public function onBoardInfoLoaded(e:Event):void{
			var dataArr:Array = WuxingWorldEditorPanel.boardInfoVO.boards;
			var tempIndex:int=cb_boardID.selectedIndex;
			for (var i:int=boardData.length; i<dataArr.length; i++) {
				boardData.addItem({label:i+1+":"+(dataArr[i] as BoardBaseVO).name});
			}
			cb_boardID.dataProvider = boardData;
			cb_boardID.selectedIndex = tempIndex;
		}
		
		private function getItemIndex(id:int):int{
			for(var i:int=0; i<itemData.length; i++){
				if(itemData.getItemAt(i).id==id){
					return i;
				}
			}
			return 0;
		}
	}
}
