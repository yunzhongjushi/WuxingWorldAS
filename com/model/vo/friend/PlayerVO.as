package com.model.vo.friend {
	import com.model.vo.user.UserVO;
	
	import flas.geom.Point;
	
	public class PlayerVO {
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		//basic info
		public var nickName:String;
		public var playerID:int;
		public var level:int
		public var trophies:int;
		//friend player info
		public var achiPoint:int;
		//top player info
		public var rank:int
//		public var FightPower:int;
		public function PlayerVO(nickName:String,playerId:int,grade:int,trophies:int) {
			var index:int = nickName.search("\r");
			if(index!=-1){
				nickName = nickName.substr(0,index) + nickName.substr(index+1);
			}
			this.nickName = nickName;
			this.playerID = playerId;
			this.level = grade;
			this.trophies = trophies;
//			this.FightPower = FightPower;
		}
		public static function getFakerData(num:int):Array{
			var arr:Array=[];;
			for (var i:int = 0; i < num; i++) 
			{
				var p:PlayerVO = PlayerVO.genFriendVO("name"+(i+1),i+1,Math.random()*100,Math.random()*5000,Math.random()*5000)
				arr.push(p);
			}
			return arr;
			
		}
		/**
		 * 获取自己的PlayerVO 
		 * @return 
		 * 
		 */		
		public static function getUserVO():PlayerVO
		{
			var vo:PlayerVO = new PlayerVO(userInfo.nickName,userInfo.userID,0,0);
			return vo
		}
		/**
		 * 好友VO
		 */		
		public static function genFriendVO(nickName:String,playerId:int,grade:int,trophies:int,achiPoint:int):PlayerVO{
			var vo:PlayerVO = new PlayerVO(nickName,playerId,grade,trophies);
			vo.achiPoint = achiPoint;
			return vo
		}
		/**
		 * 添加好友VO
		 */		
		public static function genAddFriendVO(nickName:String):PlayerVO{
			var vo:PlayerVO = new PlayerVO(nickName,0,0,0);
			return vo
		}
		/**
		 * 排行榜VO
		 */		
		public static function genTopPlayer(nickName:String,playerId:int,grade:int,trophies:int,rank:int):PlayerVO{
			var vo:PlayerVO = new PlayerVO(nickName,playerId,grade,trophies);
			vo.rank=rank;
			return vo
		}
		public function getTrophiesStr():String{
			//faker
			return String(1025);
		}
		public function getAchiPointStr():String{
			//faker
			return String(2200);
		}
		public function getLevelStr():String{
			return "等级 "+this.level;
		}
	}
}

/*
package com.model.vo.loot
{
public class PlayerVO
{
public var name:String,level:int,rank:int,trophies:int;
public var playerID:int;

public function PlayerVO(name:String,level:int)
{
this.name=name
this.level=level
}
public static function genTopPlayerVO(name:String,level:int,rank:int,trophies:int):PlayerVO{
var playerVO:PlayerVO = new PlayerVO(name,level);
playerVO.rank = rank;
playerVO.trophies = trophies;
return playerVO;
}
public function getLevelDesc():String{
return "Lv "+level;
}
}
}
*/