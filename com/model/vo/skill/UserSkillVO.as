package com.model.vo.skill {
	import com.model.logic.BaseGameLogic;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.config.skill.UserSkillConfigVO;
	import com.model.vo.user.ChessboardUserVO;

	/**
	 * 角色棋盘技能,不同等级用不同ID表示
	 * @author hunterxie
	 */
	public class UserSkillVO extends BoardSkillVO{
		
		/**
		 * 技能五行类型，用于判断升级需求
		 */
		public function get wuxing():int{
			return userSkillData.wuxing;
		}
		
		private var userSkillData:UserSkillConfigVO;
		
		/**
		 * 用户技能ID，根据LV不同对应不同技能ID
		 */
		public function get userSkillID():int{
			return baseInfo.userSkillID;
		}
		public function set userSkillID(value:int):void{
			this.baseInfo.userSkillID = value;
		}
		
		/**
		 * 升级需要花费的元素量
		 */
		public var upLVCost:int = 0;
		
//		private static var pool:Array = [];
		
		/**
		 * 角色棋盘技能
		 * @param id
		 * @param lv
		 */
		public function UserSkillVO(id:int, lv:int=1, user:ChessboardUserVO=null):void {
			this.userSkillData = SkillConfig.getUserSkillInfo(id);
			if(!user) this.myUser = BaseGameLogic.bakeUserInfo;
			userSkillID = id;
//			if(12==id){
//				trace("???")
//			}
			setLV(lv);
		}
		

		public function setLV(value:int):void{
			super.LV = value;
			if(userSkillData && value>0){ 
				this.ID = userSkillData["lv"+value];
				updateInfo(ID, value); 
				this.equipKind = BaseSkillVO.EQUIP_KIND_0;
				switch(value){
					case 1:
						upLVCost = userSkillData.up2;
						break;
					case 2:
						upLVCost = userSkillData.up3;
						break;
					case 3:
						upLVCost = userSkillData.up4;
						break;
					case 4:
						upLVCost = 0;
						break;
				}
			}
		}
		
	}
}
