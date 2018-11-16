package com.model.vo.conn {
	import com.model.vo.WuxingVO;
	import com.model.vo.skill.fight.FairySkillVO;
	import com.model.vo.fairy.FairyVO;

	public class ServerGameStartVO {
		/**
		 * 目标（观察的）用户，在左边显示
		 */
		public var attackUserID:int;
		public var attackuserLV:int;
		public var attackWuxing:Array = [];
		public var attackFairys:Array = [];
		/**
		 * 进攻方玩家选择的技能
		 */
		public var attackSkills:Array = [];
		
		
		/**
		 * 目标（观察的）用户，在左边显示
		 */
		public var defendUserID:int;
		public var defendUserLV:int;
		public var defendWuxing:Array = [];
		public var defendFairys:Array = [];
		/**
		 * 防御方玩家选择的技能
		 */
		public var defendSkills:Array = [];
		
		
		public var initNum:int;
		public var seed:int;
		
		public var skillInitNum:int;
		public var skillSeed:int;
		
		public var levelID:int = 0;
		
		/**
		 * ServerVO_91.FIGHT_TYPE...
		 */
		public var fightKind:int;
		public var clear_kind:int;
		public var gameid:String;
		
		public var lastGameInfo:Object;
		
		/**
		 * 
		 * @param info
		 * 
		 */
		public function ServerGameStartVO(info:Object) {
//			MyClass.traceInfo(info);
			
			this.attackUserID = info.atPlayerId;
			this.defendUserID = info.dePlayerId;
			
			for(var i:* in info.playerAttr){
				attackWuxing[i]=info.playerAttr[i];
			}
			for(i in info.dePlayerAttr){
				defendWuxing[i]=info.dePlayerAttr[i];
			}
			for(i in info.skills){
				if(info.skills[i]){
					attackSkills.push(info.skills[i]);
				}
			}
			for(i in info.deSkills){
				if(info.deSkills[i]){
					defendSkills.push(info.deSkills[i]);
				}
			}
			for(i in info.atFairys){
				this.attackFairys.push(createFairy(info.atFairys[i], attackUserID));
			}
			for(i in info.deFairys){
				this.defendFairys.push(createFairy(info.deFairys[i], defendUserID));
			}
			
			this.initNum = info.initNum;
			this.seed = info.seed;
			
			this.skillInitNum = info.skillInit;
			this.skillSeed = info.skillSeed;
			
			this.fightKind = info.gameType;
			this.clear_kind = info.clear_kind;
			
			this.levelID = info.levelID;
			
			this.gameid = info.gameId;
		}
		
		private function createFairy(info:Object, userID:int):FairyVO{
			var fairy:FairyVO = new FairyVO(info.ID, 
											info.TemplateID, 
											info.LV, 
											userID);
			fairy.roleKind = info.roleKind;
			fairy.HP_cu = fairy.HP_max = info.hp;
//			for(var i:* in info.attr){
//				fairy.wuxingInfo.setProperty(i, info.attr[i]);
//			}
			
			fairy.skillArr = [];
			for(var i:* in info.skills){
				fairy.skillArr.push(new FairySkillVO(info.skills[i], 1, fairy));
			}
			
			return fairy;
		}
	}
}
