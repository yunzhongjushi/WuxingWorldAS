package com.view.UI.fairy {
	import com.model.vo.fairy.BaseFairyVO;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.geom.Point;
	import flash.text.TextField;
	import flas.utils.utils;





	/**
	 * 精灵列表中的精灵头像
	 * @author hunterxie
	 */
	public class FairyListIcon extends MovieClip {
		public var tf_LV:TextField;
		public var tf_name:TextField;

		private var headImg:Bitmap = new Bitmap;

		public var mc_head:MovieClip;

		public var mc_focus:Sprite;
		public function set choosed(value:Boolean):void{
			mc_focus.visible = value;
		} 
		public function get choosed():Boolean{
			return mc_focus.visible;
		}

		public var fairyInfo:BaseFairyVO;
		
		

		public function FairyListIcon(fairy:BaseFairyVO) {
//			mc_head.scaleX = mc_head.scaleY = 0.8;
			mc_head.addChild(headImg);
			this.mouseChildren = false;
			mc_focus.visible = false;
			init(fairy);
		}

		public function init(info:BaseFairyVO):FairyListIcon {
			this.fairyInfo = info;
			this.fairyInfo.globalPoint = this.mc_head.localToGlobal(new Point);
			this.fairyInfo.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, updateInfo);

			headImg.bitmapData = utils.getDefinitionByName(fairyInfo.nickName+"head");//utils.getDefinitionByName(fairyInfo.nickName+"_list");
			this.gotoAndStop(fairyInfo.wuxing);
			this.tf_name.text = info.nickName;
			
			updateInfo();
			
			return this;
		}

		public function updateInfo(event:Event=null):void {
			tf_LV.text=String(fairyInfo.LV);
		}
		
		public function remove():void{
			if(this.parent) this.parent.removeChild(this);
			fairyPool.push(this);
		}
		
		public static var fairyPool:Array=[];
		public static function getIcon(fairy:BaseFairyVO):FairyListIcon{
			return fairyPool.length>0 ? (fairyPool.pop() as FairyListIcon).init(fairy) : new FairyListIcon(fairy);
		}
		
	}
}
