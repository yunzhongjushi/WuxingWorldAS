package editor{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.logic.ChessBoardLogic;
	import com.model.logic.FightGameLogic;
	import com.model.vo.conn.ServerGameStartVO;
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;
	import com.utils.MainDispatcher;
	import com.view.UI.fight.FightPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	

	public class FightEditorPanel extends Sprite{
		public static const TEST_FIGHT_CLOSE:String = "TEST_FIGHT_CLOSE";
		
		public static const NAME:String = "FightEditorPanel";
		public static const SINGLETON_MSG:String = "single_FightEditorPanel_only";
		protected static var instance:FightEditorPanel;
		public static function getInstance():FightEditorPanel{
			if ( instance == null ) instance = new FightEditorPanel();
			return instance;
		}
		
		public var fightPanel:FightPanel;
		
		public var btn_quitFight:CommonBtn;
		public var btn_actionShow:CommonBtn;
		
		public var tf_actionInput:TextField;
		
		public function FightEditorPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			fightPanel.visible=btn_quitFight.visible = false;
			tf_actionInput.visible = false;
			
			
			btn_quitFight.setNameTxt("结束");
			btn_quitFight.addEventListener(MouseEvent.CLICK, quitFight);
			
			btn_actionShow.setNameTxt("复盘");
			btn_actionShow.addEventListener(MouseEvent.CLICK, actionTest);
			
			MainDispatcher.getInstance().addEventListener(FairyEditorPanel.TEST_FAIRY_FIGHT, testFightStart);
		}
		
		/**
		 * 结束战斗按钮
		 * @param e
		 * @return 
		 */
		public function quitFight(e:*):void {
			fightPanel.visible=btn_quitFight.visible=false;
			MainDispatcher.dispatchInfo(new Event(TEST_FIGHT_CLOSE));
		}
		
		/**
		 * 供外部调用的战斗测试
		 * @param e
		 */
		public function testFightStart(e:ObjectEvent):void{
			var vo:ServerGameStartVO = e.data as ServerGameStartVO;
			var fightVO:FightGameLogic = FightGameLogic.newVO(LevelVO.getLevelVO(FairyEditorPanel.getChooseBoard()), vo);
			fightPanel.visible=btn_quitFight.visible=true;
			//fightPanel.startNewGame(fightVO);
			fightPanel.btn_escape.removeEventListener(MouseEvent.CLICK, fightPanel.onEscape);
			//fightPanel.onEscape=function(){};
			EventCenter.event(ApplicationFacade.SHOW_PANEL, FightPanel.NAME);
//			EventCenter.event(ApplicationFacade.SHOW_PANEL, FightPanel.getShowName(fightVO));
			fightPanel.boardPanel.qiuContainer.x = 192;
			fightPanel.boardPanel.qiuContainer.y = 631;
			fightPanel.boardPanel.mc_mask.y = fightPanel.boardPanel.qiuContainer.y-fightPanel.boardPanel.mc_mask.height;
			//trace("!!!!!!!!!!!!!",boardPanel.container.x,boardPanel.container.y);
			//(Facade.getInstance().retrieveMediator(FightPanelMediator.NAME) as FightPanelMediator).fightInfo = fightVO;
		}
		
		/**
		 * 通过输入复盘数据(str)测试过程前后台(联网)逻辑
		 * @param e
		 * @return 
		 */
		public function actionTest(e:*):void {
			if(tf_actionInput.visible==false){
				tf_actionInput.visible=true;
				return;
			}
			
			var actionStr:String = tf_actionInput.text;
			tf_actionInput.visible=false;
			ChessBoardLogic.getInstance().randomGeter.Initialize(945798405);
			ChessBoardLogic.getInstance().randomGeter.SetSeed(7944219);
//			ChessBoardLogic.isInitCanClear=false;
			//ChessBoardLogic.initInfo(8,8,6);
			
			UserVO.getInstance().userID = Math.floor(Math.random()*99999)
			MainDispatcher.dispatchInfo(new ObjectEvent("game_start", {
				initNum:945798405, 
				seed:7944219,
				fight_kind:1,
				clear_kind:1,
				tarUserID:UserVO.getInstance().userID,
				attack:{
					userID:UserVO.getInstance().userID, 
					ID:1, 
					LV:50, 
					wuxing:0, 
					HP:30, 
					AP:5, DP:[0,0,0,0,0], 
					skill:[101,102,103,104],
					res:[0,0,0,0,0],
					inc:[2,2,2,2],
					maxres:[100,100,100,100,100]
				},
				defend:{
					userID:Math.floor(Math.random()*99999), 
					ID:1,
					LV:50, 
					wuxing:0, 
					HP:30, 
					AP:5, 
					DP:[0,0,0,0,0], 
					skill:[101,102,103,104], 
					res:[0,0,0,0,0], 
					inc:[2,2,2,2],
					maxres:[100,100,100,100,100]
				}
			}));
			
			fightPanel.showTotalAction(actionStr);
		}
	}
}
