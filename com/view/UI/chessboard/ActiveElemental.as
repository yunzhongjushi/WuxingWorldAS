package com.view.UI.chessboard{
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	
	import flas.display.Bitmap;
	import flas.events.Event;
	
	import ui.chessboard.ActiveElementalUI;

	/**
	 * 
	 * @author hunterxie
	 */
	public class ActiveElemental extends ActiveElementalUI{
		
		public var wuxingBG:Bitmap = new Bitmap;
		
		public var mc_resource:QiuPoint;
		
		/**
		 * 上次消除的相同的棋子
		 */
		public var clearNum:int = 0;
		
		public var lastKind:int;
		
		public function ActiveElemental(){
			this.visible=false;
			mc_resource = new QiuPoint;
			wuxingBG.x = -30;
			wuxingBG.y = -31;
			this.mc_bgContainer.addChild(wuxingBG);
		}
		
		public function updateClears(kind:int, clearNum:int):void{
			if(!WuxingVO.judgeIsWuxing(kind)){
				this.visible = false;
				return;
			}
			if(clearNum>0){
				this.visible = true;
				mc_num.tf_LV.text = String(clearNum);
				this.kind = lastKind = kind;
				wuxingBG.setBitmapDataClass("b漩_"+lastKind, "imgs/chessboard/icon/", ".png");
				this.on(Event.ENTER_FRAME, this, onFrame);
			}else{
				this.visible = false;
				this.off(Event.ENTER_FRAME, this, onFrame);
			}
			this.mc_num.visible = clearNum>1;
		}
		
		private function onFrame(e:*):void{
			mc_bgContainer.rotation += 15;
		}
		
		public function set kind(value:int):void{
			mc_resource.kind = value;
		}
	}
}