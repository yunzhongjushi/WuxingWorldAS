package com.view.UI.fairy {
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.item.FairyEquipVO;
	import com.view.BasePanel;
	import com.view.UI.item.ItemBarMiddle;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;


	/**
	 * 装备面板（弹出）
	 * @author CC5
	 */
	public class FairyEquipmentBoard extends BasePanel {
		/**
		 * 装备框
		 */
		public var itemBar:ItemBarMiddle;
		/**
		 * 名称
		 */
		public var tf_name:TextField;
		/**
		 * 数量
		 */
		public var tf_num:TextField;
		/**
		 * 描述
		 */
		public var tf_description:TextField;
		/**
		 * 需要等级
		 */
		public var tf_needLevel:TextField;
		/**
		 * 获取途径的滑动列表
		 */
		public var list_equip_way:TouchPad;
		/**
		 * 滑动列表遮罩
		 */
		public var mc_cover:MovieClip;

		/**
		 * 各种功能的按键，通过改变按键的文字来指定某种功能
		 *
		 * 装备栏已有装备...确定，等级不够时显示灰色
		 * 装备栏无装备，背包有装备...装备
		 * 装备栏无装备，背包无装备...获取途径
		 * 在“获取途径”页...查看属性
		 */
		public var btn_function:CommonBtn;

		public function FairyEquipmentBoard() {
			btn_function.addEventListener(MouseEvent.CLICK, handle_click);
		}

		/**
		 * 按键功能实现
		 * @param e
		 *
		 */
		protected function handle_click(e:*):void {
			switch(btn_function.nameTxt) {
				case "确  定":
					this.close();
					break;
				case "装  备":
					if(btn_function.mouseEnabled) {
						ServerVO_68.equip_fairy(rFairyVO, rEquipVO);
						this.close();
					}
					break;
			}
		}
		/**
		 * 使用中的VO
		 */
		private var rEquipVO:FairyEquipVO;
		private var rFairyVO:BaseFairyVO;

		/**
		 * 更新
		 * @param equipVO
		 * @param fairyVO
		 */
		public function updateInfo(equipVO:FairyEquipVO, fairyVO:BaseFairyVO):void {
			this.rEquipVO=equipVO;
			this.rFairyVO=fairyVO;

			if(list_equip_way==null) {
				var vo:TouchPadOptions=new TouchPadOptions(mc_cover.width, mc_cover.height, EquipGetBar, 0);
				list_equip_way=new TouchPad(vo);
				list_equip_way.x=mc_cover.x;
				list_equip_way.y=mc_cover.y
				this.addChild(list_equip_way);
				mc_cover.visible=false;
			}
			list_equip_way.updateInfo(rEquipVO.getLevelVOList());
			setAttributePage();
			refresh();
		}

		/**
		 * 打开“属性”页（第一页），关闭“获取途径”页
		 */
		private function setAttributePage():void {
			btn_function.setEnable(true);

			if(rFairyVO.equipArray[rEquipVO.data.equipInfo.position]!=null) {// 该槽位已经有装备，查看装备
				btn_function.setNameTxt("确  定");
			} else {
				if(rFairyVO.LV<rEquipVO.data.needLevel||rEquipVO.num==0) {//  有装备 或 等级不够
					btn_function.setEnable(false);
					btn_function.setNameTxt("装  备");
				} else {//	有装备，等级够
					btn_function.setNameTxt("装  备");
				}
			}
		}

		/**
		 * 根据运行中VO来更新整个页面
		 *
		 */
		public function refresh():void {
			itemBar.updateInfo(rEquipVO);

			tf_name.text = String(rEquipVO.data.level);
			tf_description.text=rEquipVO.data.describe;
			tf_needLevel.text="需求精灵等级:"+rEquipVO.data.needLevel;
			tf_num.text="拥有 "+rEquipVO.num+" 件";
		}

	}
}
