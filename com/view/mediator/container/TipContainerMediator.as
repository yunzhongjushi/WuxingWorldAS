package com.view.mediator.container{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.view.BasePanel;
	import com.view.UI.SettingPanel;
	import com.view.UI.level.LevelReviewOverPanel;
	import com.view.UI.shop.ShopVIPPanel;
	import com.view.UI.tip.FairyConversationPanel;
	import com.view.UI.tip.GuideAskTip;
	import com.view.UI.tip.GuidePanel;
	import com.view.UI.tip.LoadingPanel;
	import com.view.UI.tip.RewardTipPanel;
	import com.view.UI.tip.TipChoosePanel;
	import com.view.UI.tip.TipLightPanel;
	import com.view.UI.tip.TipPanel;
	import com.view.UI.user.LVUpInfoPanel;
	
	import flas.display.Sprite;
	
	
	public class TipContainerMediator extends Sprite{
		public static const NAME:String = "TipContainerMediator";
		public static const SINGLETON_MSG:String = "single_TipContainerMediator_only";
		protected static var instance:TipContainerMediator;
		public static function getInstance():TipContainerMediator{
			if(instance==null) instance=new TipContainerMediator();
			return instance;
		}
		
		public var showPanelList:Object;
		
		/**
		 * 面板展示层，所有需要通过指令展示的面板都在这层注册
		 * @param viewComponent
		 */
		public function TipContainerMediator():void{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.mouseEnabled = false;
			showPanelList=new Object;
		
			getPanel(LevelReviewOverPanel);
			getPanel(GuideAskTip);
			getPanel(LoadingPanel);
			getPanel(TipChoosePanel);																//带选择的提示面板
			getPanel(TipPanel);																		//提示面板
			getPanel(RewardTipPanel);																//提示面板
			getPanel(TipLightPanel);																//简单文字提示弹出面板
			getPanel(LVUpInfoPanel);																//升级信息面板
			getPanel(ShopVIPPanel);																	//升级信息面板
			
			getPanel(GuidePanel);																	//引导面板
			getPanel(FairyConversationPanel);														//对话信息面板
			getPanel(SettingPanel);																	//设置面板//facade.registerMediator(new SettingPanelMediator());				
			
//			facade.registerMediator(new TipPanelMediator(getPanel(TipPanel)));						//选择信息面板
//			facade.registerMediator(new SelectPanelMediator(getPanel(SelectPanel)));				//提示信息面板
			
			function getPanel(cls:Class):BasePanel{
				var panel:BasePanel = new cls;
				showPanelList[cls["NAME"]]=panel;
				panel.on(BasePanel.SHOW_PANEL, this, showPanel);
				return panel;
			}
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, showPanel);
		}
		
		/**
		 * 把面板显示到层上 
		 * @param mediatorName
		 */
		public function showPanel(e:ObjectEvent):void{//note:INotification):void{
			var panel:BasePanel = showPanelList[e.data];
			if(panel){
				this.addChild(panel);
				panel.show();
				EventCenter.event(ApplicationFacade.SHOW_PANEL_SUCCESS, e.data);
//				return;
			}
//			if(panel is LoadingPanel){
//				(panel as LoadingPanel).show(note.getBody());
//			}else if(panel is ConversationPanel){
//				(panel as ConversationPanel).show(note.getBody());
//			}
//			AlertPanel.show("此功能尚未开放!");
		}
		
		private function closePanel(e:ObjectEvent):void{
			var panel:BasePanel = showPanelList[e.data];
			if(panel && panel.parent){
				if(panel is BasePanel){
					(panel as BasePanel).close();
				}else{
					panel.parent.removeChild(panel);
				}
			}
		}
	}
}