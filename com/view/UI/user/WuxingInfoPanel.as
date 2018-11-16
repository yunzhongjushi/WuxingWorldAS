package com.view.UI.user {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.conn.ServerVO_93;
	import com.model.vo.conn.ServerWuxingPropertyVO;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.UI.skill.SkillInfoPanel;
	import com.view.UI.skill.SkillPanel;
	import com.view.UI.tip.TipChoosePanel;
	import com.view.UI.tip.TipPanel;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.utils.Tween;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	
	/**
	 * 五行盒子面板
	 * @author hunterxie 
	 */
	public class WuxingInfoPanel extends BasePanel {
		public static const NAME:String = "WuxingInfoPanel";
		public static function getShowName():String{
			getInstance().updateInfo();
			instance.mc_skillPanel.updateInfo();
			ServerVO_93.sendInfo();
			return NAME;
		}
		public static const SINGLETON_MSG:String="single_WuxingInfoPanel_only";
		protected static var instance:WuxingInfoPanel;
		public static function getInstance():WuxingInfoPanel{
			if ( instance == null ) instance=new WuxingInfoPanel();
			return instance;
		}
		
		
		
		/**
		 * 获取五行盒子中元素块的全局坐标
		 * @param wuxing
		 * @return 
		 */
		public static function getFragmentPoint(wuxing:int):Point{
			return instance.userWuxing.getFragmentPoint(wuxing);
		}
		
		public var userWuxing:UserWuxingPanel;
		
		/**
		 * 技能面板
		 */
		public var mc_skillPanel:SkillPanel;
		
		/**
		 * 五行属性+洗点按钮
		 */
		public var mc_property:MovieClip;
		
//		public var mc_resetPointPanel:WuxingResetPointPanel;
		
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		private var serverWuxingPropertyVO:ServerWuxingPropertyVO;
		
		/**
		 * 
		 * 
		 */
		public function WuxingInfoPanel() {
//			this.alignInfo = ALIGN_MIDDLE;
			
//			mc_resetPointPanel.visible = false;
			mc_property.tf_num.text = "0";
			mc_property.mouseChildren = false;
			mc_property.addEventListener(MouseEvent.CLICK, onReserWuxingProperty);
			 
			userInfo.wuxingInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateInfo);
			
			EventCenter.on(ApplicationFacade.UPDATE_USER_INFO, this, updateInfo);
//			mc_skillPanel.visible = false;
			EventCenter.on(ApplicationFacade.GUIDE_MISSION_CONFIRM, this, onGuideConfirm);
			EventCenter.on(ApplicationFacade.FRAGMENT_ACTIVATING_OVER, this, activating);
			
			serverWuxingPropertyVO = ServerWuxingPropertyVO.getInstance();
			serverWuxingPropertyVO.on(ApplicationFacade.SERVER_INFO_OBJ, this, updateInfo);
		}
		
		private function onGuideConfirm(e:ObjectEvent):void{
			if(3==e.data){ 
				this.alpha = 0;
				this.mouseEnabled = false;
				Tween.to(this, 0.8, {alpha:1, mouseEnabled:true}, this);
				
				EventCenter.event(ApplicationFacade.SHOW_PANEL, WuxingInfoPanel.getShowName());
			}
		}
		
		protected function onReserWuxingProperty(event:*):void{ 
//			mc_resetPointPanel.visible = !mc_resetPointPanel.visible;
			
			var vo:ResetWuxingPointVO = new ResetWuxingPointVO(5);
			if(vo.goldNum==0){
				TipVO.showTipPanel(new TipVO("五行模块洗点", "您的五行无需洗点！"));
			}else{
				TipVO.showChoosePanel(vo);
			}
		}
		
		public function updateInfo(e:ObjectEvent=null):void{
			userWuxing.updateInfo();
			
			for(var i:int=0; i<5; i++){
//				var skill:SkillEquipIcon = this["equipSkill_"+i] as SkillEquipIcon;
//				skill.updateInfo();
			}
			mc_property.tf_num.text = String(userInfo.allPoint);//+"/"+(userInfo.LV-1)*4;
		}

		/**
		 * 
		 * @param info
		 */
		public function updateSkillInfo(info:UserVO):void{
			
		}
		
		
		public function activating(e:ObjectEvent):void{
			userWuxing.activating(e.data as int);
		}
	}
}
