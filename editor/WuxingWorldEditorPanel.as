package editor{
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.logic.ChessBoardLogic;
	import com.model.vo.chessBoard.BoardSkillActiveVO;
	import com.model.vo.config.board.BoardBaseVO;
	import com.model.vo.config.board.BoardConfig;
	import com.utils.MainDispatcher;
	import com.utils.TextFactory;
	import com.view.UI.animation.AnimationPanel;
	import com.view.UI.chessboard.ChessboardPanel;
	import com.view.touch.CommonBtn;
	
	import fl.controls.List;
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	import flas.events.MouseEvent;
	
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	/**
	 * 
	 * @author hutner
	 * 
	 */	
	public class WuxingWorldEditorPanel extends Sprite{
		public static const BOARD_INFO_LOADED:String = "boardInfoLoaded";
		
		public static const NAME:String = "WuxingWorldEditorPanel";
		public static const SINGLETON_MSG:String = "single_WuxingWorldEditorPanel_only";
		protected static var instance:WuxingWorldEditorPanel;


		public static function getInstance():WuxingWorldEditorPanel{
			if ( instance == null ) instance = new WuxingWorldEditorPanel();
			return instance;
		}
		
//		public static var boardInfo:XML;
		public static var boardInfoVO:BoardConfig;// = BoardInfo.getInstance();
		
		/**
		 * 展示操作过程的文本框
		 */
		public var tf_action:TextField;
		
		/**
		 * 棋盘设置面板
		 */
		public var setPanel:SetPanel;
		
		/**
		 * 打开技能编辑器
		 */
		public var btn_skillEditor:CommonBtn;
		
		/**
		 * 棋盘配置面板
		 */
		public var mc_boardConfig:BoardInfoConfigPanel;

		/**
		 * 输出board信息按钮
		 */
		public var btn_output:CommonBtn;
		/**
		 * 新建一个board信息
		 */
		public var btn_new:CommonBtn;
		public var btn_copy_new:CommonBtn;
		public var btn_insert_new:CommonBtn;
		public var btn_insert_copy:CommonBtn;
		public var btn_delete:CommonBtn;
		public var btn_board_up:SimpleButton;
		public var btn_board_down:SimpleButton;
		/**
		 * 清除当前棋盘信息
		 */
		public var btn_clear:CommonBtn;
		/**
		 * 随机设置当前棋盘棋子（根据大小和下面的种类概率）
		 */
		public var btn_random:CommonBtn;
		
		/**
		 * 编辑按钮，测试中点击后返回编辑
		 */
		public var btn_change:CommonBtn;
		/**
		 * 开始测试
		 */
		public var btn_start:CommonBtn;
		/**
		 * 记录解谜过程
		 */
		public var btn_recordSolve:CommonBtn;
		/**
		 * 展示解谜过程(复盘)
		 */
		public var btn_showSolve:CommonBtn;
		/**
		 * 当前关跳转调整按钮
		 */
		public var btn_moveTo:CommonBtn;
		public var tf_moveTo:TextField;
		
		
		public var boardPanel:ChessboardPanel;
//		public var infoArr:Array=[];
//		public function get nowInfo():Array{
//			return infoArr[tarIndex];
//		}
		public var nowInfo:BoardBaseVO;
		
		
		/**
		 * 
		 */
		public var animationPanel:AnimationPanel;
		
		/**
		 * 闯关技能选择容器
		 */
		public var mc_skillSelectPanel:SkillSelectPanel;
		/**
		 * 展示技能编辑器
		 */
		public var btn_levelEditor:CommonBtn;
		/**
		 * 展示精灵编辑器
		 */
		public var btn_fairyEditor:CommonBtn;

		public var btn_multiple:CommonBtn;
		
		public var fairyEditorPanel:FairyEditorPanel;
		public var levelEditorPanel:LevelEditorPanel;
		public var skillEditorPanel:SkillEditorPanel;
		public var fightEditorPanel:FightEditorPanel;
		public var mc_connPanel:ConnPanel;


		
		public function getSetPanel(boardID:int):BitmapData{
			tarIndex = boardList.selectedIndex = boardID;
			setArrToBoard();
			return setPanel.getSetPanel();
		}
		
		
		/**
		 *
		 * 
		 * 
		 * 
		 * 
		 */
		public function WuxingWorldEditorPanel(){
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
//			StyleManager.setComponentStyle(ComboBox, "rowCount", 15);
			
			fairyEditorPanel.visible=false;
			btn_fairyEditor.setNameTxt("精灵");
			btn_fairyEditor.addEventListener(MouseEvent.CLICK, function(e:*):void{fairyEditorPanel.visible = true;});
			
			levelEditorPanel.visible=false;
			btn_levelEditor.setNameTxt("关卡");
			btn_levelEditor.addEventListener(MouseEvent.CLICK, function(e:*):void{levelEditorPanel.visible = true;});
			
			skillEditorPanel.visible = false;
			btn_skillEditor.setNameTxt("技能");
			btn_skillEditor.addEventListener(MouseEvent.CLICK, function(e:*):void{skillEditorPanel.visible = true;});
			
			mc_connPanel.visible = false;
			btn_multiple.setNameTxt("联网");
			btn_multiple.addEventListener(MouseEvent.CLICK, function(e:*):void{mc_connPanel.visible = !mc_connPanel.visible;});
			
//			fightEditorPanel.visible = false;
			
			btn_clear.setNameTxt("清除");
			btn_clear.addEventListener(MouseEvent.CLICK, setPanel.clearInfo);
			
			btn_random.setNameTxt("随机");
			btn_random.addEventListener(MouseEvent.CLICK, randomInfo);
			
			btn_start.setNameTxt("开始测试");
			btn_start.addEventListener(MouseEvent.CLICK, onStart);
			
			tf_action.visible = btn_showSolve.visible = false;
			btn_showSolve.setNameTxt("解谜展示");
			btn_showSolve.addEventListener(MouseEvent.CLICK, onSolve);
			
			btn_recordSolve.visible = false;
			btn_recordSolve.setNameTxt("解谜记录");
			btn_recordSolve.addEventListener(MouseEvent.CLICK, onRecordSolve);
			
			btn_change.visible = false;
			btn_change.setNameTxt("编辑");
			btn_change.addEventListener(MouseEvent.CLICK, onEdite);
			
			btn_output.setNameTxt("输出");
			btn_output.addEventListener(MouseEvent.CLICK, onOutput);
			
			btn_new.setNameTxt("新增");
			btn_new.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_copy_new.setNameTxt("复制");
			btn_copy_new.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_insert_new.setNameTxt("插入");
			btn_insert_new.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_insert_copy.setNameTxt("插入复制");
			btn_insert_copy.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_delete.setNameTxt("删除");
			btn_delete.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_moveTo.setNameTxt("移至");
			btn_moveTo.addEventListener(MouseEvent.CLICK, newInfo);
			
			btn_board_up.addEventListener(MouseEvent.CLICK, newInfo);
			btn_board_down.addEventListener(MouseEvent.CLICK, newInfo);
			
			boardList.addEventListener(Event.CHANGE, showSelectList);
			
			tf_boardName.addEventListener(Event.CHANGE, onBoardNameChange);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			MainDispatcher.getInstance().addEventListener(FightEditorPanel.TEST_FIGHT_CLOSE, onShowBoard);
		}
		private function onShowBoard(e:Event):void{
			this.addChildAt(boardPanel, 0);
			onEdite();
		}
		
		public function init(e:Event):void {
			stage.stageFocusRect = false;
//			DebugPanel.getInstance().x = 360;
//			DebugPanel.getInstance().y = -20;
//			addChild(DebugPanel.getInstance());
			
			animationPanel = new AnimationPanel;
			addChild(animationPanel);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpFocus);
			
			boardPanel.addEventListener(ChessboardPanel.BOARD_GAME_OVER, onGameOver);
			
//			if(true){//BaseInfo.isLoadConfig){
//				var loader:URLLoader = new URLLoader(new URLRequest("boardInfo.json"));
//				loader.addEventListener(Event.COMPLETE, onLoaded);
//			}else{
				TweenLite.to({}, 0.5, {onComplete:onLoaded});
//			}
		}
		
		/**
		 * 
		 * @param e
		 */
		public function onLoaded(e:Event=null):void {
//			if(true){//BaseInfo.isLoadConfig){
////				boardInfo = XML(e.target.data);
////				BaseInfo.setBoardInfo(boardInfo);
//				boardInfoVO = BoardInfo.updateObj(JSON.parse(e.target.data));
//			}else{
//				boardInfo = BaseInfo.boardInfo;
				boardInfoVO = BoardConfig.getInstance();
				boardInfoVO.updateObj(BaseInfo.boardInfo);//JSON.parse(String(LoadProxy.getLoadInfo("boardInfo.json")));
//			}
			updateList();
			
//			return;
//			boardInfoVO = new BoardInfo;
//			for (var i:int=0; i<boardInfo.info.length(); i++) {
//				var info:Object = {balls:setXMLToArr(boardInfo.info[i].balls[0])}
////				infoArr[i]=[setXMLToArr(boardInfo.info[i].balls[0])];
//				var vo:BoardBaseVO = new BoardBaseVO({ID:boardInfoVO.infoArr.length});
//				boardInfoVO.infoArr.push(vo);
//				if(boardInfo.info[i].solve[0]){
////					infoArr[i][2] = String(boardInfo.info[i].solve[0]);
//					vo.solve = String(boardInfo.info[i].solve[0]);
//				}
//				if(boardInfo.info[i].grids[0]){ 
////					infoArr[i][3] = setXMLToArr(boardInfo.info[i].grids[0]);
//					info.grids = setXMLToArr(boardInfo.info[i].grids[0]);
//				}else{
////					infoArr[i][3] = [[],[],[],[],[],[],[],[]];
//				}
//				if(boardInfo.info[i].skills[0]){
////					infoArr[i][1] = setXMLToArr(boardInfo.info[i].skills[0]);
//					info.skills = setXMLToArr(boardInfo.info[i].skills[0]);
//				}else{
////					infoArr[i][1] = [[],[],[],[],[],[],[],[]];
//				}
////				infoArr[i]["name"]=boardInfo.info[i].@name;
//				vo.name = boardInfo.info[i].@name;
//				vo.updateObj(info);
//			}
//			
//			updateList();
		}
		
		/**
		 * 抬起鼠标时如果有选中焦点就把焦点去掉，否则会影响其他的选择
		 * @param e
		 */
		public function onUpFocus(e:*):void{
			if((stage.focus==tf_boardName && e.target!=tf_boardName) ||
				((stage.focus is List) && !(e.target is CellRenderer))){
				stage.focus = null; 
			}
		}
		
		public function randomInfo(e:*=null):void{
			saveAllInfo();
			var qiuarr:Array = [];
			for (var i:int=0; i<mc_boardConfig.boardConfig.maxR; i++) {
				qiuarr[i] = [];
				for (var j:int=0; j<mc_boardConfig.boardConfig.maxL; j++) {
					qiuarr[i].push(mc_boardConfig.boardConfig.getChanceBall());
				}
			}
			setPanel.randomInfo(qiuarr);
		}
		
		public function onStart(e:*):void {
//			if(boardPanel.parent) trace("boardPanel.Index:"+boardPanel.parent.getChildIndex(boardPanel)+"__boardPanelIndexNum:"+boardPanelIndexNum)
			this.addChildAt(boardPanel, 0);
//			setPanel.setBoardToArr(true);
			setPanel.visible = false;
			
//			ChessBoardLogic.updateSeed();
//			ChessBoardLogic.randomSetBoardKind(qiuArr);
			saveAllInfo();
			boardPanel.startNewGame(null, nowInfo, true);
			boardPanel.mc_mask.y = 45;
			boardPanel.qiuContainer.x = boardPanel.gridContainer.x = 192;
			boardPanel.qiuContainer.y = boardPanel.gridContainer.y = 631;
			
			btn_new.visible = btn_clear.visible = btn_start.visible = boardList.visible = false;
			btn_change.visible = tf_action.visible= true;
		}
		
		/**
		 * 解谜展示
		 * @param e
		 * @return 
		 */
		public function onSolve(e:*):void {
			btn_start.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			boardPanel.showTotalAction(nowInfo.solve);
		}
		
		/**
		 * 解谜记录
		 * @param e
		 * @return 
		 */
		public function onRecordSolve(e:*=null):void {
			var action:String = boardPanel.getTotalAction();
			tf_action.text = "解谜过程:\n"+action.replace(/,turnover,/g, "\n");
			if(e){
				nowInfo.solve = action;
				btn_showSolve.visible = true;
			}
			btn_recordSolve.visible = false;
		}
		
		/**
		 * 编辑展示
		 * @param e
		 * @return 
		 */
		public function onEdite(e:*=null):void {
			btn_new.visible = btn_clear.visible = btn_start.visible = boardList.visible = true;
			btn_change.visible = tf_action.visible = btn_recordSolve.visible = false;
			setPanel.showEdite();
			boardPanel.clearBoard();
		}
				
		/**
		 * 输出boardInfo.json
		 * @param e
		 * @return 
		 */
		public function onOutput(e:*):void {
			saveAllInfo();
			for(var i:int=0; i<boardInfoVO.boards.length; i++){
				(boardInfoVO.boards[i] as BoardBaseVO).updateSkills();
			}
			var info:String = JSON.stringify(boardInfoVO);
			TextFactory.outputFile(info, "boardInfo.json");
//			var s:String="";
//			nowInfo.balls.forEach(function(item:Object, index:int, arr:Array):void{s+=item+"\n"});
//			s+=("_______________________________________\n");
//			nowInfo.skills.forEach(function(item:Object, index:int, arr:Array):void{s+=item+"\n"});
//			setPanel.setOutput(s);
//			
//			var xml:XML=<data></data>;
//			for(var i:int=0; i<infoArr.length; i++){
//				var labelStr:String = boardList.dataProvider.getItemAt(i).label;
//				var arr:Array = infoArr[i];//infoArr.filter(function(item:Array, index:int, arr:Array):Boolean{return item["name"]==labelStr})[0];
//				//trace(boardList.sortIndex);
//				xml.appendChild(new XML("<info id='"+i+"' name='"+labelStr+"'></info>"));
//				if(i==76){
//					trace("??");
//				}
//				xml.info[i].appendChild(setArrToXML(arr[0], "balls"));
//				if(arr[3]) xml.info[i].appendChild(setArrToXML(arr[3], "grids"));
//				if(arr[1]) xml.info[i].appendChild(setArrToXML(arr[1], "skills"));
//				if(arr[2]) xml.info[i].appendChild(new XML("<solve>"+arr[2]+"</solve>"));//解谜方法
//				//trace(boardList.dataProvider.getItemAt(i).label);
//			}
//			boardInfo = xml;
//			dispatchEvent(new ObjectEvent(BOARD_INFO_LOADED));
//			TextFactory.outputFile(xml.toXMLString(), "boardInfo.xml");
		}
		
		public function saveAllInfo():void{
			nowInfo.getBoardConfig().reset();
			nowInfo.boardConfig = mc_boardConfig.saveInfo();
			nowInfo.boardSkills = mc_skillSelectPanel.getBoardSkills();
		}
		
		/**
		 * 把数组设置给棋盘
		 */
		public function setArrToBoard():void{
			setPanel.setArrToBoard(nowInfo);
			mc_boardConfig.updateInfo(nowInfo.boardConfig);
			mc_skillSelectPanel.setBoardSkills(nowInfo.boardSkills);
			var action:String = nowInfo.solve;
			tf_action.text = action ? "解谜过程:\n"+action.replace(/,turnover,/g, "\n") : "";
			btn_showSolve.visible = Boolean(nowInfo.solve);
		}
		
		//=============================================================================================
		public function get tarIndex():int{
			return _tarIndex;
		}
		public function set tarIndex(value:int):void{
			_tarIndex = value;
			nowInfo = boardInfoVO.getNowInfo(value);
		}
		private var _tarIndex:int=0;
		public var boardList:List;
		public var tf_boardName:TextField;
		public function onBoardNameChange(e:Event):void {
			boardList.dataProvider.getItemAt(tarIndex).label = nowInfo.name = tf_boardName.text;
			boardList.dataProvider = boardList.dataProvider;
			boardList.selectedIndex = nowInfo.ID;
		}
		
		public function showSelectList(e:Event):void {
			if(e.target is List){//boardList.dataProvider.getItemAt(tarIndex).label;
				saveAllInfo();
				tarIndex = e.target.selectedIndex;
				tf_boardName.text = nowInfo.name;
				setArrToBoard();
				//trace(tarIndex+":"+nowInfo.balls);
			}
		}
		
		/**
		 * 更新展示棋盘配置列表
		 */
		public function updateList(index:int=-1):void{
			var dp:DataProvider = new DataProvider();
			for (var i:int=0; i<boardInfoVO.boards.length; i++) {
				dp.addItem({label:boardInfoVO.boards[i]["name"]});//"谜题"+(i+1)});
			}
			boardList.dataProvider = dp;
			tarIndex = boardList.selectedIndex = index>-1 ? index : boardInfoVO.boards.length-1;
			tf_boardName.text = nowInfo.name;
			
			setArrToBoard();
			
			dispatchEvent(new ObjectEvent(BOARD_INFO_LOADED));
		}
		
		/**
		 * 把数组设置给XML
		 * @param arr
		 * @param str
		 * @return 
		 */
//		public function setArrToXML(arr:Array, str:String):XML{
//			var s:String="";
//			for (var i:int=0; i<arr.length; i++) {
//				while(arr[i].length>0 
//					&& ((str=="balls" && arr[i][arr[i].length-1]==QiuPoint.KIND_NULL)
//					|| (str=="grids" && arr[i][arr[i].length-1]==100)
//					|| arr[i][arr[i].length-1]=="0" 
//					|| !arr[i][arr[i].length-1])){
//					arr[i].pop();
//				}
//				for (var j:int=0; j<arr[i].length; j++) {
//					s+=(arr[i][j]?arr[i][j]:"0")+(j<(arr[i].length-1)?",":"");
//				}
//				s+=(i<(arr.length-1)?"/\n":"");
//			}
//			return XML("<"+str+">"+s+"</"+str+">");
//		}
		
		/**
		 * 把XML设置给数组
		 * @param xml
		 * @return 
		 */
//		public function setXMLToArr(xml:XML):Array{
//			var arr:Array=String(xml).replace(/\r|\n|	/g,"").split("/");
//			arr.forEach(function(item:Object, index:int, arr:Array):void{arr[index]=item.split(",")});
////			for(var i:int=0; i<8; i++){
////				if(!arr[i]) arr[i]=[];
////				var tmparr:Array = arr[i];
////				for(var j:int=tmparr.length-1; j>=0; j--){
////					if(tmparr[j]==QiuPoint.KIND_NULL){
////						tmparr.pop();
////					}else{
////						break;
////					}
////				}
////			}
//			return arr;
//		}
		
		/**
		 * 新增一个新的棋盘配置
		 * @param e
		 * @return 
		 */
		public function newInfo(e:*):void {
			var index:int = -1;
			switch(e.target){
				case btn_new:
					index = boardInfoVO.addBoard();
					break;
				case btn_copy_new:
					index = boardInfoVO.addBoard(nowInfo);
					break;
				case btn_delete:
					index = boardInfoVO.deleteBoard(nowInfo);
					break;
				case btn_insert_new:
					index = boardInfoVO.insertBoard(nowInfo);
					break;
				case btn_insert_copy:
					index = boardInfoVO.insertBoard(nowInfo, true);
					break;
				case btn_board_up:
					index = boardInfoVO.upBoard(nowInfo);
					break;
				case btn_board_down:
					index = boardInfoVO.downBoard(nowInfo);
					break;
				case btn_moveTo:
					var num:int = parseInt(tf_moveTo.text);
					while(nowInfo.ID!=num){
						if(nowInfo.ID>num){
							index = boardInfoVO.upBoard(nowInfo);
						}else{
							index = boardInfoVO.downBoard(nowInfo);
						}
					}
					break;
			}
//			var vo:BoardBaseVO = new BoardBaseVO({ID:boardInfoVO.boards.length});
//			boardInfoVO.boards.push(vo);
//			infoArr[infoArr.length-1]["name"] = "谜题";
//			boardList.dataProvider.addItem({label:"谜题"});
//			if(e.target==btn_copy_new){
//				vo.updateObj(JSON.parse(JSON.stringify(nowInfo)));
//			}
			updateList(index);
		}
		
		
		//=========================================================================================
		
		
//		public var boardPanelIndexNum:int = trace(this.getChildIndex(boardPanel))
		
		private function get ddpLogic():ChessBoardLogic{
			return ChessBoardLogic.getInstance();
		}
		public function onGameOver(e:Event):void{
			if(ddpLogic.checkHasClearAll()){
				var solve:String = boardPanel.getTotalAction();
				if(!boardPanel.tempTotalActionStr && solve!="" && solve!=nowInfo.solve){
					btn_recordSolve.visible = true;
				}
			}
		}
	}
}
