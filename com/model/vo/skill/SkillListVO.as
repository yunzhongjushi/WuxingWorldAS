package com.model.vo.skill {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.config.skill.SkillConfig;
	import com.model.vo.user.UserVO;
	
	import flas.events.EventDispatcher;

	/**
	 * 角色技能列表
	 * @author hunterxie
	 */
	public class SkillListVO extends BaseObjectVO{
		public static const UPDATE_SKILLS_INFO:String="UPDATE_SKILLS_INFO";
		
		public static const NAME:String="SkillListVO";
		public static const SINGLETON_MSG:String="single_SkillListVO_only";
		protected static var instance:SkillListVO;
		public static function getInstance():SkillListVO{
			if ( instance == null ) instance = new SkillListVO();
			return instance;
		}
		
		/**
		 * 玩家技能列表，数组内容为
		 * @see com.model.vo.skill.SkillInfoBaseVO
		 */
		public var skills:Object = {cls:SkillInfoBaseVO};
		
		/**
		 * 玩家现有的技能数量
		 * @return 
		 */
		public static function get skillLength():int{
			return skillList.length;
		}
		
		/**
		 * 拥有技能数组
		 * @see com.model.vo.skill.UserSkillVO
		 */
		public static var skillList:Array = [];
		
		private static function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 
		 * 
		 */
		public function SkillListVO() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
		}
		
		/**
		 * @param info skills：Map<Integer,Object>;
		 * Integer，全部技能，从0~技能 数 目-1装备技能，按照技能装备位置排序，初始为1，最大为5；
		 * Object，包含：id：技能id  lv：技能等级
		 * @return 
		 */		
		private function updateInfo(info:Object):void {
//			for(var i:* in info){
//				var skill:UserSkillVO = getSkillByID(i);
//				if(skill){
//					skill.updateInfo(info[i].skillId, info[i].skillLv);
//				}else{
//					skill = new UserSkillVO(info[i].skillId, info[i].skillLv);
//					skillList.push(skill);
//				}
//				userInfo.skills[skill.userSkillID] = skill.baseInfo;//new BaseSkillVO(skill.ID, skill.LV);
//			}
			for(var i:Object in skills){
				if(i!="cls"){
					var vo:SkillInfoBaseVO = skills[i] as SkillInfoBaseVO;
					var skill:UserSkillVO = getSkillByID(vo.userSkillID);
					if(!skill){
						skill = new UserSkillVO(vo.userSkillID, vo.LV);
						skillList.push(skill);
					}
					skill.baseInfo = vo;
				}
			}
		}
		
		override public function updateObj(info:Object):void{
			super.updateObj(info);
			updateInfo(skills);
		}
		
		/**
		 * 检测是否拥有某效果的技能
		 * @param skillID
		 * @return 
		 */
		public static function checkHasSkillEffect(effectID:int):Boolean{
			for(var i:int=0; i<skillList.length; i++){
				var skill:UserSkillVO = skillList[i] as UserSkillVO;
				if(skill.ID==effectID){
					return true;
				}
			}
			return false;
		}
		
		public static function getSkillByID(id:int):UserSkillVO{
			return skillList.filter(function(element:*, index:int, arr:Array):Boolean {
						return (element.userSkillID == id);
					})[0];
//			for(var i:int=0; i<skillList.length; i++){
//				var skill:UserSkillVO = skillList[i] as UserSkillVO;
//				if(skill.userSkillID==id){
//					return skill;
//				}
//			}
//			return null;
		}
		
		public static function getSkillLV(id:int):int{
			var vo:UserSkillVO = getSkillByID(id);
			if(vo) {
				return vo.LV;
			}
			return 0;
		}
		
		/**
		 * 根据skillID获取对应生成的buff信息
		 * @param skillID
		 * @return 返回id_lv字串，如："2_1"，在实际环境中再生成
		 */
		public static function getBuff(skillID:int):String{
			var buffID:int = SkillConfig.getBuffID(skillID); 
			if(buffID==0) return "0";
			if(!instance){
				instance = getInstance();
			}
			for(var i:int=0; i<skillList.length; i++){
				var skill:UserSkillVO = skillList[i] as UserSkillVO;
				if(skill.ID==skillID){
					return buffID+"_"+skill.LV;
				}
			}
			return "0";
		}
		
		public static function testAddSkill(id:int, lv:int):void{
			var getSkill:UserSkillVO = getSkillByID(id);
			if(getSkill){
				getSkill.setLV(lv);
			}else{
				getSkill = new UserSkillVO(id, lv);
				skillList.push(getSkill);
			}
			getInstance().skills[getSkill.userSkillID] = getSkill.baseInfo;
		}
		
		
		/**
		 * 本地添加战斗结束后的模拟技能奖励
		 * @param vo
		 */
		public static function testAddReward(skills:Array):void{
			if(skills.length>0){
				for(var i:int=0; i<skills.length; i++){
					var skill:int = skills[i];
					testAddSkill(skill, 1);
				}
				getInstance().dispatchUpdate();
			}
		}
		
		public function dispatchUpdate():void{
			event(UPDATE_SKILLS_INFO);
		}
	}
}
