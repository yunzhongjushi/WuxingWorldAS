package com.view.UI.fairy {
	import com.model.vo.WuxingVO;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.item.FairyEquipVO;
	import com.view.BaseImgBar;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class FairyEquipmentBar extends BaseImgBar {
		public function FairyEquipmentBar() {
			super();

			this.itemImg.mask=itemBarMiddle_Mask;

			this.addEventListener(Event.ADDED_TO_STAGE, handle_add);
		}

		protected function handle_add(event:Event):void {
			refresh();
		}

		public var stateCover:MovieClip;
		public var itemBarMiddle_Mask:MovieClip;

		public var runnning_equipVO:FairyEquipVO;
		public var runnning_fairyVO:BaseFairyVO;

		private var isEquip:Boolean;

		private var isHasEquip:Boolean;



		public function updateInfo(slot:int, equipVO:FairyEquipVO, fairyVO:BaseFairyVO, isEquip:Boolean):void {
			this.isHasEquip=(equipVO.num>0);
			runnning_equipVO=equipVO;
			runnning_fairyVO=fairyVO;
			this.isEquip=isEquip;
			refresh();
		}

		public function refresh():void {
			if(isEquip) {
				this.updateClass(runnning_equipVO.data.icon);
				stateCover.visible=false;
			} else {
				this.clear();
				if(isHasEquip) {
					stateCover.visible=true;
					if(runnning_equipVO.data.needLevel<=runnning_fairyVO.LV) {
						stateCover.gotoAndStop(1);
					} else {
						stateCover.gotoAndStop(2);
					}
				} else {
					stateCover.visible=false;
				}
			}
		}
	}
}
