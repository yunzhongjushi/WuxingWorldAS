package com.model.vo.fairy {
	import com.model.vo.conn.ServerVO_68;
	import com.model.vo.item.ItemVO;
	
	import flas.events.EventDispatcher;

	/**
	 * 新增精灵提示VO
	 * @author hunterxie
	 */
	public class TipFairyVO extends EventDispatcher {
		public static const UPDATE:String="UPDATE";

		private static var instance:TipFairyVO;

		public static function getInstance():TipFairyVO {
			if(instance==null)
				instance=new TipFairyVO();
			return instance
		}

		public var itemArr:Array;
		public var fairyArr:Array;

		/**
		 * 碎片合成精灵的列表
		 * @see BaseFairyVO
		 */
		public var pieceFairyArr:Array
		/**
		 * 直接新增精灵的列表
		 * @see BaseFairyVO
		 */
		public var addFairyArr:Array;
		/**
		 * 本次新增精灵的列表
		 * @see BaseFairyVO
		 */
		public var totalFairyArr:Array

		
		/**
		 * 
		 * 
		 */
		public function TipFairyVO() {
		}

		/**
		 * 根据有改动的数据，判断是否有新精灵合成或者新增
		 * @param itemArr	Array of ItemVO
		 * @param fairyArr
		 */
		public function updateModifyInfo(itemArr:Array=null, fairyArr:Array=null):void {
			this.itemArr=itemArr;
			this.fairyArr=fairyArr;

			pieceFairyArr=[];
			addFairyArr=[];
			totalFairyArr=[];

			if(itemArr) {
				for(var i:int=0; i<itemArr.length; i++){
					var vo:ItemVO = itemArr[i] as ItemVO;
					var fairyID:int = FairyListVO.canSynthesisNewFairy(vo, true);
					if(fairyID>0){
						pieceFairyArr.push(FairyListVO.getOriginFairy(fairyID));
					}
				}
			}

			if(fairyArr)
				addFairyArr=fairyArr;

			totalFairyArr=pieceFairyArr.concat(addFairyArr);

			if(totalFairyArr.length>0){
				event(UPDATE, this);
				for(var i:int=0; i<pieceFairyArr.length; i++) {
					ServerVO_68.piece_gen_fairy(pieceFairyArr[i] as BaseFairyVO);
				}
			}
		}
	}
}
