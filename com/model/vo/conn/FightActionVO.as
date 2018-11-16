package com.model.vo.conn {
	import com.model.vo.WuxingVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.fight.FairySkillVO;
	
	import flas.events.EventDispatcher;

	/**
	 * 玩家行动指令
	 * @author hunterxie
	 */
	public class FightActionVO extends EventDispatcher{
		public static const NAME:String = "FightActionVO";
		public static const SINGLETON_MSG:String="single_FightActionVO_only";
		protected static var instance:FightActionVO;
		public static function getInstance():FightActionVO{
			if ( instance == null ) instance = new FightActionVO();
			return instance;
		}
		
		
		/**
		 * 收到用户操作信息
		 * @author xie
		 */
		public static const SHOW_FIGHT_ACTION:String="SHOW_FIGHT_ACTION";
		
		
		/**
		 * 目标(观察的)精灵，在左边显示
		 */
		public var actionFairyID:int;
		/**
		 * 目标精灵
		 */
		public var tarFairyID:int;
		/**
		 * 棋盘行动+技能使用
		 */
		public var actions:Array;
		
		/**
		 *{fairyID:userID, tarFairyID:0, code:ServerVO_91.FIGHT_MOVE, actions:"exc:5:5:6:5,exc:4:6:4:5,exc:6:4:6:3,fall,fall,turnover"} 
		 * @param info
		 * @return 
		 */		
		public function FightActionVO() {
		}
		
		public static function show(fairy1:int, tar:int, actions:String):void{
			trace("收到玩家对局操作：", actions);
			getInstance().actionFairyID = fairy1;
			instance.tarFairyID = tar;
			instance.actions = actions.split(",");
			instance.event(SHOW_FIGHT_ACTION);
		}
		
		/**
		 * 发送给后台 
		 */
		public static function send(fairy1:int, tar:int, actions:String):void{
			
		}
	}
}
