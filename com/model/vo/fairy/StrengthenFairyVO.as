package com.model.vo.fairy {
	import com.model.vo.item.ItemVO;

	/**
	 *
	 * @author hunterxie
	 */
	public class StrengthenFairyVO {

		public static const MAX_LV:int=10;

		public var fairyVO:BaseFairyVO;

		public var mergeVO:ItemVO;

		private var _strengthenToLV:int

		public function get strengthenToLV():int {
			return Math.min(fairyVO.starLV+1, MAX_LV);
		}


		public function StrengthenFairyVO(fairyVO:BaseFairyVO, mergeVO:ItemVO) {
			this.fairyVO=fairyVO;

			this.mergeVO=mergeVO;

		}

		public function getNeedFairyLV():int {
			return strengthenToLV*10;
		}

		public function getCostMeger():int {
			return strengthenToLV*10;
		}

		public function getMergeNum():int {
			if(mergeVO==null)
				return 0;
			return mergeVO.num;
		}

		public function getCanStrengthen():Boolean {
			if(mergeVO==null)
				return false;
			return ((fairyVO.starLV<MAX_LV)&&(mergeVO.num>=getCostMeger())&&fairyVO.LV>=getNeedFairyLV())
		}

		public function getIsMaxLV():Boolean {
			return (fairyVO.starLV>=MAX_LV)
		}
	}
}
