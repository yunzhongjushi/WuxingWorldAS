package com.model.vo.config.item {
	import com.model.vo.BaseObjectVO;
	import com.model.vo.WuxingVO;


	/**
	 * 物品配置信息
	 * @author hunterxie
	 * <record templateID="1" canUse="1" canDelete="0" canSell="1"/>
	 */
	public class ItemConfigVO extends BaseObjectVO {

		/**
		 * 物品id
		 */
		public function get id():int {
			return _id;
		}
		public function set id(value:int):void {
			_id=value;
			ItemConfig.setItem(this);
		}
		private var _id:int=0;

		/**
		 * 物品名
		 */
		public function get label():String {
			return _label;
		}
		public function set label(value:String):void {
			if(value=="空技能") {
				trace("空技能???");
			}
			_label=value;
		}
		private var _label:String="物品名";

		/**物品图标名*/
		public var icon:String="";
		/**物品说明*/
		public var describe:String="物品说明";
		/**物品的五行（卖出可以获得对应五行的资源*/
		public var wuxing:int = 0;
		/**物品等级*/
		public var level:int=1;
		/**物品使用(装备)需要等级*/
		public var needLevel:int=1;
		/**物品最多叠加数（1就是不能叠加*/
		public var maxCount:int=1;
		/**物品包含的技能(ID)，使用后生效*/
		public var effect:int=0;
		/**物品类型*/
		public var kind:int;
		/**物品能否使用*/
		public var canUse:int;
		/**物品能否丢弃(删除)*/
		public var canDelete:int;
		/**物品能否出售*/
		public var canSell:int;

		/**
		 * 包含的装备信息(物品为装备时)
		 */
		public var equipInfo:EquipConfigVO=new EquipConfigVO;




		/**
		 *
		 * @param info
		 */
		public function ItemConfigVO(info:Object=null):void {
			super(info);
		}
		
		/**
		 * 价格
		 */
		public function get price():int {
			return 100+level*100;
		}
		/**
		 * 类型：属性、物品、精灵技能
		 */
		public function get type():int{
			return getTypeByID(id);
		}
		
		/**
		 * 子(物品)类型
		 */
		public function get subType():int{
			if(type==TYPE_ITEM){
				return getItemTypeByID(id);
			}
			return 0;
		}

	/**
	 *
	 */
//		public function updateByXML(item:XML):void{
//			this.id = int(item.@templateID);
//			this.label = String(item.@name);
//			this.icon = String(item.@pic);
//			this.describe = String(item.@description);
//			this.wuxing = WuxingVO.getWuxing(int(item.@wuXing),"",false);
//			this.level = int(item.@level);
//			this.maxCount = int(item.@maxCount);
//			this.needLevel = int(item.@needLevel);
//			this.effect = int(item.@skillID);
//			this.canUse = int(item.@canUse);
//			this.canDelete = int(item.@canDelete);
//			this.canSell = int(item.@canSell);
//			
//			if(int(this.id/15000)==1){
//				this.equipInfo = new EquipConfigVO;
//				this.equipInfo.updateByXML(item);
//			}
//		}
		
		
		
		/**
		 * 判断物品是否是碎片
		 * @param type
		 */
		public static function judgeIsPiece(type:int):Boolean{
			return (type==TYPE_ITEM_FAIRY_PIECE || type==TYPE_ITEM_SKILL_PIECE);
		}
		
		/**
		 * 判断物品是否是精灵装备
		 * @param type
		 */
		public static function judgeIsEquip(id:int):Boolean{
			return (id>=TYPE_ITEM_FAIRY_EQUIP && id<20000);
		}
		
		/**
		 * 判断物品是否是精灵碎片
		 * @param type
		 */
		public static function judgeIsFairyPiece(type:int):Boolean{
			return type==TYPE_ITEM_FAIRY_PIECE;
		}
		/**
		 * 根据精灵碎片ID，返回精灵模板ID
		 * 当为非碎片时，返回 -1
		 */
		public static function getFairyByPiece(id:int):int {
			if(judgeIsFairyPiece(id)) {
				return id+17000;//精灵碎片为精灵ID-17000
			}
			return -1;
		}
		
		/**
		 * 根据ID获取物品类型
		 * @param ID
		 */
		public static function getTypeByID(ID:int):int{
			if(ID>TYPE_FAIRY){
				return TYPE_FAIRY;
			}else if(ID>TYPE_SKILL){
				return TYPE_SKILL;
			}else if(ID>TYPE_ITEM){
				return TYPE_ITEM;
			} else if(ID>TYPE_SHOP_GOLD) {
				return TYPE_SHOP_GOLD;
			} else if(ID>=10 && ID<=14) {//id:10-14
				return TYPE_WUXING;
			} else if(ID>=5 && ID<=9) {//id:5-9
				return TYPE_WUXING_ACTIVE;
			}
			if(ID>TYPE_SHOP_GOLD){
				return TYPE_SHOP_GOLD;
			}
			return TYPE_ATTRIBUTE;
		}
		
		/**
		 * 获取背包Item类型
		 * @param ID
		 * @return 
		 */
		public static function getItemTypeByID(ID:int):int{
			if(ID>TYPE_ITEM_FAIRY_EQUIP){
				return TYPE_ITEM_FAIRY_EQUIP;
			}else if(ID>TYPE_ITEM_USER_EQUIP){
				return TYPE_ITEM_USER_EQUIP;
			}else if(ID>TYPE_ITEM_FAIRY_PIECE){
				return TYPE_ITEM_FAIRY_PIECE;
			}else if(ID>TYPE_ITEM_SKILL_PIECE){
				return TYPE_ITEM_SKILL_PIECE;
			}else if(ID>TYPE_ITEM_COMSUME){
				return TYPE_ITEM_COMSUME;
			}
			return TYPE_ITEM_COMSUME;
		}
		
		/**
		 * 基础属性，可以给角色/精灵等增加数据（对应商城中的消耗品）
		 */
		public static const TYPE_ATTRIBUTE:int = 0;
		/**
		 * 商城出售的钻石（对应商城中的RMB）
		 */
		public static const TYPE_SHOP_GOLD:int = 1000;
		
		/**物品类型(10000-20000)，可以放入背包（对应商城中的道具）*/
		public static const TYPE_ITEM:int = 10000;
			/**消耗品类型(11000-12000)*/
			public static const TYPE_ITEM_COMSUME:int=11000;
			/**技能碎片类型(12000-13000)*/
			public static const TYPE_ITEM_SKILL_PIECE:int=12000;
			/**精灵碎片类型(13000-14000)*/
			public static const TYPE_ITEM_FAIRY_PIECE:int=13000;
			/**角色装备类型(14000-15000)*/
			public static const TYPE_ITEM_USER_EQUIP:int=14000;
			/**精灵装备类型(15000-20000)*/
			public static const TYPE_ITEM_FAIRY_EQUIP:int=15000;
			
		/**精灵类型(30000-40000)*/
		public static const TYPE_FAIRY:int = 30000;
		/**技能类型(20000-30000)*/
		public static const TYPE_SKILL:int = 20000;
		
		/**类型：人物经验， 用于任务奖励*/
		public static const TYPE_HUMAN_EXP:int=1;
		/**类型：RMB*/
		public static const TYPE_MONEY:int=2;
		/**类型：精力*/
		public static const TYPE_ENERGY:int=3;
		/**类型：钻石*/
		public static const TYPE_GOLD:int=4;
		/**类型：五行模块激活*/
		public static const TYPE_WUXING_ACTIVE:int=5;
		/**类型：五行*/
		public static const TYPE_WUXING:int=10;
		
		/**特殊物品ID：小经验消耗品*/
		public static const EXP_SMALL:int=11030;
		/**特殊物品ID：中经验消耗品*/
		public static const EXP_MIDDLE:int=11040;
		/**特殊物品ID：大经验消耗品*/
		public static const EXP_BIG:int=11050;
		
		/**特殊物品ID：小精力消耗品*/
		public static const LIVE_SMALL:int=11000;
		/**特殊物品ID：中精力消耗品*/
		public static const LIVE_MIDDLE:int=11010;
		/**特殊物品ID：大精力消耗品*/
		public static const LIVE_BIG:int=11020;
		
		/**加五行消耗品ID下限*/
		public static const WUXING_MIN:int=11060;
		/**加五行消耗品ID上限*/
		public static const WUXING_MAX:int=11084;
	}
}
