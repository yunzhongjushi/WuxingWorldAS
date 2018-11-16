package com.view.UI.tip {
	import com.view.BasePanel;
	
	import flas.utils.Tween;
	
	import ui.tip.TipLightPanelUI;
	
	
	/**
	 * 简单文字提示弹出面板
	 * @author hunterxie
	 */
	public class TipLightPanel extends TipLightPanelUI{
		public static const NAME:String = "TipLightPanel";
		public static const SINGLETON_MSG:String="single_TipLightPanel_only";
		protected static var instance:TipLightPanel;
		public static function getInstance():TipLightPanel{
			if ( instance == null ) instance=new TipLightPanel(); 
			return instance as TipLightPanel;
		}
		
		
		/**
		 * 
		 * 
		 */
		public function TipLightPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		/**
		 * 
		 * @param info
		 * @param time
		 */
		public static function showTip(info:String, time:Number=2):void{
			getInstance().tf_info.htmlText = info;
			instance.alpha=1;
			Tween.to(instance, time, {alpha:0, onComplete:instance.close}, instance);
			instance.event(BasePanel.SHOW_PANEL);
		}
	}
}
