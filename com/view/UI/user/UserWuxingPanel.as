package com.view.UI.user {
	import com.model.ApplicationFacade;
	import com.greensock.TweenLite;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.guide.ElementActiveVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	
	/**
	 * 
	 * @author hunterxie
	 */
	public class UserWuxingPanel extends BasePanel {
		public static const UP_WUXING_PROPERTY_LEVEL:String = "UP_WUXING_PROPERTY_LEVEL";
		
		public var wuxing_0:UserWuxingJin;
		public var wuxing_1:UserWuxingMu;
		public var wuxing_2:UserWuxingTu;
		public var wuxing_3:UserWuxingShui;
		public var wuxing_4:UserWuxingHuo;

		public var mc_0:Sprite;
		public var mc_1:Sprite;
		public var mc_2:Sprite;
		public var mc_3:Sprite;
		public var mc_4:Sprite;
		
		public var mc_lock_0:Sprite;
		public var mc_lock_1:Sprite;
		public var mc_lock_2:Sprite;
		public var mc_lock_3:Sprite;
		public var mc_lock_4:Sprite;
		
		public var tf_numProperty:TextField;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		/**
		 * 五行模块是否首次激活，用于配合展示模块激活动画
		 */
		public var wuxingActiveInfo:Array = [true, true, true, true, true];
		
		/**
		 * 
		 * 
		 */
		public function UserWuxingPanel() {
			for (var i:int=0; i < 5; i++) {
				var mc:MovieClip=this["mc_" + i];
				mc.i=i;				
				mc.addEventListener(MouseEvent.CLICK, onc);
			}
			
			userInfo.wuxingInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateInfo);
			
			EventCenter.on(ApplicationFacade.GUIDE_ELEMENT_ACTIVATING, this, showActivating);
		}

		protected function onc(event:*):void {
			var lock:Sprite = this["mc_lock_" + event.target.i];
			var mc:UserWuxingMC = this["wuxing_" + event.target.i];
//			TipPanel.showPanel("五行模块加点", "你要消耗xx点"+wuxing+"元素升级"+wuxing+"模块吗？","upWuxingPropertyLevel");
			EventCenter.event(UP_WUXING_PROPERTY_LEVEL, event.target.i);
//			if(lock && lock.visible){
//				lock.visible=false;
//			}else{
//				mc.resource+=5;
//			}
		}
		
		/**
		 * 
		 */
		public function updateInfo(e:ObjectEvent=null):void{
			for(var i:int=0; i<5; i++){
				var lock:Sprite = this["mc_lock_" + i];
//				lock.visible = (userInfo.wuxingInfo.getWuxingProperty(i)>0 && wuxingActiveInfo[i]);
				
				var wuxing:UserWuxingMC=this["wuxing_" + i];
				wuxing.maxResource = userInfo.wuxingInfo.getMaxResource(i);
				wuxing.resource = userInfo.wuxingInfo.getResource(i)
				wuxing.LV = userInfo.wuxingInfo.getWuxingProperty(i);
				lock.visible = !(wuxing.isActive && wuxingActiveInfo[i]);
			}
		}
		
		/**
		 * 获取五行盒子中元素块的全局坐标
		 * @param wuxing
		 * @return 
		 */
		public function getFragmentPoint(wuxing:int=0):Point{
//			var fragment:UserWuxingMC=this["wuxing_0"];
			var fragment:UserWuxingMC=this["wuxing_" + wuxing];
			return Point.changePoint(fragment.point_middle.localToGlobal(new Point));
		}
		
		public function activating(wuxing:int):void{
			var lock:Sprite=this["mc_lock_" + wuxing];
			lock.visible = true;
			TweenLite.to(lock, 1, {alpha:0, onComplete:onActivatingOver, onCompleteParams:[wuxing]});
		}
		
		public function showActivating(e:ObjectEvent):void{
			var point:ElementActiveVO = e.data as ElementActiveVO;
			var lock:Sprite=this["mc_lock_" + point.wuxing];
			lock.visible = true;
			lock.alpha = 1;
			wuxingActiveInfo[point.wuxing] = false;
		}
		
		public function onActivatingOver(wuxing:int):void{
			wuxingActiveInfo[wuxing] = true;
			updateInfo();
		}
	}
}
