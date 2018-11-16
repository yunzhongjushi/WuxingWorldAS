package com.view.UI.altar {
	import com.model.vo.WuxingVO;
	import com.model.vo.altar.AltarVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.UI.ResourceIcon;
	import com.view.UI.item.ItemBarMiddle;
	
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
	public class AltarGold extends BasePanel {
		/**
		 * 初始页面
		 */
		public static const STATE_MAIN:String="STATE_MAIN";

		/**
		 * 选择祭坛后
		 */
		public static const STATE_SELECTED:String="STATE_SELECTED";

		private var state:String = STATE_SELECTED;

		public function AltarGold() {
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, handle_close);

		}

		protected function handle_close(e:*):void {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}

		private var running_altarVO:AltarVO
		public function updateInfo(altarVO:AltarVO):void {
			if(altarVO!=null) {
				running_altarVO=altarVO;
			}
			onToMain();
		}

		public var altar_pay_bg:MovieClip;

		public var tf_free_tip_2:TextField;

		public var price_one:ResourceIcon;

		public var price_ten:ResourceIcon;

		public var btn_one:SimpleButton;

		public var btn_ten:SimpleButton;
		
		
		// main页面
		
		public var altar_main_bg:MovieClip;
		
		public var tf_free_tip:TextField;
		
		public var price_main:ResourceIcon;
		
		public var btn_open:SimpleButton;
		
		public var item_icon:ItemBarMiddle;
		
		

		/**
		 * 
		 * 
		 */
		public function onOpenPay():void {
			closeAll();

			tf_free_tip_2.visible=true;
			price_one.visible=true;
			price_ten.visible=true;
			btn_one.visible=true;
			btn_ten.visible=true;
			altar_pay_bg.visible=true;

			btn_one.addEventListener(MouseEvent.CLICK, handle_click);
			btn_ten.addEventListener(MouseEvent.CLICK, handle_click);
			
			var ontVO:ItemVO = running_altarVO.getCostVOBySetting(false, false);
			price_one.updateInfo(WuxingVO.getWuxing(ontVO.data.wuxing), String(ontVO.num));
			
			var tenVO:ItemVO = running_altarVO.getCostVOBySetting(false, true);
			price_ten.updateInfo(WuxingVO.getWuxing(tenVO.data.wuxing), String(tenVO.num));

			this.addEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}


		public function onToMain():void {
			state=STATE_MAIN;

			closeAll();

			altar_main_bg.visible=true;
			btn_open.visible=true;
			tf_free_tip.visible=true;
			price_main.visible=true;
			item_icon.visible=true;

			btn_open.addEventListener(MouseEvent.CLICK, handle_click);
			var costVO:ItemVO = running_altarVO.getCostVOBySetting(false, false);
			price_main.updateInfo(WuxingVO.getWuxing(costVO.data.wuxing), String(costVO.num));

			this.addEventListener(Event.ENTER_FRAME, enterFrameUpdate);
			item_icon.updateInfo(ItemVO.getItemVO(ItemConfigVO.EXP_BIG));
		}



		private function closeAll():void {
			// main
			altar_main_bg.visible=false;
			btn_open.visible=false;
			tf_free_tip.visible=false;
			price_main.visible=false;

			btn_open.removeEventListener(MouseEvent.CLICK, handle_click);

			// wuxing
			tf_free_tip_2.visible=false;
			price_one.visible=false;
			price_ten.visible=false;
			btn_one.visible=false;
			btn_ten.visible=false;
			altar_pay_bg.visible=false;
			item_icon.visible=false;

			this.removeEventListener(Event.ENTER_FRAME, enterFrameUpdate);
		}

		private function enterFrameUpdate(e:*):void {
			var cd:String = running_altarVO.getGoldCDStr();
			if(state==STATE_MAIN) {
				tf_free_tip.text=cd;
				if(cd=="") {
					price_main.updateInfo("空", "免费");
				}
			}
			if(state==STATE_SELECTED) {
				tf_free_tip_2.text=cd;
				if(cd=="") {
					price_one.updateInfo("空", "免费");
				}
			}
		}

		protected function handle_click(e:*):void {
			if(e.currentTarget==btn_open) {
				onOpenPay();
			}
			if(e.currentTarget==btn_one) {
				running_altarVO.markBuy(false, false);

				event(AltarPanel.E_BUY, running_altarVO, true);
			}
			if(e.currentTarget==btn_ten) {
				running_altarVO.markBuy(false, true);

				event(AltarPanel.E_BUY, running_altarVO, true);
			}
		}

		public function refresh():void {
			running_altarVO.afterBuy();

			if(this.state==STATE_MAIN) {
				onToMain();
			}
			if(this.state==STATE_SELECTED) {
				onOpenPay();
			}

		}
	}
}
