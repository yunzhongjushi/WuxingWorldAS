package com.view.UI.shop{
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.model.vo.conn.ServerVO_185;
	import com.view.BasePanel;
	import com.view.UI.item.ItemBarMiddle;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ShopItemInfoPanel extends BasePanel {
		public var btn_buy:CommonBtn;
		public var mc_item:ItemBarMiddle;
		public var tf_name:TextField;
		public var tf_description:TextField;
		public var itemRequirementBoard:MovieClip;
		
		public var running_vo:ShopItemConfigVO;
		
		
		public function ShopItemInfoPanel() {
			this.addEventListener(MouseEvent.CLICK, handle_click);

			btn_buy.setNameTxt("购 买");
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_buy:
					ServerVO_185.getSendBuyItem(running_vo.id);
					close();
					break;
			}
		}

		public function updateInfo(vo:ShopItemConfigVO):ShopItemInfoPanel {
			running_vo = vo;
			
			tf_name.text = running_vo.data.label;
			tf_description.text = "价格："+running_vo.price;
			itemRequirementBoard["tf_label"].text = running_vo.data.describe;
			mc_item.updateShopItem(running_vo.data);
			return this;
		}

	}
}
