package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.friend.FriendListVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.friend.FriendList;
	import com.view.UI.tip.TipPanel;
	
	import flas.utils.Timer;
	
	/**
	 * 房间相关一级协议，撮合战斗+邀请战斗
	 * @author hunterxie
	 */
	public class ServerVO_4{
		//房间相关二级协议
		public static var GAME_ROOM_CREATE:int 			= 0x00;// 创建房间
		public static var GAME_ROOM_LOGIN:int 			= 0x01;// 进入房间
		public static var GAME_ROOM_SETUP_CHANGE:int 		= 0x02;// 房间设置
		public static var GAME_ROOM_KICK:int 				= 0x03;// 踢出房间0
		public static var GAME_PLAYER_ENTER:int 			= 0x04;// 玩家进入1
		public static var GAME_PLAYER_EXIT:int 			= 0x05;// 玩家退出
		public static var GAME_TEAM:int					= 0x06;// 玩家选队
		public static var GAME_START:int 					= 0x07;// 游戏开始0
		public static var UPDATE_ROOM_LIST:int 			= 0x09;// 玩家刷新房间列表
		public static var GAME_ROOM_UPDATE_PLACE:int 		= 0x0a;// 改变房间位置状态
		public static var GAME_PAIRUP_CANCEL:int 			= 0x0b;// 摄合取消
		public static var GAME_PAIRUP_ROOM_SETUP:int 		= 0x0c;// 摄合房间设置
		public static var GAME_PAIRUP_START:int 			= 0x0d;// 摄合等待1
		public static var GAME_ROOM_PASSWORD:int 			= 0x0e;// 房间密码1
		public static var GAME_PLAYER_STATE:int 			= 0x0f;// 玩家状态改变
		public static var GAME_ROOM_CLEAR:int 			= 0x10;// 房间清理1
		public static var GAME_ROOM_CREATE_MAX:int 		= 0x11;// 创建房间已满
		/**
		 * 立即撮合，创建房间直接撮合
		 */
		public static var GAME_PAIRUP_STARTING:int 		= 0x12;
		/**
		 * 邀请/被邀请玩家开始游戏
		 */
		public static var GAME_PAIRUP_INVIT:int 			= 0x14;
		/**
		 * 被邀请人返回邀请
		 */
		public static var GAME_PAIRUP_INVIT_RESULT:int 	= 0x15;
		/**
		 * 取消对某人的战斗邀请
		 */
		public static var GAME_PAIRUP_INVIT_CANCEL:int 	= 0x16;
		
		
		
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		public static var ID:int = 0x04;
		/**
		 * 返回请求是否成功
		 */
		public var returnCode:Boolean = true;
		
		/**
		 * 邀请中的用户ID
		 */
		private static var inviteUserID:int;
		
		/**
		 * 请求修改装备技能
		 * 一级协议号:0x04
			二级协议号:0x14//邀请
			请求参数:
			InvitationPlayerId (被邀请人ID)
					
		    返回:
			邀请人和被邀请人均收到一条邀请结果消息,如被邀请人不在线则只发送给邀请人消息
			参数
			ret(0表示邀请成功 1表示不可邀请)
			InvitationId(邀请人ID)
		 */
		public function ServerVO_104(obj:Object) {
			switch(obj.code){
				case GAME_PAIRUP_STARTING:
					break;
				case GAME_PAIRUP_INVIT:
					if(obj.ret==1){//邀请失败，对方不在线或者在战斗中
						TipPanel.showPanel("战斗邀请", "对方不在线或者在战斗中");
					}else if(obj.ret==0){//成功发出邀请/受到邀请
						var inviteID:int = parseInt(obj.InvitationId);
						if(userInfo.userID==inviteID){//成功发出邀请
							trace("成功发出对："+inviteUserID+"的邀请:");
							FriendListVO.updateInviteInfo(inviteUserID);
						}else{//收到邀请
							trace("收到来自："+inviteID+"的对战邀请！");
							FriendListVO.beInvited(inviteID);
						}
					}
					break;
				case GAME_PAIRUP_INVIT_RESULT:
					var inviteID:int = parseInt(obj.InvitationId);
					if(obj.ret==1){//邀请失败，对方拒绝邀请
						TipPanel.showPanel("战斗邀请", inviteID+"拒绝了你的战斗邀请！");
						FriendListVO.inviteRefuse(inviteID);
					}if(obj.ret==2){//同意但是对方已经下线或者先一步取消邀请
						TipPanel.showPanel("战斗邀请", "已经失效的战斗邀请！");
					}
					break;
				case GAME_PAIRUP_INVIT_CANCEL://取消邀请成功，可以再次邀请其他人
					inviteUserID = 0;
//					var inviteID:int = parseInt(obj.InvitationId);
//					if(userInfo.userID==inviteID){
//						inviteUserID = 0;
//					}else{//好友取消邀请
//						FriendList.inviteCancel(inviteID);
//					}
					break;
			}
		}
		
		/**
		 * 撮合匹配战斗
		 */
		public static function sendMatch():void{
			MainNC.getInstance().sendInfo(MainNC.CLIENT_GAME_ROOM, {code:GAME_PAIRUP_STARTING});
		}
		
		/**
		 * 邀请玩家进行战斗
		 * @param id	对方玩家ID
		 */
		public static function sendInvite(id:int):void{
			inviteUserID = id;
			MainNC.getInstance().sendInfo(MainNC.CLIENT_GAME_ROOM, {code:GAME_PAIRUP_INVIT, InvitationPlayerId:id});
		}
		
		/**
		 * 取消发出的邀请
		 * @param id	对方玩家ID
		 */
		public static function sendInvite(id:int):void{
			inviteUserID = id;
			MainNC.getInstance().sendInfo(MainNC.CLIENT_GAME_ROOM, {code:GAME_PAIRUP_INVIT_CANCEL});
		}
		
		/**
		 * 拒绝某玩家的邀请
		 * @param id	对方玩家ID
		 */
		public static function sendAgreeInvite(id:int):void{
			MainNC.getInstance().sendInfo(MainNC.CLIENT_GAME_ROOM, {code:GAME_PAIRUP_INVIT_RESULT, InvitationPlayerId:id, rs:0});
		}
		
		/**
		 * 接受某玩家的邀请
		 * @param id	对方玩家ID
		 */
		public static function sendAgreeInvite(id:int):void{
			MainNC.getInstance().sendInfo(MainNC.CLIENT_GAME_ROOM, {code:GAME_PAIRUP_INVIT_RESULT, InvitationPlayerId:id, rs:1});
		}
	}
}
