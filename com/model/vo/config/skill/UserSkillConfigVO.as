package com.model.vo.config.skill{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 角色棋盘技能,不同等级用不同ID表示
	 * @author hunterxie
	 */
	public class UserSkillConfigVO extends BaseObjectVO{
		public static var compare:UserSkillConfigVO = new UserSkillConfigVO();
		//<skill id="20001" wuxing="0" name="十字斩" info="消除十字形状的棋子，威力随等级上升" lv1="7" lv2="8" lv3="9" lv4="0" up2="1000" up3="5000" up4="20000"/>
		public var id:int = 0;
		
		public var label:String = "角色技能";
		/**
		 * 技能五行类型，用于判断升级需求
		 */
		public var wuxing:int = 5;
		
		/**
		 * 技能详细描述
		 */
		public var describe:String = "";
		
		/**
		 * 等级1对应的技能ID
		 */
		public var lv1:int = 0;
		public var lv2:int = 0;
		public var lv3:int = 0;
		public var lv4:int = 0;
		
		/**
		 * 升级等级3对应消耗(对应wuxing)的资源
		 */
		public var up2:int = 0;
		public var up3:int = 0;
		public var up4:int = 0;

		
		
		/**
		 * 
		 * @param info
		 */
		public function UserSkillConfigVO(info:Object=null):void{
			super(info);
		}
		
//		public function updateByXML(skill:XML):void{
//			this.id = int(skill.@id);
//			this.label = String(skill.@name);
//			this.wuxing = int(skill.@wuxing);
//			this.describe = String(skill.@info);
//			this.lv1 = int(skill.@lv1);
//			this.lv2 = int(skill.@lv2);
//			this.lv3 = int(skill.@lv3);
//			this.lv4 = int(skill.@lv4);
//			this.up2 = int(skill.@up2);
//			this.up3 = int(skill.@up3);
//			this.up4 = int(skill.@up4);
//		}
	}
}