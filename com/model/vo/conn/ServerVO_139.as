package com.model.vo.conn {
	import com.conn.MainNC;
	import com.model.vo.user.UserVO;
	
	/**
	 * 战斗日志查询
	 * @author hunterxie
	 */
	public class ServerVO_139{
		public static var ID:int = 0x8b;
		
		/**
		 * 战斗日志列表查询
				客户端 -> 服务器
			一级协议：0x8b
			参数：
			playerId：int；//要查询的玩家id
			返回：
			playerId：int；//要查询的玩家id
			Logs：Map<String,Object>；String：//日志位置从0开始，Object，日志
		 */
		public function ServerVO_139(obj:Object) {
//			MyClass.traceInfo(obj);
			
			var arr:Array = [];
			for(var i:* in obj.logs){
				arr[i] = obj.logs[i];
			}
			
//			ServerVO_140.sendInfo(obj.logs[0].id);
		}
		
		/**
		 * 发送给server
		 */
		public static function sendInfo():void{
			MainNC.getInstance().sendInfo(ID, {playerId:UserVO.getInstance().userID});
		}
		
		
		
		/**
		日志结构：
		atPlayerId：int；//攻击方玩家id
		atPlayerEquip：int[]；//攻击方装备id
		atPlayerSkill：Map<String,Object>;//攻击方装备的玩家技能String，从0~4；  Object:id:int;//技能id，lv:int;//技能等级
		dePlayerId：int；//防御方玩家id
		dePlayerEquip：int[]；//防御方装备id
		dePlayerSkill：Map<String,Object>;//防御方装备的玩家技能String，从0~4；  Object:id:int;//技能id，lv:int;//技能等级
		actions：String[]；//移动操作，每回合的移动操作
		randomVal：int；//随机数
		Seed：int；//种子
		fightType：int；//游戏类型
		gameStart：Long;//游戏开始秒数，距1970年1月1日总秒
		gameEnd：Long;//游戏结束秒数，距1970年1月1日总秒
		levelId：int;//关卡id
		isWin：int;//是否胜利，0胜利，1失败
		isFightGame：boolean；//是否为对战游戏
		-----当为对战类型游戏时，会额外包含字段--------
			skillRandom:int；//技能随机数
		skillSeed:int;//技能种子数
		atFyInfo:Map<String,Object>;//攻击方精灵属性包含字段
		------精灵属性------
			id：int;//精灵id
		templateId：int;//精灵种族
		lv：int;//精灵等级
		userId：int;//主人id
		attr：int[];属性点[0,0,0,0,0]
		res：int[];初始资源[0,0,0,0,0]
		maxRes：int[];资源上限[0,0,0,0,0]
		incRes：int[];资源增长速率[0,0,0,0,0]
		skill：int[];技能id
		
		deFyInfo:Map<String,Object>;//防御方精灵属性，属性字段同精灵属性
		 */
	}
}
