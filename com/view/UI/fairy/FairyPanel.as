package com.view.UI.fairy {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.PanelPointShowVO;
	import com.model.vo.conn.ServerVO_192;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.LevelupFairyVO;
	import com.model.vo.fairy.UpgradeSkillTipVO;
	import com.model.vo.fairy.UpgradeSkillVO;
	import com.model.vo.fairy.UpgradeTotalSkillTipVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.level.LevelPanel;
	import com.view.mediator.fairy.UplevelFairyTipVO;
	
	import flas.events.MouseEvent;
	
	import flash.events.Event;

	/**
	 *
	 * @author hunterxie
	 *
	 */
	public class FairyPanel extends BasePanel {
		public static const NAME:String="FairyPanel";
		private static const SINGLETON_MSG:String="single_FairyPanel_only";
		private static var instance:FairyPanel;
		public static function getInstance():FairyPanel {
			if(instance==null)
				instance=new FairyPanel();
			return instance;
		}

		/**
		 * 发出消息：升级技能 , 可能多次
		 */
		public static const UPGRADE_SKILL:String="UPGRADE_SKILL";

		/**
		 * 发出消息：使用经验物品, 可能多次
		 */
		public static const USE_EXP_ITEM:String="USE_EXP_ITEM";
		/**
		 * 发出消息：模拟使用经验物品, 使用1次
		 */
		public static const USE_EXP_ITEM_SIM:String="USE_EXP_ITEM_SIM";

		/**
		 * 发出消息：装备精灵
		 */
		public static const EQUIP_FAIRY:String="EQUIP_FAIRY";

		/**
		 * 内部消息：打开强化面板
		 */
		public static const OPEN_STRENGTH:String="OPEN_STRENGTH";

		/**
		 * 内部消息：打开喂养面板
		 */
		public static const OPEN_FEED:String="OPEN_FEED";

		/**
		 * 精灵列表框体
		 */
		public var fairyListBoard:FairyListBoard;
		/**
		 * 精灵装备面板
		 */
		public var fairyEquipmentBoard:FairyEquipmentBoard;

		/**
		 * 精灵信息框体
		 */
		public var fairyInfoBoard:FairyInfoBoard;

		private function get userInfo():UserVO {
			return UserVO.getInstance();
		}

		private function get fairyListVO():FairyListVO {
			return FairyListVO.getInstance();
		}

		/**
		 * 记录点击的精灵，再次打开面板时，默认选定该精灵
		 */
		private var selectedFairy:BaseFairyVO;
		
		public var serverVO_68:ServerVO_68;

		/**
		 * 精灵面板
		 */
		public function FairyPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;

			this.addEventListener(MouseEvent.CLICK, handle_click);

			this.addEventListener(OPEN_FEED, handle_open);
			this.addEventListener(OPEN_STRENGTH, handle_open);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_remove);

			fairyListVO.addEventListener(FairyListVO.UPDATE_FAIRYS_INFO, updateInfo);

			handle_remove();
			
			serverVO_68 = ServerVO_68.getInstance();
			serverVO_68.on(ApplicationFacade.SERVER_INFO_OBJ, this, onUpgradeFairy);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShowPanel);
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, onTipConfirm);
			
		}
		
		private function onTipConfirm(e:ObjectEvent):void{
			if(e.data is UpgradeSkillTipVO) {
				var vo1:UpgradeSkillTipVO=e.data as UpgradeSkillTipVO;
				if(vo1.isConfirmSuccess) { // 购买，并用钻石补足不够的元素
					var upgradeVO:UpgradeSkillVO = vo1.vo;
					var targetLV:int=upgradeVO.skillLV+1;
					ServerVO_68.upgrade_skill(upgradeVO);//true
					FairyListVO.testLevelupSkill(upgradeVO);
				}
			}
			if(e.data is UpgradeTotalSkillTipVO) {
				var vo3:UpgradeTotalSkillTipVO=e.data as UpgradeTotalSkillTipVO;
				if(vo3.isConfirmSuccess) { // 购买，并用钻石补足不够的元素
					fairyInfoBoard.sendOnekeyup();
				}
			}
			if(e.data is UplevelFairyTipVO) {
				var vo2:UplevelFairyTipVO=e.data as UplevelFairyTipVO;
				if(vo2.isConfirmSuccess) { // 成功用钻石补足不够的元素
					var levelupVO:LevelupFairyVO = vo2.vo;
					ServerVO_68.uplevel_fairy(levelupVO.fairyVO.ID, 1, true);
					FairyListVO.testLevelupFairy(levelupVO);
				}
			}
		}
				
		private function onShowPanel(e:ObjectEvent):void{
			if(e.data==FairyPanel.NAME){
				 ServerVO_68.get_fairys();
				 ServerVO_192.getItems();
				 PanelPointShowVO.showPointGuide(FairyPanel.NAME, false);
				 if(BaseInfo.isTestLogin) {
					 updateInfo();
					 ServerVO_192.getItems();
				 }
			}
		}

		/**
		 * 关闭整个面板时，关闭精灵信息和精灵列表
		 * @param e
		 */
		protected function handle_remove(e:Event=null):void {
			fairyEquipmentBoard.close();
		}

		/**
		 * 打开功能面板
		 * 喂养面板
		 * 强化面板
		 * @param e
		 */
		protected function handle_open(e:ObjectEvent):void {
			var fairyVO:BaseFairyVO;

			switch(e.type) {
				case OPEN_FEED:
					break;
				case OPEN_STRENGTH:
					break;
			}
		}

		/**
		 * 根据点击事件，打开功能
		 * FairyBarSmall...点击精灵，打开精灵信息面板
		 * FairySkillBar...点击技能，打开技能面板
		 * FairyEquipmentBar...点击装备，打开装备面板
		 * @param e
		 */
		protected function handle_click(e:*):void {
			if(e.target is FairyBarSmall) {
				var fairyBarSmall:FairyBarSmall=e.target as FairyBarSmall;
				fairyListBoard.barList.callFnOfBars("onUnselecte");
				fairyBarSmall.onSelecte();
				fairyInfoBoard.updateVO(fairyBarSmall.running_vo);

				selectedFairy=fairyBarSmall.running_vo;
			}
			if(e.target is FairyEquipmentBar) {
				var eBar:FairyEquipmentBar=e.target as FairyEquipmentBar;

				fairyEquipmentBoard.updateInfo(eBar.runnning_equipVO, eBar.runnning_fairyVO);
				this.addChild(fairyEquipmentBoard);
			}
			if(e.target is EquipGetBar) {
				close();
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelPanel.getShowName((e.target as EquipGetBar).levelVO));//打开关卡
			}
		}

		public function onUpgradeFairy(e:ObjectEvent):void {
			if(serverVO_68.isOK==false) {
				trace("【警告】 前一次操作不成功！");
			}
			if(serverVO_68.subCodeObj==ServerVO_68.CODE_UPGRADE_FAIRY){
				fairyInfoBoard.refresh();
			}
		}

		/**
		 * 更新精灵信息
		 */
		public function updateInfo(e:Event=null):void {
			fairyListBoard.updateInfo();

			if(FairyListVO.fairyNum>0) {
				fairyInfoBoard.visible = true;
				if(selectedFairy==null)
					selectedFairy=fairyListBoard.getFirstFairyVO();
				var bar:FairyBarSmall=fairyListBoard.barList.getSPbyVO(selectedFairy) as FairyBarSmall
				if(bar==null)
					bar=fairyListBoard.barList.getSPbyVO(fairyListBoard.getFirstFairyVO()) as FairyBarSmall;
				if(bar) {
					fairyInfoBoard.updateVO(selectedFairy);
					fairyListBoard.barList.callFnOfBars("onUnselecte");
					bar.onSelecte();
				}
			} else {
				fairyInfoBoard.visible = false;
			}
		}
	}
}
