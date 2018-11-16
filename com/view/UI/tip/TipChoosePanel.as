package com.view.UI.tip {
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.tip.TipVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.display.StageAlign;
	import flas.events.MouseEvent;
	
	import ui.tip.TipChoosePanelUI;
	
	
	/**
	 * 带选择的弹出面板
	 * @author hunterxie
	 */
	public class TipChoosePanel extends TipChoosePanelUI {
		public static const NAME:String = "TipChoosePanel";
		public static const SINGLETON_MSG:String="single_TipChoosePanel_only";
		protected static var instance:TipChoosePanel;
		public static function getInstance():TipChoosePanel{
			if ( instance == null ) instance=new TipChoosePanel();
			return instance as TipChoosePanel;
		}
		
		private var vo:TipVO;
		
		/**
		 * 
		 * 
		 */
		public function TipChoosePanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = StageAlign.BOTTOM_LEFT;
			btn_ok.setNameTxt("确  定");
			btn_ok.on(MouseEvent.CLICK, this, confirm);
			btn_cancel.setNameTxt("取  消");
			btn_cancel.on(MouseEvent.CLICK, this, close);
			
			vo = TipVO.getInstance()
			vo.on(TipVO.TIP_CHOOSE_PANEL_SHOW, this, showPanel);
		}
		
		/**
		 * 
		 * @param title
		 * @param info
		 * @param vo
		 * @param arr		可供选择按钮数组
		 */
		private function showPanel(e:ObjectEvent):void{
			this.vo = e.data as TipVO;
			this.tf_title.htmlText = vo.title;
			this.tf_info.htmlText = vo.info;
//			this.tf_info.autoSize = TextFieldAutoSize.CENTER;
			this.btn_ok.setNameTxt(vo.btn1);
			this.btn_cancel.setNameTxt(vo.btn2);
			if(vo.btn2 != ""){
				this.btn_ok.x = 355;
				this.btn_cancel.visible=true;
			}else{
				this.btn_ok.x = 426;
				this.btn_cancel.visible=false;
			}
			this.event(BasePanel.SHOW_PANEL, TipChoosePanel.NAME);
		}
		
		public function confirm(e:*=null):void{
			vo.choosed = 1;
			super.close();
			EventCenter.event(TipVO.TIP_PANEL_CONFIRM, vo);
		}
		
		protected var isCancelUse:Boolean = false;
		override public function close(e:*=null):void{
			vo.choosed = 2;
			super.close(e);
			EventCenter.event(TipVO.TIP_PANEL_CANCEL, vo);
		}
	}
}
