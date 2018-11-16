package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.proxy.BaseConnProxy;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.model.vo.fairy.FairySaveVO;
	import com.model.vo.fairy.StrengthenFairyVO;
	import com.model.vo.fairy.UpgradeSkillVO;
	import com.model.vo.item.FairyEquipVO;
	import com.model.vo.item.ItemListVO;

	/**
	 * 精灵协议
	 * @author hunterxie
	 */
	public class ServerVO_68 extends BaseConnProxy {
		private static var instance:ServerVO_68;
		public static function getInstance():ServerVO_68{
			if ( instance == null ) instance=new ServerVO_68();
			return instance;
		}
		
		
		/** 协议号 */
		public static const ID:int=0x44;

		public static const CODE_UPDATE_ALL:Object={code:0x02, load:"正在获取精灵..."};
		public static const CODE_UPDATE_SINGLE:Object={code:0x20, load:"正在获取精灵..."};
		public static const CODE_UPGRADE_SKILL:Object={code:0x09, load:"正在升级技能..."};
		public static const CODE_STRENGTHEN_FAIRY:Object={code:0x0b, load:"正在强化精灵..."};
		public static const CODE_EQUIP_FAIRY:Object={code:0x0d, load:"正在装备精灵..."};
		public static const CODE_UPGRADE_FAIRY:Object={code:0x0e, load:"正在进阶精灵..."};
		public static const CODE_UPLEVEL_FAIRY:Object={code:0x08, load:"正在升级精灵..."};

		public static const CODE_PIECE_GEN_FAIRY:Object={code:0x09, load:"正在升级精灵..."};


		/** 新协议拷贝以下 */
		private static const LOAD_SHOW_LIST:Array=[CODE_UPDATE_ALL, CODE_UPDATE_SINGLE, CODE_UPGRADE_SKILL, CODE_STRENGTHEN_FAIRY, CODE_EQUIP_FAIRY, CODE_UPGRADE_FAIRY, CODE_UPLEVEL_FAIRY]

		private static function sendInfo(obj:Object, codeObj:Object):void {
			var code:int=codeObj["code"];
			if(code!=-1)
				obj.code=code;
			MainNC.getInstance().sendInfo(ID, obj, codeObj["load"]);
		}

		override protected function getCodeObj(code:int):Object {
			for each(var obj:Object in LOAD_SHOW_LIST) {
				if(obj["code"]==code)
					return obj;
			}
			return null;
		}

		/** 新协议拷贝以上 */

		private function get fairyList():FairyListVO {
			return FairyListVO.getInstance();
		}

		public function ServerVO_68(obj:Object=null):void {
			super(obj);
		}

		override protected function handleReceive(obj:Object):void {
			switch(subCodeObj) {
				case CODE_UPDATE_ALL:
					fairyList.updateFairyInfoByServer(obj);
					break;
				case CODE_UPDATE_SINGLE:
					var vo:FairySaveVO = new FairySaveVO;
					fairyList.updateSingle(vo.updateByServer(obj));
//					fairyList.updateSingleFairyInfoByServer(obj);
					break;
				case CODE_UPGRADE_SKILL:
					break;
				case CODE_STRENGTHEN_FAIRY:
					break;
				case CODE_EQUIP_FAIRY:
					break;
				case CODE_UPGRADE_FAIRY:
					break;
				case CODE_UPLEVEL_FAIRY:
					break;
			}
		}

		/**
		 * 获取所有精灵的信息
		 *
		 */
		public static function get_fairys():void {
			var obj:Object={};
			var codeObj:Object=CODE_UPDATE_ALL;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
		}


		/**
		 * 升级精灵
		 *
		 */
		public static function uplevel_fairy(id:int, lv:int, isCostMoney:Boolean):void {
			var obj:Object={};
			var codeObj:Object=CODE_UPLEVEL_FAIRY;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.petId=id;
				obj.targetLv=lv;
				obj.isCostMoney=(isCostMoney?"1":"0");
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
		}

		/**
		 * 技能升级
		 *
		 */
		public static function upgrade_skill(vo:UpgradeSkillVO):void{
			if(vo.upgradeTime==0) return;
			
			var obj:Object={};
			var codeObj:Object=CODE_UPGRADE_SKILL;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.id=vo.fairyVO.ID;
				obj.place=vo.skillPosition+1;
				obj.lv=vo.getTargetLV();
				obj.isCostMoney=(vo.getIsCostMoney()?"1":"0");
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
		}

		/**
		 * 强化精灵
		 */
		public static function strengthen_fairy(strengthVO:StrengthenFairyVO):void {
			var obj:Object={};
			var codeObj:Object=CODE_STRENGTHEN_FAIRY;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.petId=strengthVO.fairyVO.ID;
				obj.strgLv=strengthVO.strengthenToLV;
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收

//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
			ItemListVO.testAddItem(strengthVO.mergeVO.templateID, -1*strengthVO.getCostMeger());
			FairyListVO.testStrengthen(strengthVO.fairyVO.ID, strengthVO.strengthenToLV);
		}

		/**
		 * 装备精灵
		 */
		public static function equip_fairy(fairyVO:BaseFairyVO, equipVO:FairyEquipVO):void {
			var obj:Object={};
			var codeObj:Object=CODE_EQUIP_FAIRY;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.petId=fairyVO.ID;
				obj.equipId=equipVO.itemID;
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
			FairyListVO.testEquip(fairyVO.ID, equipVO);
			ItemListVO.testAddItem(equipVO.templateID, -1);
		}

		/**
		 * 进阶精灵
		 */
		public static function upgrade_fairy(fairyVO:BaseFairyVO):void {
			var obj:Object={};
			var codeObj:Object=CODE_UPGRADE_FAIRY;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.petId=fairyVO.ID;
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
				FairyListVO.testUpgrade(fairyVO.ID);

//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
			FairyListVO.testUpgrade(fairyVO.ID);
		}

		/**
		 * 碎片合成精灵
		 */
		public static function piece_gen_fairy(fairyVO:BaseFairyVO):void {
			var obj:Object={};
			var codeObj:Object=CODE_PIECE_GEN_FAIRY;

			trace("碎片合成精灵碎片的接口，后台还没有写！！");
			return;

			if(BaseInfo.isTestLogin==false) {
				//联网处理 - 发送至服务器
				obj.petId=fairyVO.ID;
				sendInfo(obj, codeObj);
			} else {
				//本地处理 - 模拟接收
				return;

//				obj.result = 0;
//				var vo:ServerVO_68 = new ServerVO_68(obj);
//				vo.sendInfoFromLocal(codeObj);
			}
		}

		/**
		 * 增加精灵接口
		 * @param id	精灵ID
		 */
		public static function addFairy(id:int):void {
			if(BaseInfo.isTestLogin) {
				FairyListVO.testAddFairy(id);
			} else {
				MainNC.getInstance().sendInfo(ID, {code:"1", templateId:id});
				get_fairys();
			}
		}
	}
}
