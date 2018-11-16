package com.view.UI.level {
	import com.model.vo.level.LevelVO;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.skill.UserSkillVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.fairy.FairySkillBar;
	import com.view.choose.BaseChoosePanel;
	
	/**
	 * 关卡技能选择面板
	 * @author hunterxie
	 */
	public class LevelSkillChoosePanel extends BaseChoosePanel{
		public static const NAME:String = "LevelSkillChoosePanel";
		public static const SINGLETON_MSG:String="single_LevelSkillChoosePanel_only";
		protected static var instance:LevelSkillChoosePanel;
		public static function getInstance():LevelSkillChoosePanel{
			if ( instance == null ) instance = new LevelSkillChoosePanel();
			return instance;
		}
		
		public var vo:LevelVO;	
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 
		 * 
		 */
		public function LevelSkillChoosePanel() {
			super(true);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			 
		}
		
		public function updateLevelInfo(vo:LevelVO):void{
			this.vo = vo;
			updateInfo(FairySkillBar, SkillListVO.skillList, userInfo.skillOpenNum);
			 
//			updateChooseItem();
		}
		
		/**
		 * 玩家选择的关卡技能列表
		 * @return [-1,-1,-1,-1,-1]
		 */
		public function getSkillArr():Array{
			var arr:Array = [];
			for(var i:int=0; i<BaseInfo.TOTAL_USER_SKILL_NUM; i++){
				if(i<chooseVOArr.length){ 
					arr.push((chooseVOArr[i] as UserSkillVO).ID);
				}else{
					arr.push(-1);
				}
			}
			
			return arr;
		}
	}
}