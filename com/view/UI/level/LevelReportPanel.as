package com.view.UI.level {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.level.LevelOverVO;
	import com.model.vo.level.LevelStarVO;
	import com.model.vo.skill.UserSkillVO;
	import com.utils.ColorFactory;
	import com.view.BasePanel;
	import com.view.UI.ResourceIcon;
	import com.view.UI.fairy.FairyBarSmall;
	import com.view.UI.fairy.FairySkillBar;
	import com.view.UI.item.ItemBarMiddle;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 战报面板
	 * @author hunterxie
	 */
	public class LevelReportPanel extends BasePanel{
		public static const NAME:String = "LevelReportPanel";
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:LevelReportPanel;
		public static function getInstance():LevelReportPanel{
			if ( instance == null ) instance=new LevelReportPanel();
			return instance as LevelReportPanel;
		}
		
		public var btn_retry:CommonBtn; 
		public var btn_OK:CommonBtn;
		
		public var mc_receve_exp:ResourceIcon;
		public var mc_receve_money:ResourceIcon;

		public var mc_receveWuxing_0:ResourceIcon;
		public var mc_receveWuxing_1:ResourceIcon;
		public var mc_receveWuxing_2:ResourceIcon;
		public var mc_receveWuxing_3:ResourceIcon;
		public var mc_receveWuxing_4:ResourceIcon;
		
		public var tf_score:TextField;
		public var tf_maxSequence:TextField;
		public var mc_star_1:MovieClip;
		public var mc_star_2:MovieClip;
		public var mc_star_3:MovieClip;
		
		public var mc_tar_1:MovieClip;
		public var mc_tar_2:MovieClip;
		public var mc_tar_3:MovieClip;
		public var tf_starInfo_1:TextField;
		public var tf_starInfo_2:TextField;
		public var tf_starInfo_3:TextField;
		
		public var tf_receveWuxing_0:TextField;
		public var tf_receveWuxing_1:TextField;
		public var tf_receveWuxing_2:TextField;
		public var tf_receveWuxing_3:TextField;
		public var tf_receveWuxing_4:TextField;
		
		public var tf_lvUp:TextField;
		public var tf_receve_money:TextField;
		public var tf_receve_exp:TextField;
		
		public var fightOverVO:LevelOverVO;
		
		public var mc_rewardContainer:Sprite;
		
		/**
		 * 战斗结束面板
		 */
		public function LevelReportPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = ALIGN_MIDDLE;
			btn_OK.setNameTxt("确  定");  
			btn_OK.addEventListener(MouseEvent.CLICK, close); 
			
			btn_retry.setNameTxt("重  玩");  
			btn_retry.addEventListener(MouseEvent.CLICK, retry);
			
			fightOverVO = LevelOverVO.getInstance();
			fightOverVO.on(LevelOverVO.INFO_UPDATED, this, updateInfo);
			
			EventCenter.on(ApplicationFacade.FRAGMENT_ACTIVATING_OVER, this, close);
			EventCenter.on(ApplicationFacade.SHOW_FIGHT_RESULT, this, onShowResult);
		}
		private function onShowResult(e:ObjectEvent):void{
			EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelReportPanel.NAME);
		}
		
		public function updateInfo(e:ObjectEvent):void {
			this.mc_receve_exp.updateInfo("EXP",String(fightOverVO.reward.exp));
			this.tf_score.text = String(fightOverVO.score);
			if(fightOverVO.reward.resource){
				this.mc_receveWuxing_0.updateInfo("金",String(fightOverVO.reward.resource[0]));
				this.mc_receveWuxing_1.updateInfo("木",String(fightOverVO.reward.resource[1])); 
				this.mc_receveWuxing_2.updateInfo("土",String(fightOverVO.reward.resource[2]));
				this.mc_receveWuxing_3.updateInfo("水",String(fightOverVO.reward.resource[3]));
				this.mc_receveWuxing_4.updateInfo("火",String(fightOverVO.reward.resource[4]));
			}
			this.tf_maxSequence.text = String(fightOverVO.maxSequence);
			this.mc_receve_money.updateInfo("钻石",String(fightOverVO.reward.gold));
			
//			fightOverVO.gameVO.levelVO.myScore = vo.score; 
			
			for(var i:int=1; i<=3; i++){ 
				var star:MovieClip = this["mc_star_"+i];
				star.filters = i<=fightOverVO.gameVO.levelVO.maxStarNum ? [] : [ColorFactory.getGrayFilter()];
				
				var star1:MovieClip = this["mc_tar_"+i];
				star1.filters = fightOverVO.gameVO.levelVO["star_"+i].hasOwn ? [] : [ColorFactory.getGrayFilter()];
				
				var info:TextField = this["tf_starInfo_"+i];
				info.htmlText = (fightOverVO.gameVO.levelVO["star_"+i] as LevelStarVO).tarInfo;
			}
			
			while(mc_rewardContainer.numChildren) mc_rewardContainer.removeChildAt(0);
			
			var tarX:int = 0;
			var baseW:int = 110;
			for(i=0; i<fightOverVO.reward.fairys.length; i++){
				var fairy:FairyBarSmall = new FairyBarSmall;
				fairy.x = tarX;
				fairy.updateInfo(new BaseFairyVO(Math.floor(Math.random()*99999), fightOverVO.reward.fairys[i], 1));
				mc_rewardContainer.addChild(fairy);
				
				tarX += baseW;
			}
			
			for(i=0; i<fightOverVO.reward.items.length; i++){
				var item:ItemBarMiddle = new ItemBarMiddle;
				item.x = tarX;
				item.updateInfo(new ItemVO(fightOverVO.reward.items[i], 1, Math.floor(Math.random()*99999)));
				mc_rewardContainer.addChild(item);
				
				tarX += baseW;
			}
			
			for(i=0; i<fightOverVO.reward.skills.length; i++){
				var skill:FairySkillBar = new FairySkillBar;
				skill.x = tarX;
				skill.updateInfo(new UserSkillVO(fightOverVO.reward.skills[i], 1), null);
				mc_rewardContainer.addChild(skill);
				 
				tarX += baseW;
			}
		}
		
		public function retry(e:*=null):void{
			close();
			if(fightOverVO.gameVO.levelVO.configVO.isGuide){
				EventCenter.event(ApplicationFacade.LEVEL_GAME_START, fightOverVO.gameVO.levelVO);
			}else{
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelPanel.getShowName(fightOverVO.gameVO.levelVO));
			}
		}
	}
}