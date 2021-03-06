package com.view.UI.challenge {
	import com.model.vo.item.ItemBaseVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.level.LevelVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	import com.view.UI.item.ItemBarMiddle;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 挑战塔——水
	 * @author hunterxie
	 */
	public class ChallengeShui extends BasePanel{
		public static const NAME:String = "ChallengeShui";
		public static const SINGLETON_MSG:String="single_ChallengeShui_only";
		protected static var instance:ChallengeShui;
		public static function getInstance():ChallengeShui{
			if ( instance == null ) instance=new ChallengeShui();
			return instance as ChallengeShui;
		}
		
		
		public var tf_lv:TextField;
		
		public var tf_info:TextField;
		
		/**
		 * 奖励
		 */
		public var rewardContainer:MovieClip;
		
		public var rewardList:Array;
		
		public var levelInfo:LevelVO;
		
		public var btn_start:CommonBtn;
		
		
		
		public function ChallengeShui() {
			super(false);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			
		}
		
		public function updateInfo(vo:LevelVO=null):void{
			while(rewardContainer.numChildren){
				rewardContainer.removeChildAt(0);
			}
			for(var i:int=0; i<levelInfo.configVO.rewards.rewards.length; i++){
				var reward:ItemBaseVO = levelInfo.configVO.rewards.rewards[i] as ItemBaseVO;
				var itemBar:ItemBarMiddle = new ItemBarMiddle();
				itemBar.updateInfo(ItemVO.getItemVO(reward._itemID, 1));//ItemVO.getFairyItemVO(1)//
				itemBar.x = rewardContainer.width;
				rewardContainer.addChild(itemBar);
			}
		}
	}
}
