package ui.chessboard {
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.view.UI.chessboard.ActiveElemental;
	import com.view.UI.chessboard.BoardSkillPanel;
	
	/**
	 * 特殊情况：不进行移动过程中控制操作会出现消除中移动额外棋子过来也可跟正在消除棋子匹配的情况（消除开始时就应该进行数组处理了）
	 * @author hunterxie
	 */
	public class ChessBoardPanelUI extends BasePanel {
		/**
		 * 棋盘棋子容器
		 */
		public var qiuContainer:Sprite;
		/**
		 * 棋盘格子buff容器
		 */
		public var gridContainer:Sprite;
		/**
		 * 不能点击覆盖
		 */
		public var mc_cover:Sprite;

		/**
		 * 复盘展示覆盖
		 */
		public var mc_actionCover:Sprite;
		
		/**
		 * 棋盘付费技能列表
		 */
		public var mc_boardSkillPanel:BoardSkillPanel;
		
		/**
		 * 静空领域技能
		 */
		public var mc_stopFall:MovieClip;
		
		/**
		 * 战斗回放
		 */
		public var tf_gameReview:TextField;
		 
		/**
		 * 倒计时/倒计步数
		 */
		public var tf_countdown:TextField;
		
		/**
		 * 游戏积分
		 */
		public var tf_score:TextField;
		
		
		/**
		 * 上次移动且消除的球
		 */
		public var mc_active:ActiveElemental;
		/**
		 * 
		 */
		public var mc_boardBG:MovieClip;
		/**
		 * 棋盘棋子容器遮罩
		 */
		public var mc_mask:MovieClip;
		
		public var btn_help:CommonBtn;
		/**
		 * 
		 */
		public var tf_turnNum:TextField;

		
		/**
		 * =====================================================================
		 * 主函数
		 * =====================================================================
		 */
		public function ChessBoardPanelUI() {
		}
	}
}