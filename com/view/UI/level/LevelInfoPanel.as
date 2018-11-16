package com.view.UI.level {
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.level.LevelStarVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;
	import com.utils.ColorFactory;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 关卡信息面板，包括技能选择和精灵选择
	 * @author hunterxie
	 */
	public class LevelInfoPanel extends Sprite{
		public static const NAME:String = "LevelInfoPanel";
		public static const SINGLETON_MSG:String="single_LevelInfoPanel_only";
		protected static var instance:LevelInfoPanel;
		public static function getInstance():LevelInfoPanel{
			if ( instance == null ) instance = new LevelInfoPanel();
			return instance;
		}
		
		public var tf_levelInfo:TextField;
		public var tf_maxScore:TextField;
		public var tf_useEnegy:TextField;
		/**
		 * 暂时展示关卡目标信息
		 */
		public var tf_infos:TextField;//TODO后续需要用图形展示，如敌人信息，收集信息等
		
		public var mc_star_1:MovieClip;
		public var mc_star_2:MovieClip;
		public var mc_star_3:MovieClip;
		public var tf_starInfo_1:TextField;
		public var tf_starInfo_2:TextField;
		public var tf_starInfo_3:TextField;
		
		public var container_leveTarget:Sprite;
		
		public var vo:LevelVO;	
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 
		 * 
		 */
		public function LevelInfoPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
		}
		
		public function updateInfo(vo:LevelVO):void{
			this.vo = vo;
			this.tf_useEnegy.text = String(vo.configVO.energyCost);
			this.tf_maxScore.text = String(vo.myScore); 
			this.tf_levelInfo.text = String(vo.configVO.label);
			
			for(var i:int=1; i<=3; i++){
				var star:MovieClip = this["mc_star_"+i];
				star.filters = vo["star_"+i].hasOwn ? [] : [ColorFactory.getGrayFilter()];
				
				var info:TextField = this["tf_starInfo_"+i];
				info.htmlText = (vo["star_"+i] as LevelStarVO).tarInfo;
			}
			tf_infos.text = "";
			switch(vo.configVO.kind){
				case LevelConfigVO.KIND_GAME_FIGHT_PVE:
					for(i=0; i<vo.fairyInfos.length; i++){
						var fairy:FairyVO = vo.fairyInfos[i] as FairyVO;
						tf_infos.appendText(fairy.nickName+":"+fairy.LV+"级		");
					}
					break;
				case LevelConfigVO.KIND_GAME_COLLECT_RESOURCE:
					for(var k:* in vo.tarResource){
						tf_infos.appendText(k+":"+vo.tarResource[k]+"	");
					}
					break;
			}
		}
	}
}