package com.model.vo.fairy {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.FairyEquipVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.level.LevelRewardVO;
	import com.model.vo.user.UserVO;



	/**
	 * 静态变量精灵记录列表
	 * @author hunterxie
	 */
	public class FairyListVO extends BaseObjectVO {
		public static const NAME:String="FairyListVO";
		public static const SINGLETON_MSG:String="single_FairyListVO_only";
		protected static var instance:FairyListVO;
		public static function getInstance():FairyListVO {
			if(instance==null) instance=new FairyListVO();
			return instance as FairyListVO;
		}

		/**
		 * 玩家精灵总数量
		 */
		public static function get fairyNum():int {
			return getInstance()._fairyList.length;
		}
		public static function get firstFairy():BaseFairyVO{
			return getInstance()._fairyList[0];
		}
		public static function get fairyList():Array{
			return getInstance()._fairyList.concat();
		}


		public static const UPDATE_FAIRYS_INFO:String="UPDATE_FAIRYS_INFO";
		
		/**
		 * 开启的作战精灵槽位
		 */
		public var fairyOpenNum:int = 1;
		
		/**
		 * 拥有的精灵列表
		 * @see com.model.vo.fairy.BaseFairyVO
		 */
		private var _fairyList:Array=[];
		
		/**
		 * 拥有的精灵基础表,数组内容为 BaseFairyInfoVO
		 * @see com.model.vo.fairy.BaseFairyInfoVO
		 */
		public var fairys:Array = BaseObjectVO.getClassArray(FairySaveVO);

		/**
		 * 出战精灵列表,数组内容为精灵ID
		 */
		public var fightFairys:Array=[];

		private static function get userInfo():UserVO {
			return UserVO.getInstance();
		}


		/**
		 * 精灵列表
		 */
		public function FairyListVO() {
			if(instance!=null) throw Error(SINGLETON_MSG);
			instance=this;

		}

//		/**
//		 * 更新从服务器收到的单个精灵信息
//		 * @param info
//		 */
//		public function updateSingleFairyInfoByServer(info:Object):void {
//			var i:int=0;
//			var vo:BaseFairyVO;
//			if(info["pet"]) {
//				var pet:Object=info["pet"];
//				vo=_fairyList[pet.Place];
//				if(!vo) {
//					vo=_fairyList[pet.Place]=new BaseFairyVO(pet.PetID, pet.PetTemplateID, parseInt(pet.PetLevel), pet.MasterID);
//				}
//				vo.updateInfoByServer(pet);
//				fairys[pet.Place]=vo.baseInfo;
//			}
//			this.dispatchUpdate();
//		}

		/**
		 * 更新从服务器收到的所有精灵信息
		 * @param info
		 */
		public function updateFairyInfoByServer(info:Object):void {
			var i:int=0;
			var vo:FairySaveVO;
//			var vo:BaseFairyVO;
//			while(_fairyList.length)
//				_fairyList.pop();
//			while(fairys.length)
//				fairys.pop();
			while(info["pet"+i]) {
				var pet:Object=info["pet"+i];
				vo = fairys[pet.Place];
				if(!vo){
					vo = fairys[pet.Place] = new FairySaveVO;
				}
				vo.updateByServer(pet);
				updateSingle(vo, pet.Place);
//				if(_fairyList[pet.Place]) {
//					vo=_fairyList[pet.Place];
//				} else {
//					vo=_fairyList[pet.Place]=new BaseFairyVO(pet.PetID, pet.PetTemplateID, parseInt(pet.PetLevel), pet.MasterID);
//				}
//				vo.updateInfoByServer(pet);
//				fairys[pet.Place]=vo.baseInfo;
				i++;
			}
			this.dispatchUpdate();
		}


		public function updateSingle(vo:FairySaveVO, index:int=-1):void {
			var fairy:BaseFairyVO;
			if(index==-1){
				index=0;
				for(var i:int=0; i<_fairyList.length; i++, index=i){
					if(vo.ID==_fairyList[i].ID){
						fairy = _fairyList[i];
						break;
					}
				}
			}else{
				fairy = _fairyList[index];
			}
			if(!fairy){
				fairy =_fairyList[index] = new BaseFairyVO(vo.ID, vo.originID, vo.LV, userInfo.userID);
				fairys[index] = vo;
			}
			fairy.baseInfo = vo;
		}
		public function updateAll(arr:Array):void {
			for(var i:int=0; i<arr.length; i++){
				updateSingle(arr[i]);
			}
		}
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			updateAll(fairys);
		}

		/**
		 * 通过精灵ID获取精灵VO
		 * @param id
		 * @return
		 */
		public static function getFairy(id:int):BaseFairyVO {
			for(var i:int=0; i<instance._fairyList.length; i++) {
				var vo:BaseFairyVO=instance._fairyList[i];
				if(vo&&vo.ID==id) {
					return vo;
				}
			}
			return null;
		}

		/**
		 * 通过精灵模版ID获取精灵VO
		 * @param id
		 * @return
		 */
		public static function getOriginFairy(originID:int):BaseFairyVO {
			for(var i:int=0; i<instance._fairyList.length; i++) {
				var vo:BaseFairyVO=instance._fairyList[i];
				if(vo&&vo.originID==originID) {
					return vo;
				}
			}
			return null;
		}

		/**
		 * 当前出战精灵列表
		 * @return
		 */
		public static function getFightFairy():Array {
			var arr:Array=[];
			return arr;
		}

		/**
		 * 模拟加经验
		 * @param fairyID
		 * @param value
		 *
		 */
		public static function testAddExp(fairyID:int, value:int):void {
			if(fairyID==0) {
				for(var i:int=0; i<instance._fairyList.length; i++) {
					(instance._fairyList[i] as BaseFairyVO).testAddExp(value);
				}
			} else {
				var vo:BaseFairyVO=getFairy(fairyID);
				if(vo)
					vo.testAddExp(value);
			}
		}

		/**
		 * 模拟强化
		 * @param fairyID
		 *
		 */
		public static function testStrengthen(fairyID:int, strengthenToLV:int):void {
			var vo:BaseFairyVO=getFairy(fairyID);
			if(vo)
				vo.starLV=strengthenToLV;
		}

		/**
		 * 模拟装备
		 * @param fairyID
		 */
		public static function testEquip(fairyID:int, equipVO:FairyEquipVO):void {
			var vo:BaseFairyVO=getFairy(fairyID);
			if(vo)
				vo.equipChange(equipVO);
		}

		/**
		 * 模拟进阶
		 * @param fairyID
		 */
		public static function testUpgrade(fairyID:int):void {
			var vo:BaseFairyVO=getFairy(fairyID);
			if(vo)
				vo.upgradeIntensLV();
		}

		/**
		 * 模拟升级技能<br>
		 * 单机模式下 与 单次使用模拟
		 * @param fairyID
		 */
		public static function testLevelupSkill(vo:UpgradeSkillVO):void{//fairyID:int, skillPlace:int, targetLV:int):void {
			var fairy:BaseFairyVO=getFairy(vo.fairyVO.ID);
			if(fairy && UserVO.testAddResource(vo.wuxing, vo.getUpgradeSkillCost()*-1)){
				fairy.upgradeSkillLV(vo.skillPosition, vo.getTargetLV());
			}
		}
		
		/**
		 * 根据精灵碎片ID判断是否可以合成
		 * @param vo 精灵碎片
		 * @param isSynthesis 是否马上合成
		 * @return 大于0表示可以合成
		 */
		public static function canSynthesisNewFairy(vo:ItemVO, isSynthesis:Boolean=false):int {
			var fairyID:int = ItemConfigVO.getFairyByPiece(vo.templateID);
			if(fairyID!=-1 && vo.num>=BaseInfo.GEN_FAIRY_COST) {
				for each(var fairyVO:BaseFairyVO in instance._fairyList) {
					if(fairyVO.originID==fairyID){
						if(isSynthesis){
							if(testAddFairy(fairyID)){
								ItemListVO.testUseItem(vo, BaseInfo.GEN_FAIRY_COST);
							}
						}
						return fairyID;
					}
				}
			}
			return 0;
		}

		/**
		 * 本地添加精灵
		 * @param fairyID
		 * @return 
		 */
		public static function testAddFairy(fairyID:int):Boolean {
			if(!getOriginFairy(fairyID)) {
				var vo:BaseFairyVO=new BaseFairyVO(Math.floor(Math.random()*99999), fairyID, 1, userInfo.userID);
				instance._fairyList.push(vo);
				instance.fairys.push(vo.baseInfo);

				//	新获得精灵提示，物品信息改动时需要更新数据
				TipFairyVO.getInstance().updateModifyInfo(null, [vo]);

				instance.dispatchUpdate();
				return true;
			}
			return false;
		}

		/**
		 * 模拟提升精灵等级
		 * @param ID
		 */
		public static function testLevelupFairy(vo:LevelupFairyVO):void {
			UserVO.testAddResource(vo.fairyVO.wuxing, -vo.fairyVO.needExp);
			var fairy:BaseFairyVO = getFairy(vo.fairyVO.ID)
			fairy.testAddExp(fairy.needExp);
		}
		
		/**
		 * 本地添加战斗结束后的模拟精灵奖励
		 * @param vo
		 */
		public static function testAddReward(vo:LevelRewardVO):void{
			if(vo.fairys.length>0){
				for(var i:int=0; i<vo.fairys.length; i++){
					var fairy:int = vo.fairys[i];
					testAddFairy(fairy);
				}
				instance.dispatchUpdate();
			}
		}
		
		public function dispatchUpdate():void{
			event(UPDATE_FAIRYS_INFO);
		}
	}
}
