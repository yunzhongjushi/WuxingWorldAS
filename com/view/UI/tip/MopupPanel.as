package com.view.UI.tip {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.ItemVO;
	import com.model.vo.tip.MopupBarVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import listLibs.SlideContainer;
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	/**
	 * 扫荡面板
	 * @author hunterxie
	 */
	public class MopupPanel extends BasePanel {
		public static const NAME:String="MopupPanel";
		private static const SINGLETON_MSG:String="single_MopupPanel_only";
		private static var instance:MopupPanel;
		public static function getInstance():MopupPanel {
			if(instance==null)
				instance=new MopupPanel();
			return instance as MopupPanel;
		}

		public function MopupPanel() {
			if(instance!=null)
				throw Error(SINGLETON_MSG);
			instance=this;

			//init
			btn_ok.setNameTxt("确 认");
			this.addEventListener(MouseEvent.CLICK, handle_click);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShowPanel);
			
		}
		
		private function onShowPanel(e:ObjectEvent):void{
			if(e.data==MopupPanel.NAME){
				var arr:Array=[];
				for(var i:int=0; i<10; i++) {
					arr.push(new MopupBarVO(i, getItemArr(), 100, [10, 20, 30, 40, 50]));
				}
				updateInfo(arr);
			}
			function getItemArr():Array {
				var itemArr:Array=[];
				for(var i:int=0; i<Math.floor(Math.random()*4+4); i++) {
					itemArr.push(ItemVO.getItemVO(ItemConfigVO.LIVE_BIG, 10));
				}
				return itemArr
			}
		}

		protected function handle_click(e:*):void {
			switch(e.target) {
				case btn_ok:
					this.close();
					break;
			}
		}
		/**
		 * 显示下个扫荡条的间隔，按帧算
		 */
		private var show_bar_interval:int=50;
		/**
		 * 显示增加元素的延迟，按帧算
		 */
		private var show_add_rs_delay:int=20;

		public var tf_turn:TextField;
		public var tf_add_jin:TextField;
		public var tf_add_mu:TextField;
		public var tf_add_tu:TextField;
		public var tf_add_shui:TextField;
		public var tf_add_huo:TextField;
		public var tf_add_exp:TextField;

		public var btn_ok:CommonBtn;

		public var mc_cover:MovieClip;
		//
		public var rVOList:Array;

//		public var flexList:TouchContainer;
//		public var mcList:TouchListFlexible;

		public var barList:TouchPad

		public function updateInfo(voList:Array):void {
			if(barList==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, MopupBar, 3);

				//创建ListPanel

				barList=new TouchPad(vo);
				barList.x=mc_cover.x;
				barList.y=mc_cover.y

				var index:int=this.getChildIndex(mc_cover);

				this.addChildAt(barList, index);

				mc_cover.visible=false;
			}

			rVOList=voList
			tf_turn.text="扫荡回合："+1+" / "+voList.length;

			totalExp=0;
			tf_add_exp.text="+"+totalExp;

			totalWuxing=[0, 0, 0, 0, 0]

			for(var i:int=0; i<totalWuxing.length; i++) {
				(this["tf_add_"+wuxingName[i]] as TextField).text="+"+totalWuxing[i];
			}

			barList.updateInfo([]);
			barList.setMode(SlideContainer.MODE_SCROLL);
			btn_ok.visible=false;
			show_bar_interval=35;
			count=show_bar_interval-20;
			totalSlide=0;
			showNum=1;
			this.addEventListener(Event.ENTER_FRAME, handle_ef);
		}

		private var count:int;
		private var showNum:int;
		private var totalSlide:int;

		private var wuxingName:Array=["jin", "mu", "tu", "shui", "huo"];
		private var totalWuxing:Array;
		private var totalExp:int;

		protected function handle_ef(e:Event):void {
			var vo:MopupBarVO;
			if(count>=show_bar_interval) {
				//action
				var arr:Array=rVOList.slice(0, showNum);
				for(var i:int=0; i<arr.length; i++) {
					vo=arr[i] as MopupBarVO;
					if(i==arr.length-1) {
						vo.setShowItem();
					} else {
						vo.setShowBar();
					}
				}
				if(showNum>rVOList.length) {
					// end
					barList.setMode(SlideContainer.MODE_NORMAL);
					btn_ok.visible=true;
					this.removeEventListener(Event.ENTER_FRAME, handle_ef);
					return;
				}
				var slide:int=barList.appendVO(vo);
				var preSlide:int=totalSlide;
				totalSlide+=slide;
				if(totalSlide>=mc_cover.height) {
					if(preSlide>=mc_cover.height) {
						barList.toSlide(-1*(slide+2));
					} else {
						barList.toSlide(-1*(totalSlide-mc_cover.height+2));
					}
				}

				totalExp+=vo.addExp;

				tf_turn.text="扫荡回合："+showNum+" / "+rVOList.length;

				count=0;
				showNum++;
				show_bar_interval=20+vo.itemArr.length*5+20;
				show_add_rs_delay=20+vo.itemArr.length*5+10
			} else if(count==show_add_rs_delay&&showNum>1) {
				vo=rVOList[rVOList.length-1]
				tf_add_exp.text="+"+totalExp;
				for(var j:int=0; j<totalWuxing.length; j++) {
					totalWuxing[j]+=vo.addWuxing[j];
					(this["tf_add_"+wuxingName[j]] as TextField).text="+"+totalWuxing[j];
				}
				count++;
			} else {
				count++;
			}
		}

	}
}
