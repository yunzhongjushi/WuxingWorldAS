package com.view.UI.map {
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.config.level.LevelConfig;
	import com.model.vo.level.LevelListVO;
	import com.model.vo.level.LevelVO;
	
	import flas.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	/**
	 * 地图上的建筑
	 * @author hunterxie
	 */
	public class MapBuild extends Image{
		
		public var id:int=0;
		
		/**
		 * 此建筑是否开启
		 */
		public function get isOpen():Boolean{
			return BaseInfo.isOpenAllBuild ? true : _isOpen;
		}
		public function set isOpen(value:Boolean):void{
			_isOpen = value;
			if(value) this.touchable = true;
		}
		private var _isOpen:Boolean;
		
		public var data:LevelConfigVO;
		
		public var triggerLevel:LevelVO;
		
//		public var tartchArea:
		
		/**
		 * 
		 * @param id
		 * @param point
		 */
		public function MapBuild(id:int, pointStr:String, texture:Texture):void{
			super(texture);
			
			var arr:Array = pointStr.split(",");
			var point:Point = new Point(parseInt(arr[0]), parseInt(arr[1]));
			this.alpha = 0;
			this.x = point.x-this.width/2;
			this.y = point.y-this.height/2; 
			this.name = "MapBuild_"+id;
			this.data = LevelConfig.getLevelByID(id);
			
			this.triggerLevel = LevelListVO.getLevelVO(data.trigger);
			if(!triggerLevel || triggerLevel.isPassed){ 
				this.isOpen = true;
			}else{
				this.triggerLevel.addEventListener(LevelVO.LEVEL_INFO_UPDATE, updateLevelPass);
			}
		}
		private function updateLevelPass(e:*):void{
			this.isOpen = triggerLevel.isPassed;
		}
	}
}
