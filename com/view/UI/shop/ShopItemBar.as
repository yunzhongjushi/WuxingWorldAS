package com.view.UI.shop{
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.view.BaseImgBar;
	import com.view.UI.ResourceIcon;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;

	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class ShopItemBar extends BaseImgBar implements ITouchPadBar	{
		/**
		 * 当前物品配置
		 */
		public var running_vo:ShopItemConfigVO;
		
		public var board_price:ResourceIcon;
		
		public var btn_cover:MovieClip;
		
		public var shopItemBannerArr:MovieClip;
		
		public var itemPicArr:*;

		public function ShopItemBar() {
			super();
		}

		public function updateInfo(_vo:*):void {
			if(_vo is ShopItemConfigVO){
				running_vo = _vo as ShopItemConfigVO;
				tf_label.text=String(running_vo.data.label)
				shopItemBannerArr.gotoAndStop(running_vo.bannerType);
				board_price.updateInfo(running_vo.buyTypeStr, String(running_vo.price));
				updateClass(running_vo.data.icon);
			}
		}
	}
}
