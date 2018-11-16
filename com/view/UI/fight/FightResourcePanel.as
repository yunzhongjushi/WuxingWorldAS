package com.view.UI.fight {
	import com.model.vo.WuxingVO;
	import com.view.UI.ResourcePanel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 * @author hunterxie
	 */
	public class FightResourcePanel extends ResourcePanel {
		
		public function FightResourcePanel() {
			super();
		}
		
		override public function init(info:WuxingVO):void{
			super.init(info);
			
//			var clearID:int = WuxingVO.getWuxing(info.myWuxing, WuxingVO.KE_WO);
//			for(var i:int=0; i<5; i++){
//				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
//				mc.visible=true;
//				mc.x =36*i;
//				if(i==clearID){
//					mc.visible=false;
//				}else if(i>clearID){
//					mc.x = 36*(i-1);
//				}
//			}
		}
		
		public function initProperty(info:WuxingVO):void{
			resourceInfo = info;
			resourceInfo.removeEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateInfo);
			resourceInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateWuxingProperty);
			updateWuxingProperty();
		}
		
		private function updateWuxingProperty(e:Event=null):void{
			for(var i:int=0; i<5; i++){
				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
				mc.mc_cover.scaleX = 1;
				mc.tf_energy.text = resourceInfo.getWuxingProperty(i); 
			}
		}
		
		override public function updateInfo(e:Event=null):void {
			for(var i:int=0; i<5; i++){ 
				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
				mc.mc_cover.width = Math.floor(resourceInfo.getResource(i)/resourceInfo.getMaxResource(i)*55);
				mc.tf_energy.text = resourceInfo.getResource(i);//+"/"+resourceInfo.getMaxResource(i);
			}
		}
	}
}