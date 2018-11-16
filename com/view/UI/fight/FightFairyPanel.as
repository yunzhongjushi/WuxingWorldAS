package com.view.UI.fight {
	import com.greensock.TweenLite;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyVO;
	import com.view.BasePanel;
	import com.view.UI.fairy.StarLevelPanel;
	
	import flas.events.MouseEvent;
	import flas.geom.Point;
	import flas.utils.utils;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	
	
	
	/**
	 * 战斗中的精灵面板
	 * @author hunterxie
	 */
	public class FightFairyPanel extends BasePanel {
		public var mc_star:StarLevelPanel;
		public var tf_hp:TextField;
		public var tf_LV:TextField;
		public var tf_AP:TextField;
		public var tf_DP:TextField;
		public var tf_nickName:TextField;
		
		private var headImg:Bitmap = new Bitmap;
		public var mc_head:MovieClip;
		public var mc_hp:MovieClip;
		public var mc_wuxing:MovieClip;
		public var mc_wuxing_bg:MovieClip;
		
		/**
		 * 能量条
		 */
		public var mc_bigSkillEnergy:MovieClip;
		/**
		 * 技能闪烁
		 */
		public var mc_skillShow:MovieClip;
		public var mc_scoreShow:MovieClip;
		
		public var mc_buff_0:FightBuffIcon;
		public var mc_buff_1:FightBuffIcon;
		public var mc_buff_2:FightBuffIcon;
		public var mc_buff_3:FightBuffIcon;
		
		/**
		 * 精灵边框，BOSS跳到第二帧，大技能闪烁边框
		 */
		public var mc_frame:MovieClip;
		
		/**
		 * 死亡状态
		 */
		public var mc_die:Sprite;
		
		/**
		 * AI技能释放倒计时
		 */
		public var mc_skillCount:SkillCountDownIcon;
		
//		public var mc_fightSkillPanel:BaseMultipleButtonPanel;
		/**
		 * 人物目标点（用户展示积分、伤害、特效等）
		 */
		public var mc_attackPoint:MovieClip;
//		public var mc_resourcePanel:FightResourcePanel;
		
		public function get skillPrepare():Boolean{ 
			return mc_skillShow.visible;
		}
		public function set skillPrepare(value:Boolean):void{
			mc_skillShow.visible=value;
			if(value){
				mc_skillShow.gotoAndPlay(2); 
			}else{
				mc_skillShow.gotoAndStop(1);
			}
		}
		
		public var fairyInfo:FairyVO;
		private var tarRoles:Array;
		
		public function FightFairyPanel() {
			mc_skillShow.visible = false;
			mc_scoreShow.visible = false;
			mc_skillCount.visible = false;
			mc_die.visible = false;
//			mc_fightSkillPanel.direct=false;
//			mc_fightSkillPanel.scaleX=mc_fightSkillPanel.scaleY=0.5;
			mc_head.addChild(headImg);
//			mc_head.addEventListener(MouseEvent.CLICK, onHeadClick);
			
//			function onHeadClick(event:*):void{
//				mc_head.gotoAndStop(int(mc_head.totalFrames*Math.random()));
//			}
			mc_buff_0.visible = mc_buff_1.visible = mc_buff_2.visible = mc_buff_3.visible = false;
			this.mouseChildren = false;
		}
		
		/**
		 * 精灵点击事件
		 * @param e
		 */
//		private function onHeadClick(e:*):void{
//			fairyInfo.useBigSkill();
//		}
		
		public function init(info:FairyVO, tarRoles:Array):void{
			this.visible=true;
			if(fairyInfo){
				this.fairyInfo.removeEventListener(FairyVO.TURN_CLEAR_RESOURCE_ADD, onUpdateScoreInfo);
				this.fairyInfo.removeEventListener(FairyVO.ON_TURN_OVER, onTurnOver);
				this.fairyInfo.removeEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, updateInfo);
				this.fairyInfo.removeEventListener(FairyVO.BE_BUFFED, onAddBuff);
				this.fairyInfo.removeEventListener(FairyVO.BIG_SKILL_ENERGY_CHANGE, onEnergyChanged);
			}
			this.fairyInfo = info;
			(mc_scoreShow.tf_score as TextField).textColor = WuxingVO.getColor(fairyInfo.wuxing);//= "<font color='"+WuxingVO.getColor(fairyInfo.wuxing)+"'>"+int(e.data)+"</font>";
			this.fairyInfo.addEventListener(FairyVO.TURN_CLEAR_RESOURCE_ADD, onUpdateScoreInfo);
			this.fairyInfo.addEventListener(FairyVO.ON_TURN_OVER, onTurnOver);
			this.fairyInfo.globalPoint = Point.changePoint(this.mc_attackPoint.localToGlobal(new Point));
			this.fairyInfo.addEventListener(BaseFairyVO.FAIRY_INFO_UPDATE, updateInfo);
//			this.fairyInfo.wuxingInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateWuxingInfo);
			this.tarRoles = tarRoles;
//			this.tarRolePanel.addEventListener(FairyVO.UPDATE_ROLE_INFO, onUpdateEnemyInfo);
//			if(mc_resourcePanel) mc_resourcePanel.initProperty(fairyInfo.wuxingInfo);
			this.fairyInfo.addEventListener(FairyVO.BE_BUFFED, onAddBuff);
			this.fairyInfo.addEventListener(FairyVO.BIG_SKILL_ENERGY_CHANGE, onEnergyChanged);
			updateInfo(); 
		}
		
		protected function onTurnOver(event:Event):void{
			mc_scoreShow.visible = false; 
		}
		
		private function onUpdateScoreInfo(e:ObjectEvent):void{
			mc_scoreShow.visible = true; 
			mc_scoreShow.tf_score.text = String(e.data);
			TweenLite.to(mc_scoreShow, 0.3, {scaleX:2, scaleY:2, onComplete:showScoreSmall});
		}
		private function showScoreSmall():void{
			TweenLite.to(mc_scoreShow, 0.2, {scaleX:1, scaleY:1});
		}
		private function onBaseAttack():void{
			mc_scoreShow.visible = false;
		}
		
		/**
		 * 内存中往往固定一份，通过数据更新改变
		 * @param event
		 */
		public function updateInfo(event:Event=null):void{//TODO:更新数据频繁改变界面会造成卡顿，需优化
			headImg.bitmapData = utils.getDefinitionByName(fairyInfo.nickName);
			mc_wuxing.gotoAndStop(fairyInfo.wuxing+1);
			mc_wuxing_bg.gotoAndStop(fairyInfo.wuxing+1);
			mc_hp.scaleX = fairyInfo.HP_cu/fairyInfo.HP_max; 
			mc_star.showStar(fairyInfo.starLV);
			tf_hp.text = String(fairyInfo.HP_cu)+"/"+fairyInfo.HP_max; 
			tf_LV.text = String(fairyInfo.LV);
			if(tf_nickName) tf_nickName.text = String(fairyInfo.nickName);
			onAddBuff();
			
			if(fairyInfo.isAI){
				skillPrepare = Boolean(fairyInfo.aiSkillUse()!=null);
				mc_skillCount.visible = true;
				if(fairyInfo.nowCountSkill) mc_skillCount.updateInfo(fairyInfo.nowCountSkill); 
				mc_bigSkillEnergy.visible = false;
			}else{
				mc_skillCount.visible = false;
				this.mc_bigSkillEnergy.scaleX = 0;
				mc_bigSkillEnergy.visible = true;
			}
			if(fairyInfo.isAlive){
				mc_die.visible = false;
			}else{
				mc_die.visible = true;
				mc_skillCount.visible = false;
			}
//			this.mc_resourcePanel.updateInfo();
//			if(fairyInfo.skillArr) this.mc_fightSkillPanel.initInfo(fairyInfo.skillArr);
		}
		
		protected function onAddBuff(event:Event=null):void{
			for(var i:int=0; i<4; i++){
				var mc:FightBuffIcon = this["mc_buff_"+i] as FightBuffIcon;
				if(i<fairyInfo.buffArr.length){
					mc.visible = true;
					mc.updateInfo(fairyInfo.buffArr[i]);
				}else{
					mc.visible = false;
				}
			}
		}
		
		protected function onEnergyChanged(event:Event=null):void{
			this.mc_bigSkillEnergy.scaleX = fairyInfo.bigSkillEnergy/fairyInfo.bigSkillEnergyMax;
			this.skillPrepare = fairyInfo.isBigSkillPrepared();
		}
		
		protected function onUpdateEnemyInfo(event:Event=null):void{
			
		}
	}
}