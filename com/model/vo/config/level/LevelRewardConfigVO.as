package com.model.vo.config.level {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.item.ItemBaseVO;

	/**
	 * 关卡奖励配置信息
	 * @author hunterxie
	 */
	public class LevelRewardConfigVO extends BaseObjectVO {
		/**
		 * 通用关卡掉落配置
		 */
		public static var rewardGeneral:LevelRewardConfigVO;
		public static function setGeneralReward(info:Object):void{
			rewardGeneral = new LevelRewardConfigVO;
			rewardGeneral.updateObj(info);
//			rewardGeneralArr = [];
//			for(var i:int=0; i<arr.length; i++){
//				rewardGeneralArr.push(new LevelRewardBaseVO(arr[i]));
//			}
		}
		
		/**
		 * 过关一星奖励
		 */
		public var reward1:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
		
		/**
		 * 过关三星奖励
		 */
		public var reward3:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
		
		/**
		 * 过关奖励
		 */
		public var rewards:Array = BaseObjectVO.getClassArray(LevelRewardBaseVO);
		
		/**
		 * 
		 * 
		 */
		public function LevelRewardConfigVO(info:Object=null) {
			super(info);
		}
		
		public function judgeHaveReward(id:int):Boolean{
			return judgeHava(this.rewards, id) || judgeHava(this.reward1, id) || judgeHava(this.reward3, id);
		}
		private function judgeHava(arr:Array, id:int):Boolean{
			for(var i:int=0; i<arr.length; i++){
				var vo:LevelRewardBaseVO = arr[i] as LevelRewardBaseVO;
				if(vo.ID==id) return true;
			}
			return false;
		}
		
		/**
		 * 模拟闯关奖励
		 * @param id 配置id
		 * @return 
		 */
		public function getTestRewards(star1:Boolean=true, star3:Boolean=true):Array{
			var arr:Array = [];
			getRewards(rewardGeneral.rewards, arr);
			getRewards(rewards, arr);
			if(star1){
				getRewards(rewardGeneral.reward1, arr);
				getRewards(reward1, arr);
			}
			if(star3){
				getRewards(rewardGeneral.reward3, arr);
				getRewards(reward3, arr);
			}
			return arr;
		}
		/**
		 * 
		 * @param arr		奖励配置
		 * @param total		奖励获得
		 * @return 
		 */
		private function getRewards(arr:Array, total:Array):void{
			for(var i:int=0; i<arr.length; i++){
				var vo:LevelRewardBaseVO = arr[i] as LevelRewardBaseVO;
				var num:int = vo.testReward();
				if(num>0){
					var judge:Boolean = false;
					for(var j:int=0; j<total.length; j++){
						var reward:ItemBaseVO = total[j] as ItemBaseVO;
						if(reward._itemID == vo.ID){
							reward.num+=num;
							judge = true;
							break;
						}
					}
					if(!judge){
						total.push(new ItemBaseVO(vo.ID, num));
					}
				}
			}
		}
	}
}
