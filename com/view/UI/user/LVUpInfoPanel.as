package com.view.UI.user {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.level.LevelOverVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.text.TextField;

	/**
	 * 升级后展示的角色数据变化面板，作为前期引导玩家对角色属性的概念
	 * @author hunterxie
	 */
	public class LVUpInfoPanel extends BasePanel{
		public static const NAME:String = "LVUpInfoPanel";
		public static const SINGLETON_MSG:String="single_LVUpInfoPanel_only";
		protected static var instance:LVUpInfoPanel;
		public static function getInstance():LVUpInfoPanel{
			if ( instance == null ) instance=new LVUpInfoPanel(); 
			return instance as LVUpInfoPanel;
		}
		
		public var btn_ok:CommonBtn;
		public var tf_LV:TextField;
		public var tf_live:TextField;
		public var tf_maxLive:TextField;
		public var tf_wuxingPoint:TextField;
		public var tf_fairyLV:TextField;
		
		public var info:LevelOverVO;
		
		public function LVUpInfoPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			btn_ok.setNameTxt("确定");
			btn_ok.addEventListener(MouseEvent.CLICK, close);
			
			info = LevelOverVO.getInstance();
			info.on(LevelOverVO.INFO_UPDATED, this, updateInfo);
		}
		public function updateInfo(e:ObjectEvent):void{
			if(info.oldLV<info.newLV){
				tf_LV.text = info.oldLV+" → "+info.newLV;
				tf_live.text = "1"+" → "+"2";
				tf_maxLive.text = "1"+" → "+"2";
				tf_wuxingPoint.text = "1"+" → "+"2"; 
				tf_fairyLV.text = "1"+" → "+"2";
				EventCenter.event(ApplicationFacade.SHOW_PANEL, LVUpInfoPanel.NAME);
			}
		}
	}
}
