package com.view.UI.activity {
	import com.model.event.ObjectEvent;
	import com.model.vo.activity.ActivityAwardVO;
	import com.model.vo.activity.ActivityVO;
	import com.view.BasePanel;

	/**
	 *
	 * @author raojing
	 */
	public class ActivityPanel extends BasePanel {
		public static const NAME:String="ActivityPanel";
		public static function getShowName():String{
			getInstance().open();
			return NAME;
		}
		private static const SINGLETON_MSG:String="single_ActivityPanel_only";
		private static var instance:ActivityPanel;

		public static function getInstance():ActivityPanel {
			if(instance==null)
				instance=new ActivityPanel();
			return instance as ActivityPanel;
		}

		public function ActivityPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;
			init();
		}
		/**
		 *
		 */
		public static const MARK_SIGN:String="MARK_SIGN";




		public var activity_info_board:ActivityInfoBoard;
		public var activity_list_panel:ActivityListPanel;
		public var activity_add_panel:ActivityAddPanel;

		public var isLoad:Boolean=false;

		private var running_tag:int;

		/**
		 *
		 *
		 */
		private function init():void {
			this.onClose(null)
			//init altarListPanel
			activity_list_panel.addEventListener(ActivityListPanel.E_CLOSE, onClose);
			activity_list_panel.addEventListener(ActivityListPanel.E_ADD, onOpenAddPanel);
			activity_list_panel.addEventListener(ActivityListPanel.E_BAR_CLICK, onActivityBar);
		}
		private var updateFnArr:Array=[];

		public function onClose(e:ObjectEvent):void {
			this.close();
		}
		public function onActivityBar(e:ObjectEvent):void {
			var activity_vo:ActivityVO=e.data as ActivityVO;
			activity_info_board.updateInfo(activity_vo);
		}

		public function onOpenAddPanel(e:ObjectEvent):void {
			activity_add_panel.updateInfo(null);
		}

		public function updateInfo(voList:Array):void {
			activity_list_panel.updateInfo(voList);
		}

		public function open():void {
			if(!isLoad) {
				updateInfo(getFakerVoList());
			} else {
			}
			this.visible=true;
		}
		
		private function getFakerVoList():Array{
			var newArr:Array=[];
			for(var i:int=0;i<5;i++){
				var a_vo:ActivityVO = new ActivityVO(i+10000,"标题-"+i,"描述-"+i,"内容-"+i,"2014-7-1 00:00:00","2014-7-30 00:00:00","首冲-"+i,0);
				for(var j:int=0;j<3;j++){
					var aw_vo:ActivityAwardVO = ActivityAwardVO.genItemAward(Math.random()*20,j);
					a_vo.addAwardVO(aw_vo);
				}
				var money_vo:ActivityAwardVO = ActivityAwardVO.genMoneyAward(100);
				a_vo.addAwardVO(money_vo);
				newArr.push(a_vo);
			}
			return newArr;
		}
	}
}
