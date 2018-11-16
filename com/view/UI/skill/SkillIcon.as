package com.view.UI.skill {
	import com.model.vo.skill.UserSkillVO;
	import com.view.BaseImgBar;
	import com.view.UI.fairy.StarLevelPanel;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flas.utils.utils;
	
	
	/**
	 * 技能图标（技能列表中的）
	 * @author hunterxie
	 */
	public class SkillIcon extends BaseImgBar{
		public var displayShow:Bitmap = new Bitmap;
		
		public var container:Sprite;
		
		public var mc_focus:Sprite;
		public function set choosed(value:Boolean):void{
			mc_focus.visible = value;
		}
		public function get choosed():Boolean{
			return mc_focus.visible;
		}
		
		public var tf_name:TextField;
		
		public var mc_stars:StarLevelPanel;
		
		public var vo:UserSkillVO;
		
		/**
		 * 技能五行底框
		 */
		public var mc_frame:MovieClip;
		
		
		
		/**
		 * 
		 * @param skill
		 */
		public function SkillIcon(skill:UserSkillVO=null) {
			container.addChild(displayShow);
			mc_focus.visible = false;
			if(!skill){
				clearInfo();
				return;
			}
			updateInfo(skill); 
		}
		
		public function updateInfo(vo:UserSkillVO):SkillIcon{
			this.vo = vo;
			displayShow.bitmapData =  utils.getDefinitionByName(vo.icon);
			displayShow.x = -displayShow.width/2;
			displayShow.y = -displayShow.height/2;
			
			tf_name.text = vo.name;
			mc_stars.showStar(vo.LV);
			mc_stars.x = (this.width-mc_stars.width)/2;
			mc_frame.gotoAndStop(vo.wuxing);
			
			return this;
		}
		
		public function clearInfo():void{
			this.displayShow.bitmapData = null;
			this.tf_name.text = "";
			this.mc_stars.showStar(0);
		}
		
		public function remove():void{
			if(this.parent) this.parent.removeChild(this);
			skillPool.push(this);
		}
		
		public static var skillPool:Array=[];
		public static function getIcon(skill:UserSkillVO):SkillIcon{
			return skillPool.length>0 ? (skillPool.pop() as SkillIcon).updateInfo(skill) : new SkillIcon(skill);
		}
	}
}
