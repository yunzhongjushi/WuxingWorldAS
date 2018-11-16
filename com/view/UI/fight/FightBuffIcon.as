package com.view.UI.fight {
	import com.model.vo.skill.BoardBuffVO;
	import com.model.vo.skill.fight.FairyBuffVO;
	import com.view.BaseImgBar;
	
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 战斗中精灵面板上的buff图标
	 * @author hunterxie
	 */ 
	public class FightBuffIcon extends BaseImgBar{
		public var buff:FairyBuffVO;
		
		public var tf_ID:TextField;
		
		public function FightBuffIcon() {
//			addChild(headImg);
//			mc_mask.visible = false;
		}
		
		public function updateInfo(vo:FairyBuffVO):void{ 
			if(buff){ 
				buff.removeEventListener(BoardBuffVO.CHANGE_BUFF_STATE, onBuffUpdate); 
			}
			buff=vo;
			buff.addEventListener(BoardBuffVO.CHANGE_BUFF_STATE, onBuffUpdate);
			
//			headImg.bitmapData = utils.getDefinitionByName((vo.icon);
			onBuffUpdate();  
			this.updateClass(vo.icon);
		} 
		 
		private function onBuffUpdate(e:Event=null):void{
			if(buff.collect>0){ 
				tf_ID.text = String(buff.collect);
			}else if(buff.continuedTime>0){
				tf_ID.text = String(buff.continuedTime);
			}else{
				tf_ID.text = "";//String(buff.ID);
			}
		}
	}
}
