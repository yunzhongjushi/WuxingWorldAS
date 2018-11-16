package com.view.UI.achievement {
	import com.model.vo.task.taskListVO;
	import com.model.vo.config.mission.MissionConfig;
	import com.view.BasePanel;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.geom.Rectangle;
	import flash.text.TextField;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	public class AchievementListPanel extends BasePanel {
		public static const TAG_SUMMARY:String="成就点数";
		public static const TAG_COMMON:String="通用成就";
		public static const TAG_FIGHT:String="战斗成就";
		public static const TAG_PUZZLE:String="解谜成就";

		public function AchievementListPanel() {
			super();
			this.addEventListener(MouseEvent.CLICK, handle_click);
		}

		public function handle_click(e:*):void {
			switch(e.target) {

			}
		}
		//Function Names
		public static const E_CLOSE:String="E_CLOSE";
		public static const E_BAR_CLICK:String="E_BAR_CLICK";
		//Event Names
		public static const TEMP:String="TEMP";
		//场景含有组件
		public var tf_cur:TextField;
		public var tf_total:TextField;


		// 元素
		private var barList:TouchPad
		public var mc_cover:MovieClip;

		// 
		/**
		 * 更新面板信息
		 * @param pointName
		 * @param voList
		 */
		public function updateInfo(kind:int):void {
			if(barList==null) {
				var rect:Rectangle=new Rectangle(0, 0, mc_cover.width, mc_cover.height);
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, AchievementBar) //new TouchListVO(rect, AchievementBar, new Point(), 10);

				//创建ListPanel
				barList=new TouchPad(vo);
				barList.x=mc_cover.x;
				barList.y=mc_cover.y
				this.addChild(barList);
				mc_cover.visible=false;
			}

			tf_cur.text		= String(taskListVO.totalScoreInfo[kind]);//总成就点数的展示是没有意义的
			tf_total.text	= String(MissionConfig.totalScoreInfo[kind]);//总成就点数的展示是没有意义的
			barList.updateInfo(taskListVO.getAchievementKindArr(kind));
		}
	}
}
