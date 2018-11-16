package com.model.vo.config.mission {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.config.item.ItemConfig;

	/**
	 * 成就奖励配置信息
	 * @author hunterxie
	 */
	public class AchievementRewardConfigVO extends BaseObjectVO{
		/**
		 * 物品ID
		 */
		public var id:int = 3;
		/**
		 * 物品名
		 */
		public var label:String = "live";
		/**
		 * 掉落数量
		 */
		public var num:int = 1;
		
		
		public function AchievementRewardConfigVO(info:Object=null) {
			super(info);
		}
		
		public static function getTestVO(id:int, num:int):AchievementRewardConfigVO{
			var item:ItemConfigVO = ItemConfig.getItemConfigByID(id);
			var vo:AchievementRewardConfigVO = new AchievementRewardConfigVO;
			vo.id = id;
			vo.num = num;
			vo.label = item.label;
			return vo;
		}
	}
}
