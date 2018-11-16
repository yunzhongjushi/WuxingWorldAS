package com.view.UI {
	import com.model.vo.WuxingVO;
	import com.utils.ArrayFactory;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ResourcePanel extends Sprite {
		public var mc_energy_0:MovieClip;
		public var mc_energy_1:MovieClip;
		public var mc_energy_2:MovieClip;
		public var mc_energy_3:MovieClip;
		public var mc_energy_4:MovieClip;
		 
		public var resourceInfo:WuxingVO;
		
		public function ResourcePanel() {
			this.mouseChildren = false;
			for(var i:int=0; i<5; i++)
				(this["mc_energy_"+i] as MovieClip).gotoAndStop(i+1);
		}
		
		public function init(info:WuxingVO):void{
			resourceInfo = info;
			resourceInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateInfo);
			updateInfo();
		}
		
		/**
		 * 展示资源信息
		 * @param e
		 */
		public function updateInfo(e:Event=null):void {
			var baseX:int = 0;
			for(var i:int=0; i<5; i++){
				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
				if(resourceInfo.getWuxingProperty(i)>0){
					mc.visible = true;
					mc.x = baseX;
					baseX += mc.width+10; 
				}else{
					mc.visible = false;
				}
				mc.mc_cover.scaleX = resourceInfo.getResource(i)/resourceInfo.getMaxResource(i);
				mc.tf_energy.text = resourceInfo.getResource(i)+"/"+resourceInfo.getMaxResource(i);
			}
		}
		
		/**
		 * 展示五行等级信息
		 * @param e
		 */
		public function updateProperty(e:Event=null):void {
			var max:int = ArrayFactory.getMax(resourceInfo.getWuxingPropertyArr());
			for(var i:int=0; i<5; i++){
				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
				mc.mc_cover.scaleX = resourceInfo.getWuxingProperty(i)/max;
				mc.tf_energy.text = String(resourceInfo.getWuxingProperty(i));
			}
		}
		
		public function changeSite():void{
			for(var i:int=0; i<5; i++){
				var mc:MovieClip = this["mc_energy_"+i] as MovieClip;
				mc.tf_energy.scaleX=-1;
				mc.tf_energy.x=mc.tf_energy.width;
			}
		}
	}
}