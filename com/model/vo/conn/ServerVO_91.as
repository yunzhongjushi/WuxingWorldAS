package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.tip.TipVO;
	
	/**
	 * 战斗相关
	 * @author hunterxie
	 */
	public class ServerVO_91{
		public static const INTO_FIGHT:String = "正在进入关卡......";
		public static const RESULT_FIGHT:String = "正在请求闯关结果......";
		public static const CNN_FIGHT_OUT_TIME:String = "战斗请求连接超时......";
		
		public static var ID:int = 0x5b;
		
		
		//战斗相关二级协议(code)
		public static var FIGHT_CREATE:int 				= 0x01;// 创建游戏load游戏(请求)
		public static var FIGHT_START:int 				= 0x05;// 游戏开始(PVP)
		public static var FIGHT_MOVE:int 					= 0x02;// 用户单次行动
		public static var FIGHT_OVER:int 					= 0x04;// 游戏结束(server传过来)
		public static var FIGHT_RESET:int 				= 0x06;// 棋子信息出错，整盘信息还原(PVP,server传)
		public static var FIGHT_ERROR:int 				= 0x03;// 游戏出错，用户操作的精灵对应的用户ID不匹配(PVP)
		public static var FIGHT_FAIL:int 					= 0x07;// 闯关失败
		
		
		//战斗相关三级协议(gameType)
		public static var FIGHT_TYPE_PVP:int 				= 0x01;// PVP
		public static var FIGHT_TYPE_PVE:int 				= 0x02;// PVE闯关
		public static var FIGHT_TYPE_PUZZLE:int 			= 0x03;// 解谜闯关
		public static var FIGHT_TYPE_SKILL:int 			= 0x04;// 学习技能闯关
		public static var FIGHT_TYPE_LOTTERY:int 			= 0x05;// 抽奖闯关
		public static var FIGHT_TYPE_BUILD:int 			= 0x06;// 打造闯关
		
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		private static var nowSendInfo:Object;
		
		/**
		 * 战斗信息
		 * 一级协议：0x5b
			参数：
			kind:int;//0:金，1:木，2:土，3:水，4火:
			返回：
			attr:[0,0,0,0,0];//当前分配好的五行属性点：[金，木，土，水，火]
			attrNum:int;//当前剩余可分配点数
			returnCode:int;//0:失败，1：成功
		 */
		public function ServerVO_91(obj:Object) {
			switch(obj.code){
				case FIGHT_START:
					MainNC.closeLodingPanel(INTO_FIGHT);
					break;
				case FIGHT_OVER:
					MainNC.closeLodingPanel(RESULT_FIGHT);
					break;
				case FIGHT_ERROR:
					MainNC.closeLodingPanel(RESULT_FIGHT);
					MainNC.closeLodingPanel(INTO_FIGHT);
					TipVO.showChoosePanel(new TipVO("连接超时", "连接超时，您要重新发送请求吗!", ServerVO_91.CNN_FIGHT_OUT_TIME));
					trace("游戏出错:"+obj.error);
					break;
				case FIGHT_FAIL:
					MainNC.closeLodingPanel(RESULT_FIGHT);
					MainNC.closeLodingPanel(INTO_FIGHT);
					trace("闯关失败!!!");
					break;
				
			}
		}
		
		public static function sendInfo(info:Object, loadingInfo:String=""):void{
			if(BaseInfo.isTestLogin) return;
			nowSendInfo = info;
			MainNC.getInstance().sendInfo(ID, info, loadingInfo);
		}
		
		/**
		 * 发送给server战斗行动（一回合）
		 * @return 
		 */
		public static function fightMove(info:Object):void{
			sendInfo(info);
		}
		
		/**
		 * 发送给server战斗开局
		 * @return 
		 */
		public static function fightStart(info:Object):void{
			sendInfo(info, INTO_FIGHT);
		}
		
		/**
		 * 向后台发送战斗数据
		 * @param info
		 */
		public static function getFightResult(info:Object):void{
			sendInfo(info, RESULT_FIGHT);
		}
		
		/**
		 * 向后台发送解谜关卡数据
		 * @param info
		 */
		public static function getPuzzleResult(info:Object):void{
			sendInfo(info, RESULT_FIGHT);
		}
	}
}
