package com.model.vo.config.skill {
	import com.model.vo.BaseObjectVO;

	/**
	 * 技能配置信息
	 * @author hunterxie
	 */
	public class SkillConfig extends BaseObjectVO {
		public static var compare:SkillConfig = new SkillConfig(null, false);
		
		public static const NAME:String = "SkillInfo";
		public static const SINGLETON_MSG:String = "single_SkillInfo_only";
		protected static var instance:SkillConfig;

		public static function getInstance():SkillConfig{
			if ( instance == null ) instance = new SkillConfig();
			return instance;
		}
		
		public static function updateObj(info:Object):SkillConfig{
			getInstance().updateObj(info);
			return instance;
		}
		
		public static var allSkill:Object = {}; 
		public static function setSkill(vo:SkillConfigVO):void{
			allSkill[vo.id] = vo;
		}
		public static function getSkillByID(id:int=0):SkillConfigVO{
			getInstance();
			return allSkill[id];
		}		
		
		/**
		 * 
		 */
		public var skills:Array = BaseObjectVO.getClassArray(SkillConfigVO);
		/**
		 * 
		 */
		public var buffs:Array = BaseObjectVO.getClassArray(BuffConfigVO);
		/**
		 * 
		 */
		public var userSkills:Array = BaseObjectVO.getClassArray(UserSkillConfigVO);
		
		
		/**
		 * 
		 * 
		 */
		public function SkillConfig(info:Object=null, isSingle:Boolean=true) {
			if(!isSingle){
				this.skills = [SkillConfigVO.compare];
				this.buffs = [BuffConfigVO.compare];
				this.userSkills = [UserSkillConfigVO.compare];
				return;
			}
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			if(!info){
				info = BaseInfo.skillInfo;//JSON.parse(String(LoadProxy.getLoadInfo("skillInfo.json")));
			}
			instance.updateObj(info);
		}
		
//		public function updateByXML(info:XML):void{
//			skills=[];
//			for (var i:int=0; i<info.skills.skill.length(); i++) {
//				var vo:SkillConfigVO = new SkillConfigVO();
//				vo.updateByXML(info.skills.skill[i]);
//				skills.push(vo);
//			}
//			buffs=[];
//			for (i=0; i<info.buffs.buff.length(); i++) {
//				var vo1:BuffConfigVO = new BuffConfigVO();
//				vo1.updateByXML(info.buffs.buff[i]);
//				buffs.push(vo1);
//			}
//			userSkills=[];
//			for (i=0; i<info.userSkill.skill.length(); i++) {
//				var vo2:UserSkillConfigVO = new UserSkillConfigVO();
//				vo2.updateByXML(info.userSkill.skill[i]);
//				userSkills.push(vo2);
//			}
//		}
		
		public static function get skillLength():int{
			return getInstance().skills.length;
		}
		
		public function addSkill():SkillConfigVO{
			var vo:SkillConfigVO = new SkillConfigVO({id:skills.length});
			skills.push(vo);
			return vo;
		}
		
		public function addBuff():BuffConfigVO{
			var vo:BuffConfigVO = new BuffConfigVO;
			vo.id = buffs.length;
			buffs.push(vo);
			return vo;
		}
		
		/**
		 * 获取技能的位置(ID？)
		 * @param id
		 * @return 
		 */
		public function getSkillIndex(id:int):int{
			for(var i:int=0; i<skills.length; i++){
				if((skills[i] as SkillConfigVO).id==id){
					return i;
				}
			}
			return 0;
		}
		
		
		/**
		 * 根据ID获取技能信息
		 * @param id
		 */
		public static function getSkillInfo(id:int):SkillConfigVO{
			getInstance();
			for(var i:int=0; i<instance.skills.length; i++){
				var skill:SkillConfigVO = instance.skills[i] as SkillConfigVO;
				if(skill.id==id){
					return skill;
				}
			}
			throw Error("找不到对应ID的技能配置！！");
			return null; 
		}
		/**
		 * 根据技能ID获取生成的buffID
		 * @param skillID
		 * @return 
		 */
		public static function getBuffID(skillID:int):int{
			var skill:SkillConfigVO = getSkillInfo(skillID);
			for(var i:int=0; i<skill.effects.length; i++){
				var effect:SkillEffectConfigVO = skill.effects[i] as SkillEffectConfigVO;
				if(effect.id==0){//BoardSkillEffectVO.EFFECT_KIND_0){
					return effect.value;
				}
			}
			return 0;//是否可以生成buff 
		}
		/**
		 * 根据buffID获取buff
		 * @param id
		 */
		public static function getBuffInfo(id:int):BuffConfigVO{
			getInstance();
			for(var i:int=0; i<instance.buffs.length; i++){
				var buff:BuffConfigVO = instance.buffs[i] as BuffConfigVO;
				if(buff.id==id){
					return buff;
				}
			}
			throw Error("找不到对应ID的buff配置！！");
			return null;
		}
		/**
		 * 根据buffID获取buff的位置
		 * @param buffID
		 */
		public static function getBuffPosition(buffID:int):int{
			var buff:BuffConfigVO = getBuffInfo(buffID);
			if(buff){
				return buff.buffPosition;
			}
			return -1;
		}
		/**
		 * 
		 * @param buffID
		 */
		public static function getBuffReplaceKind(buffID:int):int{
			var buff:BuffConfigVO = getBuffInfo(buffID);
			if(buff){
				return buff.replaceKind;
			}
			return 0;
		}
		/**
		 * 根据ID获取用户技能
		 * @param id
		 */
		public static function getUserSkillInfo(id:int):UserSkillConfigVO{
			getInstance();
			for(var i:int=0; i<instance.userSkills.length; i++){
				var skill:UserSkillConfigVO = instance.userSkills[i] as UserSkillConfigVO;
				if(skill.id==id){
					return skill;
				}
			}
			throw Error("找不到对应ID的userSkill配置！！");
			return null;
		}
		
		public function getChangeVO():Object{
			return getChange(compare, this);
		}
		
		/**
		 * 获取技能图标的Class名，从配置中读取
		 * @param id 
		 */
//		public static function getSkillIcon(id:int):String{
//			var info:Object;
//			for(var i:int=0; i<instance.infos.icons.length; i++){
//				var obj:Object = instance.infos.icons[i];
//				if(obj.id==id){
//					info = obj;
//				}
//			}
//			
//			var cls:String = String(info["class"]);
//			if(!cls){
//				cls = "Fragment_0";
//			}
//			return cls;
//		}
	}
}
