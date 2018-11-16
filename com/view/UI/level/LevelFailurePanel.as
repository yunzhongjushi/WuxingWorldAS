package com.view.UI.level{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.BaseGameLogic;
	import com.model.logic.FightGameLogic;
	import com.model.logic.LevelGameLogic;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.level.LevelVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;
	
	/**
	 * 
	 * @author hunterxie
	 */
	public class LevelFailurePanel extends BasePanel{
		public static const NAME:String = "LevelFailurePanel";
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:LevelFailurePanel;
		public static function getInstance():LevelFailurePanel{
			if ( instance == null ) instance=new LevelFailurePanel();
			return instance as LevelFailurePanel;
		}
		
		
		public var btn_OK:CommonBtn;
		public var btn_retry:CommonBtn;
//		public var tf_reason:TextField;
		public var tf_target:TextField;
		
		private var levelVO:LevelVO;
		
		private var fightGameLogic:FightGameLogic;
		private var levelGameLogic:LevelGameLogic;
		
		
		/**
		 * 闯关失败面板
		 */
		public function LevelFailurePanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = ALIGN_MIDDLE;
			btn_OK.setNameTxt("结束游戏");
			btn_OK.addEventListener(MouseEvent.CLICK, close); 
			
			btn_retry.setNameTxt("再试一次");
			btn_retry.addEventListener(MouseEvent.CLICK, retry);
			
			fightGameLogic = FightGameLogic.getInstance();
			fightGameLogic.on(FightGameLogic.FIGHT_LOGIC_OVER, this, updateInfo);
			levelGameLogic = LevelGameLogic.getInstance();
			levelGameLogic.on(BaseGameLogic.GAME_OVER, this, updateInfo);
		}
		
		public function updateInfo(e:ObjectEvent):void{
			var vo:BaseGameLogic = e.target as BaseGameLogic;
			levelVO = vo.levelVO;
//			tf_reason.text = "没有达到目标!";
			btn_OK.mouseEnabled = !(vo.levelVO.configVO.isGuide);
			tf_target.text = levelVO.configVO.describe;
		}
		
		public function retry(e:*=null):void{
			close();
			if(levelVO.configVO.isGuide){
				EventCenter.event(ApplicationFacade.LEVEL_GAME_START, levelVO);
			}else{
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LevelPanel.getShowName(levelVO));
			}
		}
	}
}