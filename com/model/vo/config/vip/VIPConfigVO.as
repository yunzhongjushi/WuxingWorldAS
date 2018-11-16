package com.model.vo.config.vip {
	import com.model.vo.BaseObjectVO;

	/**
	 * 单个VIP等级配置信息
	 * @author hunterxie
	 */
	public class VIPConfigVO extends BaseObjectVO{

		/**
		 * 对应的VIP等级
		 */
		public var lv:int;
		/**
		 * 冲钻数，达到viplv对应需要的数量
		 */
		public var chager:int;
		/**
		 * 每天购买精力值次数
		 */
		public var addEnergyCount:int;
		/**
		 * 技能觉醒几率
		 */
		public var skillOdds:int;
		/**
		 * 每天扫荡次数
		 */
		public var mopUp:int;
		/**
		 * 重置竞技场次数
		 */
		public var restPVPCount:int;
		/**
		 * 闯塔次数
		 */
		public var passMissionCount:int;
		/**
		 * 每日领取精力值（废）
		 */
		public var addEnergyValue:int;
		/**
		 * 每天时间暂停（废）
		 */
		public var timeSuspend:int;
		/**
		 * 消除提示（废）
		 */
		public var EliminateTips:int;
		/**
		 * 五行资源购买次数（废）
		 */
		public var buyWuxingResCount:int;
		/**
		 * 祭坛召唤次数（废）
		 */
		public var altarPetCount:int;
		/**
		 * 五行资源购买收益比（废）
		 */
		public var buyWuxingResOdds:int;
		/**
		 * 说明信息
		 */
		public var info:String;
		
		
		
		public function VIPConfigVO(info:Object=null) {
			super(info);
		}
	}
}
