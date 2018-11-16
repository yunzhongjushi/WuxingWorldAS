package com.view.UI.skill {
	import com.model.vo.WuxingVO;
	import com.model.vo.skill.UserSkillVO;
	import com.model.vo.tip.TipVO;
	import com.view.UI.ResourceIcon;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 
	 * @author hunterxie
	 */
	public class SkillInfoPanel extends Sprite{
		public var tf_name:TextField;
		public var tf_LV:TextField;
		public var tf_wuxing:TextField;
		public var tf_info:TextField;
		
		public var mc_bg:Sprite; 
		
		public var btn_add:CommonBtn;
		
		public var mc_nowSkill:SkillIcon;
		
		public var nowSkill:UserSkillVO;
		
		public var mc_close:SimpleButton;
		
		public var mc_resourceIcon:ResourceIcon; 
		
		
		public function SkillInfoPanel() {
			btn_add.setNameTxt("升　级");
			btn_add.addEventListener(MouseEvent.CLICK, onAddLV);
			 
			this.visible = false;
			mc_close.addEventListener(MouseEvent.CLICK, onClose);
			mc_bg.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		protected function onClose(event:*):void{
			this.visible = false;
		}
		
		private function onAddLV(e:*):void{
			if(nowSkill && nowSkill.upLVCost>0){
				
			}else{
				TipVO.showTipPanel(new TipVO("错误", "技能已经到达最高等级！"))
			}
		}
		
		public function updateInfo(vo:UserSkillVO):void{
			nowSkill = vo;
			this.visible = true;
			
			mc_nowSkill.updateInfo(nowSkill);
			
			tf_name.text = nowSkill.name;
			tf_LV.text = String(nowSkill.LV);
			tf_wuxing.text = String(nowSkill.wuxing);
			tf_info.text = "　　"+nowSkill.describe;
			
			mc_resourceIcon.visible =  (nowSkill.upLVCost>0);
			mc_resourceIcon.updateInfo(WuxingVO.getWuxing(nowSkill.wuxing), WuxingVO.getColorStr(String(nowSkill.upLVCost), nowSkill.wuxing));
		}
	}
}
