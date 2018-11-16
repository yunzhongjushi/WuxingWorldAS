package com.model.vo.config.skill{
	import com.model.vo.BaseObjectVO;
	
	
	/**
	 * 关卡配置信息
	 * @author hunterxie
	 */
	public class BuffConfigVO extends BaseObjectVO{
		public static var compare:BuffConfigVO = new BuffConfigVO();
		
		/**
		 * 技能id
		 */
		public var id:int = 0;
		
		/**
		 * 技能名
		 */
		public var label:String = "空buff";
		
		/**
		 * 技能图标名
		 */
		public var icon:String = "b默认";
		/**
		 * 技能详细描述
		 */
		public var describe:String = "空buff";
		/**
		 * 技能所属五行
		 */
		public var wuxing:int = 5;
		/**
		 * 技能出现（附属）的位置(0:精灵, 1:棋子1, 2:棋子2, 3:格子)
		 */
		public var buffPosition:int = 1;
		/**
		 * buff的收集值(-1为不判断)
		 */
		public var collect:int = -1;
		/**
		 * buff持续时间(-1为永久持续)
		 */
		public var continuedTime:int = -1;
		/**
		 * buff的生效次数(-1为无限次，棋子不消失)
		 */
		public var effectTime:int = 1;
		/**
		 * buff的可叠加层数，不是生效次数；-1表示不限制;TODO:增加层数是否改变生效次数要设定<br>
		 * 如果优先级相同而且类型相同就进行叠加。<br>
		 * 叠加后效果为最新的效果，效果x层数得出最终效果<br>
		 */
		public var maxLayer:int = 1;
		
		/**
		 * 是否是有害buff
		 */
		public var isDebuff:int = 0;
		
		/**
		 * 可以替换的buff类型，如果buff生成时已经有对应类型的buff根据优先级进行替换
		 */
		public var replaceKind:int = 0;
		/**
		 * 替换优先级，如果是相同类型的buff高于优先级就替换，替换buff不产生“结束效果”
		 */
		public var priority:int = 0;
		
		/**
		 * 技能效果列表
		 */
		public var effects:Array = BaseObjectVO.getClassArray(SkillEffectConfigVO, true);
		
		
		/**
		 * 
		 * @param info
		 */
		public function BuffConfigVO(info:Object=null):void{
			super(info);
			
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

//		public function updateByXML(buff:XML):void{
//			this.id 			= buff.@id;
//			this.label 			= String(buff.@label);
//			this.describe 		= String(buff.describe); 
//			this.icon 			= int(buff.@icon);//BaseInfo.getSkillIcon(int(buff.@icon));//
//			this.wuxing 		= int(buff.@wuxing);//WuxingVO.getWuxing(int(skill.@wuxing), "", false);
//			
//			this.collect 		= int(buff.@collect);
//			this.continuedTime 	= int(buff.@continuedTime);
//			this.effectTime 	= int(buff.@effectTime);
//			this.isDebuff 		= int(buff.@isDebuff);
//			this.maxLayer 		= int(buff.@maxLayer); 
//			this.buffPosition 	= int(buff.@buffPosition);
//			this.priority 		= int(buff.@priority);
//			this.replaceKind 	= int(buff.@replaceKind);
//			
//			this.effects = [];
//			for(var i:int=0; i<buff.effect.length(); i++){
//				var vo:SkillEffectConfigVO = new SkillEffectConfigVO;
//				vo.updateByXML(buff.effect[i]);
//				this.effects.push(vo);
//			}
//		}
	}
}