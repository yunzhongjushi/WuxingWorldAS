package com.model.vo.friend {
	import com.model.vo.user.UserVO;
	
	import flas.events.EventDispatcher;
	
	/**
	 * 单个好友信息
	 */
	public class FriendVO extends EventDispatcher{
		/**
		 * 更新被邀请状态
		 */
		public static const UPDATE_FRIEND_INFO:String = "UPDATE_FRIEND_INFO";
		/**
		 * 内存池
		 */
		private static var pool:Array;
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public var nickName:String;
		public var playerID:int;
		public var level:int
		public var trophies:int;
		
		//friend player info
		public var achiPoint:int;
		
		//top player info
		public var rank:int
		public var defenceID:int = 0;
		
		/**
		 * 是否受到了他的邀请
		 */
		public function get isInvite():Boolean{
			return _isInvite;
		}
		public function set isInvite(judge:Boolean):void{
			_isInvite = judge;
			dispatchUpdate();
		}
		private var _isInvite:Boolean;
		
		public function dispatchUpdate():void{
			event(UPDATE_FRIEND_INFO);
		}
		
		
		public function get canPuzzle():Boolean {return defenceID >= 0};
		
		public function FriendVO(nickName:String,playerId:int,grade:int) {
			updateInfo(nickName, playerId, grade);
		}
		
		public function updateInfo(nickName:String, playerId:int,grade:int):void {
			var index:int = nickName.search("\r");
			if(index!=-1){
				nickName = nickName.substr(0,index) + nickName.substr(index+1);
			}
			this.nickName = nickName;
			this.playerID = playerId;
			this.level = grade;
//			this.FightPower = FightPower;
			dispatchUpdate();
		}
		
		/**
		 * 自己作为好友的信息
		 */
		private static var _selfFriend:FriendVO;
		/**
		 * 获取自己的PlayerVO 
		 * @return 
		 */		
		public static function get selfFriend():FriendVO{
			if(!_selfFriend) _selfFriend = new FriendVO(userInfo.nickName, userInfo.userID, 0);
			return _selfFriend;
		}
		/**
		 * 排行榜VO
		 */		
		public static function genTopPlayer(nickName:String,playerId:int,grade:int,trophies:int,rank:int):FriendVO{
			var vo:FriendVO = new FriendVO(nickName,playerId,grade);
			vo.rank=rank;
			return vo
		}
		public function getTrophiesStr():String{
			return String(1025);
		}
		public function getAchiPointStr():String{
			return String(2200);
		}
		public function getLevelStr():String{
			return "等级 "+this.level;
		}
	}
}