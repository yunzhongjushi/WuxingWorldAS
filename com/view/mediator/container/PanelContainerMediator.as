package com.view.mediator.container{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.view.BasePanel;
	import com.view.UI.achievement.AchievementPanel;
	import com.view.UI.activity.SignPanel;
	import com.view.UI.altar.AltarPanel;
	import com.view.UI.challenge.ChallengeHuo;
	import com.view.UI.challenge.ChallengeJin;
	import com.view.UI.challenge.ChallengeMu;
	import com.view.UI.challenge.ChallengePanel;
	import com.view.UI.challenge.ChallengeShui;
	import com.view.UI.challenge.ChallengeTu;
	import com.view.UI.fairy.FairyPanel;
	import com.view.UI.fairy.TipFairyPanel;
	import com.view.UI.fight.FightPanel;
	import com.view.UI.friend.FriendPanel;
	import com.view.UI.item.ItemPanel;
	import com.view.UI.level.LevelFailurePanel;
	import com.view.UI.level.LevelPanel;
	import com.view.UI.level.LevelReportPanel;
	import com.view.UI.chessboard.PuzzlePanel;
	import com.view.UI.mail.MailPanel;
	import com.view.UI.map.BigMapS;
	import com.view.UI.playerEditor.PlayerEditorPanel;
	import com.view.UI.shop.ShopPanel;
	import com.view.UI.task.TaskPanel;
	import com.view.UI.tip.MopupPanel;
	import com.view.UI.user.WuxingInfoPanel;
	import com.view.UI.user.WuxingPropertyPanel;
	
	import flas.display.Sprite;
	
	public class PanelContainerMediator extends Sprite{
		public static const NAME:String = "PanelContainerMediator";
		public static const SINGLETON_MSG:String = "single_PanelContainerMediator_only";
		protected static var instance:PanelContainerMediator;
		public static function getInstance():PanelContainerMediator{
			if(instance==null) instance=new PanelContainerMediator();
			return instance;
		}
		
		public var showPanelList:Object;
		
		/**
		 * 面板展示层，所有需要通过指令展示的面板都在这层注册
		 * @param viewComponent
		 *   
		 */
		public function PanelContainerMediator():void{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			showPanelList=new Object;
			
			getPanel(LevelPanel)																		//关卡信息面板	//facade.registerMediator(new LevelPanelMediator(getPanel(LevelPanel)));
			getPanel(FairyPanel);																		//精灵列表面板//facade.registerMediator(new FairyPanelMediator(getPanel(FairyPanel)));						
			getPanel(FightPanel);																		//战斗面板//facade.registerMediator(new FightPanelMediator(getPanel(FightPanel)));						
			getPanel(PuzzlePanel);																		//解谜面板//facade.registerMediator(new PuzzlePanelMediator(getPanel(PuzzlePanel)));					
			getPanel(LevelReportPanel);																	//战斗报告面板	//facade.registerMediator(new LevelReportPanelMediator(getPanel(LevelReportPanel)));
			getPanel(LevelFailurePanel);																//闯关失败面板facade.registerMediator(new LevelFailurePanelMediator(getPanel(LevelFailurePanel)));
			getPanel(WuxingInfoPanel);																	//五行信息面板//facade.registerMediator(new WuxingInfoPanelMediator(getPanel(WuxingInfoPanel)));			
			getPanel(WuxingPropertyPanel);																//单个五行信息面板//facade.registerMediator(new WuxingPropertyPanelMediator(getPanel(WuxingPropertyPanel)));	
			
//			facade.registerMediator(new SkillPanelMediator(getPanel(SkillPanel)));						//技能面板
			
			getPanel(ChallengePanel);																	//挑战总面板//facade.registerMediator(new ChallengePanelMediator(getPanel(ChallengePanel)));				
			getPanel(ChallengeJin);																		//金挑战面板//facade.registerMediator(new ChallengeJinMediator(getPanel(ChallengeJin)));					
			getPanel(ChallengeMu);																		//木挑战面板//facade.registerMediator(new ChallengeMuMediator(getPanel(ChallengeMu)));					
			getPanel(ChallengeTu);																		//土挑战面板//facade.registerMediator(new ChallengeTuMediator(getPanel(ChallengeTu)));					
			getPanel(ChallengeShui);																	//水挑战面板//facade.registerMediator(new ChallengeShuiMediator(getPanel(ChallengeShui)));				
			getPanel(ChallengeHuo);																		//火挑战面板//facade.registerMediator(new ChallengeHuoMediator(getPanel(ChallengeHuo)));					
			 
			
			//以下由饶境添加
			getPanel(SignPanel);																	//签到面板 //facade.registerMediator(new SignPanelMediator(getPanel(SignPanel)));					
			getPanel(MailPanel);																	//信件面板//facade.registerMediator(new MailPanelMediator(getPanel(MailPanel)));
			getPanel(FriendPanel);																	//好友面板 //facade.registerMediator(new FriendPanelMediator(getPanel(FriendPanel)));				
			getPanel(AltarPanel);																	//祭坛面板//facade.registerMediator(new AltarPanelMediator());					
			getPanel(AchievementPanel);																//成就面板//facade.registerMediator(new AchievementPanelMediator(getPanel(AchievementPanel)));		
			getPanel(ItemPanel);																	//物品面板//facade.registerMediator(new ItemPanelMediator(getPanel(ItemPanel)));					
			getPanel(TaskPanel);																	//任务面板//facade.registerMediator(new TaskPanelMediator(getPanel(TaskPanel)));					
			getPanel(ShopPanel);																	//商城面板//facade.registerMediator(new ShopPanelMediator(getPanel(ShopPanel)));					
			
			getPanel(MopupPanel);																	//扫荡面板//facade.registerMediator(new MopupPanelMediator(getPanel(MopupPanel)));					
//			getPanel(RewardTipPanel);																//扫荡奖励面板//facade.registerMediator(new RewardTipPanelMediator(getPanel(RewardTipPanel)));			
//			getPanel(LootPanel);																	//掠夺面板//facade.registerMediator(new LootPanelMediator(getPanel(LootPanel)));					
//			getPanel(ActivityPanel);																//活动控制台面板//facade.registerMediator(new ActivityPanelMediator(getPanel(ActivityPanel)));			
			getPanel(PlayerEditorPanel);															//关卡编辑器面板//facade.registerMediator(new PlayerEditorPanelMediator(getPanel(PlayerEditorPanel)));	
			getPanel(TipFairyPanel);																//新获得精灵展示面板//facade.registerMediator(new TipFairyPanelMediator(getPanel(TipFairyPanel)));			
			//以上由Jim添加
			
			function getPanel(cls:Class):BasePanel{
				var panel:BasePanel = new cls;
				showPanelList[cls["NAME"]]=panel;
				return panel; 
			}
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, showPanel);
			EventCenter.on(ApplicationFacade.WORLD_MAP_BUILD_CHOOSE, this, showBuildInfoPanel);
		}
		
		private function showBuildInfoPanel(e:*):void{
			switch(e.data){
				case "MapBuild_0"://金挑战
					showPanel(new ObjectEvent("", ChallengeJin.NAME));
					break;
				case "MapBuild_1"://木挑战
					showPanel(new ObjectEvent("", ChallengeMu.NAME));
					break;
				case "MapBuild_2"://土挑战
					showPanel(new ObjectEvent("", ChallengeTu.NAME));
					break;
				case "MapBuild_3"://水挑战
					showPanel(new ObjectEvent("", ChallengeShui.NAME));
					break;
				case "MapBuild_4"://火挑战
					showPanel(new ObjectEvent("", ChallengeHuo.NAME));
					break;
				case "MapBuild_5"://自创谜题
					break;
				case "MapBuild_6"://竞技场
					break;
				case "buildHome"://总部
					showPanel(new ObjectEvent("", PlayerEditorPanel.NAME));
					break;
			}
		}
		
		/**
		 * 把面板显示到层上 
		 * @param mediatorName
		 */
		private function showPanel(e:ObjectEvent):void{//note:INotification):void{//
			//如果战斗面板打开，其他面板就不能再打开，必须退出战斗
//			var fightPanelMediator:FightPanelMediator=facade.retrieveMediator(FightPanelMediator.NAME) as FightPanelMediator;
//			if (fightPanelMediator && fightPanelMediator.panelOpenJudge() && note.getType()!=FightPanel.NAME) return;
			
			var panel:BasePanel=showPanelList[e.data];//note.getType()];
			if(panel){
				if(this.contains(panel) && (panel is BasePanel)){
//					(panel as BasePanel).close();
					return;
				}
				panel.show();
				this.addChild(panel)
				EventCenter.event(ApplicationFacade.SHOW_PANEL_SUCCESS, e.data);
			}
//			AlertPanel.show("此功能尚未开放!");
		}
		
		private function closePanel(e:ObjectEvent):void{
			var panel:Sprite=showPanelList[e.data];
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