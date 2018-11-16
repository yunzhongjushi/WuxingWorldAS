package com.view.UI.skill{
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.conn.ServerVO_107;
	import com.model.vo.skill.SkillListVO;
	import com.model.vo.skill.UserSkillVO;
	import com.model.vo.user.UserVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	import com.view.touch.SlidePanel;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	
	/**
	 * 技能面板
	 * @author hunterxie
	 */
	public class SkillPanel extends BasePanel{
		public static const NAME:String = "SkillPanel";
		public static const SINGLETON_MSG:String="single_SkillPanel_only";
		protected static var instance:SkillPanel;
		public static function getInstance():SkillPanel{
			if ( instance == null ) instance = new SkillPanel();
			return instance;
		}
		
		public var mc_skillContainer:Sprite;
		public var mc_skillMask:Sprite;
		/**
		 * 
		 */
		public var mc_skillInfoPanel:SkillInfoPanel;
		public var btn_add:MovieClip;
		public var btn_equip:CommonBtn;
		
		private function get skillListVO():SkillListVO{
			return SkillListVO.getInstance();
		}
		private function get skillList():Array{
			return SkillListVO.skillList;
		}
		public var nowSkill:UserSkillVO;
		
		
		public var skillIconList:Array = [];
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		
		/**
		 * 技能面板
		 */
		public function SkillPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			mc_skillContainer.mask = mc_skillMask;
			mc_skillContainer.addEventListener(MouseEvent.CLICK, onSkillClick);
//			this.addEventListener(MouseEvent.MOUSE_UP, onSkillClick);
//			this.addEventListener(MouseEvent.MOUSE_MOVE, onSkillClick);
			
//			listMaxY = -(Math.ceil(totalSkillNum/lineNum)*130-mc_skillMask.height);
			
			skillListVO.addEventListener(SkillListVO.UPDATE_SKILLS_INFO, updateInfo);
			
			SlidePanel.fromDisplayObject(this.mc_skillMask, this.mc_skillContainer);
			
			EventCenter.on(ApplicationFacade.SHOW_PANEL, this, onShowPanel);
		}
		
		private function onShowPanel(e:ObjectEvent):void{
			if(e.data==SkillPanel.NAME){
				updateInfo();
				ServerVO_107.sendInfo();
			}
		}
		
//		/**
//		 * 技能总数量
//		 */
//		private var totalSkillNum:int=0;
//		/**    
//		 * 屏幕内最大显示数量
//		 */
//		private var maxShowListNum:int=16;
//		/**
//		 * 当前显示的第一个技能位置
//		 */
//		private var nowShowListNum:int=0;
//		/**
//		 * 每行显示的图标数量
//		 */
		private var lineNum:int = 2;
//		private var listMaxY:int = 0;
//		private var mousePoint:Point;
//		private var isDrag:Boolean;
//		public var dragJudgeNum:int = 10;
		private function onSkillClick(e:*):void{
			if(e.target is SkillIcon){
				var icon:SkillIcon = e.target as SkillIcon;
				mc_skillInfoPanel.updateInfo(icon.vo);
			}
//			switch (e.type) {
//				case MouseEvent.MOUSE_DOWN:
//					mousePoint = new Point(mc_skillContainer.mouseX, mc_skillContainer.mouseY);
//					break;
//				case MouseEvent.MOUSE_UP:
//					if(!isDrag){
//						if(e.target is SkillIcon){
//							updateNowSkill(icon.vo);
//						}
//					}
//					mousePoint = null;
//					isDrag = false;
//					break;
//				case MouseEvent.MOUSE_MOVE:
//					if(mousePoint){
//						var ty:int=Math.floor(mc_skillContainer.mouseY-mousePoint.y);
//						if(!isDrag){
//							if(Math.abs(ty)>dragJudgeNum){
//								isDrag = true;
//							}
//						}else{
//							updateShow(ty);
//						}
//					}
//					break;
//			}
		}
		
//		private function updateShow(ty:int):void{
//			mc_skillContainer.y+=ty;
//			
//			if(mc_skillContainer.y<listMaxY){//底是初始位置
//				mc_skillContainer.y = listMaxY;
//			}else if(mc_skillContainer.y>mc_skillMask.y){
//				mc_skillContainer.y = mc_skillMask.y;
//			}
//			
//			var showNum:int = Math.floor((mc_skillMask.y-mc_skillContainer.y)/130)*lineNum;
//			if(showNum!=nowShowListNum){
//				updateInfo(showNum);
//			}
//		}
		
		/**
		 * 更新显示列表，根据显示位置确定
		 * @param showNum	显示初始位置
		 */
		public function updateInfo(e:Event=null):void{
//			while(skillList.length){
//				var icon:SkillIcon = (nowShowListNum<showNum?skillList.pop():skillList.shift()) as SkillIcon;
//				icon.remove();
//			}
//			for(var i:int=showNum; i<maxShowListNum+showNum; i++){
//				if(i<skillList.length){
//					var skill:UserSkillVO = skillList[i] as UserSkillVO;
//					icon = SkillIcon.getIcon(skill);
//					icon.x = (i)%lineNum*100;
//					icon.y = Math.floor((i)/lineNum)*130;
//					mc_skillContainer.addChild(icon);
//					skillList.push(icon);
//				}
//			}
//			nowShowListNum = showNum; 
			
			for(var i:int=0; i<skillList.length; i++){
				var skill:UserSkillVO = skillList[i] as UserSkillVO;
				if(skill.ID==0){//精灵默认攻击技，不展示也不应该有
					continue;
				}
				var icon:SkillIcon = skillIconList[i];
				if(!icon){
					icon = SkillIcon.getIcon(skill);
					skillIconList.push(icon);
					mc_skillContainer.addChild(icon);
				}
				icon.updateInfo(skill);
				icon.x = (i%lineNum)*112;
				icon.y = Math.floor(i/lineNum)*108;
			}
		}
		
//		public function updateNowSkill(vo:UserSkillVO):void{
//			this.nowSkill = vo;
//		}
	}
}