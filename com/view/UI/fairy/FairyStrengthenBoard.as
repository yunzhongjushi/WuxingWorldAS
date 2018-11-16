package com.view.UI.fairy {
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.StrengthenFairyVO;
	import com.model.vo.item.ItemListVO;
	import com.model.vo.item.ItemVO;
	import com.view.BasePanel;
	import com.view.UI.item.ItemBarMiddle;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * 强化面板
	 * @author CC5
	 */
	public class FairyStrengthenBoard extends BasePanel {
		public var fairyBar_1:FairyBarSmall;
		public var tf_label_1:TextField;
		public var tf_hp_1:TextField;
		public var tf_atk_1:TextField;
		public var tf_def_1:TextField;

		public var fairyBar_2:FairyBarSmall;
		public var tf_label_2:TextField;
		public var tf_hp_2:TextField;
		public var tf_atk_2:TextField;
		public var tf_def_2:TextField;

		public var tf_requirement:TextField;
		public var tf_cost:TextField;

		public var pieceBar:ItemBarMiddle

		/**
		 * 强化按钮
		 */
		public var btn_strengthen:CommonBtn;

		public var fairyStrengthenBoard_Arrow:MovieClip;

		public var section_1_x_arr:Array=[];
		public var offset_x_when_max:int;

		public function FairyStrengthenBoard() {
			this.addEventListener(MouseEvent.CLICK, handle_click);

			section_1_x_arr["fairyBar_1"]=fairyBar_1.x;
			section_1_x_arr["tf_label_1"]=tf_label_1.x;
			section_1_x_arr["tf_hp_1"]=tf_hp_1.x;
			section_1_x_arr["tf_atk_1"]=tf_atk_1.x;
			section_1_x_arr["tf_def_1"]=tf_def_1.x;

			offset_x_when_max=(fairyBar_2.x-fairyBar_1.x)/2

			btn_strengthen.setNameTxt("强  化");
		}

		/**
		 * 发送消息：强化精灵
		 * @param e
		 */
		protected function handle_click(e:*):void {
			if(e.target==btn_strengthen){
				ServerVO_68.strengthen_fairy(running_strengthenVO);
			}
		}

		private var running_strengthenVO:StrengthenFairyVO;

		/**
		 * 更新数据
		 * @param mergeVO
		 * @param fairyVO
		 *
		 */
		public function updateInfo(mergeVO:ItemVO, fairyVO:BaseFairyVO):void {
			this.running_strengthenVO=new StrengthenFairyVO(fairyVO, mergeVO);

			if(running_strengthenVO) {
				running_strengthenVO.fairyVO.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);
			}

			running_strengthenVO.fairyVO.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, refresh);

			refresh();

			if(mergeVO.num<1000) {
				// GM命令，添加物品
				ItemListVO.testAddItem(mergeVO.templateID, 1000);
			}
		}

		/**
		 * 更新面板
		 * @param e
		 *
		 */
		public function refresh(e:ObjectEvent=null):void {
			var fairy_1:BaseFairyVO=running_strengthenVO.fairyVO;

			fairyBar_1.updateInfo(fairy_1);

			tf_hp_1.text="生命: "+String(fairy_1.HP_max);
			tf_atk_1.text="攻击: "+String(fairy_1.finalAP);
			tf_def_1.text="防御: "+String(fairy_1.finalDP);

			var fairy_2:BaseFairyVO=running_strengthenVO.fairyVO;

			fairyBar_2.updateInfo(fairy_2);

			//提升一个强化等级
			fairyBar_2.updateStrengthLV(fairy_2.intensLV);

			tf_hp_2.text="生命: "+String(fairy_2.HP_max);
			tf_atk_2.text="攻击: "+String(fairy_2.finalAP);
			tf_def_2.text="防御: "+String(fairy_2.finalDP);

			pieceBar.updateInfo(running_strengthenVO.mergeVO);

			tf_requirement.text="强化要求：\n精灵等级达到"+running_strengthenVO.getNeedFairyLV()+"级";
			tf_cost.text="消耗碎片 x "+running_strengthenVO.getCostMeger();

			//
			if(running_strengthenVO.getCanStrengthen()) {
				btn_strengthen.setEnable(true);
			} else {
				btn_strengthen.setEnable(false);
			}

			if(running_strengthenVO.getIsMaxLV()) {
				fairyStrengthenBoard_Arrow.visible=false;
				tf_label_2.visible=false;
				fairyBar_2.visible=false;
				tf_hp_2.visible=false;
				tf_atk_2.visible=false;
				tf_def_2.visible=false;

				fairyBar_1.x=section_1_x_arr["fairyBar_1"]+offset_x_when_max;
				tf_label_1.x=section_1_x_arr["tf_label_1"]+offset_x_when_max;
				tf_hp_1.x=section_1_x_arr["tf_hp_1"]+offset_x_when_max;
				tf_atk_1.x=section_1_x_arr["tf_atk_1"]+offset_x_when_max;
				tf_def_1.x=section_1_x_arr["tf_def_1"]+offset_x_when_max;

				tf_requirement.text="该精灵已强化到最高等级。";
				tf_cost.text="不可强化";
			} else {
				fairyStrengthenBoard_Arrow.visible=true;
				tf_label_2.visible=true;
				fairyBar_2.visible=true;
				tf_hp_2.visible=true;
				tf_atk_2.visible=true;
				tf_def_2.visible=true;

				fairyBar_1.x=section_1_x_arr["fairyBar_1"];
				tf_label_1.x=section_1_x_arr["tf_label_1"];
				tf_hp_1.x=section_1_x_arr["tf_hp_1"];
				tf_atk_1.x=section_1_x_arr["tf_atk_1"];
				tf_def_1.x=section_1_x_arr["tf_def_1"];
			}
		}
	}
}
