package com.view.UI.shop {
	import com.model.event.ObjectEvent;
	import com.model.vo.config.shop.ShopConfig;
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.view.BasePanel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;

	public class ShopCategoryPanel extends BasePanel {
		public var btn_category_1:MovieClip;
		public var btn_category_2:MovieClip;
		public var btn_category_3:MovieClip;
		
		
		public function ShopCategoryPanel() {
			btn_category_1.type = ShopItemConfigVO.TYPE_GOLD;
			btn_category_2.type = ShopItemConfigVO.TYPE_RESOURCE;
			btn_category_3.type = ShopItemConfigVO.TYPE_ITEM;
		}
	}
}
