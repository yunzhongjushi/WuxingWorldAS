package com.view.UI.altar {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.altar.AltarTipVO;
	import com.model.vo.altar.AltarVO;
	import com.model.vo.conn.ServerVO_69;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	
	import flas.events.Event;

	/**
	 * 祭坛面板
	 * @author 饶境
	 */
	public class AltarPanel extends BasePanel {
		public static const NAME:String="AltarPanel";
		private static const SINGLETON_MSG:String="single_AltarPanel_only";
		private static var instance:AltarPanel;
		public static function getInstance():AltarPanel {
			if(instance==null)
				instance=new AltarPanel();
			return instance;
		}

		private function get userInfo():UserVO {
			return UserVO.getInstance();
		}
		
		private var serverVO_69:ServerVO_69;

		
		/**
		 * 
		 * 
		 */		
		public function AltarPanel():void {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			init();
			
			serverVO_69 = ServerVO_69.getInstance();
			serverVO_69.on(ApplicationFacade.SERVER_INFO_OBJ, this, onUpdate69);
				
		}
		
		private function onUpdate69(e:ObjectEvent):void{
			if(serverVO_69.code==ServerVO_69.GET_ALTARINFO) {
				updateInfo(serverVO_69.altarVO);
			}
			
			if(serverVO_69.code==ServerVO_69.ALTAR_BUY && serverVO_69.isSuccessed) {
				updateReward(serverVO_69.rewardArr);
			}
		}

		// 购买 购买的类型见 AltarVO
		public static const E_BUY:String="E_BUY";


		public var altar_wuxing:AltarWuxing;

		public var altar_gold:AltarGold;

		public var altar_reward:AltarRewardPanel

		// 缓存数据

		public var running_vo:AltarVO;

		public var isInit:Boolean

		public function init():void {
			isInit=false;

			altar_wuxing.close();
			altar_gold.close();
			altar_reward.close();

			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
			
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, onTipConfirm);
			this.on(AltarPanel.E_BUY, this, handle_buy);
		}
		
		
		protected function handle_buy(e:ObjectEvent):void {
			var altarVO:AltarVO=e.data as AltarVO;
			
			if(altarVO.currentBuyItem==AltarVO.ITEM_WUXING) {
				var targetWuxing:int=userInfo.wuxingInfo.getResource(altarVO.selectedWuxing);
				if(targetWuxing>=altarVO.getAltarCostByBuyType()) { // 元素购买
					ServerVO_69.altarBuy(altarVO.getBuyItem(), altarVO.getBuyType());
					closeReward();
				} else { // 钻石不足元素
					var needWuxing:int=altarVO.getAltarCostByBuyType()-userInfo.wuxingInfo.getResource(altarVO.selectedWuxing);
					TipVO.showChoosePanel(new AltarTipVO(altarVO.selectedWuxing, needWuxing, altarVO.getBuyItem(), altarVO.getBuyType()));
				}
			} else if(altarVO.currentBuyItem==AltarVO.ITEM_GOLD) {
				if(UserVO.testAddGold(-altarVO.getAltarCostByBuyType())) { // 钻石购买
					ServerVO_69.altarBuy(altarVO.getBuyItem(), altarVO.getBuyType());
					closeReward();
				}
			}
		}
		
		private function onTipConfirm(e:ObjectEvent):void{
			if(e.data is AltarTipVO) {
				var vo:AltarTipVO = e.data as AltarTipVO;
				if(vo.isConfirmSuccess) { //用钻石补足不够的元素扣除成功
					ServerVO_69.altarBuy(vo.buyItem, vo.buyType, true);
					closeReward();
				}
			}
		}

		protected function handle_add(e:*):void {
			if(isInit==false) {
				ServerVO_69.getInfo();
			} else {
				altar_wuxing.updateInfo(null);
				altar_gold.updateInfo(null);
				altar_reward.close();
			}
		}

		public function updateInfo(vo:AltarVO):void {
//			isInit = true;

			running_vo=vo;

			// show
			addChild(altar_wuxing);
			addChild(altar_gold);

			// update
			altar_wuxing.updateInfo(running_vo);
			altar_gold.updateInfo(running_vo);
		}

		public function updateReward(itemVOArr:Array):void {
			if(running_vo.currentBuyItem==AltarVO.ITEM_WUXING) {
				UserVO.testAddResource(running_vo.selectedWuxing, -running_vo.getAltarCostByBuyType());
			}

			addChild(altar_reward);

			altar_wuxing.refresh();

			altar_gold.refresh();

			altar_reward.updateInfo(itemVOArr, running_vo);
		}

		public function closeReward():void {
			altar_reward.close();
		}

	}
}
