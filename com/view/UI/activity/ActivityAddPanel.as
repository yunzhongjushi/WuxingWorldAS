package com.view.UI.activity {
	import com.model.vo.activity.ActivityAwardVO;
	import com.model.vo.activity.ActivityVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	public class ActivityAddPanel extends BasePanel {
		public function ActivityAddPanel() {
			super();
			btn_add.setNameTxt("添 加")
			btn_clear.setNameTxt("清 除")
			btn_input.setNameTxt("输 入")
			this.addEventListener(MouseEvent.CLICK, handle_click);
			onUnLock();
		}

		public function handle_click(e:*):void {
			switch(e.target) {
				case btn_close:
					this.close();
					break;
				case btn_clear:
					runnning_vo=ActivityVO.genEmptyVO();
					break;
				case btn_lock:
					onUnLock();
					break;
				case btn_check:
					onCheck();
					break;
				case btn_add:
//							getFnByName(E_ADD).call(null,sendObj);
					break;
				case btn_input:
					break;
			}
		}
		//****************   以上为模板，请勿随意改动。   *******************************
		//Function Names
		public static const E_ADD:String="E_ADD";
		public static const E_CLOSE:String="E_CLOSE";
		//
		public var activity_input_board:ActivityInputBoard;
		//
		public var btn_add:CommonBtn;
		public var btn_clear:CommonBtn;
		public var btn_input:CommonBtn;
		public var btn_check:MovieClip;
		public var btn_lock:MovieClip;
		//Activity params
		//1-1
		public var t1:TextField;
		public var t2:TextField;
		public var t3:TextField;
		public var t4:TextField;
		public var t5:TextField;
		public var t6:TextField;
		public var t7:TextField;
		public var tf_description:TextField;
		//1-2
		public var tf_last:TextField;
		public var tf_award_content:TextField;
		public var tf_award_description:TextField;
		public var tf_warning:TextField;
		//2-1
		public var i1:TextField;
		public var i2:TextField;
		public var i3:TextField;
		public var i4:TextField;
		public var i5:TextField;
		public var i6:TextField;
		//2-2
		public var c1:TextField;
		public var c2:TextField;
		public var c3:TextField;
		public var c4:TextField;
		public var c5:TextField;
		public var c6:TextField;
		//2-3
		public var tf_money:TextField;
		//
		public var runnning_vo:ActivityVO;


		public function updateInfo(vo:ActivityVO):void {
			if(vo) {
				set_runnning_vo(vo);
			} else {
				if(runnning_vo==null) {
					set_runnning_vo(ActivityVO.genEmptyVO());
				}
			}
		}

		public function set_runnning_vo(vo:ActivityVO):void {
			runnning_vo=vo;
			//
			tf_last.text="待生成..."
			tf_award_content.text="待生成..."
			tf_award_description.text="待生成..."
			// 
			t1.text=String(runnning_vo.activeId);
			t2.text=runnning_vo.title
			t3.text=runnning_vo.content
			t4.text=runnning_vo.type
			t5.text=String(runnning_vo.questId);
			t6.text=runnning_vo.startDate
			t7.text=runnning_vo.endDate
			tf_description.text=runnning_vo.description
			//
			tf_money.text="0"
			//
			i1.text="0"
			i2.text="0"
			i3.text="0"
			i4.text="0"
			i5.text="0"
			i6.text="0"
			// 
			c1.text="0"
			c2.text="0"
			c3.text="0"
			c4.text="0"
			c5.text="0"
			c6.text="0"
			//
			var a_arr:Array=vo.awardArr;
			var i:int;
			var j:int=1;
			for(i=0; i<a_arr.length; i++) {
				var a_vo:ActivityAwardVO=a_arr[i] as ActivityAwardVO;
				if(a_vo.money==0) {
					this["i"+j].text=String(a_vo.itemID);
					this["c"+j].text=String(a_vo.count);
					j++
				} else {
					tf_money.text=String(a_vo.money)
				}
			}
			onUnLock();
		}

		public function onCheck():void {
			saveParamsToVO()
			btn_check.gotoAndStop(2);
			btn_lock.visible=true;
			if(parseInt(runnning_vo.getMoney())>=500) {
				tf_warning.visible=true;
			} else {
				tf_warning.visible=false;
			}
			tf_last.text=runnning_vo.getLastStr()
			tf_award_content.text=runnning_vo.getAwardContent()
			tf_award_description.text=runnning_vo.getAwardDescription()
		}

		public function onUnLock():void {
			btn_check.gotoAndStop(1);
			btn_lock.visible=false;
			tf_warning.visible=false;
		}

		public function onInput(str:String):void {
			runnning_vo=ActivityVO.genFromStr(str);
		}

		public function saveParamsToVO():void {
			var new_activity_vo:ActivityVO=new ActivityVO(t1.text, t2.text, tf_description.text, t3.text, t6.text, t7.text, t4.text, t5.text);
			for(var i:int=1; i<=6; i++) {
				if(this["i"+i].text!="0") {
					var award_vo:ActivityAwardVO=ActivityAwardVO.genItemAward(this["i"+i].text, this["c"+i].text);
					new_activity_vo.addAwardVO(award_vo);
				}
			}
			if(this.tf_money.text!="0") {
				var money_vo:ActivityAwardVO=ActivityAwardVO.genMoneyAward(parseInt(tf_money.text));
				new_activity_vo.addAwardVO(money_vo);
			}
			runnning_vo=new_activity_vo;
		}
	}
}
