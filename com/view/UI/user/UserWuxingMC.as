package com.view.UI.user {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flas.geom.Point;
	import flash.text.TextField;

	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class UserWuxingMC extends Sprite {
		public var mask_wuxing:MovieClip;
		public var tf_resource:TextField;
		public var tf_LV:TextField;
		public var baseScale:Number=0.05;
		
		public var mask_movie:MovieClip;
		public var mc_light:MovieClip;
		public var mc_bubble:MovieClip;
		public var point_middle:MovieClip;
		public var mc_property:MovieClip;
		
		public function get isActive():Boolean{
			return LV>0;
		}
		
		public function get LV():int{
			return _LV;
		}
		public function set LV(value:int):void{
			_LV = value;
			tf_LV.text = String(_LV);
			tf_LV.visible = isActive;
		}
		private var _LV:int=-1;
		

		private var _resource:int=0;

		public function get resource():int {
			return _resource;
		}
		public function set resource(value:int):void {
			_resource=value;
			updateInfo();
		}
		
		private var _maxResource:int=100;
		public function set maxResource(value:int):void {
			_maxResource=value;
			updateInfo();
		}

		
		
		/**
		 * 五行模块
		 */
		public function UserWuxingMC() {
			this.mouseEnabled=this.mouseChildren=false;
			mask_wuxing.scaleY=0;
			mc_bubble.stop();
			
			tf_LV.text = "";
			tf_LV.mouseEnabled = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onAddToStage);
		}
		
		protected function onAddToStage(event:Event=null):void{
			if(_resource>0 && this.stage){
				mc_bubble.play(); 
			}else{
				mc_bubble.stop();
			}
		}


		public function updateInfo():void {
//			this.resource=re;
//			this.maxResource=maxRe;
			this.mask_wuxing.scaleY = baseScale*(1-_resource/_maxResource)+_resource/_maxResource;
			if(this.mask_wuxing.scaleY>1){
				this.mask_wuxing.scaleY=1;
			}
//			if(mc_light){
//				trace(mask_wuxing.rotation, mask_wuxing.height, Math.cos(mask_wuxing.rotation)*mask_wuxing.height, Math.sin(mask_wuxing.rotation)*mask_wuxing.height);
//				mc_light.x = mask_wuxing.x-Math.sin(mask_wuxing.rotation)*mask_wuxing.height;
//				mc_light.y = mask_wuxing.y-Math.cos(mask_wuxing.rotation)*mask_wuxing.height;
				var point:Point = Point.changePoint(this.globalToLocal(mask_wuxing.point.localToGlobal(new Point)));
				mc_light.x = point.x;
				mc_light.y = point.y;
//			}
			this.tf_resource.text = String(_resource);// + "/" + _maxResource;
			onAddToStage();
		}
	}
}
