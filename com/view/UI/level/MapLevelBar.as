package com.view.UI.level{
	import com.model.vo.level.LevelVO;
	import com.view.BaseImgBar;
	
	import flash.display.MovieClip;
	
	/**
	 * flash版本 地图上的关卡图标
	 * Starling版本 为 MapLevel
	 * @author Jim
	 */	
	public class MapLevelBar extends BaseImgBar{
		public var mc_placeholder:MovieClip;
		public var frame_elite:BaseImgBar;
		private var mLevelVO:LevelVO;
		
		public function MapLevelBar(){
			if(mc_placeholder.parent) this.removeChild(mc_placeholder);
			
			frame_elite	= new BaseImgBar();
			frame_elite.updateClass("mapLevelBG"); 
			img_container.addChild(frame_elite.itemImg);
		}

		public function get levelVO():LevelVO{
			return mLevelVO;
		}

		public function set levelVO(value:LevelVO):void{
			mLevelVO = value;
			
			frame_elite.visible	= mLevelVO.configVO.isHighLevel;
			this.updateClass("mapLevel" + mLevelVO.configVO.wuxing + (mLevelVO.configVO.isHighLevel ? "3" : "2"));
		}

	}
}