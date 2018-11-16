package com.view.UI.altar {
	import com.model.vo.altar.AltarVO;
	import com.model.vo.config.item.ItemConfigVO;
	import com.model.vo.item.ItemVO;
	import com.view.BaseImgBar;
	import com.view.BasePanel;
	import com.view.UI.item.ItemBarMiddle;
	
	import flas.display.BitmapData;
	import flas.geom.Point;
	import flas.utils.utils;
	
	import flash.display.Bitmap;


	public class AltarRewardPanel extends BasePanel {
		public function AltarRewardPanel() {
			super();
		}

		private var showingBarArr:Array=[];

		private var itemBarSite_1:Point=new Point(440, 280);

		private var itemBarSite_10:Point=new Point(100, 180);

		private var itemBarIntervalX:int=175;

		private var itemBarIntervalY:int=160;

		private var running_vo:AltarVO

		public function updateInfo(itemVOList:Array, altarVO:AltarVO):void {
			while(showingBarArr.length) {//清除之前的物品框
				removeItemBar(showingBarArr.pop());
			}
			running_vo=altarVO;
			hideAllEffect();// 去掉所有的特效光
			if(itemVOList.length==1) {// 设置物品框 
				var bar:ItemBarMiddle=getItemBar();
				showingBarArr.push(bar);

				bar.x=itemBarSite_1.x;
				bar.y=itemBarSite_1.y;

				var itemVO:ItemVO=itemVOList[0] as ItemVO
				bar.updateInfo(itemVO);
				if(itemVO.data.type==ItemConfigVO.TYPE_FAIRY) {
					showEffect(bar);
				}
			}
			if(itemVOList.length==10) {
				for(var i:int=0; i<itemVOList.length; i++) {
					bar=getItemBar();
					showingBarArr.push(bar);

					bar.x=itemBarSite_10.x+(i>4?(i-5)*itemBarIntervalX:i*itemBarIntervalX);
					bar.y=itemBarSite_10.y+(i>4?itemBarIntervalY:0);

					itemVO=itemVOList[i] as ItemVO

					bar.updateInfo(itemVO);

					if(itemVO.data.type==ItemConfigVO.TYPE_FAIRY) {
						showEffect(bar);
					}
				}
			}
		}

		private var itemPool:Vector.<ItemBarMiddle>=new Vector.<ItemBarMiddle>;

		private function getItemBar():ItemBarMiddle {
			var itemBar:ItemBarMiddle;

			if(itemPool.length==0) {
				itemBar=new ItemBarMiddle();
			} else {
				itemBar=itemPool.pop();
			}

			addChild(itemBar);

			return itemBar;
		}

		private function removeItemBar(itemBar:ItemBarMiddle):void {
			itemBar.close();
			itemPool.push(itemBar);
		}


		/** Pool */
		private var effectPool:Array=[];

		/**
		 * 如果是精灵就在物品边框加上光效
		 * @param itemBar
		 */
		private function showEffect(itemBar:BaseImgBar):void {
			var img:Bitmap=new Bitmap();
			img.bitmapData = utils.getDefinitionByName("极品光effect") as BitmapData;
			img.x=(img.width-itemBar.width)/2*-1+itemBar.x;
			img.y=(img.height-itemBar.height)/2*-1+itemBar.y;
			this.addChildAt(img, this.getChildIndex(mc_bg)+1);
			effectPool.push(img);
		}

		private function hideAllEffect():void {
			while(effectPool.length) {
				var img:Bitmap=effectPool.pop();

				if(img.parent)
					img.parent.removeChild(img);
			}
		}
	}
}
