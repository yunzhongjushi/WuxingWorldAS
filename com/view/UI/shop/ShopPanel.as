package com.view.UI.shop {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.shop.ShopConfig;
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.model.vo.conn.ServerVO_185;
	import com.model.vo.tip.TipVO;
	import com.view.BasePanel;
	import com.view.UI.tip.TipNotEnoughResourceVO;
	
	import flas.events.MouseEvent;

	/**
	 * 商城面板
	 * @author raojing
	 */
	public class ShopPanel extends BasePanel {
		public static const NAME:String="ShopPanel";
		public static function getShowName(type:int=0):String{
			instance.onCategory(type);//打开面板时跳到对应的分类
			if(ShopConfig.running_isInit) {
				ServerVO_185.getShopInfo();
			}
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:ShopPanel;

		public static function getInstance():ShopPanel {
			if(instance==null)
				instance=new ShopPanel();
			return instance;
		}
		
		private var serverVO_185:ServerVO_185;
		
		
		/**
		 *
		 *
		 */
		public function ShopPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			init();
			
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, onTipConfirm);
			
			serverVO_185 = ServerVO_185.getInstance();
			serverVO_185.on(ApplicationFacade.SERVER_INFO_OBJ, this, onServ185);
				
		}
		
		private function onServ185(e:ObjectEvent):void{
			if(ServerVO_185.BUY_ITEM==serverVO_185.subCode) {
				if(serverVO_185.isBuySuccess) {
					TipVO.showTipPanel(new TipVO("购买成功", "购买成功"));
				}
			}
		}
		private function onTipConfirm(e:ObjectEvent):void{
			if(e.data == TipNotEnoughResourceVO.NOT_ENOUGH_ENERGY ||
				e.data == TipNotEnoughResourceVO.NOT_ENOUGH_GOLD ||
				e.data == TipNotEnoughResourceVO.NOT_ENOUGH_WUXING){
				EventCenter.event(ApplicationFacade.SHOW_PANEL, ShopPanel.getShowName());
			}
		}

		public static const E_ON_CATEGORY:String="E_OPEN_CATEGORY";

		public var shopItemInfoPanel:ShopItemInfoPanel;

		public var shopItemPanel:ShopItemListPanel

		public var shopMainPanel:ShopMainPanel

		public var shopCategoryPanel:ShopCategoryPanel


		public var shopVipPanel:ShopVIPPanel;

		private var running_tag:int;
		
		private function get shopInfo():ShopConfig{
			return ShopConfig.getInstance();
		}
		
		private var updateFnArr:Array=[];
		;

		/**
		 *
		 *
		 */
		private function init():void {
			shopInfo.addEventListener(ShopConfig.UPDATE_SHOP_INFO, updateInfo);
			
			shopCategoryPanel.close();
			shopCategoryPanel.addEventListener(MouseEvent.CLICK, onChooseShop);
			
			shopItemPanel.close();
			shopItemPanel.addEventListener(ShopItemListPanel.E_BAR_CLICK, onItemBar);
			
			shopMainPanel.addEventListener(ShopMainPanel.E_BACK, onBack);
			shopMainPanel.addEventListener(ShopMainPanel.E_VIP, onShowVIP);
			
			shopItemInfoPanel.close();

			shopVipPanel.close();
			shopVipPanel.addEventListener(E_ON_CATEGORY, updateInfo);

			this.addEventListener(MouseEvent.CLICK, onclick);
		}

		protected function onclick(event:*):void {
			if(event.target is ShopItemBar) {
				var vo:ShopItemConfigVO = (event.target as ShopItemBar).running_vo;
				if(vo.isCash) {
					if(!vo.isCash) {
						ServerVO_185.getSendBuyItem(vo.id);
					}
				}else{
					addChild(shopItemInfoPanel.updateInfo(vo));
				}
			}
		}

		private function handle_MainUpdate(e:ObjectEvent):void {
			for(var i:int=0; i<updateFnArr.length; i++) {
				updateFnArr[i].call();
			}
		}

		/**
		 * 显示VIP面板，回调函数
		 * @param e
		 */
		public function onShowVIP(e:ObjectEvent):void {
			shopVipPanel.updateInfo();
		}

		public function onBack(e:ObjectEvent):void {
			addChild(shopCategoryPanel);
			shopItemPanel.close();
			shopItemInfoPanel.close();
			shopMainPanel.updateInfo(ShopMainPanel.SHOP_NAME, false);
		}

		public function onItemBar(e:ObjectEvent):void {
			var vo:ShopItemConfigVO = e.data as ShopItemConfigVO;
			if(!vo.isCash) {
				shopItemInfoPanel.updateInfo(vo);
			}
		}
		
		private function onChooseShop(e:*):void{
			if(e.target==shopCategoryPanel.btn_category_1 ||
				e.target==shopCategoryPanel.btn_category_2 ||
				e.target==shopCategoryPanel.btn_category_3){
				onCategory(e.target.type);
			}
		}
		/**
		 * 进行类别选择
		 * @param e
		 */
		public function onCategory(type:int=0):void {
			switch(type) {
				case ShopItemConfigVO.TYPE_GOLD:
					shopMainPanel.updateInfo("钻石", true);
					shopItemPanel.updateInfo(shopInfo.golds);
					break;
				case ShopItemConfigVO.TYPE_RESOURCE:
					shopMainPanel.updateInfo("五行", true);
					shopItemPanel.updateInfo(shopInfo.res);
					break;
				case ShopItemConfigVO.TYPE_ITEM:
					shopMainPanel.updateInfo("道具", true);
					shopItemPanel.updateInfo(shopInfo.items);
					break;
				default:
					updateInfo();
					return;
			}
			shopCategoryPanel.close();
			addChild(shopItemPanel);
		}

		/**
		 * 
		 * @param shopVO
		 * 
		 */
		public function updateInfo(e:ObjectEvent=null):void {
			shopItemPanel.close();
			shopItemInfoPanel.close();
			addChild(shopCategoryPanel);
			shopMainPanel.updateInfo();
		}
	}
}
