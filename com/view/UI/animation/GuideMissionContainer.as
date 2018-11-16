package com.view.UI.animation {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.level.LevelVO;
	import com.view.BasePanel;
	import com.view.MovieShow;
	import com.view.UI.main.MainButtonPanel;
	import com.view.UI.user.WuxingInfoPanel;
	
	import flas.display.Sprite;
	import flas.utils.utils;



	/**
	 * 引导任务层
	 * @author hunterxie
	 */
	public class GuideMissionContainer extends BasePanel {
		public static const NAME:String="GuideMissionContainer";
		private static const SINGLETON_MSG:String="single_GuideMissionContainer_only";
		private static var instance:GuideMissionContainer;
		public static function getInstance():GuideMissionContainer {
			if (instance == null)
				instance=new GuideMissionContainer();
			return instance;
		}
		
		/**
		 * 捡到宝盒
		 */
		public static const CutsceneIntoMap:String = "CutsceneIntoMap";
		/**
		 * 进入大地图
		 */
		public static const CutsceneIntoMap2:String = "CutsceneIntoMap2";
		
		/**
		 * 片头动画
		 */
		public static const CutsceneTitle:String = "CutsceneTitle";
		/**
		 * 第一个引导关卡前的动画
		 */
		public static const CutsceneFirstLevel:String = "CutsceneFirstLevel";
		
		
		public var cutscene:*;
		private var cutsceneArr:Object = {};
		private var initMovieArr:Array = [];
		
		
		private var activating:WuxingFragmentActivating;
		
		/**
		 * 引导任务层
		 */
		public function GuideMissionContainer() {
			if (instance != null)
				throw Error(SINGLETON_MSG);
			instance=this;
			
//			initMovieArr.push(getDefinitionByName("CutsceneFirstLevel", false));
			initMovieArr.push(utils.getDefinitionByName(CutsceneIntoMap2, false));
			MovieShow.initInfoByFrame(initMovieArr.concat(), movieInitOver);
			
			this.on("playOver", this, onPlayOver);
			this.on("chooseGuide", this, onChooseGuide);
			
			EventCenter.on(ApplicationFacade.GUIDE_MISSION_COMPLETE, this, showGuide);
			EventCenter.on(ApplicationFacade.GUIDE_MISSION_SHOW, this, showGuide);
			EventCenter.on(ApplicationFacade.GUIDE_CUTSCENE_MOVIE_SKIP, this, showGuide);
			EventCenter.on(ApplicationFacade.GUIDE_MISSION_CONFIRM, this, guideConfirm);
			EventCenter.on(BasePanel.CLOSE_PANEL, this, onPanelClose);
			
			
			activating = WuxingFragmentActivating.getInstance();
			activating.on(WuxingFragmentActivating.SHOW_ACTIVATING, this, showPanel);
		}
		
		private function onPanelClose(e:ObjectEvent):void{
			if(BaseInfo.isTestGuide){
//				switch(e.data){
//					case GuideAskTip.NAME:
//						panel.removeEventListener("chooseGuide", onChooseGuide);
//						panel.cutscene.play();
//						break;
//					case LoadingPanel.NAME://片头加载动画播放结束
//						if(note.getBody()==LoadingPanel.FIRST_LOADING_OVER){
////							if(gameSO.lastLoginUser)
//							panel.showGuide(CutsceneTitle);
//						}
//						break;
//				}
			}
		}
		
		private function guideConfirm(e:ObjectEvent):void{
			switch(e.data){
				case 3:
					clear();
					break;
				case 5:
					showGuide(new ObjectEvent("", CutsceneIntoMap2));
					break;
			}
		}
		
		private function movieInitOver():void{
			for(var i:int=0; i<initMovieArr.length; i++){
				var ms:MovieShow = MovieShow.getMovieShow(initMovieArr[i]);
				ms.name = utils.getQualifiedClassName(initMovieArr[i]);
				cutsceneArr[ms.name] = ms;
			}
		}
		
		public function showGuide(e:ObjectEvent):void{
			clear();
			var str:String = String(e.data);
			if(cutsceneArr[str]){
				cutscene = cutsceneArr[str];
			}else{
				cutscene = utils.getDefinitionByName(str);
			}
//			cutscene.scaleX = BaseInfo.fullScreenWidth/960;
//			cutscene.scaleY = BaseInfo.fullScreenHeight/640;
			cutscene.x = (BaseInfo.fullScreenWidth-960)/2;
			cutscene.y = (BaseInfo.fullScreenHeight-640)/2;
			cutscene.name = str;
			cutscene.gotoAndPlay(1);
			addChild(cutscene);
		}
		
		public function showPanel(e:ObjectEvent):void{
			clear();
			addChild(e.target as BasePanel);
		}
		
		public function clear():void{
			while(this.numChildren){
				var mc:* = this.getChildAt(0);
				if(mc.hasOwnProperty("stop")){
					mc["stop"](); 
				}
				if(this.contains(mc)) removeChild(mc);
			}
		}
		
		
		private function onPlayOver(e:*):void {
			switch (e.target.name){//getQualifiedClassName(e.target)) {
				case GuideMissionContainer.CutsceneTitle://片头剧情播放结束
					EventCenter.event(ApplicationFacade.GUIDE_CUTSCENE_MOVIE_SKIP);
					break;
				case GuideMissionContainer.CutsceneFirstLevel://第一个剧情关卡展示动画播放结束,引导关第一关开始
					EventCenter.event(ApplicationFacade.LEVEL_GAME_START, LevelVO.getLevelVO(20000));
					break;
				case GuideMissionContainer.CutsceneIntoMap://进入地图前
					var buttonPanel:MainButtonPanel = MainButtonPanel.getInstance();
					buttonPanel.visible = true;
					buttonPanel.updateBtnShow(WuxingInfoPanel.NAME);
					this.addChild(buttonPanel);
					EventCenter.event(ApplicationFacade.GUIDE_GET_WUXING_BOX);
					break;
				case GuideMissionContainer.CutsceneIntoMap2://进入地图前动画播放结束，进入世界地图
					clear();
					EventCenter.event(ApplicationFacade.GUIDE_BIG_MAP_ENTER); 
					break;
				case "CutsceneActivating"://激活槽位动画播放结束
					
					break;
			}
		}
		
		private function onChooseGuide(e:*):void{
			this.removeEventListener("chooseGuide", onChooseGuide);
			this.cutscene.play();
		}
	}
}
