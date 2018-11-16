package com.view.UI.item {
	import com.model.vo.WuxingVO;
	import com.model.vo.item.ItemVO;
	import com.view.UI.fairy.StarLevelPanel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flas.utils.utils;

	/**
	 * 
	 * @author hunterxie
	 */
	public class ItemIcon extends Sprite{
		public var displayShow:Bitmap = new Bitmap;
		
		public var container:Sprite;
		
		public var tf_name:TextField;
		
		public var mc_focus:Sprite;
		public function set choosed(value:Boolean):void{
			mc_focus.visible = value;
		}
		public function get choosed():Boolean{
			return mc_focus.visible;
		}
		
		public var mc_stars:StarLevelPanel;
		
		public var vo:ItemVO;
		
		
		public function ItemIcon(item:ItemVO=null) {
			if(!item){
				clearInfo();
				return;
			}
			container.addChild(displayShow);
			mc_focus.visible = false;
//			displayShow.x = displayShow.y = -boardWidth/2;
//			this.addChild(displayShow);
		}
		
		public function updateInfo(vo:ItemVO):ItemIcon{
			this.vo = vo;
			displayShow.bitmapData =  utils.getDefinitionByName(WuxingVO.getWuxing(vo.templateID));
			
			tf_name.text = vo.data.label;
			mc_stars.showStar(0);
			mc_stars.x = (this.width-mc_stars.width)/2;
			
			return this;
		}
		
		public function remove():void{
			if(this.parent) this.parent.removeChild(this);
			itemPool.push(this);
		}
		
		public static var itemPool:Array=[];
		public static function getIcon(item:ItemVO):ItemIcon{
			return itemPool.length>0 ? (itemPool.pop() as ItemIcon).updateInfo(item) : new ItemIcon(item);
		}
		
		public function clearInfo():void{
			this.displayShow.bitmapData = null;
			this.tf_name.text = "";
			this.mc_stars.showStar(0);
		}
	}
}
