package com.view.UI.user {
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.user.UserVO;
	import com.view.UI.tip.TipNotEnoughResourceVO;
	import com.view.UI.tip.TipChoosePanel;
	import com.model.vo.tip.TipVO;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;

	public class WuxingResetPointPanel extends Sprite{
		public var btn_reset_0:MovieClip;
		public var btn_reset_1:MovieClip;
		public var btn_reset_2:MovieClip;
		public var btn_reset_3:MovieClip;
		public var btn_reset_4:MovieClip;
		
		public var btn_reset_5:MovieClip;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		public function WuxingResetPointPanel() {
			for(var i:int=0; i<6; i++){
				var mc:MovieClip = this["btn_reset_"+i];
				mc.id = i;
				mc.addEventListener(MouseEvent.CLICK, onResetPoint);
			}
		}
		
		protected function onResetPoint(event:*):void{
			var mc:MovieClip = event.target as MovieClip;
			var vo:ResetWuxingPointVO = new ResetWuxingPointVO(mc.id);
			if(vo.goldNum==0){
				TipVO.showChoosePanel(new TipVO(("五行模块洗点", "您的五行无需洗点！"));
			}else{
				TipVO.showChoosePanel(new TipVO((vo.title, vo.info, vo));
			}
		}
	}
}
