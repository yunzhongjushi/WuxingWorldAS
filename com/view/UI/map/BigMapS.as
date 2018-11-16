package com.view.UI.map{
	import com.greensock.TweenLite;
	import com.model.ApplicationFacade;
	import com.model.event.EventCenter;
	import com.model.vo.config.level.LevelConfig;
	import com.model.vo.config.level.LevelConfigVO;
	import com.model.vo.level.LevelListVO;
	import com.model.vo.level.LevelVO;
	
	import flas.geom.Point;
	import flas.utils.utils;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * 世界地图系统（包括关卡+云层）
	 * @author hunterxie
	 */
	public class BigMapS extends Sprite{
		private static const SINGLETON_MSG:String="single_BigMapS_only";
		private static var instance:BigMapS;
		public static function getInstance():BigMapS{
			if ( instance == null ) instance=new BigMapS();
			return instance;
		}

		private var mousePoint:Point;
		private var isDrag:Boolean;
		
		public var dragJudgeNum:int = 25;
		
		public var levelHideArea:int = 200;
		public var buildHideArea:int = 400;

		/**
		 * 地图显示纵向数量
		 */
		private var mapR:int = 3;
		/**
		 * 地图显示横向数量
		 */
		private var mapL:int = 3;
		
		/**
		 * 地图最大纵向数量
		 */
		private var maxR:int = 4;
		/**
		 * 地图最大横向数量
		 */
		private var maxL:int = 4;
		
		/**
		 * 地图显示范围宽
		 */
		private var stageW:int = 0;
		/**
		 * 地图显示范围高
		 */
		private var stageH:int = 0;
		
		/**
		 * 地图最大宽
		 */
		private var maxW:int = 0;
		/**
		 * 地图最大高
		 */
		private var maxH:int = 0;
		
		/**
		 * 显示列表的横纵值数组，用来获取地图bitmap
		 */
		private var showInfoList:Array = [];
		/**
		 * 显示的地图列表，二维数组
		 */
		private var showMapList:Array = [];
		/**
		 * 显示的建筑列表
		 */
		private var showBuildList:Array = [];
		/**
		 * 所有的关卡列表
		 */
		private var allLevelList:Array = [];
		/**
		 * 关卡对应的云层列表
		 */
		private var allCloudList:Array = [];
		/**
		 * 总地图列表
		 */
		private var mapInfoArr:Array = [];
		
		/**
		 * 显示的地图容器
		 */
		private var mapContainer:Sprite = new Sprite;
		/**
		 * 显示的路径容器
		 */
//		private var pathContainer:Sprite = new Sprite;
		/**
		 * 显示关卡的容器
		 */
		private var levelContainer:Sprite = new Sprite;
		/**
		 * 显示云层的容器
		 */
		private var cloudContainer:Sprite = new Sprite;
		/**
		 * 显示的建筑容器
		 */
		private var buildContainer:Sprite = new Sprite;
		private var sampleMap:Image;
		
		private var mRenderTexture:RenderTexture;
		private var mImg:Image;
		
		
		/**
		 * 装texture的池子，仅此一份用于starling优化效率
		 */
		public static var mapTexturePool:Object = {};
		
		public function BigMapS() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			mapTexturePool["mapLevel金1"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel金1"));
			mapTexturePool["mapLevel金2"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel金2"));
			mapTexturePool["mapLevel金3"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel金3"));
			mapTexturePool["mapLevel木1"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel木1"));
			mapTexturePool["mapLevel木2"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel木2"));
			mapTexturePool["mapLevel木3"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel木3"));
			mapTexturePool["mapLevel土1"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel土1"));
			mapTexturePool["mapLevel土2"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel土2"));
			mapTexturePool["mapLevel土3"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel土3"));
			mapTexturePool["mapLevel水1"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel水1"));
			mapTexturePool["mapLevel水2"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel水2"));
			mapTexturePool["mapLevel水3"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel水3"));
			mapTexturePool["mapLevel火1"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel火1"));
			mapTexturePool["mapLevel火2"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel火2"));
			mapTexturePool["mapLevel火3"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevel火3"));
			mapTexturePool["mapLevelBG"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevelBG"));
			mapTexturePool["mapLevelBGGray"] = Texture.fromBitmapData(utils.getDefinitionByName("mapLevelBGGray"));
			
			mapTexturePool["LevelStar"] = Texture.fromBitmapData(utils.getDefinitionByName("LevelStar"));
			mapTexturePool["GrayStar"] = Texture.fromBitmapData(utils.getDefinitionByName("GrayStar"));
			mapTexturePool["MapCloud4"] = Texture.fromBitmapData(utils.getDefinitionByName("MapCloud4"));
			mapTexturePool["MapCloud1"] = Texture.fromBitmapData(utils.getDefinitionByName("MapCloud1"));
			
			mapTexturePool["build0"] = Texture.fromBitmapData(utils.getDefinitionByName("build金"));
			mapTexturePool["build1"] = Texture.fromBitmapData(utils.getDefinitionByName("build木"));
			mapTexturePool["build2"] = Texture.fromBitmapData(utils.getDefinitionByName("build土"));
			mapTexturePool["build3"] = Texture.fromBitmapData(utils.getDefinitionByName("build水"));
			mapTexturePool["build4"] = Texture.fromBitmapData(utils.getDefinitionByName("build火"));
			mapTexturePool["build5"] = Texture.fromBitmapData(utils.getDefinitionByName("build冰"));
			mapTexturePool["build6"] = Texture.fromBitmapData(utils.getDefinitionByName("buildArena"));
			mapTexturePool["build7"] = Texture.fromBitmapData(utils.getDefinitionByName("buildHome")); 
			
//			for(var i:int=0; i<3; i++){
//				mapInfoArr[i] = [];
//				for(var j:int=0; j<3; j++){
//					mapInfoArr[i][j] = Texture.fromBitmapData(utils.getDefinitionByName("Map"+i+"_"+j));
//				}
//			}
			
//			for(var i:int=0; i<28; i++){
//				if(!mapInfoArr[i]) mapInfoArr[i] = [];
//				for(var j:int=0; j<8; j++){
//					mapInfoArr[i][j] = mapInfoArr[i%4][j%4];
//				}
//			}
//			for(var i:int=0; i<28; i++){
//				for(var j:int=0; j<4; j++){
//					var map:Image = new Image(mapInfoArr[i%4][j%4]);
//					map.x = j*map.width;
//					map.y = -(i+1)*map.height;
//					mapContainer.addChild(map);
//				}
//			}
//			mapContainer.y = 640;
//			addChild(mapContainer);
			this.flatten();
			this.addEventListener(TouchEvent.TOUCH, mapInteract);
			this.addEventListener(Event.ADDED_TO_STAGE, onShow);
			LevelListVO.getInstance().addEventListener(LevelListVO.UPDATE_LEVELS_INFO, updateInfo);
		}
		private function onShow(e:Event):void{
			mapBuildShow();
			mapLevelShow();
		}
		
		/**
		 * 
		 * @param stageW	地图显示范围宽
		 * @param stageH	地图显示范围高
		 * @param mapArr	地图数组，二维数组
		 * @param levelArr	关卡列表，一维数组
		 */
		public function init(stageW:int, stageH:int, mapArr:Array=null):void{
			this.stageW = stageW;
			this.stageH = stageH;
			mRenderTexture = new RenderTexture(stageW, stageH);
			mImg = new Image(mRenderTexture);
			if(mapArr){
				this.mapInfoArr = mapArr;
			}
			sampleMap = new Image(mapInfoArr[0][0]);
			
			var levelInfo:LevelConfig = LevelConfig.getInstance();
//			var levelArr:Array = LevelInfo.levelPointArr;
			allLevelList = [];
			for(var i:int=0; i<levelInfo.baseLevels.length; i++){
				var level:LevelConfigVO = levelInfo.baseLevels[i] as LevelConfigVO;
				allLevelList.push(new MapLevel(i, level.point));
				allCloudList["level"+i] = new Image(mapTexturePool["MapCloud4"]);
			}
			
			showBuildList = [];
			for(i=0; i<levelInfo.builds.length; i++){
				level = levelInfo.builds[i] as LevelConfigVO;
				showBuildList.push(new MapBuild(i, level.point, mapTexturePool["build"+i]));
				allCloudList["build"+i] = new Image(mapTexturePool["MapCloud1"]);
			}
				
			maxR = mapInfoArr.length;
			maxL = mapInfoArr[0].length;
			maxW = maxL*sampleMap.width;
			maxH = maxR*sampleMap.height;
			mapR = Math.ceil(stageH/sampleMap.height)+1;
			if(mapR>maxR) mapR=maxR;
			mapL = Math.ceil(stageW/sampleMap.width)+1;
			if(mapL>maxL) mapL=maxL;
			
			mapContainer.y = stageH;
			addChild(mapContainer);
//			addChild(pathContainer);
			for(i=0; i<mapR; i++){
				showMapList[i] = [];
				showInfoList[i] = [];
				for(var j:int=0; j<mapL; j++){
					showInfoList[i][j] = new Point(j,i);
					var map:Image = new Image(mapInfoArr[i][j]);
					map.smoothing = TextureSmoothing.NONE;
					map.blendMode = BlendMode.NONE;
					map.x = j*sampleMap.width;
					map.y = -(i+1)*sampleMap.height;
					showMapList[i][j] = map;
					mapContainer.addChild(map);
				}
			}
			mapContainer.addChild(buildContainer);
			mapBuildShow();
			mapContainer.addChild(levelContainer);
			cloudContainer.touchable = cloudContainer.touchGroup = false;
			mapContainer.addChild(cloudContainer);
			mapLevelShow();
		}
		
//		/**
//		 * 展示路径
//		 * @param path
//		 */
//		public function showPath(path:Image):void{
//			pathContainer.addChild(path);
//		}
		
		private function updateShow(tx:int, ty:int):void{
			mapContainer.x+=tx;
			mapContainer.y+=ty;
//			return;
			var showMin:Image = showMapList[0][0];
			var showMaxX:Image = showMapList[0][showMapList[0].length-1];
			var showMaxY:Image = showMapList[showMapList.length-1][0];
			var pointMin:Point = Point.changePoint(this.globalToLocal(showMin.localToGlobal(new Point)));
			var pointMaxX:Point = Point.changePoint(this.globalToLocal(showMaxX.localToGlobal(new Point)));
			var pointMaxY:Point = Point.changePoint(this.globalToLocal(showMaxY.localToGlobal(new Point)));
			
			if(mapContainer.x>0){
				mapContainer.x=0;
			}else if(mapContainer.x<stageW-maxW){
				mapContainer.x = stageW-maxW;
			}else{
				if(tx>0){
					if(pointMin.x>0){//-judgeDistance){//pointMaxX.x>stageW){
						for(var i:int=0; i<mapR; i++){
							var info:Point = showInfoList[i].pop() as Point;
//							var info1:Point = info.clone();
							info.x -= mapL;// showInfoList[i][0].x-1;
							showInfoList[i].unshift(info);
							
							var map:Image = showMapList[i].pop() as Image;
							map.x = showMin.x-map.width;
							showMapList[i].unshift(map);
							map.texture = mapInfoArr[info.y][info.x];
						}
//						trace("x:+");
					}
				}else if(pointMaxX.x<stageW-showMin.width){
					for(i=0; i<mapR; i++){
						info = showInfoList[i].shift() as Point;
//						var info1:Point = info.clone();
						info.x += mapL;
						showInfoList[i].push(info);
						
						map = showMapList[i].shift() as Image;
						map.x = showMaxX.x+map.width;
						showMapList[i].push(map);
						map.texture = mapInfoArr[info.y][info.x];
					}
//					trace("x:-");
				}
			}
			
			if(mapContainer.y<stageH){//底是初始位置
				mapContainer.y = stageH;
			}else if(mapContainer.y>maxH){
				mapContainer.y = maxH;
			}else{
				if(ty>0){
					if(pointMaxY.y>0){//-judgeDistance){//pointMaxY.y>stageH){
						var infoArr:Array = showInfoList.shift() as Array;
						var mapArr:Array = showMapList.shift() as Array;
						for(i=0; i<mapL; i++){
							info = infoArr[i] as Point;
//							var info1:Point = info.clone();
							info.y += mapR;
							
							map = mapArr[i] as Image;
							map.y = showMaxY.y-map.height;
							map.texture = mapInfoArr[info.y][info.x];
						}
						showInfoList.push(infoArr);
						showMapList.push(mapArr);
//						trace("y:+");
					}
				}else if(pointMin.y<stageH-showMin.height){//+judgeDistance){//showMin.y<-showMin.height){
					infoArr = showInfoList.pop() as Array;
					mapArr = showMapList.pop() as Array;
					for(i=0; i<mapL; i++){
						info = infoArr[i] as Point;
//						var info1:Point = info.clone();
						info.y -= mapR;
						
						map = mapArr[i] as Image;
						map.y = showMin.y+showMin.height;
						map.texture = mapInfoArr[info.y][info.x];
					}
					showInfoList.unshift(infoArr);
					showMapList.unshift(mapArr);
//					trace("y:-");
				}
			}
			
			mapBuildShow();
			mapLevelShow();
		}
		
		private function mapBuildShow():void{
			var num:int = showBuildList.length;
			for(var i:int=0; i<showBuildList.length; i++){
				var build:MapBuild = showBuildList[i];
				var cloud:Image = allCloudList["build"+i] as Image;
				if(build.x+mapContainer.x>stageW+buildHideArea || build.x+mapContainer.x<-buildHideArea || build.y+mapContainer.y>stageH+buildHideArea || build.y+mapContainer.y<-buildHideArea){
					if(buildContainer.contains(build)) buildContainer.removeChild(build);
				}else if(!buildContainer.contains(build)){
					buildContainer.addChild(build);
					build.touchable = build.isOpen;
					if(build.isOpen){
						if(cloudContainer.contains(cloud)) cloudContainer.removeChild(cloud);
					}else{
						cloud.x = build.x-(cloud.width-build.width)/2;
						cloud.y = build.y-(cloud.height-build.height)/2;
						cloudContainer.addChild(cloud);
					}
				}else{
					if(build.isOpen){
						if(cloudContainer.contains(cloud)) cloudContainer.removeChild(cloud);
					}
				}
			}
		}
		
		private function mapLevelShow():void{
			var num:int = allLevelList.length;
			for(var i:int=0; i<num; i++){
				var level:MapLevel = allLevelList[i] as MapLevel;
				var cloud:Image = allCloudList["level"+i] as Image;
				if(level.x+mapContainer.x>stageW+levelHideArea || level.x+mapContainer.x<-levelHideArea || level.y+mapContainer.y>stageH+levelHideArea || level.y+mapContainer.y<-levelHideArea){
					level.removeImg();
					if(cloud.parent==cloudContainer){
						cloudContainer.removeChild(cloud);
					}
				}else{
					levelContainer.addChild(level.getImage());
					if(!level.levelInfo || !level.levelInfo.isOpen){
						cloud.x = level.x-(cloud.width-MapLevel.correctX)/2;
						cloud.y = level.y-(cloud.height-MapLevel.correctY)/2;
						cloudContainer.addChild(cloud);
					}else if(cloud.parent==cloudContainer){
						cloudContainer.removeChild(cloud);
					}
				}
			}
//			var build:MapBuild = showBuildList[1];
//			if(!buildContainer.contains(build)){
//				buildContainer.addChild(build);
//				cloudContainer.addChild(cloud);
//			}
		}
		
		
		private var accX:int = 0;
		private var accY:int = 0;
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		private var friction:Number = 0.9;
		private function onFrame(e:Event):void{
			if(speedX==0 && speedY==0){
				this.flatten();
				this.removeEventListener(Event.ENTER_FRAME, onFrame);
				return;
			}
			speedX*=friction;
			speedY*=friction;
			updateShow(Math.floor(speedX), Math.floor(speedY));
			if(Math.abs(speedX)<1) speedX=0;
			if(Math.abs(speedY)<1) speedY=0;
		}
		
		/**
		 * 地图上的触碰事件
		 * @param e
		 */
		private function mapInteract(e:TouchEvent):void{
			var touch:Touch = e.getTouch(this);
			if(!touch) return;
			
			var pos:Point = Point.changePoint(touch.getLocation(mapContainer));
			
			switch(touch.phase){
				case "began":
					mousePoint = pos;
					this.unflatten();
					this.removeEventListener(Event.ENTER_FRAME, onFrame);
					if(touch.target.name && touch.target.name.indexOf("MapBuild_")!=-1){
						touch.target.alpha=1;
					}
					break;
				case "ended":
					mousePoint = null;
					if(isDrag){
						isDrag = false;
						speedX = accX;
						speedY = accY;
						this.addEventListener(Event.ENTER_FRAME, onFrame);
					}else if(touch.target.name && touch.target.name.indexOf("mapLevel_")!=-1){
						var level:MapLevel = allLevelList[parseInt(touch.target.name.replace("mapLevel_",""))] as MapLevel;
						if(level.touchable){
							EventCenter.event(ApplicationFacade.WORLD_MAP_LEVEL_CHOOSE, level.levelInfo);
						}
					}else if(touch.target.name && touch.target.name.indexOf("MapBuild_")!=-1){
						EventCenter.event(ApplicationFacade.WORLD_MAP_BUILD_CHOOSE, touch.target.name);
					}
					if(touch.target.name && touch.target.name.indexOf("MapBuild_")!=-1){
						touch.target.alpha=0;
					}
					break;
				case "hover":
					break;
				case "moved":
					if(mousePoint){
						accX = Math.floor(pos.x-mousePoint.x);
						accY = Math.floor(pos.y-mousePoint.y);
						if(!isDrag){
							if(Math.pow(accX, 2)+Math.pow(accY, 2) > dragJudgeNum){
								isDrag = true;
							}
						}else{
							updateShow(accX, accY);
						}
					}
					break;
			}
		}
		
		
		/**
		 * 更新地图当前展示的所有元素
		 */
		public function updateInfo(e:*=null):void{
			for(var i:int=0; i<LevelConfig.levelLength; i++){
				var level:MapLevel = allLevelList[i] as MapLevel;
				if(!level){
					continue;
				}
				level.updateInfo(LevelListVO.getLevelVO(i));
//				levelContainer.addChild(mc);
//				mc.getImage();
			}
			mapLevelShow();
		}
		
		private var mapLevelPoint:Image;
		/**
		 * 大地图移动到指定关卡的坐标位置，并在指定关卡上展示提示标志
		 * @param id
		 */
		public function showMoveToLevel(id:int):void{
			if(!mapLevelPoint){
				mapLevelPoint = new Image(Texture.fromBitmapData(utils.getDefinitionByName("LevelPoint")));
				mapLevelPoint.touchable = false;
			}
//			TweenLite.to(this, 2, {x:100, y:100});
			var level:MapLevel = allLevelList[id] as MapLevel;
			mapLevelPoint.x = level.x;
			mapLevelPoint.y = level.y;
			mapContainer.addChild(mapLevelPoint);
			
			unflatten();
			flatten();
		}
		
		public static function testShowMoveToLevel(id:int):void{
			instance.showMoveToLevel(id);
		}
		
		public var isActive:Boolean = true;
		public function deactive():void{
			addChild(getImage());
			if(this.contains(mapContainer)){
				removeChild(mapContainer);
			}
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
			this.removeEventListener(TouchEvent.TOUCH, mapInteract);
			isActive = false;
		}
		public function active():void{
			if(this.contains(mImg)){
				removeChild(mImg);
			}
			addChild(mapContainer);
			this.addEventListener(TouchEvent.TOUCH, mapInteract);
			isActive = true;
		}
		
		
		/**
		 * 缓存地图截图，节省资源
		 */
		public function getImage():Image{
			if(this.stage){
				var tempx:int = this.x;
				var tempy:int = this.y;
//				this.x = 0;
//				this.y = 0;
				mRenderTexture.clear();
				mRenderTexture.draw(this);
//				this.x = mImg.x = tempx;
//				this.y = mImg.y = tempy;
			}
			return mImg;
		}
	}
}