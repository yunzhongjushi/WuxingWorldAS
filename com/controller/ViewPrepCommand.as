package com.controller{
	
	/**
	 * @author hunterxie
	 */
	public class ViewPrepCommand{
		
		public function ViewPrepCommand(){
			
		}
		
		override public function execute() :void{
//			var main:WuxingWorldBase = note.getBody() as WuxingWorldBase;
			
//			if(BaseInfo.isShowDebug) facade.registerMediator( new DebugPanelMediator( DebugPanel.getInstance()));				//调试面板
			
//			facade.registerMediator( new WuxingWorldMediator( main ) );									//公共业务逻辑层（鼠标点击、tip等）
			
//			facade.registerMediator(new MainPanelMediator(main.mainView));								//登录面板
			
//			StarlingContainer.getInstance().initMap();													//地图层//facade.registerMediator(new StarlingContainerMediator(StarlingContainer.getInstance()));	
			
//			facade.registerMediator(new RoleContainerMediator(main.roleContainer));						//人物层
			
//			facade.registerMediator(new PanelContainerMediator(main.panelContainer));					//面板层
			
//			facade.registerMediator(new TipContainerMediator(main.tipContainer));						//提示层
			
//			facade.registerMediator(new OperateContainerMediator(main.operaterContainer));				//操作层	
			
//			facade.registerMediator(new AnimationPanelMediator(AnimationPanel.getInstance()));			//动画层
			
//			facade.registerMediator(new GuideMissionContainerMediator(GuideMissionContainer.getInstance()));//新手指导层
			
//			ChessboardPanel.getInstance();																//棋盘层//facade.registerMediator(new ChessboardPanelMediator(ChessboardPanel.getInstance()));		

			//面板层注册=====================================================================================================
//			facade.registerMediator(new UserInfoPanelMediator(UserInfoPanel.getInstance()));			//人物信息面板
			
//			facade.registerMediator(new BagPanelMediator(new BagPanel()));								//背包面板
//			
//			facade.registerMediator(new EquipmentPanelMediator(new EquipmentPanelMC()));				//装备面板		
//			
//			facade.registerMediator(new ItemOperMenuMediator(new ItemOperMenuMC()));					//物品使用面板
//			
//			facade.registerMediator(new AuctionHouseMediator(new TradPanel()));							//交易面板
//			
//			facade.registerMediator(new LeagueStoragePanelMediator(LeagueStorageMC.getInstance()));		//家族仓库面板
//			
//			
//			
//			facade.registerMediator(new MissionPanelMediator(new MissionPanel));						//任务面板
//			
//			facade.registerMediator(new AutoMissionPanelMediator(new AutoMissionMainPanel));			//自动任务面板
//			
//			facade.registerMediator(new NPCMissionPanelMediator(new NPCMissionMainPanel()));			//NPC任务对话面板
//			
//			facade.registerMediator(new MailListMediator(new InformationListPanel()));					//新建面板
//			
//			facade.registerMediator(new WeaponUpgradeMediator(new WeaponUpgradeMC));	  				//法宝修炼
//			
//			
//			facade.registerMediator(new ChatShowItemMediator(ChatShowItemContainer.getInstance()));		//物品查看面板
//			/**门派仓库*/
//			facade.registerMediator(new CountryBagPanelMediator(new MovieClip()));						//门派仓库
//			/**荣誉商城*/
//			facade.registerMediator(new CountryHonorPanelMediator(new MovieClip()));					//荣誉商城
//			/**查看其它玩家装备*/
//			facade.registerMediator(new OpponentEquipmentPanelMediator(new EquipmentPanelMC()));		//查看其它玩家装备
//			
//			facade.registerMediator(new PreViewEquipmentPanelMediator(new PreViewEquipmentPanel()));			//炼妖套装预览面板
//			
//			facade.registerMediator(new AlchemyPanelMediator(new AlchemyMainPanel()));					//炼丹  TraceMissionPanelMediator
//			
//			facade.registerMediator(new EquipmentBagMediator(new EquipBagPanel()));						//装备背包
//			
//			facade.registerMediator(new SpecialBagMediator(new ItemUseChooseMainPanel));				//存放经筛选出来的物品 
//			
//			facade.registerMediator(new DropItemListMediator(new MovieClip));                            //打怪掉落物品列表
//			
//			facade.registerMediator(new ShortCutUseMediator(new MovieClip));                            //快捷使用物品
//			
//			facade.registerMediator(new ExchangMoneyMediator(new MovieClip));                           //钱不够
//			
//			//面板层注册=====================================================================================================
//			facade.registerMediator(new AddLoginPanelMediator(new LoginPremiumMainPanel));                      //人物登录领取奖励
//			facade.registerMediator(new AutoUnderCityMediator(new AutoUndercityMainPanel));                     //自动闯关面板
//			//面板层注册=====================================================================================================
//			facade.registerMediator(new UserListPanelMediator(UserListPanel.getInstance()));			//右上角用户列表面板
//			
//			facade.registerMediator(new NPCPanelMediator(new NPCMainPanel))								//NPC表面板
//			
//			facade.registerMediator(new NPCChatPanelMediator(new NPCChatMainPanel))						//NPC聊天面板
//			
//			facade.registerMediator(new CountrySkillUsePanelMediator(new CountrySkillUseMainPanel));	//门派技能使用面板
//			
//			facade.registerMediator(new CountryPanelMediator(new CountryMainPanel));					//门派(国家)面板
//			
//			facade.registerMediator(new CountryBattlePanelMediator(new CountryBattleMainPanel));		//门派战面板
//			
//			facade.registerMediator(new SiegeBattlePanelMediator(new SiegeBattleMainPanel));			//攻城战面板
//			
//			facade.registerMediator(new RankPanelMediator(new RankMainPanel));							//排行个人/家族面板
//			
//			facade.registerMediator(new LeaguePanelMediator(new LeagueMainPanel))						//家族(联盟)面板
//			
//			facade.registerMediator(new GMPanelMediator(new GMMainPanel));								//GM面板
//			
//			facade.registerMediator(new ListsPanelMediator(new ListsMainPanel));						//历练场面板
//			
//			facade.registerMediator(new NanTianMenPanelMediator(new NanTianMenMainPanel));				//南天门资源面板
//			
//			facade.registerMediator(new NanTianMenRankPanelMediator(new NanTianMenRankMainPanel));		//南天门修仙榜面板
//			
//			facade.registerMediator(new GeneralMapPanelMediator(new GeneralMapMainPanel));				//概要地图面板
//			
//			facade.registerMediator(new TrainPanelMediator(new TrainMainPanel));						//角色修炼面板
//			
//			facade.registerMediator(new BaseMightPanelMediator(new BaseMightMainPanel));				//元神面板
//			
//			facade.registerMediator(new GuideMissionPanelMediator(new GuideMissionPanel));				//新手任务面板
//			
//			facade.registerMediator(new TreasureBoxPanelMediator(new TreasureBoxPanel));				//降妖塔面板
//			
//			facade.registerMediator(new CountryOfficialPanelMediator(new CountryOfficialMainPanel));	//人物属性面板查看门派官员列表
//			
//			facade.registerMediator(new XianqiChangePanelMediator(new XianqiChangeMainPanel));			//仙气转换面板
//			
//			facade.registerMediator(new SocialityMainPanelMediator(new SocialityMainPanel));			//好友社交面板
//			
//			facade.registerMediator(new PlayerInfoCheckMainPanelMediator(new PlayerInfoCheckMainPanel));//用户信息查看面板
//			
//			facade.registerMediator(new EquipShowMainPanelMediator(new EquipShowMainPanel));			//套装展示面板
//			
//			facade.registerMediator(new SceneListPanelMediator(new UserParticularPanel));				//更多场景玩家面板
//			
//			facade.registerMediator(new SystemSetPanelMediator(new SystemSetMainPanel));				//系统设置面板
//			
//			facade.registerMediator(new MusicMediator(null));											//音乐模块
//			
//			facade.registerMediator(new VIPPanelMediator(new VIPMainPanel));							//VIP面板
//			
//			facade.registerMediator(new TeamPanelMediator(new TeamMainPanel));							//组队面板	
//			
//			facade.registerMediator(new CountryBattleManagePanelMediator(new CountryBattleManageMainPanel));	//门派战管理面板	
		}
	}
}