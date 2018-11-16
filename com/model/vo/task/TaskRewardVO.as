package com.model.vo.task {
	import com.model.vo.item.ItemResourceVO;
	import com.model.vo.item.ItemVO;

	/**
	 * 成就奖励信息
	 * @author hunterxie
	 */
	public class TaskRewardVO {
		public static const DESCRIPTION_TIP:String="DESCRIPTION_TIP";
		public static const DESCRIPTION_BAR:String="DESCRIPTION_BAR";

		private var RewardItemID_1:int;
		private var RewardItemNum_1:int;

		private var RewardItemID_2:int;
		private var RewardItemNum_2:int;

		private var RewardItemID_3:int;
		private var RewardItemNum_3:int;
		private var RewardGP:int;
		private var RewardGold:int;
		private var RewardEnergy:int;
		private var RewardJIN:int;
		private var RewardMU:int;
		private var RewardTU:int;
		private var RewardSHUI:int;
		private var RewardHUO:int;
		private var RewardBuffID:int;

		public var itemVOList:Array = [];

		public function TaskRewardVO(data:XML=null) {
			if(!data) return;
			RewardItemID_1 =	data.@RewardItemID_1;
			RewardItemNum_1	=	data.@RewardItemNum_1;
			RewardItemID_2=		data.@RewardItemID_2;
			RewardItemNum_2=	data.@RewardItemNum_2;
			RewardItemID_3=		data.@RewardItemID_3;
			RewardItemNum_3=	data.@RewardItemNum_3;
			RewardGP=			data.@RewardGP;
			RewardGold=			data.@RewardGold;
			RewardEnergy=		data.@RewardEnergy;
			RewardJIN=			data.@RewardJIN;
			RewardMU=			data.@RewardMU;
			RewardTU=			data.@RewardTU;
			RewardSHUI=			data.@RewardSHUI;
			RewardHUO=			data.@RewardHUO;
			RewardBuffID=		data.@RewardBuffID;

//			if(RewardItemID_1!=0) {
//				itemVOList.push(ItemVO.getItemVO(RewardItemID_1, RewardItemNum_1));
//			}
//			if(RewardItemID_2!=0) {
//				itemVOList.push(ItemVO.getItemVO(RewardItemID_2, RewardItemNum_2));
//			}
//			if(RewardItemID_3!=0) {
//				itemVOList.push(ItemVO.getItemVO(RewardItemID_3, RewardItemNum_3));
//			}
//			if(RewardGP!=0) {
//				itemVOList.push(ItemResourceVO.getHumanExp(RewardGP));
//			}
//			if(RewardGold!=0) {
//				itemVOList.push(ItemResourceVO.getGold(RewardGold));
//			}
//			if(RewardEnergy!=0) {
//				itemVOList.push(ItemResourceVO.getEnergy(RewardEnergy));
//			}
//			if(RewardJIN!=0) {
//				itemVOList.push(ItemResourceVO.getWuxing(RewardJIN, 0));
//			}
//			if(RewardMU!=0) {
//				itemVOList.push(ItemResourceVO.getWuxing(RewardMU, 1));
//			}
//			if(RewardTU!=0) {
//				itemVOList.push(ItemResourceVO.getWuxing(RewardTU, 2));
//			}
//			if(RewardSHUI!=0) {
//				itemVOList.push(ItemResourceVO.getWuxing(RewardSHUI, 3));
//			}
//			if(RewardHUO!=0) {
//				itemVOList.push(ItemResourceVO.getWuxing(RewardHUO, 4));
//			}
		}

		public function getDescription(descriptionType:String):String {
			var itemVO:ItemVO;
			var str:String;
			var numPerLine:int=1;
			var temp:int=1;
			if(descriptionType==DESCRIPTION_BAR) {
				str="奖励  ";
				numPerLine=2;
			} else if(descriptionType==DESCRIPTION_TIP) {
				str="";
				numPerLine=1;
			}

			if(RewardItemID_1!=0) {
				itemVO=ItemVO.getItemVO(RewardItemID_1);
				str=str.concat(itemVO.data.label, " x ", RewardItemNum_1);
				wrapStr()
			}
			if(RewardItemID_2!=0) {
				itemVO=ItemVO.getItemVO(RewardItemID_2);
				str=str.concat(itemVO.data.label, " x ", RewardItemNum_2);
				wrapStr()
			}
			if(RewardItemID_3!=0) {
				itemVO=ItemVO.getItemVO(RewardItemID_3);
				str=str.concat(itemVO.data.label, " x ", RewardItemNum_3);
				wrapStr()
			}
			if(RewardGP!=0) {
				str=str.concat("经验", " + ", RewardGP);
				wrapStr()
			}
			if(RewardGold!=0) {
				str=str.concat("钻石", " + ", RewardGold);
				wrapStr()
			}
			if(RewardEnergy!=0) {
				str=str.concat("精力", " + ", RewardEnergy);
				wrapStr()
			}
			if(RewardJIN!=0) {
				str=str.concat("金元素", " + ", RewardJIN);
				wrapStr()
			}
			if(RewardMU!=0) {
				str=str.concat("木元素", " + ", RewardMU);
				wrapStr()
			}
			if(RewardTU!=0) {
				str=str.concat("土元素", " + ", RewardTU);
				wrapStr()
			}
			if(RewardSHUI!=0) {
				str=str.concat("水元素", " + ", RewardSHUI);
				wrapStr()
			}
			if(RewardHUO!=0) {
				str=str.concat("火元素", "+ ", RewardHUO);
				wrapStr()
			}
			if(str.length>=1) {
				str=str.slice(0, str.length-1)
			}
			return str;
			function wrapStr():void {
				if(temp>=numPerLine) {
					str+="\n"
					temp=1
				} else {
					str+="  "
					temp++
				}
			}
		}
	}
}
