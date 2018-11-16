package com.model.vo.item {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.fairy.TipFairyVO;
	import com.model.vo.level.LevelRewardVO;
	import com.model.vo.user.UserVO;

	/**
	 * 静态保存角色物品信息
	 * @author hunterxie
	 */
	public class ItemListVO extends BaseObjectVO {
		public static const NAME:String="ItemListVO";
		public static const SINGLETON_MSG:String="single_ItemListVO_only";
		protected static var instance:ItemListVO;

		public static function getInstance():ItemListVO {
			if(instance==null)
				instance=new ItemListVO();
			return instance as ItemListVO;
		}

		public static const ITEM_LIST_UPDATE:String="ITEM_LIST_UPDATE";
		
		/**
		 * 物品列表
		 * @ItemVO
		 */
		private var itemList:Array = [];
		public static function getItemList():Array{
			return getInstance().itemList;
		}

		/**
		 * 基础物品列表，保存在本地
		 * @BaseItemVO
		 */
		public var baseItemList:Array = BaseObjectVO.getClassArray(ItemBaseVO);

		/**
		 *
		 *
		 */
		public function ItemListVO() {
			if(instance!=null) throw Error(SINGLETON_MSG);
			instance=this;
		}
		
		/**
		 * 根据本地数据更新
		 * @param info
		 */
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			
			while(itemList.length)
				itemList.pop();
			for(var i:int=0; i<baseItemList.length; i++) {
				var vo:ItemBaseVO = baseItemList[i] as ItemBaseVO;
				var item:ItemVO=ItemVO.getItemVO(vo._templateID, vo.num, vo._itemID);
				item.baseItemVO = vo;
				itemList.push(item);
			}
			
			TipFairyVO.getInstance().updateModifyInfo(itemList);
			
			this.dispatchUpdate();
		}

		/**
		 * 服务器更新
		 * @param info
		 */
		public function updateByServer(info:Object):Array {
			while(itemList.length)
				itemList.pop();
			while(baseItemList.length)
				baseItemList.pop();
			for(var i:String in info) {
				if(i!="code"&&i!="serverCMD") {
					var id:int=parseInt(i);
					var str:String=info[i]
					var index:int=str.indexOf("-");
					if(index!=-1) {
						var num:int=parseInt(str.substr(index+1));
						if(num>0) {
							var itemId:int=parseInt(str.substr(0, index));
							var item:ItemVO=ItemVO.getItemVO(id, num, itemId);
							itemList.push(item);
							baseItemList.push(item.baseItemVO);
						}
					}
				}
			}
			//	新获得精灵提示，物品信息改动时需要更新数据
			TipFairyVO.getInstance().updateModifyInfo(itemList);

			this.dispatchUpdate();
			return baseItemList;
		}

		/**
		 * 模拟添加物品，通过templateID
		 * @param id
		 * @param num
		 */
		public static function testAddItem(templateID:int, num:int):void {
			var vo:ItemVO = getItemByTempID(templateID);
			if(vo) {
				vo.num += num;
			} else {
				vo = ItemVO.getItemVO(templateID, num, Math.floor(Math.random()*99999));
				instance.itemList.push(vo);
				instance.baseItemList.push(vo.baseItemVO);
			}

			//新获得精灵提示，物品信息改动时需要更新数据
			TipFairyVO.getInstance().updateModifyInfo([vo]);
			
			instance.dispatchUpdate();
		}

		/**
		 * 模拟使用物品
		 * @param id
		 * @param num
		 */
		public static function testUseItem(vo:ItemVO, useNum:int):void {
//			var config:ItemConfigVO = getItemByTempID(id);
			switch(vo.data.id){
				case 14:
					UserVO.getInstance().EXP_cu += vo.data.effect*useNum;
					break;
				case 15:
					UserVO.getInstance().energy += vo.data.effect*useNum;
					break;
				case 16:
					UserVO.getInstance().wuxingInfo.addResource(0, vo.data.effect*useNum);
					break;
				case 17:
					UserVO.getInstance().wuxingInfo.addResource(1, vo.data.effect*useNum);
					break;
				case 18:
					UserVO.getInstance().wuxingInfo.addResource(2, vo.data.effect*useNum);
					break;
				case 19:
					UserVO.getInstance().wuxingInfo.addResource(3, vo.data.effect*useNum);
					break;
				case 20:
					UserVO.getInstance().wuxingInfo.addResource(4, vo.data.effect*useNum);
					break;
			}
			testAddItem(vo.templateID, -1*useNum);
		}

		/**
		 * 模拟出售物品
		 * @param id
		 * @param num
		 */
		public static function testSellItem(vo:ItemVO, useNum:int):void {
			UserVO.getInstance().wuxingInfo.addResource(vo.data.wuxing, vo.data.price*useNum);
			testAddItem(vo.templateID, useNum*-1);
		}

		/**
		 * 获取当前列表中的物品，通过templateID
		 * @param templateID
		 * @param isAutoGen
		 */
		public static function getItemByTempID(templateID:int, isAutoGen:Boolean=false):ItemVO {
			for(var i:int=0; i<instance.itemList.length; i++) {
				var vo:ItemVO=instance.itemList[i] as ItemVO;
				if(vo.templateID==templateID) {
					return vo;
				}
			}
			if(isAutoGen) {
				return ItemVO.getItemVO(templateID, 0);
			}
			return null
		}
		
		public static function getItemNum(templateID:int):int{
			var vo:ItemVO = getItemByTempID(templateID);
			if(vo){
				return vo.num;
			}
			return 0;
		}

		/**
		 * 根据精灵装备位置获取物品列表中对应的物品
		 * @param slot	装备位置
		 * @return
		 */
		public static function getEquipVO(id:int):FairyEquipVO {
			var eVO:ItemVO = getItemByTempID(id);
			if(eVO && eVO.num>0) {
				return eVO as FairyEquipVO;
			}
			return null;
		}
		
		/**
		 * 本地添加战斗结束后的模拟物品奖励
		 * @param vo
		 */
		public static function testAddReward(vo:LevelRewardVO):void{
			if(vo.items.length>0){
				for(var i:int=0; i<vo.items.length; i++){
					var item:int = vo.items[i];
					testAddItem(item, 1);
				}
				instance.dispatchUpdate();
			}
		}
		
		public function dispatchUpdate():void{
			event(ITEM_LIST_UPDATE);
		}
	}
}
