package com.view {
	import com.model.vo.config.fairy.FairyConfigVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.conn.ServerVO_255;
	import com.model.vo.conn.ServerVO_68;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 
	 * @author hunterxie
	 * 
	 */
	public class GMPanel extends BasePanel {
		private static const SINGLETON_MSG:String="single_GMPanel_only";
		private static var instance:GMPanel;
		public static function getInstance():GMPanel{
			if ( instance == null ) instance=new GMPanel();
			return instance as GMPanel;
		}
		
//==========================================================================================
		public var tf_value_exp:TextField;
		public var tf_add_fairy_ID:TextField;
		public var tf_fairy_ID:TextField;
		public var tf_value_fairy_exp:TextField;
		public var tf_value_gold:TextField;
		public var tf_wuxing_ID:TextField;
		public var tf_value_wuxing:TextField;
		public var tf_item_ID:TextField;
		public var tf_value_item:TextField;
		public var tf_skill_ID:TextField;
		public var tf_value_skill:TextField;
		public var tf_mission_ID:TextField;
		public var tf_value_live:TextField;
		public var tf_active_wuxing_ID:TextField;
		
		public var btn_add_exp:CommonBtn;
		public var btn_add_fairy:CommonBtn;
		public var btn_add_fairy_exp:CommonBtn;
		public var btn_add_all_fairy_exp:CommonBtn;
		public var btn_add_gold:CommonBtn;
		public var btn_add_wuxing:CommonBtn;
		public var btn_add_all_wuxing:CommonBtn;
		public var btn_add_item:CommonBtn;
		public var btn_add_skill:CommonBtn;
		public var btn_add_mission:CommonBtn;
		public var btn_add_live:CommonBtn;
		public var btn_active_all_wuxing:CommonBtn;
		public var btn_active_wuxing:CommonBtn;
		
		
		public function GMPanel() {
			
			btn_add_exp.setNameTxt("增加经验");
			btn_add_fairy.setNameTxt("增加精灵");
			btn_add_fairy_exp.setNameTxt("精灵经验");
			btn_add_all_fairy_exp.setNameTxt("增加全部");
			btn_add_gold.setNameTxt("增加钻石");
			btn_add_wuxing.setNameTxt("增加元素");
			btn_add_all_wuxing.setNameTxt("增加全部");
			btn_add_item.setNameTxt("增加物品");
			btn_add_skill.setNameTxt("增加技能");
			btn_add_mission.setNameTxt("完成任务");
			btn_add_live.setNameTxt("增加精力");
			btn_active_all_wuxing.setNameTxt("激活全部");
			btn_active_wuxing.setNameTxt("激活");
			
			btn_add_exp.addEventListener(MouseEvent.CLICK, onc);
			btn_add_fairy.addEventListener(MouseEvent.CLICK, onc);
			btn_add_fairy_exp.addEventListener(MouseEvent.CLICK, onc);
			btn_add_all_fairy_exp.addEventListener(MouseEvent.CLICK, onc);
			btn_add_gold.addEventListener(MouseEvent.CLICK, onc);
			btn_add_wuxing.addEventListener(MouseEvent.CLICK, onc);
			btn_add_all_wuxing.addEventListener(MouseEvent.CLICK, onc);
			btn_add_item.addEventListener(MouseEvent.CLICK, onc);
			btn_add_skill.addEventListener(MouseEvent.CLICK, onc);
			btn_add_mission.addEventListener(MouseEvent.CLICK, onc);
			btn_add_live.addEventListener(MouseEvent.CLICK, onc);
			btn_active_all_wuxing.addEventListener(MouseEvent.CLICK, onc);
			btn_active_wuxing.addEventListener(MouseEvent.CLICK, onc);

		}
		private function onc(e:*):void{
			switch(e.target){
				case btn_add_exp:
					ServerVO_255.sendInfo(2, 0, parseInt(tf_value_exp.text));
					break;
				case btn_add_fairy:
					var id:int = parseInt(tf_add_fairy_ID.text);
					if(id<10000) id += ItemConfigVO.TYPE_FAIRY;
					ServerVO_68.addFairy(id);
					break;
				case btn_add_fairy_exp:
					ServerVO_255.sendInfo(3, parseInt(tf_fairy_ID.text), parseInt(tf_value_fairy_exp.text));
					break;
				case btn_add_all_fairy_exp:
					ServerVO_255.sendInfo(3, 0, parseInt(tf_value_fairy_exp.text));
					break;
				case btn_add_gold:
					ServerVO_255.sendInfo(4, 0, parseInt(tf_value_gold.text));
					break;
				case btn_add_wuxing:
					ServerVO_255.sendInfo(5, parseInt(tf_wuxing_ID.text), parseInt(tf_value_wuxing.text));
					break;
				case btn_add_all_wuxing:
					ServerVO_255.sendInfo(5, 5, parseInt(tf_value_wuxing.text));
					break;
				case btn_add_item:
					ServerVO_255.sendInfo(6, parseInt(tf_item_ID.text), parseInt(tf_value_item.text));
					break;
				case btn_add_skill:
					ServerVO_255.sendInfo(7, parseInt(tf_skill_ID.text), parseInt(tf_value_skill.text));
					break;
				case btn_add_mission:
					ServerVO_255.sendInfo(9, parseInt(tf_mission_ID.text), 0);
					break;
				case btn_add_live:
					ServerVO_255.sendInfo(10, 0, parseInt(tf_value_live.text));
					break;
				case btn_active_all_wuxing:
					ServerVO_255.sendInfo(8, 5); 
					break;
				case btn_active_wuxing:
					ServerVO_255.sendInfo(8, parseInt(tf_active_wuxing_ID.text));
					break;
			}
		}
	}
}