package com.model.vo.item {
	/**
	 * 资源类ItemVO，用于展示资源，传递消耗
	 * 包括 五行资源，钻石，精力，人物经验
	 * @author CC5
	 */
	public class ItemResourceVO extends ItemVO {
		/**
		 * 资源类ItemVO, templateID与itemID为0
		 * @param num
		 *
		 */
		public function ItemResourceVO(templateID:int, num:int=-1, id:int=-1) {
			super(0, num, 0);
		}

		public var resourceStr:String;

		/**
		 * 获取 五行元素 VO
		 * @param num
		 * @param wuxing
		 * @return
		 */
//		public static function getWuxing(num:int, wuxing:String):ItemResourceVO {
//			var vo:ItemResourceVO = new ItemResourceVO(num);
//			vo.type = ItemVO.TYPE_WUXING;
//			vo.wuxing = vo.name = vo.pic = wuxing;
//			return vo;
//		}

		/**
		 * 获取 钻石 VO
		 * @param num
		 * @return
		 */
//		public static function getGold(num:int):ItemResourceVO {
//			var vo:ItemResourceVO=new ItemResourceVO(num);
//			vo.type=ItemVO.TYPE_GOLD;
//			vo.name = vo.pic = "钻石";
//			return vo;
//		}

		/**
		 * 获取 精力 VO
		 * @param num
		 * @return
		 */
//		public static function getEnergy(num:int):ItemResourceVO {
//			var vo:ItemResourceVO=new ItemResourceVO(num);
//			vo.type=ItemVO.TYPE_ENERGY;
//			vo.name = vo.pic = "精力";
//			return vo;
//		}

		/**
		 * 获取 人物经验 VO
		 * @param num
		 * @return
		 */
//		public static function getHumanExp(num:int):ItemResourceVO {
//			var vo:ItemResourceVO=new ItemResourceVO(num);
//			vo.type=ItemVO.TYPE_HUMAN_EXP;
//			vo.name = vo.pic = "经验";
//			return vo;
//		}

		/**
		 * 获取 现金 VO
		 * @param num
		 * @return
		 */
//		public static function getMoney(num:int):ItemResourceVO {
//			var vo:ItemResourceVO=new ItemResourceVO(num);
//			vo.type=ItemVO.TYPE_MONEY;
//			vo.name = vo.pic = "RMB";
//			return vo;
//		}
	}
}
