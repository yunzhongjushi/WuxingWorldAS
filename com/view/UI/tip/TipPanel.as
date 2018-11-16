package com.view.UI.tip {
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.tip.TipVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import ui.tip.TipPanelUI;
	
	
	/**
	 * 弹出面板
	 * @author hunterxie
	 */
	public class TipPanel extends TipPanelUI {
		public static const NAME:String = "TipPanel";
		public static const SINGLETON_MSG:String="single_TipPanel_only";
		protected static var instance:TipPanel;
		public static function getInstance():TipPanel{
			if ( instance == null ) instance=new TipPanel(); 
			return instance as TipPanel;
		}
		
		private var vo:TipVO;
		
		/**
		 * 
		 * 
		 */
		public function TipPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = StageAlign.BOTTOM_LEFT;
			btn_ok.setNameTxt("确  定");
			btn_ok.on(MouseEvent.CLICK, this, confirm);
			
			vo = TipVO.getInstance();
			vo.on(TipVO.TIP_PANEL_SHOW, this, showPanel);
		}
		
		/**
		 * 
		 * @param title
		 * @param info
		 * @param key	TipVO
		 */
		private function showPanel(e:ObjectEvent):void{
			this.vo = e.data as TipVO;
			this.tf_info.text = vo.info;//htmlText = vo.info;
			this.btn_ok.setNameTxt(vo.btn1);
			this.event(BasePanel.SHOW_PANEL, TipPanel.NAME);
		}
		
		public function confirm(e:*=null):void{
			vo.confirm();
			close();
		}
	}
}
