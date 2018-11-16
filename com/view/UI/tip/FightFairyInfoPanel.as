package com.view.UI.tip{
	import com.model.vo.WuxingVO;
	import com.model.vo.fairy.FairyVO;
	import com.model.vo.skill.fight.FairyBuffVO;
	import com.model.vo.skill.fight.FairySkillVO;
	import com.view.UI.fight.FightBuffIcon;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 战斗中精灵信息展示面板
	 * @author hunterxie
	 */
	public class FightFairyInfoPanel extends Sprite{
		public var tf_fairyName:TextField;
		public var mc_wuxing:MovieClip;
		
		public var tf_LV:TextField;
		public var tf_SLV:TextField;
		public var tf_AP:TextField;
		public var tf_DP:TextField;
		public var tf_HP:TextField;
		
		public var tf_skill0:TextField;
		public var tf_skill1:TextField;
		public var tf_skill2:TextField;
		public var tf_skill3:TextField;
		
		public var tf_buff0:TextField;
		public var tf_buff1:TextField;
		public var tf_buff2:TextField;
		public var tf_buff3:TextField;
		
		public var mc_buff_0:FightBuffIcon;
		public var mc_buff_1:FightBuffIcon;
		public var mc_buff_2:FightBuffIcon; 
		public var mc_buff_3:FightBuffIcon;
		
		public var mc_bg:Sprite;
		
		
		public function FightFairyInfoPanel(){
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		public function updateInfo(info:FairyVO):void{ 
			tf_fairyName.text = info.nickName;
			mc_wuxing.gotoAndStop(info.wuxing+1);
			
			tf_LV.text = "等级："+info.LV;
			tf_SLV.text = "强化等级："+info.intensLV;
			tf_AP.text = "攻击："+info.finalAP;
			tf_DP.text = "防御："+info.finalDP;
			tf_HP.text = "生命："+info.HP_cu+"/"+info.HP_max; 
			
			var lastText:TextField;
			for(var i:int=0; i<4; i++){
				var skillText:TextField = this["tf_skill"+i];
				if(i<info.skillArr.length){
					skillText.text = "技能"+(i+1)+"："+(info.skillArr[i] as FairySkillVO).name;
				}else{
					skillText.visible = false;
				}
				
				var buffText:TextField = this["tf_buff"+i];
				var buffIcon:FightBuffIcon = this["mc_buff_"+i];
				if(i<info.buffArr.length){
					var buff:FairyBuffVO = info.buffArr[i];
					buffIcon.updateInfo(buff);
					buffText.text = "        "+buff.describe;
					buffText.visible = buffIcon.visible = true;
					buffText.height = buffText.textHeight+5;
					if(lastText){
						buffIcon.y = buffText.y = lastText.y+lastText.height+10;
					}
					lastText = buffText;
				}else{
					buffText.visible = buffIcon.visible = false;
				}
			}
			if(lastText){
				mc_bg.height = lastText.y+lastText.height+5;
			}else{
				mc_bg.height = 210;
			}
		}
	}
}
