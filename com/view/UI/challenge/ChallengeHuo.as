package com.view.UI.challenge {
	import com.model.vo.config.level.LevelRewardBaseVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.level.LevelVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	import com.view.UI.item.ItemBarMiddle;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 挑战塔——火
	 * @author hunterxie
	 */
	public class ChallengeHuo extends BasePanel{
		
		public static const NAME:String = "ChallengeHuo";
		public static const SINGLETON_MSG:String="single_ChallengeHuo_only";
		protected static var instance:ChallengeHuo;
		public static function getInstance():ChallengeHuo{
			if ( instance == null ) instance=new ChallengeHuo();
			return instance as ChallengeHuo;
		}
		
		
		public var tf_lv:TextField;
		
		public var tf_info:TextField;
		
		/**
		 * 奖励
		 */
		public var rewardContainer:MovieClip;
		/**
		 * 精灵显示列表
		 */
		public var fairyContainer:MovieClip;
		
		public var fairyList:MovieClip;
		
		public var rewardList:Array;
		
		public var levelInfo:LevelVO;
		
		public var btn_start:CommonBtn;
		
		
		
		public function ChallengeHuo() {
			super(false);
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			
		}
		
		public function updateInfo(vo:LevelVO=null):void{
			while(rewardContainer.numChildren){
				rewardContainer.removeChildAt(0);
			}
			for(var i:int=0; i<levelInfo.configVO.rewards.rewards.length; i++){
				var reward:LevelRewardBaseVO = levelInfo.configVO.rewards.rewards[i] as LevelRewardBaseVO;
				var itemBar:ItemBarMiddle = new ItemBarMiddle();
				
				itemBar.updateInfo(ItemVO.getItemVO(reward.ID, 1));//ItemVO.getFairyItemVO(1)//
				itemBar.x = rewardContainer.width;
				rewardContainer.addChild(itemBar);
			}
//			var reward:XMLList = levelInfo.reward.item;
//			for(var i:int=0; i<reward.length(); i++){
//				var itemBar:ItemBarMiddle = new ItemBarMiddle();
//				itemBar.updateInfo(ItemVO.getItemVO(int(reward[i].@ID),1));//ItemVO.getFairyItemVO(1)//
//				itemBar.x = rewardContainer.width;
//				rewardContainer.addChild(itemBar);
//			}
		}
	}
}
