package com.view.UI.playerEditor {
	import com.model.vo.editor.EditListVO;
	import com.model.vo.editor.EditVO;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 玩家自创谜题
	 * @author hunterxie
	 */
	public class PlayerEditorLevelBtn extends MovieClip{
		/**
		 * 是否是完成的谜题，首先要自己成功解谜
		 */
		public var mc_flag:MovieClip;
		
		
		/**
		 * 
		 */
		public var tf_ID:TextField;
		/** 谜题ID */
		public var editID:int;
		
		/** 按钮对应的数据 */
		private var info:EditVO;
		
		
		public function PlayerEditorLevelBtn() {
			this.mouseChildren = false;
		}
		
		public function updateInfo(id:int):void{
			if(this.info){
				this.info.removeEventListener(EditVO.UPDATE_EDIT_INFO, onUpdate);
			}
			this.editID = id;
			this.info = EditListVO.getEditByID(id);
			this.info.addEventListener(EditVO.UPDATE_EDIT_INFO, onUpdate);
			
			onUpdate();
		}
		
		private function onUpdate(e:Event=null):void{
			this.tf_ID.text =  String(this.info.ID);
			this.mc_flag.visible = this.info.isSetDefend;
			if(!this.info.isUnlocked){
				this.gotoAndStop(3);
			}else{
				this.gotoAndStop(this.info.isNowEdit ? 2 : 1);
			}
		}
	}
}
