package com.view.UI.item {
	import com.model.event.ObjectEvent;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.ItemBaseVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class ItemInfoPanel extends BasePanel {
		public function ItemInfoPanel() {
			btn_use.setNameTxt("使 用");
			btn_sell.setNameTxt("出 售");

			this.addEventListener(MouseEvent.CLICK, handle_click);
			ItemListVO.getInstance().addEventListener(ItemListVO.ITEM_LIST_UPDATE, onUpdateVO);
		}

		protected function onUpdateVO(e:ObjectEvent):void {
			if(running_vo) {
				running_vo.removeEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
				running_vo=ItemListVO.getItemByTempID(running_vo.templateID);
				if(running_vo) {
					running_vo.addEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
				}
			}
		}

		public function handle_click(e:*):void {
			if(running_vo==null||running_vo.num<=0) {
				return;
			}
			switch(e.target) {
				case btn_use:
					event(E_USE, running_vo);
					break;
				case btn_sell:
					event(E_SELL, running_vo);
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   ******************************* 
		public static const E_USE:String="E_USE";
		public static const E_SELL:String="E_SELL";
		//Event Names 
		//场景含有组件  
		public var btn_use:CommonBtn;
		public var btn_sell:CommonBtn;
		public var itemBarMiddle:ItemBarMiddle;
		public var tf_title:TextField;
		public var tf_description:TextField;
		public var tf_price:TextField;
		public var itemRequirementBoard:MovieClip;
		//running
		public var running_vo:ItemVO;

		public function updateInfo(vo:ItemVO):ItemInfoPanel {
			if(running_vo) {
				running_vo.removeEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
			}
			running_vo=vo;
			running_vo.addEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
			refresh();
			
			return this;
		}

		public function refresh(e:ObjectEvent=null):void {
			if(running_vo==null||running_vo.num<=0) {
				close();
				return;
			}

			tf_title.text=running_vo.data.label;
			tf_description.text="五行："+running_vo.data.wuxing+"\n";
			tf_price.text="售价："+running_vo.data.price+" "+running_vo.data.wuxing+"元素";
			itemRequirementBoard["tf_label"].text=running_vo.data.describe;
			itemBarMiddle.updateInfo(running_vo);

			if(running_vo.data.type==ItemConfigVO.TYPE_ITEM_COMSUME) {
				setupPanel(true, true, true);
			} else {
				setupPanel(true, false, true);
			}
		}

		private function setupPanel(hasRequirement:Boolean, hasUse:Boolean, hasSell:Boolean):void {
			if(hasRequirement) {
				itemRequirementBoard.visible=true;
			} else {
				itemRequirementBoard.visible=false;
			}
			if(hasUse) {
				btn_use.visible=true;
			} else {
				btn_use.visible=false;
			}
			if(hasSell) {
				btn_sell.visible=true;
			} else {
				btn_sell.visible=false;
			}
		}

	}
}
