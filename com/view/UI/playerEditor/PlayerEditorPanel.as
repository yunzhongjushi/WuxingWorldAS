package com.view.UI.playerEditor{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.editor.EditListVO;
	import com.model.vo.editor.EditVO;
	import com.model.vo.tip.TipVO;
	import com.view.BasePanel;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.events.Event;

	
	/**
	 * 玩家自创关卡
	 * @author hunterxie
	 */
	public class PlayerEditorPanel extends BasePanel{
		public static const NAME:String = "PlayerEditorPanel";
//		public static function getShowName():String{
//			instance.onShowPanel();
//			return NAME;
//		}
		public static const SINGLETON_MSG:String = "single_PlayerEditorPanel_only";
		protected static var instance:PlayerEditorPanel;
		public static function getInstance():PlayerEditorPanel{
			if ( instance == null ) instance = new PlayerEditorPanel();
			return instance;
		}
		
		
		public var mc_level_0:PlayerEditorLevelBtn;
		
		public var showLevelNum:int = 5;
		
		public var boardBtns:Array = [];
		
		public var editList:EditListVO;
		
		/**
		 * 编辑按钮，测试中点击后返回编辑
		 */
		public var btn_change:CommonBtn;
		/**
		 * 开始测试
		 */
		public var btn_start:CommonBtn;
		/**
		 * 展示解谜过程(复盘)
		 */
		public var btn_showSolve:CommonBtn;
		/**
		 * 设置为守卫关
		 */
		public var btn_setDefend:CommonBtn;
		/**
		 * 分享按钮
		 */
		public var btn_share:CommonBtn;
		
		
		/**
		 * 棋盘面板(共用)
		 */
		public var boardPanel:ChessboardPanel;
		
		/**
		 * 编辑面板
		 */
		public var setPanel:PlayerEditorSetPanel;
		
		/**
		 * 临时保存的点击按钮，用于切换时等待用户选择是否保存数据
		 */
		private var tempBtn:PlayerEditorLevelBtn;
		
		private var nowInfo:EditVO;
		
		
		/*******************************************************
		 *
		 * 
		 * 
		 * 
		 * 
		 *******************************************************/
		public function PlayerEditorPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			
			btn_start.setNameTxt("开始测试");
			btn_start.addEventListener(MouseEvent.CLICK, onStart);
			
			btn_showSolve.visible = false;
			btn_showSolve.setNameTxt("解谜展示");
			btn_showSolve.addEventListener(MouseEvent.CLICK, onSolve);
			
			btn_change.visible = false;
			btn_change.setNameTxt("编    辑");
			btn_change.addEventListener(MouseEvent.CLICK, onEdite);
			
			btn_setDefend.visible = false;
			btn_setDefend.setNameTxt("设为守卫");
			btn_setDefend.addEventListener(MouseEvent.CLICK, onSetDefend);
			
			btn_share.visible = false;
			btn_share.setNameTxt("分享谜题");
			btn_share.addEventListener(MouseEvent.CLICK, onShare);
			
			boardPanel = ChessboardPanel.getInstance();
			boardPanel.addEventListener(ChessboardPanel.BOARD_GAME_OVER, onGameOver);
			
			this.addEventListener(Event.ADDED_TO_STAGE, inStage);
			
			
			editList = EditListVO.getInstance();
			
			for(var i:int=0; i<editList.edits.length; i++){
				var btn:PlayerEditorLevelBtn = new PlayerEditorLevelBtn();
				if(i==0){
					btn = mc_level_0;
				}else if(i<showLevelNum){
					btn.x = mc_level_0.x;
					btn.y = mc_level_0.y + (mc_level_0.height+5)*i;
				}else{
					break;
				}
				
				btn.addEventListener(MouseEvent.CLICK, onEditorClick);
				btn.updateInfo(i);
				boardBtns.push(btn);
				this.addChild(btn);
			}
			
			EventCenter.on(TipVO.TIP_PANEL_CANCEL, this, recoverEditInfo);
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShowPanel);
		}
		
		private function inStage(e:Event):void{
			for(var i:int=0; i<boardBtns.length; i++){
				var btn:PlayerEditorLevelBtn = boardBtns[i];
				if(btn.editID==editList.nowEditID){
					btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
			}
		}
		
		private function onEditorClick(e:*):void{
			onEdite();
			if(tempBtn && editList.compareHasChanged()){//如果按钮有点击“说明打开过”
				TipVO.showChoosePanel(new TipVO("谜题改动", "谜题有改动，你要覆盖原有的谜题吗？", EditVO.COVER_EDIT_INFO, "覆  盖", "不覆盖"));
				return;
			}
			tempBtn = e.target as PlayerEditorLevelBtn;
			setNowInfo();
		}
		private function setNowInfo():void{
			for(var i:int=0; i<showLevelNum; i++){
				(boardBtns[i] as PlayerEditorLevelBtn).gotoAndStop(1);
			}
			if(tempBtn){
				tempBtn.gotoAndStop(2);
			}
			
			nowInfo = editList.setNowInfo(tempBtn.editID);
			boardPanel.setBoardBG(nowInfo.boardScale);
			btn_setDefend.visible = btn_share.visible = btn_showSolve.visible = nowInfo.getIsSolve();
			setPanel.setArrToBoard(nowInfo);
		}
		
		public function onStart(e:*):void {
			setPanel.visible = false;
			
			boardPanel.startNewGame(null, nowInfo);//mc_skillSelectPanel.getBoardSkills()
			
			btn_start.visible = false;
			btn_change.visible = true;
//			btn_recordSolve.visible = true;//
		}
		
		public function onShowPanel(e:ObjectEvent=null):void{
			if(e.data == NAME){
				setPanel.visible = true;
				boardPanel.mc_boardSkillPanel.visible = false;
				this.addChildAt(boardPanel, 0);
			}
		}
		
		/**
		 * 解谜展示
		 * @param e
		 * @return 
		 */
		public function onSolve(e:*):void {
			btn_start.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			boardPanel.showTotalAction(nowInfo.solve);
//			btn_showSolve.mouseEnabled = false;
		}
		
		/**
		 * 设为守卫关卡
		 * @param e
		 */
		public function onSetDefend(e:*=null):void {
			editList.setDefend();
		}
		
		/**
		 * 分享谜题
		 * @param e
		 */
		public function onShare(e:*=null):void {
			TipVO.showTipPanel(new TipVO("分享谜题", "已经复制，请去微信粘贴分享！", "分享谜题", "去微信粘贴"));
		}
		
		/**
		 * 编辑展示
		 * @param e
		 * @return 
		 */
		public function onEdite(e:*=null):void {
			btn_start.visible = true;
			btn_change.visible = false;
			setPanel.visible = true;
//			mc_skillSelectPanel.setBoardSkills(true);
			boardPanel.clearBoard();
		}
		
		/**
		 * 游戏逻辑实例
		 * @return 
		 */
		private function get ddpLogic():ChessBoardLogic{
			return ChessBoardLogic.getInstance();
		}
		public function onGameOver(e:Event):void{
			if(!this.parent || !this.contains(boardPanel)) return;
			
//			btn_showSolve.mouseEnabled = true;
			if(ddpLogic.checkHasClearAll()){
				if(!boardPanel.tempTotalActionStr && boardPanel.getTotalAction()!=nowInfo.solve){
					nowInfo.setSolve(boardPanel.getTotalAction());
					btn_setDefend.visible = btn_share.visible = btn_showSolve.visible = true;
				}
//				if(!nowInfo.solve){
//					if(!boardPanel.tempTotalActionStr && boardPanel.getTotalAction()!=nowInfo.solve)
//						TipVO.showChoosePanel("自创测试结束", "你要覆盖现有的解谜过程吗？", EditVO.COVER_EDIT_INFO, "覆  盖", "不覆盖"));
//				}else{
//					onSaveSolve();
//				}
				
				if(nowInfo.solve.lastIndexOf("exc")>0){
					TipVO.showTipPanel(new TipVO("自创测试结束", "自创谜题解谜成功！"));
				}else{
					TipVO.showTipPanel(new TipVO("自创测试结束", "你只用了一步就解谜成功了\n谜题限制只能移动一步！"));
				}
			}else{
				nowInfo.setSolve("");
				btn_setDefend.visible = btn_share.visible = btn_showSolve.visible = false;
				TipVO.showTipPanel(new TipVO("自创测试结束", "测试结束，还剩棋子没消除不能保存解题过程！"));
			}
		}
		/**
		 * 还原编辑前的谜题信息
		 * @return 
		 */
		public function recoverEditInfo(e:ObjectEvent):void{
			if(e.data==EditVO.COVER_EDIT_INFO){
				setNowInfo();
				if(e.type==TipVO.TIP_PANEL_CANCEL){
					editList.setRestoreNowInfo();
				}
			}
		}
		
		override public function close(e:*=null):void{
			if(editList.compareHasChanged()){
				TipVO.showChoosePanel(new TipVO("谜题改动", "谜题有改动，你要覆盖原有的谜题吗？", EditVO.COVER_EDIT_INFO, "覆  盖", "不覆盖"));
			}else{
				super.close();
			}
		}
	}
}
