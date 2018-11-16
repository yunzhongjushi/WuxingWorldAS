package editor{
	import com.model.vo.skill.BoardBuffVO;
	import com.view.UI.chessboard.QiuEffect;
	
	import flas.display.Sprite;
	

	public class QiuEffectSet extends Sprite {
		public var tarX:int;
		public var tarY:int;
		
		public var kind:String = "";
		
		public var buff:QiuEffect;
		public function get ID():int{
			return buff.ID;
		}
		
		public var vo:BoardBuffVO;
		
		public function QiuEffectSet(vo:BoardBuffVO, tx:Number, ty:Number):void{
			this.vo = vo;
			
			buff = QiuEffect.getQiuEffect(vo);
			buff.x = -buff.width/2;
			buff.y = -buff.height/2;
			addChild(buff);
			
			this.tarX = this.x = tx;
			this.tarY = this.y = ty;
			this.mouseChildren=false;
		}
	}
}
