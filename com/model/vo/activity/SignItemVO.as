package com.model.vo.activity {
	import com.model.vo.item.ItemVO;

	/**
	 * 单个签到格子
	 */
	public class SignItemVO extends ItemVO {
		public static const SIGNED:String="signed";
		public static const AVAILABLE:String="available";
		public static const NO_AVAILABLE:String="noAvailable";

		/**
		 *  奖励的ItemVO
		 */
//		public var containItemVO:ItemVO;
		/**
		 * 格子所在序号
		 */
		public var signID:int;
		/**
		 * 该格子签到状态，有已签、可签、不可签
		 */
		public var status:String;
		
		/**
		 * 奖励的物品数量
		 */
		public var itemNum:int;

		public function SignItemVO(info:Object) {
			super(info.id);
			this.itemNum = info.num;

//			var xml:XML=BaseInfo.getSignRewardInfo(id);
//
//			if(xml==null)
//				return;
//
//			var id:int=int(xml.@ID);
//			var templateID:int=int(xml.@RewardItemID_1);
//			var num:int=int(xml.@RewardItemNum_1);
//			var fairyID:int=int(xml.@RewardPetID);
//			var fairy_num:int=int(xml.@RewardPetNum);
//			var gold:int=int(xml.@RewardGold);
//
//			if(templateID!=0) {
//				containItemVO=ItemVO.getItemVO(templateID, num);
//			}else if(fairyID!=0) {
//				containItemVO=new ItemFairyVO(fairyID);
//			}else if(gold!=0) {
//				containItemVO=ItemResourceVO.getGold(gold);
//			}
//
//			super.name=containItemVO.name;
//			super.pic=containItemVO.pic;
		}

		/**
		 * 标记为已签到
		 *
		 */
		public function updateSign():void {
			status=SIGNED;
		}

		/**
		 * 更新信息
		 * @param signID		序号
		 * @param curAvailNO	当前可签到的格子范围
		 * @param markNO		已经签到的格子范围
		 */
		public function updateInfo(signID:int, curAvailNO:Object, markNO:Object):void {
			this.signID=signID;
			status=NO_AVAILABLE;

			if(curAvailNO) {
				if(signID==curAvailNO)
					status=AVAILABLE;
			}

			if(markNO) {
				if(signID<=markNO)
					status=SIGNED;
			}
		}
	}
}
