package com.model.vo.config.level {
	import com.model.vo.BaseObjectVO;


	/**
	 * 关卡奖励配置信息
	 * @author hunterxie
	 */
	public class LevelRewardBaseVO extends BaseObjectVO{
		/**物品ID*/
		public var ID:int = 3;
		/**物品名*/
		public var label:String = "live";
		/**掉落概率*/
		public var chance:Number = 1;
		/**最低掉落数量*/
		public var numMin:int = 1;
		/**最大掉落数量*/
		public var numMax:int = 1;
		
		
		public function LevelRewardBaseVO(info:Object=null) {
			super(info);
		}
		
		/**
		 * 测试自己是否获得奖励
		 * @return 返回奖励数量
		 */
		public function testReward():int{
			if(Math.random()<chance){
				return numMin+Math.floor(Math.random()*(numMax-numMin));
			}
			return 0;
		}
		
		
	}
}
