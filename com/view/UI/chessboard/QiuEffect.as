package com.view.UI.chessboard {
	import com.model.event.ObjectEvent;
	import com.model.vo.skill.BoardBuffVO;
	
	import flas.display.Bitmap;
	import flas.display.Sprite;
	
	import ui.chessboard.EffectLVUI;

	public class QiuEffect extends Sprite{
		public static var effectPool:Array=[];
		
		
		/**
		 * buff层数展示
		 */
		public var mc_layer:EffectLVUI;
		
		/**
		 * 解谜关目标棋子关键词
		 */
		public static const LEVEL_TARGET_POINT:String = "point";
		
		public var buffVO:BoardBuffVO;
		
		public function get ID():int{
			return buffVO.ID;
		}
		
		public var displayShow:Bitmap = new Bitmap;
		public function QiuEffect(){
			addChildAt(displayShow, 0);
			
			mc_layer = new EffectLVUI();
			mc_layer.visible = false;
			mc_layer.mouseEnabled = mc_layer.mouseChildren = false;
//			mc_layer.x = -mc_layer.width/2;
//			mc_layer.y = -mc_layer.height/2;
			addChild(mc_layer);
		}
		
		public function remove(e:ObjectEvent=null):void{
			this.mc_layer.visible = false;
			buffVO.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);
//			buffVO.off(BoardBuffVO.CLEAR_BUFF, this, remove);
			buffVO = null;
			if(this.parent){
				this.parent.removeChild(this);
				effectPool.push(this);
			}
		}
		
		/**
		 * 从对象池中获取
		 * @param skillID
		 * @param kind
		 * @param String
		 * @return 
		 */
		public static function getQiuEffect(vo:BoardBuffVO):QiuEffect{
			var effect:QiuEffect;
			if(effectPool.length>0){
				effect = effectPool.pop() as QiuEffect;
			}else{
				effect = new QiuEffect;
			}
			return effect.updateInfo(vo);
		}
		
		public function get isSkillModeActive():Boolean{
			return buffVO.isSkillModeActive;
		}
		 
		public function updateInfo(vo:BoardBuffVO):QiuEffect{
			if(this.buffVO){
				buffVO.off(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState);
//				buffVO.off(BoardBuffVO.CLEAR_BUFF, this, remove);
			}
			this.buffVO = vo;
			buffVO.on(BoardBuffVO.CHANGE_BUFF_STATE, this, changeBuffState, false, 0, true);
//			buffVO.on(BoardBuffVO.CLEAR_BUFF, remove, false, 0, true);
			changeBuffState(); 
			return this;
		}
		
		private function changeBuffState(e:ObjectEvent=null):void{
			displayShow.setBitmapDataClass(buffVO.icon, "imgs/chessboard/icon/", ".png");
			displayShow.x = -displayShow.width/2;
			displayShow.y = -displayShow.height/2;
			mc_layer.tf_LV.text = String(buffVO.effectTime);
			mc_layer.visible = buffVO.effectTime>1;
		}
	}
}