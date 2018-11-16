package com.view.UI.altar {
	import com.model.vo.WuxingVO;
	import com.model.vo.altar.AltarVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.UI.ResourceIcon;
	
	import flas.events.Event;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class AltarWuxing extends BasePanel {
		/**
		 * 初始页面
		 */
		public static const STATE_MAIN:String="STATE_MAIN";
		/**
		 * 选择祭坛后
		 */
		public static const STATE_SELECTED:String="STATE_SELECTED";

		/**
		 * 
		 */
		private var state:String;
		
		//***********祭坛界面********************
		public var altar_pay_bg:MovieClip;
		public var btn_back:SimpleButton;
		public var tf_wuxing_name:TextField;
		public var tf_free_tip_2:TextField;
		public var tf_wuxing_tip:TextField;
		public var price_one:ResourceIcon;
		public var price_ten:ResourceIcon;
		public var btn_one:SimpleButton;
		public var btn_ten:SimpleButton;
		//***********祭坛界面********************
		
		//***********主界面********************
		public var altar_main_bg:MovieClip;
		public var tf_free_tip:TextField;
		public var price_main:ResourceIcon;
		
		public var btn_0:MovieClip;
		public var btn_1:MovieClip;
		public var btn_2:MovieClip;
		public var btn_3:MovieClip;
		public var btn_4:MovieClip;
		//***********主界面********************

		
		/**
		 *
		 * 
		 * 
		 * 
		 *  
		 * 
		 */		
		public function AltarWuxing() {
			for(var i:int=0; i<5; i++) {
				var btn:MovieClip = this["btn_"+i] as MovieClip;
				btn.wuxing = 1;
				btn.visible = true;
				btn.addEventListener(MouseEvent.CLICK, handle_click);
			}
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_close);
		}

		protected function handle_close(e:*):void {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}

		private var running_altarVO:AltarVO;
		public function updateInfo(altarVO:AltarVO):void {
			if(altarVO!=null) {
				running_altarVO=altarVO;
			}
			onToMain();
		}

		/**
		 * 展示五行选择面板
		 * @param wuxing
		 */
		public function onSelectWuxing(wuxing:int):void {
			state = STATE_SELECTED;
			closeAll();

			running_altarVO.selectedWuxing = wuxing;

			altar_pay_bg.visible=true;
			btn_back.visible=true;
			tf_free_tip_2.visible=true;
			price_one.visible=true;
			price_ten.visible=true;
			btn_one.visible=true;
			btn_ten.visible=true;
			tf_wuxing_tip.visible=true;
			tf_wuxing_name.visible=true;

			btn_back.addEventListener(MouseEvent.CLICK, handle_click);
			btn_one.addEventListener(MouseEvent.CLICK, handle_click);
			btn_ten.addEventListener(MouseEvent.CLICK, handle_click);

			tf_wuxing_tip.text = "有机会获得"+WuxingVO.getHtmlWuxing(wuxing)+"精灵的碎片"
			tf_wuxing_name.text = "消耗"+WuxingVO.getHtmlWuxing(wuxing)+"资源";
			
			var onevo:ItemVO = running_altarVO.getCostVOBySetting(true, false);
			price_one.updateInfo(onevo.data.icon, String(onevo.num));
			var tenvo:ItemVO = running_altarVO.getCostVOBySetting(true, true);
			price_ten.updateInfo(tenvo.data.icon, String(tenvo.num));
//			price_ten.updateInfoByVO(running_altarVO.getCostVOBySetting(true, true));

			this.addEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}


		public function onToMain():void {
			state = STATE_MAIN;
			closeAll();

			altar_main_bg.visible=true;
			tf_free_tip.visible=true;
			price_main.visible=true;

			this.addEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}

		private function closeAll():void {
			altar_main_bg.visible=false;
			tf_free_tip.visible=false;
			price_main.visible=false;

			// wuxing
			altar_pay_bg.visible=false;
			btn_back.visible=false;
			tf_free_tip_2.visible=false;
			tf_wuxing_tip.visible=false;
			price_one.visible=false;
			price_ten.visible=false;
			btn_one.visible=false;
			btn_ten.visible=false;
			tf_wuxing_name.visible=false;

			btn_back.removeEventListener(MouseEvent.CLICK, handle_click);
			this.removeEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}

		private function enterFrameUpdate(e:*):void {
			var cd:String=running_altarVO.getWuxingCDStr();

			if(state==STATE_MAIN) {
				price_main.updateInfo("空", "消耗"+running_altarVO.getCostVOBySetting(true, false).num+"元素");
				tf_free_tip.text=cd;
				if(cd==""||running_altarVO.wuxingFreeTime<=0) {
					tf_free_tip.text=running_altarVO.getWuxingFreeTimeStr();
					if(running_altarVO.wuxingFreeTime>0) {
						price_main.updateInfo("空", "免费");
					}
				}
			}
			if(state==STATE_SELECTED) {
				tf_free_tip_2.text=cd;
				if(cd==""||running_altarVO.wuxingFreeTime<=0) {
					tf_free_tip_2.text=running_altarVO.getWuxingFreeTimeStr();
					if(running_altarVO.wuxingFreeTime>0) {
						price_one.updateInfo("空", "免费");
					}
				}
			}
		}

		protected function handle_click(e:*):void {
			switch(e.target){
				case btn_back:
					onToMain();
					break;
				case btn_one:
					running_altarVO.markBuy(true, false);
					event(AltarPanel.E_BUY, running_altarVO, true);
					break;
				case btn_ten:
					running_altarVO.markBuy(true, true);
					event(AltarPanel.E_BUY, running_altarVO, true);
					break;
				default :
					if(e.target.wuxing){
						onSelectWuxing(e.target.wuxing);
					}
					break;
			}
		}

		public function refresh():void {
			running_altarVO.afterBuy();

			if(this.state==STATE_MAIN) {
				onToMain();
			}
			if(this.state==STATE_SELECTED) {
				onSelectWuxing(running_altarVO.selectedWuxing);
			}

		}
	}
}
