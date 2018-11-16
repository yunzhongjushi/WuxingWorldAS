package com.model.vo.animation {
	import com.model.ApplicationFacade;
	
	import flas.events.EventDispatcher;
	
	/**
	 * 动画展示信息结构
	 * @author hunterxie
	 * 
	 */
	public class AnimationShowVO extends EventDispatcher{
		public static const NAME:String="AnimationShowVO";
		public static const SINGLETON_MSG:String="single_AnimationShowVO_only";
		protected static var instance:AnimationShowVO;
		public static function getInstance():AnimationShowVO{
			if ( instance == null ) instance=new AnimationShowVO();
			return instance;
		}
		
		/**
		 * 消除指定球
		 */
		public static const EFFECT_TRIGGER:String = "EFFECT_TRIGGER";
		/**
		 * 激活宝盒元素
		 */
		public static const ELEMENT_ACTIVATING:String = "ELEMENT_ACTIVATING";
		
		/**
		 * 展示文本信息
		 * @see com.model.vo.animation.InfoShowVO
		 */
		public static const TEXT_INFO_SHOW:String = "TEXT_INFO_SHOW";
		/**
		 * 直连闪电
		 */
		public static const FIGHT_LIGHTNING_SHOW:String = "FIGHT_LIGHTNING_SHOW";
		/**
		 * 连锁闪电
		 */
		public static const FIGHT_SKILL_LIGHTNING_SHOW:String = "FIGHT_SKILL_LIGHTNING_SHOW";
		/**
		 * 爆炸技能
		 */
		public static const FIGHT_SKILL_BOOM_SHOW:String = "FIGHT_SKILL_BOOM_SHOW";
		/**
		 * 五行法球
		 */
		public static const WUXING_FIRE_BALL:String = "WUXING_FIRE_BALL";
		
		public static const FIGHT_LV_UP:String = "FIGHT_LV_UP";
		public static const SOUND_PLAY:String = "SOUND_PLAY";
		
		public static const FIGHT_QIU_CHOOSE_SOUND:String = "ClickSound";
		public static const FIGHT_QIU_CLEAR_SOUND1:String = "ClearSound1";
		public static const FIGHT_QIU_CLEAR_SOUND2:String = "ClearSound2";
		public static const FIGHT_QIU_CLEAR_SOUND3:String = "ClearSound3";
		public static const FIGHT_QIU_CLEAR_SOUND4:String = "ClearSound4";
		public static const FIGHT_QIU_CLEAR_SOUND5:String = "ClearSound5";
		
		
		public var kind:String;
		public var info:*;
		
		/**
		 * @param kind
		 * @param vo
		 * 
		 */
		public function AnimationShowVO(kind:String="", vo:*=null) {
			this.kind = kind;
			this.info = vo;
		}
		
		public static function showAnimation(kind:String="", vo:*=null):void{
			getInstance().event(ApplicationFacade.SHOW_ANIMIATION, new AnimationShowVO(kind, vo));
		}
	}
}