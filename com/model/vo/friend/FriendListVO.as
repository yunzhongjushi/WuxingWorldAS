package com.model.vo.friend {
	import flas.events.EventDispatcher;

	/**
	 * 
	 * @author hunterxie
	 */
	public class FriendListVO extends EventDispatcher{
		/**
		 * 更新整个好友列表
		 */
		public static const UPDATE_FRIEND_INFO:String = "UPDATE_FRIEND_INFO";
		/**
		 * 添加单个好友
		 */
		public static const ADD_FRIEND_INFO:String = "ADD_FRIEND_INFO";
		
		public static const NAME:String = "FriendListVO";
		public static const SINGLETON_MSG:String="single_FriendListVO_only";
		protected static var instance:FriendListVO;
		public static function getInstance():FriendListVO{
			if ( instance == null ) instance=new FriendListVO();
			return instance as FriendListVO;
		}
		
		public var friendList:Array;
		
		
		
		public function FriendListVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
		}
		
		public static function updateInfoByServer(obj:Object):void{
			getInstance();
			instance.friendList = [];
			
			var fArr:Array=obj["friends"] as Array;
			for(var i:int=0; i<fArr.length; i++) {
				var vo:FriendVO = instance.friendList[i];
				if(!vo){
					vo = new FriendVO(fArr[i]["NickName"], fArr[i]["playerId"], fArr[i]["Grade"]);
				}else{
					vo.updateInfo(fArr[i]["NickName"], fArr[i]["playerId"], fArr[i]["Grade"]);
				}
				vo.defenceID = fArr[i]["defencePuzzleID"];
				
				instance.friendList.push(vo);
			}
			instance.event(UPDATE_FRIEND_INFO);
		}
		
		public static function updateAddFriend(obj:Object):void{
			getInstance();
			if(obj["NickName"]) {
				var vo:FriendVO = new FriendVO(obj["NickName"], obj["playerId"], obj["Grade"]);
				vo.defenceID = obj["defencePuzzleID"];
				
				instance.friendList.push(vo);
			}
			instance.event(UPDATE_FRIEND_INFO);
		}
		
		/**
		 * 通过角色id获取好友
		 * @param id
		 */
		public static function getFriendByID(id:int):FriendVO{
			var tar:FriendVO;
			for(var i:int=0; i<instance.friendList.length; i++){
				var vo:FriendVO = instance.friendList[i] as FriendVO;
				if(vo.playerID == id){
					tar = vo;
					break;
				}
			}
			return vo;
		}
		
		/**
		 * 成功发出邀请后更新好友列表邀请状态（变为取消邀请）
		 * @param id
		 */
		public static function updateInviteInfo(id:int):void{
			
		}
		
		/**
		 * 收到玩家战斗邀请，一般是好友
		 * @param id
		 */
		public static function beInvited(id:int):void{
			
		}
		
		/**
		 * 拒绝战斗邀请
		 * @param id
		 */
		public static function inviteRefuse(id:int):void{
			
		}
		
		/**
		 * 取消战斗邀请
		 * @param id
		 */
		public static function inviteCancel(id:int):void{
			
		}
	}
}
