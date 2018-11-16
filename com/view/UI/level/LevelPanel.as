package com.view.UI.level {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.level.LevelChooseEnterVO;
	import com.model.vo.level.LevelListVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.utils.ColorFactory;
	import com.view.BasePanel;
	import com.view.UI.tip.TipNotEnoughResourceVO;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 关卡信息面板，包括技能选择和精灵选择
	 * @author hunterxie
	 */
	public class LevelPanel extends BasePanel{
		public static const NAME:String = "LevelPanel";
		public static function getShowName(vo:LevelVO):String{
			getInstance().updateInfo(vo);
			return NAME;
		}
		public static const SINGLETON_MSG:String="single_LevelPanel_only";
		protected static var instance:LevelPanel;
		public static function getInstance():LevelPanel{
			if ( instance == null ) instance = new LevelPanel();
			return instance;
		}
		
		/**
		 * 精灵选择面板，在精灵战斗关卡中出现
		 */
		public var mc_levelInfoPanel:LevelInfoPanel;
		/**
		 * 技能选择面板，在可以携带技能的关卡中出现
		 */
		public var mc_skillChoosePanel:LevelSkillChoosePanel;
		/**
		 * 精灵选择面板，在精灵战斗关卡中出现
		 */
		public var mc_fairyChoosePanel:LevelFairyChoosePanel;
		
		public var btn_start:CommonBtn;
		
		public var btn_start_high:CommonBtn;
		public var btn_back:CommonBtn;
		
		public var tf_levelName:TextField;
		
		
		/**
		 * 展示技能选择动画
		 */
		public var container_skillMovie:Sprite;
		/**
		 * 设置技能动画的移动时间
		 */
		public var setSkillMovieTime:Number = 0.5;
		
		/**
		 * 进行到第几个步骤
		 */
		public var stepNum:int = 1;
		/**
		 * 总体需要进行的步骤（如直接开始——技能选择——精灵选择）
		 */
		public var totalStepNum:int = 1;
		
		
		public var vo:LevelVO;	
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 
		 * 
		 */
		public function LevelPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this; 
			
			this.alignInfo = ALIGN_MIDDLE;
			
			tf_levelName.mouseEnabled = false;
			
			btn_start.setNameTxt("开始");
			btn_start.addEventListener(MouseEvent.CLICK, onStartC);
			
			btn_back.visible = false;
			btn_back.setNameTxt("上一步");
			btn_back.addEventListener(MouseEvent.CLICK, onBackC);
			
//			btn_start_high.visible = false;
			btn_start_high.setNameTxt("精英关");
			btn_start_high.addEventListener(MouseEvent.CLICK, onHigh);
			
			EventCenter.on(ApplicationFacade.WORLD_MAP_LEVEL_CHOOSE, this, showLevelInfoPanel);
		}
		
		private function showLevelInfoPanel(e:ObjectEvent):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelPanel.getShowName(e.data as LevelVO));
		}
		
		public function updateInfo(vo:LevelVO):void{
			this.vo = vo;
			totalStepNum = 1;
			if(vo.skillCarry) totalStepNum++;
			if(vo.fairyCarry) totalStepNum++;
			
			stepNum = 0;
			onStartC();//设置0后触发开始事件展示所处阶段
			
			this.mc_levelInfoPanel.updateInfo(vo);
			if(vo.skillCarry){
				this.mc_skillChoosePanel.updateLevelInfo(vo);
			}else{
				this.mc_skillChoosePanel.reset();
			}
			if(vo.fairyCarry){
				this.mc_fairyChoosePanel.updateLevelInfo(vo);
			}else{
				this.mc_fairyChoosePanel.reset();
			}
			
			btn_start_high.setNameTxt(vo.configVO.isHighLevel?"普通关":"精英关");
			tf_levelName.text = "第 "+(vo.configVO.isHighLevel?vo.id-10000:vo.id)+" 关"+(vo.configVO.isHighLevel?"（精英）":"");
			if(!vo.configVO.isHighLevel && !vo.isHighLevelOpen){
				btn_start_high.filters = [ColorFactory.getGrayFilter()];
				btn_start_high.mouseEnabled = false; 
			}else{
				btn_start_high.filters = null;
				btn_start_high.mouseEnabled = true;	
			}	
		}
		
		private function get levelChoiceVO():LevelChooseEnterVO{
			return userInfo.levelChoiceVO;
		}
		private function gameStart():void{
			close();
//			var chooseVO:LevelChooseEnterVO = new LevelChooseEnterVO(vo.id, mc_skillChoosePanel.getSkillArr(), mc_fairyChoosePanel.getFairyArr());
//			var arr:Array = mc_skillChoosePanel.getSkillArr();
//			if(!BaseInfo.isTestLogin) userInfo.updateBoardSkills(arr);
			
			vo.levelChoiceVO.updateInfo(vo.id, mc_skillChoosePanel.getSkillArr(), mc_fairyChoosePanel.getFairyArr());
			EventCenter.event(ApplicationFacade.LEVEL_GAME_START, vo);
		}
		
		/**
		 * 点击开始按钮，如果可以携带技能即进入技能选择
		 * @param e
		 */
		private function onStartC(e:*=null):void{
			if(vo.fairyCarry && stepNum>0){
				if(FairyListVO.fairyNum==0){
					TipVO.showChoosePanel(new TipVO("没有精灵", "这是精灵战斗关卡，你还没有精灵不能闯关！", TipNotEnoughResourceVO.NOT_ENOUGH_FAIRY));
					return;
				}else if(vo.userNeedFairyID>0 && !FairyListVO.getFairy(vo.userNeedFairyID)){
					TipVO.showChoosePanel(new TipVO("没有精灵", "你没有所需的精灵，不能闯关！", TipNotEnoughResourceVO.NOT_HAS_FAIRY));
					return;
				}
			}
			stepNum++;
			judgeStep();
			btn_back.visible = false;
			if(totalStepNum>stepNum){
				btn_start.setNameTxt("下一步");
				if(stepNum>1) btn_back.visible = true;
			}else if(totalStepNum==stepNum){
				btn_start.setNameTxt("开  始");
				btn_back.visible = stepNum>1; 
			}else{
				gameStart();
			}
		}
		/**
		 * 返回上一步
		 * @param e
		 */
		private function onBackC(e:*):void{
			stepNum--;
			btn_back.visible = false;
			if(stepNum<=1){
				stepNum=1;
			}else if(totalStepNum>stepNum){
				btn_start.setNameTxt("下一步");
				btn_back.visible = true;
			}else if(totalStepNum==stepNum){
				btn_start.setNameTxt("开  始");
				btn_back.visible = true; 
			}
			judgeStep();
		}
		
		public function onHigh(e:*):void{
			updateInfo(LevelListVO.getLevelVO(vo.configVO.isHighLevel ? vo.id-10000 : vo.id+10000));
//			btn_start_high.setNameTxt(vo.isHighLevel?"精英关":"普通关");
		}
		
		/**
		 * 根据步骤展示技能/角色选择面板
		 */
		private function judgeStep():void{ 
			mc_levelInfoPanel.visible = false;
			mc_skillChoosePanel.visible = false; 
			mc_fairyChoosePanel.visible = false; 
			
			switch(stepNum){
				case 1:
					mc_levelInfoPanel.visible = true;
					break;
				case 2:
					if(vo.skillCarry){
						this.mc_skillChoosePanel.visible = true;
					}else if(vo.fairyCarry){
						mc_fairyChoosePanel.visible = true;
					}
					break;
				case 3:
					mc_fairyChoosePanel.visible = true;
					break;
			}
		}
	}
}