package com.view.UI.item{
	import com.model.vo.config.item.ItemConfig;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.config.shop.ShopItemConfigVO;
	import com.model.vo.item.ItemBaseVO;
	import com.model.vo.item.ItemVO;
	import com.view.BaseImgBar;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import listLibs.ITouchPadBar;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class ItemBarMiddle extends BaseImgBar implements ITouchPadBar{
		/**
		 * 碎片展示
		 */
		public var mc_piece:BaseImgBar;
		/**
		 * 物品展示
		 */
		public var mc_normal:BaseImgBar;
		
		public var running_vo:ItemVO;
		
		public var tarShow:BaseImgBar;
		
		
		/**
		 * 
		 * 
		 */
		public function ItemBarMiddle(){
			
		}
		
		public function updateInfo(vo:*):void{
			if(vo == null) return;
			if(running_vo) running_vo.removeEventListener(ItemBaseVO.UPDATE_ITEM_INFO,refresh);
			running_vo = vo as ItemVO;
			running_vo.addEventListener(ItemBaseVO.UPDATE_ITEM_INFO,refresh);
			
			refresh();
		}
		
		/**
		 * 商城物品临时展示
		 * @param vo
		 */
		public function updateShopItem(vo:ItemConfigVO):void{
			mc_piece.visible = mc_normal.visible = false;
			tarShow = mc_normal;
			if(ItemConfigVO.judgeIsPiece(vo.type)){
				tarShow = mc_piece;
			}
			tarShow.visible = true;
			tarShow.updateClass(vo.icon);
		}
		
		private function refresh(e:Event=null):void{
			mc_piece.visible = mc_normal.visible = false;
			tarShow = mc_normal;
			if(ItemConfigVO.judgeIsPiece(running_vo.data.type)){
				tarShow = mc_piece;
			}
			tarShow.visible = true;
			tarShow.updateClass(running_vo.data.icon);
			tarShow.tf_label.visible = running_vo.num>1;
			tarShow.tf_label.text = String(running_vo.num);
//			
//			
//			updateClass(running_vo.data.icon); 
//			
//			mc_piece.visible = false;
//			mc_normal.visible = false;
//			
//			var mc:BaseImgBar = mc_normal;
//			if(ItemConfigVO.judgeIsPiece(running_vo.data.type)){
//				mc = mc_piece;
//			}
//			mc.visible = true;
//			mc.tf_label.visible = running_vo.num>1;
//			mc.tf_label.text = String(running_vo.num);
//			updateClass(running_vo.data.icon);
		}
		
		public function close():void{
			if(this.parent) this.parent.removeChild(this);
		}
		
	}
}