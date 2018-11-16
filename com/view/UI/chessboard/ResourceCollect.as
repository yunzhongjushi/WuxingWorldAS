package com.view.UI.chessboard{
	import flas.display.Sprite;
	/**
	 * 
	 * @author hunterxie
	 */
	public class ResourceCollect extends Sprite{
		public var vo:*;
		public var mc_resource:Qiu;
		public var tf_num:*; 
		
		public function ResourceCollect(){
			mc_resource = new Qiu;
			mc_resource.x = 46;
			mc_resource.y = 37;
			this.addChild(mc_resource);
		} 
		
		public function updateInfo(info:*):void{
			this.vo = info;
		}
		
		public function set kind(value:int):void{
			mc_resource.kind = value;
		}
	}
}