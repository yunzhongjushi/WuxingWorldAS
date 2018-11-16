package com.view.UI.fairy {
	import com.model.vo.fairy.BaseFairyVO;
	import com.model.vo.fairy.FairyListVO;
	import com.view.BasePanel;
	
	import flash.display.Sprite;
	
	import listLibs.TouchPad;
	import listLibs.TouchPadOptions;

	/**
	 * 精灵列表面板
	 * @author CC5
	 *
	 */
	public class FairyListBoard extends BasePanel {
		/**
		 * 精灵的滑动列表
		 */
		public var barList:TouchPad;
		public var mc_cover:Sprite;
		
		private var running_voList:Array;
		
		
		/**
		 *
		 * 
		 *  
		 * 
		 */		
		public function FairyListBoard() {}
		
		

		/**
		 * 更新数据
		 * @param voList
		 */
		public function updateInfo():void {
			if(barList==null) {
				var vo:TouchPadOptions = new TouchPadOptions(mc_cover.width, mc_cover.height, FairyBarSmall, 10, 2);
				barList=new TouchPad(vo);
				barList.x=mc_cover.x;
				barList.y=mc_cover.y
				this.addChild(barList);
				mc_cover.visible=false;
			}
			running_voList = FairyListVO.fairyList;
			refresh();
		}

		/**
		 * 更新面板
		 */
		public function refresh():void {
			running_voList.sortOn("ID", Array.NUMERIC);
			running_voList.sortOn("EXP_cu", Array.NUMERIC);
			running_voList=running_voList.reverse();
			barList.updateInfo(running_voList);
		}

		public function getFirstFairyVO():BaseFairyVO {
			if(running_voList) {
				return running_voList[0] as BaseFairyVO;
			}
			return null;
		}
	}
}
