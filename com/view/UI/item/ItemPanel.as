package com.view.UI.item {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.conn.ServerVO_192;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	
	import flash.events.Event;

	/**
	 * 物品面板
	 * @author 饶境
	 */
	public class ItemPanel extends BasePanel {
		public static const NAME:String="ItemPanel";
		private static const SINGLETON_MSG:String="single_ItemPanel_only";
		private static var instance:ItemPanel;
		public static function getInstance():ItemPanel {
			if(instance==null)
				instance=new ItemPanel();
			return instance;
		}

		/**获取物品*/
		public static const GET_ITEM:String="GET_ITEM";

		/**刷新物品列表*/
		public static const REFRESH_LIST:String="REFRESH_LIST";
		
		
		public static const tagArr:Array = ["总览","消耗","装备","碎片","技能"];
		//=================以下为场景元素===============================
		public var itemMainPanel:ItemMainPanel
		public var itemListPanel:ItemListPanel;
		public var itemUsePanel:ItemUsePanel;
		public var itemInfoPanel:ItemInfoPanel;

		private var running_tag:String;

		/**
		 * 物品列表
		 * @return
		 */
		private function get itemList():Array {
			return ItemListVO.getItemList();
		}
		
		public var serverVO_192:ServerVO_192;

		/**
		 * 初始化
		 */
		public function ItemPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;

			//
			itemInfoPanel.addEventListener(ItemInfoPanel.E_USE, openUsePanel);
			itemInfoPanel.addEventListener(ItemInfoPanel.E_SELL, openSellPanel);
			itemInfoPanel.addEventListener(REFRESH_LIST, refresh);
			ItemListVO.getInstance().addEventListener(ItemListVO.ITEM_LIST_UPDATE, refresh);

			itemMainPanel.addEventListener(ItemMainPanel.E_ON_TAG, onTag);
			itemListPanel.addEventListener(ItemListPanel.E_CLOSE, close);
			this.addEventListener(MouseEvent.CLICK, onItemBar);

			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_remove);

			handle_remove();
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShow);
			
			serverVO_192 = ServerVO_192.getInstance();
			serverVO_192.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateInfo);
		}
			
		private function onShow(e:ObjectEvent):void{
			if(e.data==ItemPanel.NAME){
				ServerVO_192.getItems();
				BaseInfo.isTestLogin && updateInfo();
			}
		}

		/**
		 * 关闭面板，移除其他面板
		 * @param e
		 */
		protected function handle_remove(e:Event=null):void {
			itemInfoPanel.visible = false;
			itemUsePanel.visible = false;
			running_tag = "消耗";
		}

		/**
		 * 点击物品，展示物品信息面板
		 * @param e
		 */
		private function onItemBar(e:*):void {
			if(e.target is ItemBarMiddle) {
				itemInfoPanel.updateInfo((e.target as ItemBarMiddle).running_vo);
				itemInfoPanel.visible = true;
				itemUsePanel.visible = false;
			}
		}

		/**
		 * 打开使用条
		 * @param e
		 */
		private function openUsePanel(e:ObjectEvent):void {
			var vo:ItemVO=e.data as ItemVO
			if(itemUsePanel.parent!=null||vo.num==0) {
				itemUsePanel.visible = false;
			} else {
				itemUsePanel.visible = true;
				itemUsePanel.updateInfoByUse(vo);
			}
		}

		/**
		 * 打开出售条
		 * @param e
		 */
		private function openSellPanel(e:ObjectEvent):void {
			var vo:ItemVO=e.data as ItemVO
			if(itemUsePanel.parent!=null||vo.num==0) {
				itemUsePanel.visible = true;
			} else {
				itemUsePanel.visible = true;
				itemUsePanel.updateInfoBySell(vo);
			}
		}

		/**
		 * 打开某标签的物品
		 * @param e
		 */
		private function onTag(e:ObjectEvent):void {
			var tag:String=e.data as String;//tag=null 时表示“全部”
			running_tag=tag;
			refresh();
		}

		/**
		 * 发出消息：出售物品
		 * @param e
		 */
		private function onSell(e:ObjectEvent):void {
			var vo:ItemVO=e.data as ItemVO;
			ItemListVO.testSellItem(vo, vo.useItemNumSim);
			refresh()
		}

		public function updateInfo(e:ObjectEvent=null):void {
			if(e && e.data != ServerVO_192.GET_INFO) return;
			
			if(running_tag==null || running_tag=="")
				running_tag = "消耗";

			itemMainPanel.updateInfo(tagArr);
			itemMainPanel.reset();
			refresh()

		}

		private function getItemArr(type:int):Array {
			var i:int;
			var newArr:Array=[];
			for(i=0; i<itemList.length; i++) {
				var vo:ItemVO=itemList[i] as ItemVO;
				if(vo.data.subType==type && vo.num>0) {
					newArr.push(vo);
				}
			}
			newArr.sortOn("templateID");
			return newArr;
		}

		private function refresh(e:Event=null):void {
			var arr:Array = itemList;
			switch(running_tag) {
				case "消耗":
					arr=getItemArr(ItemConfigVO.TYPE_ITEM_COMSUME);
					break;
				case "装备":
					arr=getItemArr(ItemConfigVO.TYPE_ITEM_FAIRY_EQUIP);
					break;
				case "碎片":
					arr=getItemArr(ItemConfigVO.TYPE_ITEM_FAIRY_PIECE);
					break;
				case "技能":
					arr=getItemArr(ItemConfigVO.TYPE_ITEM_SKILL_PIECE);
					break;
			}
			itemListPanel.updateInfo(arr);
		}
	}
}
