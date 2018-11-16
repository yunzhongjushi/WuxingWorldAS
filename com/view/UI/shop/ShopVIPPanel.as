package com.view.UI.shop {
	import com.model.event.ObjectEvent;
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.model.vo.config.vip.VIPConfig;
	import com.model.vo.config.vip.VIPConfigVO;
	import com.model.vo.shop.VIPVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 商城中打开的游戏VIP展示面板
	 * @author hunterxie
	 */
	public class ShopVIPPanel extends BasePanel {
		public function get vipInfo():VIPVO{
			return VIPVO.getInstance();
		}

		public var tf_vip_title:TextField;

		public var tf_vip_lv:TextField;

		public var vip_progress:VIPProgress;

		public var tf_upgrade_needGold:TextField;
		public var tf_upgrade_lv:TextField;


		public var btn_charge:CommonBtn;

		public var tf_vip_info:TextField;

		public var btn_pre:SimpleButton

		public var btn_next:SimpleButton;
		
		/**
		 * 当前面板记录的翻页（VIP等级）
		 */
		public function get currentLV():int{
			return _currentLV;
		}
		public function set currentLV(value:int):void{
			_currentLV = value;
			if(_currentLV<0){
				_currentLV = 0;
			}else if(_currentLV>=VIPConfig.maxVIPLVNum){
				_currentLV = VIPConfig.maxVIPLVNum-1;
			}
			
			btn_pre.visible = currentLV>0;
			btn_next.visible = currentLV<VIPConfig.maxVIPLVNum-1;
			if(currentLV>=0 && currentLV<VIPConfig.maxVIPLVNum){
				data = VIPConfig.getGameVIPByLV(currentLV);
				tf_vip_title.text = String(currentLV);
				tf_vip_info.text = data.info;
			}
		}
		private var _currentLV:int;
		
		/**
		 * 当前展示的VIP模版信息
		 */
		private var data:VIPConfigVO;

		public function ShopVIPPanel() {
			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);

			btn_charge.setNameTxt("充 值");
			
			vipInfo.addEventListener(VIPVO.UPDATE_VIP_INFO, updateInfo);
		}

		protected function handle_add(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handle_add);

			this.addEventListener(MouseEvent.CLICK, handle_click);

		}

		protected function handle_click(e:*):void {
			switch(e.target) {
				case btn_charge:
					event(ShopPanel.E_ON_CATEGORY, ShopItemConfigVO.TYPE_GOLD);
					this.close();
					break;
				case btn_pre:
					currentLV--;
					break;
				case btn_next:
					currentLV++;
					break;
			}
		}

		public function updateInfo(e:ObjectEvent=null):void {
			this.visible = true;
			tf_vip_lv.text = String(vipInfo.data.lv);
			vip_progress.updateInfo(UserVO.getInstance().totalCharge, vipInfo.nextCharge);

			if(vipInfo.nextLV!=-1) {
				tf_upgrade_needGold.text=String(vipInfo.upgradeRemain);
				tf_upgrade_lv.text=String(vipInfo.nextLV)
			} else {
				tf_upgrade_needGold.text="0";
				tf_upgrade_lv.text=String(vipInfo.data.lv);
			}

			currentLV = vipInfo.data.lv;
		}
	}
}
