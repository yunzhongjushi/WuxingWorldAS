package com.model.vo.config.lvs{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 玩家/精灵等级配置信息
	 * @author hunterxie
	 */
	public class LVConfigVO extends BaseObjectVO{
		public static var PLAYER_EXP:String = "playerExp";
		public static var FAIRY_EXP_0:String = "fairyExp0";
		public static var FAIRY_EXP_1:String = "fairyExp1";
		public static var FAIRY_EXP_2:String = "fairyExp2";
		public static var FAIRY_EXP_3:String = "fairyExp3";
		public static var FAIRY_EXP_4:String = "fairyExp4";
		public static var FAIRY_EXP_5:String = "fairyExp5";
		public var lv:int = 0;
		public var playerExp:int = 0;
		public var fairyExp0:int = 0;
		public var fairyExp1:int = 0;
		public var fairyExp2:int = 0;
		public var fairyExp3:int = 0;
		public var fairyExp4:int = 0;
		public var fairyExp5:int = 0;
		
		
		/**
		 * 
		 * @param info
		 */
		public function LVConfigVO(info:Object=null):void{
			super(info);
		}
	}
}