package com.model.vo.activity {


	/**
	 * 签到信息VO
	 * @author CC5
	 *
	 */
	public class SignInfoVO {
		/**
		 * 当前可签到格子的序数
		 */
		public var currentNO:int;
		/**
		 * 当前已经签到格子的序数
		 *
		 * 如果可领取奖励，等于“当前可签到格子的序数”-1
		 * 如果已经领取过奖励，等于“当前可签到格子的序数”
		 */
		public var markNO:int;
		/**
		 *
		 */
		public var canGetReward:Boolean;

		private var voList:Array;

		public function SignInfoVO(currentNO:int, markNO:int, canGetReward:Boolean) {
			this.markNO=markNO;
			this.currentNO=currentNO;
			this.canGetReward=canGetReward;
		}

		public function getSignBarVoList():Array {
			if(voList==null) {
				voList=[];

				for(var i:int=1; i<=31; i++) {
					var signVO:SignItemVO = new SignItemVO(i);
					if(signVO!=null) {
						signVO.updateInfo(i, currentNO, markNO);
						voList.push(signVO);
					}
				}
			}
			return voList;
		}
	}
}
