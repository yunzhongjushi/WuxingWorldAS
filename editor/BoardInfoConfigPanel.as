package editor {
	import com.model.vo.config.board.BoardConfigVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class BoardInfoConfigPanel extends BasePanel{
		public var btn_show:CommonBtn;
		
		/**
		 * 长宽和步数限制的文字底，不影藏
		 */
		public var tf_RL_num:TextField;
		/**
		 * 步数限制，不影藏
		 */
		public var tf_step:TextField;
		/**
		 * 回合限制，不影藏
		 */
		public var tf_round:TextField;
		
		/**
		 * 高
		 */
		public var cb_maxR:ComboBox;
		/**
		 * 宽
		 */
		public var cb_maxL:ComboBox;
		/**
		 * 回合模式
		 */
		public var cb_ActiveMode:ComboBox;
		/**
		 * 初始化掉落是否可消
		 */
		public var cb_isInitCanClear:ComboBox;
		/**
		 * 是否可快消
		 */
		public var cb_isDelayFall:ComboBox;
		/**
		 * 是否掉落随机新棋子
		 */
		public var cb_isCreateNew:ComboBox;
		/**
		 * 交换展示时间
		 */
		public var tf_exchangeTime:TextField;
		/**
		 * 掉落展示时间
		 */
		public var tf_fallTime:TextField;
		/**
		 * 消除展示时间
		 */
		public var tf_clearTime:TextField;
		/**
		 * 掉落后判断依然在连消中的时间
		 */
		public var tf_sequenceTime:TextField;
		/**
		 * 棋子类型
		 */
		public var tf_kindArr:TextField;
		/**
		 * 对应棋子类型的棋子掉落权重
		 */
		public var tf_chanceArr:TextField;
		
		
		public var boardConfig:BoardConfigVO = new BoardConfigVO();
		
		/**
		 * 是否显示剩下的信息
		 */
		private var isShow:Boolean = true;
		
		
		public function BoardInfoConfigPanel() {
//			new DataProvider([{id:"5", label:5},{id:"6", label:6},{id:"8", label:8}]);
			tf_RL_num.mouseEnabled = false;
			cb_maxR.dataProvider = new DataProvider([5,6,7,8]);
			cb_maxR.selectedIndex = 3;
			cb_maxL.dataProvider = new DataProvider([5,6,7,8]);
			cb_maxL.selectedIndex = 3;
			cb_ActiveMode.dataProvider = new DataProvider(["回合驱动", "全回合制驱动", "时间驱动"]);
			cb_isInitCanClear.dataProvider = new DataProvider(["不能", "能"]);
			cb_isDelayFall.dataProvider = new DataProvider(["不能", "能"]);
			cb_isCreateNew.dataProvider = new DataProvider(["不能", "能"]);
			
			btn_show.setNameTxt("显");
			btn_show.addEventListener(MouseEvent.CLICK, onShow);
			onShow();
		}
		
		public function onShow(event:*=null):void{
			isShow = !isShow;
			btn_show.setNameTxt(isShow?"藏":"显");
			for(var i:int=0; i<this.numChildren; i++){
				this.getChildAt(i).visible = isShow;
			}
			cb_maxL.visible = cb_maxR.visible = btn_show.visible = tf_RL_num.visible = tf_step.visible = tf_round.visible = true;
		}
		
		public function updateInfo(info:Object):void{
			this.boardConfig.reset();
			this.boardConfig.updateObj(info);

			cb_maxR.selectedIndex = boardConfig.maxR-5;
			cb_maxL.selectedIndex = boardConfig.maxL-5;
			cb_ActiveMode.selectedIndex = boardConfig.activeMode;
			cb_isInitCanClear.selectedIndex = boardConfig.isInitCanClear;
			cb_isDelayFall.selectedIndex = boardConfig.isDelayFall;
			cb_isCreateNew.selectedIndex = boardConfig.isCreateNew;
			tf_exchangeTime.text = String(boardConfig.exchangeTime);
			tf_fallTime.text = String(boardConfig.fallTime);
			tf_clearTime.text = String(boardConfig.clearTime);
			tf_sequenceTime.text = String(boardConfig.sequenceTime);
			tf_kindArr.text = boardConfig.kindArr.toString();
			tf_chanceArr.text = boardConfig.chanceArr.toString();
			tf_step.text = boardConfig.stepLimit.toString();
			tf_round.text = boardConfig.roundLimit.toString();
		}
		
		public function saveInfo():Object{
			boardConfig.maxR = cb_maxR.selectedIndex+5;
			boardConfig.maxL = cb_maxL.selectedIndex+5;
			boardConfig.activeMode = cb_ActiveMode.selectedIndex;
			boardConfig.isInitCanClear = cb_isInitCanClear.selectedIndex;
			boardConfig.isDelayFall = cb_isDelayFall.selectedIndex;
			boardConfig.isCreateNew = cb_isCreateNew.selectedIndex;
			boardConfig.exchangeTime = Number(tf_exchangeTime.text);
			boardConfig.fallTime = Number(tf_fallTime.text);
			boardConfig.clearTime = Number(tf_clearTime.text);
			boardConfig.sequenceTime = Number(tf_sequenceTime.text);
			boardConfig.kindArr = tf_kindArr.text.split(",");
			boardConfig.chanceArr = tf_chanceArr.text.split(",");
			boardConfig.stepLimit = Number(tf_step.text);
			boardConfig.roundLimit = Number(tf_round.text);
			var info:Object = boardConfig.getChangeVO();
			return info;
		}
	}
}
