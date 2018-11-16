package com.model.vo.config.skill{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 技能配置信息
	 * @author hunterxie
	 */
	public class SkillConfigVO extends BaseObjectVO{
		public static var compare:SkillConfigVO = new SkillConfigVO();
		/**
		 * 技能id
		 */
		public var id:int = 0;
		/**技能名*/
		public var label:String = "空技能";
		/**技能图标名*/
		public var icon:String = "默认";
		/**技能详细描述*/
		public var describe:String = "空技能";
		/**使用类型(0:被动.1:主动)*/
		public var useKind:int = 0;
		/**装备类型(附在0:角色, 1:精灵, 2:棋子)*/
		public var equipKind:int = 0;
		/**技能冷却时间(回合)*/
		public var cd:int = 0;
		/**技能所属五行*/
//		public var wuxing:int = 5;
		/**技能威力*/
		public var power:Number = 1;
		/**技能命中率*/
		public var hit:Number = 1;
		/**
		 * 技能消耗，有资源就要有消耗，最大消耗就是在持续活动中（无感知）
		 */
		public var cost:Array = [0,0,0,0,0];
		/**
		 * 技能效果列表
		 */
		public var effects:Array = BaseObjectVO.getClassArray(SkillEffectConfigVO, true);
		
		
		/**
		 * 
		 * @param info
		 */
		public function SkillConfigVO(info:Object=null):void{
			super(info);
			if(info && info.id>=0) SkillConfig.setSkill(this);
		}
		
		public function addEffect():SkillEffectConfigVO{
			var vo:SkillEffectConfigVO = new SkillEffectConfigVO;
			this.effects.push(vo);
			return vo
		}
		
		public function reduceEffect():SkillEffectConfigVO{
			return this.effects.pop();
		}
		
		public function getChangeVO():Object{
			return getChange(compare, this);
		}

//		public function updateByXML(skill:XML):void{
//			this.id 			= skill.@id;
//			this.label 			= String(skill.@label);
//			this.describe 		= String(skill.describe);
//			this.icon 			= int(skill.@icon);//String(data.@icon);
//			this.wuxing 		= int(skill.@wuxing);//WuxingVO.getWuxing(int(skill.@wuxing), "", false);
//			this.power 			= int(skill.@power);
//			this.equipKind 		= int(skill.@equipKind);
//			this.useKind 		= int(skill.@useKind);
//			
//			this.cost = [int(skill.cost.@金),
//						int(skill.cost.@木),
//						int(skill.cost.@土),
//						int(skill.cost.@水),
//						int(skill.cost.@火)]
//			
//			this.effects = [];
//			for(var i:int=0; i<skill.effect.length(); i++){
//				var vo:SkillEffectConfigVO = new SkillEffectConfigVO;
//				vo.updateByXML(skill.effect[i]);
//				this.effects.push(vo);
//			}
//		}
	}
}