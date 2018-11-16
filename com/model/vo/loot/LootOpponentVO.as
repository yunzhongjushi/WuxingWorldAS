package com.model.vo.loot {
	import com.model.vo.altar.FairyTemplateVO;


	public class LootOpponentVO {
		public static const FAIRY_ID_NULL:int=-1;
		public static const POS_1:String="FAIRY_POS_1";
		public static const POS_2:String="FAIRY_POS_2";
		public static const POS_3:String="FAIRY_POS_3";
		public var oppoName:String;
		private var resourceArr:Array;
		private var winScore:int;
		private var lostScore:int;
		private var rank:int;
		public var playerID:int;
//		private var fairy_1:FairyVO;
//		private var fairy_2:FairyVO;
//		private var fairy_3:FairyVO;
		private var fairyIDObj:Object={}
		private var fairyObj:Object={}

		public function LootOpponentVO(playerID:int, oppoName:String, resourceArr:Array, rank:int, fairyID_1:int, fairyID_2:int, fairyID_3:int) {
			this.playerID=playerID;
			this.oppoName=oppoName;
			this.resourceArr=resourceArr;
			this.rank=rank;
			fairyIDObj[POS_1]=fairyID_1;
			fairyIDObj[POS_2]=fairyID_2;
			fairyIDObj[POS_3]=fairyID_3;
			//获取守护兽信息
			fairyObj[POS_1]=FairyTemplateVO.genProtectorFairyVO(5, 1);
		}

		public function updateRank(lootVO:LootVO):void {
			var rankDiff:int=lootVO.rank-rank;
			var failFactor:Number=1/(0.5*Math.pow(1.006, -1*rankDiff)+0.5);
			var successFactor:Number=1/(0.5*Math.pow(1.006, rankDiff)+0.5);
			//win
			var winBase:int=20;
			winScore=winBase*successFactor;
			//lose
			var lostBase:Number;
			if(lootVO.rank>=1025) {
				lostBase=-20;
			} else {
				lostBase=((25-lootVO.rank)/50)>=0?0:((25-lootVO.rank)/50);
			}
			lostScore=lostBase*failFactor;
		}

		/**
		 *
		 * @param NO
		 * 如0，1，2
		 * @return
		 *
		 */
		public function getFairyID(pos:String):int {
			return fairyIDObj[pos];
		}

		public function setFairyVO(fairyVO:FairyTemplateVO, pos:String):void {
			fairyObj[pos]=fairyVO;
		}

		public function getFairyVO(pos:String):FairyTemplateVO {
			var fairyVO:FairyTemplateVO=fairyObj[pos] as FairyTemplateVO
			if(fairyVO==null)
				return FairyTemplateVO.genEmptyFairyVO();
			return fairyVO
		}

		public function getWin():int {
			return winScore;
		}

		public function getLost():int {
			return lostScore;
		}

		public function getResource(attr:int):int {
			return resourceArr[attr];
		}

	}
}
