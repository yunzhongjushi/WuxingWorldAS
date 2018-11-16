package com.model.vo.altar {

	public class RewardVO {
		public var fairyVoArr:Array;
		public var luckEventID:int;
		public var luckEventDescription:String
		public var challengeRewardID:int;
		public var challengeRewardDescription:String

		public function RewardVO(fairyVoArr:Array, luckEventID:int, challengeRewardID:int) {
			this.fairyVoArr=fairyVoArr;
			this.luckEventID=luckEventID;
			this.challengeRewardID=challengeRewardID;
			luckEventDescription="幸运事件ID:"+luckEventID
			challengeRewardDescription="挑战奖励ID:"+challengeRewardID
		}

		public function getLuckEventStr():String {
			return luckEventDescription
		}

		public function getChallengeRewardStr():String {
			return challengeRewardDescription
		}

		public function getFairy(index:int=0):FairyTemplateVO {
			if(index<=(fairyVoArr.length-1)) {
				return fairyVoArr[index]
			}
			return null;
		}
	}
}
