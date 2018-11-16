package com.view.UI.level{
	import com.model.event.EventCenter;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;
	
	/**
	 * 战斗回放结束面板
	 * @author hunterxie
	 */
	public class LevelReviewOverPanel extends BasePanel{
		public static const NAME:String = "LevelReviewOverPanel";
		private static const SINGLETON_MSG:String="single_"+NAME+"_only";
		private static var instance:LevelReviewOverPanel;
		public static function getInstance():LevelReviewOverPanel{
			if ( instance == null ) instance=new LevelReviewOverPanel();
			return instance as LevelReviewOverPanel;
		}
		
		
		/**
		 * 再重放一次游戏复盘
		 */
		public static const REVIEW_GAGIN:String = "REVIEW_GAGIN";
		
		public var btn_OK:CommonBtn;
		public var btn_retry:CommonBtn;
		public var tf_target:TextField;
		
		
		/**
		 * 复盘结束面板
		 */
		public function LevelReviewOverPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = ALIGN_MIDDLE;
			
			btn_OK.setNameTxt("关  闭");
			btn_OK.addEventListener(MouseEvent.CLICK, close);
			
			btn_retry.setNameTxt("再看一次");
			btn_retry.addEventListener(MouseEvent.CLICK, retry);
		}
		
		
		public function retry(e:*=null):void{
			if(this.parent)
				this.parent.removeChild(this);
			EventCenter.event(LevelReviewOverPanel.REVIEW_GAGIN);
		}
	}
}