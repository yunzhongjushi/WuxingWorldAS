package com.view.UI.item {
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_124;
	import com.model.vo.conn.ServerVO_192;
	import com.model.vo.item.ItemBaseVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.user.UserVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ItemUsePanel extends BasePanel {

		private static const USE:String="使用";
		private static const SELL:String="出售";

		private const MULTIPLE_USE_SELL_NUM:int=10;

		private function get userVO():UserVO {
			return UserVO.getInstance();
		}

		public var itemUsePanel_BG:MovieClip;
		public var btn_use_1:CommonBtn;
		public var btn_use_5:CommonBtn;

		private var state:String;
		private var running_vo:ItemVO;

		public function ItemUsePanel() {
			this.addEventListener(MouseEvent.CLICK, handle_click);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);

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

		protected function onRemove(e:Event):void {
			onSend();
		}

		protected function onSend(e:*=null):void {
			if(running_vo==null||running_vo.useItemNum==0)
				return;
			
			if(state==USE){
				ServerVO_192.getSendUseItem(running_vo);
			}else if(state==SELL){
				ServerVO_124.getSendSellItem(running_vo);
			}

			running_vo.useItemNum=0;
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_use_1:
					running_vo.useItemNum+=1;
					running_vo.useItemNumSim=1;
					if(state==USE){
						ItemListVO.testUseItem(running_vo, running_vo.useItemNumSim);
					}else if(state==SELL){
						ItemListVO.testSellItem(running_vo, running_vo.useItemNumSim);
					}
					break;
				case btn_use_5:
					running_vo.useItemNum+=Math.min(MULTIPLE_USE_SELL_NUM, running_vo.num);
					running_vo.useItemNumSim=Math.min(MULTIPLE_USE_SELL_NUM, running_vo.num);
					if(state==USE){
						ItemListVO.testUseItem(running_vo, running_vo.useItemNumSim);
					}else if(state==SELL){
						ItemListVO.testSellItem(running_vo, running_vo.useItemNumSim);
					}
					break;
			}
			TimerFactory.once(500, this, onSend);//限制技能500ms使用一次
		}

		public function updateInfoByUse(vo:ItemVO):void {
			state=USE;
			itemUsePanel_BG.gotoAndStop(1);

			if(running_vo)
				running_vo.removeEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
			running_vo=vo;
			running_vo.addEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);

			btn_use_1.setNameTxt("使用 1 个");
			refresh();
		}

		public function updateInfoBySell(vo:ItemVO):void {
			state=SELL;
			itemUsePanel_BG.gotoAndStop(2);

			if(running_vo)
				running_vo.removeEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);
			running_vo=vo;
			running_vo.addEventListener(ItemBaseVO.UPDATE_ITEM_INFO, refresh);

			btn_use_1.setNameTxt("出售 1 个");
			refresh();
		}

		private function refresh(e:Event=null):void {
			if(running_vo==null||running_vo.num<=0) {
				onSend();
				close();
				return
			}
			if(running_vo.num<MULTIPLE_USE_SELL_NUM) {
				btn_use_5.setNameTxt("全部( "+running_vo.num+" )");
			} else {
				btn_use_5.setNameTxt(state+" "+MULTIPLE_USE_SELL_NUM+" 个");
			}
		}
	}
}
