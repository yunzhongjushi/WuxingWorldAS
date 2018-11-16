package com.view.UI.user {
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.event.ObjectEvent;
	import com.model.vo.WuxingVO;
	import com.model.vo.chessBoard.QiuPoint;
	import com.model.vo.conn.ServerVO_90;
	import com.model.vo.conn.ServerVO_92;
	import com.model.vo.conn.ServerVO_94;
	import com.model.vo.tip.TipVO;
	import com.model.vo.user.UserVO;
	import com.utils.TimerFactory;
	import com.view.BasePanel;
	import com.view.UI.tip.TipChoosePanel;
	import com.view.UI.tip.TipPanel;
	import com.view.touch.CommonBtn;
	
	import flas.events.MouseEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	
	
	/**
	 * 用户单个五行属性面板
	 * @author hunterxie
	 */
	public class WuxingPropertyPanel extends BasePanel{
		public static const NAME:String = "WuxingPropertyPanel";
		public static const SINGLETON_MSG:String = "single_WuxingPropertyPanel_only";
		protected static var instance:WuxingPropertyPanel;
		public static function getInstance():WuxingPropertyPanel{
			if ( instance == null ) instance = new WuxingPropertyPanel();
			return instance;
		}
		
		/**
		 * 
		 */
		public var wuxing:int;
//		public var wuxingNum:int;
		
		public var tf_LV:TextField;
		public var tf_upTrigger:TextField;
		public var tf_increaseSpeed:TextField;
		public var tf_upCost:TextField;
		
		public var mc_wuxingProperty:UserWuxingMC;
		/**
		 * 五行元素底板
		 */
		public var mc_wuxingBG:MovieClip;
		/**
		 * 五行元素文字
		 */
		public var mc_wuxingWord:MovieClip;
		/**
		 * 五行相克说明
		 */
		public var tf_keInfo:TextField;
		
		/**
		 * 加点按钮
		 */
		public var btn_add:CommonBtn;
		
		/**
		 * 元素洗点
		 */
		public var btn_resetByGold:CommonBtn;
		
		/**
		 * 钻石洗点
		 */
		public var btn_resetByResource:CommonBtn;
		
		private function get userInfo():UserVO{
			return UserVO.getInstance();
		}
		
		private var upLvArr:Array = [0,0,0,0,0];
		
		
		/**
		 * 
		 * 
		 */
		public function WuxingPropertyPanel() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			btn_add.setNameTxt("升级五行");
			btn_add.on(MouseEvent.CLICK, this, onUpdateWuxingLevel);
			
			btn_resetByResource.setNameTxt("元素洗点");
			btn_resetByResource.addEventListener(MouseEvent.CLICK, onReset);
			btn_resetByGold.setNameTxt("钻石洗点");
			btn_resetByGold.addEventListener(MouseEvent.CLICK, onReset);
			userInfo.wuxingInfo.addEventListener(WuxingVO.WUXING_RESOURCE_UPDATE, updateInfo);
			
			tf_LV.mouseEnabled=false; 
			tf_upTrigger.mouseEnabled=false;
			tf_increaseSpeed.mouseEnabled=false;
			tf_upCost.mouseEnabled=false;
			
//			this.btn_close.visible = false;
			this.mc_wuxingProperty.tf_LV.visible = false;
			
			EventCenter.on(BasePanel.CLOSE_PANEL, this, onClosePanel);
			EventCenter.on(UserWuxingPanel.UP_WUXING_PROPERTY_LEVEL, this, updateInfo);
			EventCenter.on(TipVO.TIP_PANEL_CONFIRM, this, tipPanelConfirm);
		}
		
		private function tipPanelConfirm(e:ObjectEvent):void{
			if(e.data is ResetWuxingPointVO){
				onReserWuxingProperty(e.data as ResetWuxingPointVO);
			}else if(e.data is UpLvWuxingVO){
				onUpLvTimer();
				
				var vo:UpLvWuxingVO = (e.data as UpLvWuxingVO);
				if(vo.isConfirmSuccess){
					userInfo.allPoint -= 1;
					userInfo.wuxingInfo.setProperty(vo.wuxing, userInfo.wuxingInfo.getWuxingProperty(vo.wuxing)+1);
					
					var arr:Array = [0,0,0,0,0];
					arr[vo.wuxing] = 1;
					ServerVO_92.sendInfo(arr, true);
				}
			}
		}
		private function onReserWuxingProperty(vo:ResetWuxingPointVO):void{
			//			if(userInfo.gold<vo.goldNum){
			//				TipVO.showChoosePanel(new TipVO(("五行模块洗点", "您的钻石不足，请去商城购买！", TipNotEnoughResourceVO.NOT_ENOUGH_GOLD));
			//				return;
			//			}
			if(vo.kindChoose==ResetWuxingPointVO.KIND_GOLD){//钻石洗点
				ServerVO_94.sendInfo(vo);
			}else if(vo.kindChoose==ResetWuxingPointVO.KIND_RESOURCE){//元素洗点
				ServerVO_90.sendInfo(vo);
			}
		}
		
		private function onUpLvTimer(event:*=null):void{
			if(upLvArr.some(function(item:int, index:int, arr:Array):Boolean{return item>0})){
				ServerVO_92.sendInfo(upLvArr);
			}
			upLvArr = [0,0,0,0,0];
		}
		
		/**
		 * 升级单个五行模块
		 * @param event
		 */		
		protected function onUpdateWuxingLevel(event:*=null):void{
			if(userInfo.allPoint==0){
				TipVO.showTipPanel(new TipVO("五行模块加点", "剩余五行点不够，请等角色升级后再加点！"))
				return;
			}
			var resource:int = userInfo.wuxingInfo.getResource(this.wuxing);
			var property:int = userInfo.wuxingInfo.getWuxingProperty(this.wuxing);
			var useNum:int = property*100;
			if(resource<useNum){
				TipVO.showChoosePanel(new UpLvWuxingVO(this.wuxing, useNum-resource));
				onUpLvTimer();
				return;
			}
			userInfo.allPoint-=1;
			UserVO.testAddResource(this.wuxing, -useNum);
			userInfo.wuxingInfo.setProperty(this.wuxing, property+1);
			upLvArr[this.wuxing] += 1;
			if(BaseInfo.iscontiuedSend){
				TimerFactory.once(1000, this, onUpLvTimer);
			}else{
				ServerVO_92.sendInfo(upLvArr);
				upLvArr = [0,0,0,0,0];
			}
		}
		
		
		private function onClosePanel(e:ObjectEvent):void{
			if(e.data==WuxingInfoPanel.NAME){
				close();
			}
		}
		
		protected function onReset(event:*):void{
			var vo:ResetWuxingPointVO = new ResetWuxingPointVO(wuxing, 
				event.target==btn_resetByResource?ResetWuxingPointVO.KIND_RESOURCE:ResetWuxingPointVO.KIND_GOLD);
			if(vo.goldNum<=0 && vo.wuxingNum<=0){
				TipVO.showTipPanel(new TipVO("五行模块洗点", "您的五行无需洗点！"));
				return;
			}
//			switch(event.target){
//				case btn_resetByResource:
//					vo = new ResetWuxingPointVO(WuxingVO.getWuxing(wuxing), ResetWuxingPointVO.KIND_RESOURCE);
//					vo.info = "消耗"+vo.wuxingNum+"点"+wuxingStr+"元素重置"+wuxingStr+"模块.";
//					if(vo.goldNum>0){
//						vo.info+="\n您需要购买所缺的"+(vo.wuxingNum-userInfo.wuxingInfo.getResource(wuxing))+"点"+WuxingVO.getHtmlWuxing(wuxing)+"元素!";
//					}
//					break;
//				case btn_resetByGold:
//					vo = new ResetWuxingPointVO(WuxingVO.getWuxing(wuxing), ResetWuxingPointVO.KIND_RESOURCE);
//					vo.info = "您要消耗"+vo.goldNum+"钻石重置"+wuxingStr+"模块吗!";
//					break;
//			}
			TipVO.showChoosePanel(vo);
		}
		
		/**
		 * 
		 * @param wuxing
		 */
		public function updateInfo(e:ObjectEvent):void{//wuxingKind:int=QiuPoint.KIND_100):void{
			this.wuxing = e.data as int;
			if(this.wuxing==QiuPoint.KIND_100){
				return;
			}
//			this.wuxingNum = WuxingVO.getWuxing(wuxing);
			this.mc_wuxingBG.gotoAndStop(wuxing);
			this.mc_wuxingWord.gotoAndStop(wuxing);
			this.tf_keInfo.htmlText = WuxingVO.getHtmlWuxing(wuxing)+"克"+WuxingVO.getHtmlWuxing(WuxingVO.getWuxing(wuxing, WuxingVO.WO_KE));
			
//			var bmp:Bitmap = mc_wuxingProperty.getChildAt(1) as Bitmap;
//			bmp.bitmapData = utils.getDefinitionByName("Property_"+wuxing);//因为需要遮罩，而旋转后遮罩的图片有问题，所以用了额外的图
			mc_wuxingProperty.mc_property.gotoAndStop(wuxing);
			mc_wuxingProperty.maxResource = userInfo.wuxingInfo.getMaxResource(wuxing);
			mc_wuxingProperty.resource = userInfo.wuxingInfo.getResource(wuxing)
			mc_wuxingProperty.LV = userInfo.wuxingInfo.getWuxingProperty(wuxing);
			mc_wuxingProperty.updateInfo();
			
			tf_LV.text = String(mc_wuxingProperty.LV);//+"级";
			tf_upTrigger.htmlText = mc_wuxingProperty.LV*100+"点"+WuxingVO.getHtmlWuxing(this.wuxing)+"元素";
			tf_upCost.htmlText = mc_wuxingProperty.LV*100+WuxingVO.getHtmlWuxing(this.wuxing);
			tf_increaseSpeed.text = "每小时"+5000+"点";//userInfo.wuxingInfo.inc(wuxingNum);
		}
	}
}
