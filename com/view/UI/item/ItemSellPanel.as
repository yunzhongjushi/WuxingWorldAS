package com.view.UI.item {
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.PagePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;

	public class ItemSellPanel extends BasePanel {
		public function ItemSellPanel() {
			btn_ok.tf_name.text="确定";

			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_ok:
					var useNum:int=progressPanel.cuPage;
					running_vo.useItemNum=useNum;
					event(E_SELL, running_vo);
					break;
				case btn_cover:
					this.close();
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_SELL:String="E_SELL";
		//Event Names
		//场景含有组件
		public var progressPanel:PagePanel;
		public var btn_ok:CommonBtn;
		public var btn_cover:MovieClip
		//running 
		private var running_vo:ItemVO

		public function updateInfo(vo:ItemVO):void {
			running_vo=vo;
			progressPanel.init(1, vo.num);
		}
	}
}
