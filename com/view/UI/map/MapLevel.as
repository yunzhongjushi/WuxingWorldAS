package com.view.UI.map {
	import com.model.vo.WuxingVO;
	import com.model.vo.level.LevelVO;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flas.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	/**
	 * starling中拼接的关卡展示
	 * @author hunterxie
	 */
	public class MapLevel extends Sprite{
		public var levelImg:Image;
//		public var cloudImg:Image;
		public var levelBgImg:Image;
		public var tf_num:TextField;
		public var mc_star_1:Image;
		public var mc_star_2:Image;
		public var mc_star_3:Image;
		
		public var id:int=0;
		public function get wuxing():int{
			if(this.levelInfo){
				return levelInfo.configVO.wuxing;
			}
			return 0;
		}
		
		/**
		 * 关卡信息
		 */
		public var levelInfo:LevelVO;
		
		public static const correctX:int = 30;
		public static const correctY:int = 40;
		public static const correctWidth:int = 60;
		public static const correctHeight:int = 84;
		
		/**
		 * 
		 * @param id
		 * @param point
		 * @param arr			关卡五行图片数组
		 * @param starTexture	星星图片Texture
		 */
		public function MapLevel(id:int, pointStr:String):void{
			var arr:Array = pointStr.split(",");
			var point:Point = new Point(parseInt(arr[0]), parseInt(arr[1]));
			levelImg = new Image(getCloseLevelTexture());
			levelImg.x = -25+correctX;
			levelImg.y = -25+correctY;
			addChild(levelImg);
			levelBgImg = new Image(getGrayLevelHighTexture());
			levelBgImg.x = -29+correctX;
			levelBgImg.y = -20+correctY;
			
			mc_star_1 = new Image(getStarTexture());
			mc_star_1.x = -10+correctX;
			mc_star_1.y = 24+correctY;
			addChild(mc_star_1);
			mc_star_2 = new Image(getStarTexture());
			mc_star_2.x = -30+correctX; 
			mc_star_2.y = 15+correctY;
			addChild(mc_star_2);
			mc_star_3 = new Image(getStarTexture());
			mc_star_3.x = 10+correctX;
			mc_star_3.y = 15+correctY;
			mc_star_1.touchable = mc_star_2.touchable = mc_star_3.touchable = false;
			addChild(mc_star_3);
			
			tf_num = new TextField(36, 27, "", "方正准圆_GBK", 20, 0xFFEE00, true);
			tf_num.x = -18+correctX;
			tf_num.y = -40+correctY;
			tf_num.touchable = false;
			tf_num.nativeFilters = [new GlowFilter(0,1,2,2,10)];
			addChild(tf_num);
			
//			cloudImg = new Image(stararr[2]);
//			cloudImg.touchable = false;
			
			init(id, point);
			this.touchGroup = false;
			this.flatten();
		}
		
		private function getCloseLevelTexture():Texture{
			return BigMapS.mapTexturePool["mapLevel"+WuxingVO.getWuxing(wuxing)+"1"] as Texture;
		}
		private function getOpenLevelTexture():Texture{
			return BigMapS.mapTexturePool["mapLevel"+WuxingVO.getWuxing(wuxing)+"2"] as Texture;
		}
		private function getHighLevelTexture():Texture{
			return BigMapS.mapTexturePool["mapLevel"+WuxingVO.getWuxing(wuxing)+"3"] as Texture;
		}
		private function getGrayLevelHighTexture():Texture{
			return BigMapS.mapTexturePool["mapLevelBG"] as Texture;
		}
		private function getGrayLevelHighGrayTexture():Texture{
			return BigMapS.mapTexturePool["mapLevelBGGray"] as Texture;
		}
		private function getStarTexture():Texture{
			return BigMapS.mapTexturePool["LevelStar"] as Texture;
		}
		private function getGrayStarTexture():Texture{
			return BigMapS.mapTexturePool["GrayStar"] as Texture;
		}
		
		private var mRenderTexture:RenderTexture;
		public var mImg:Image;
		
		public function removeImg():void{
			if(mImg && mImg.parent) mImg.parent.removeChild(mImg);
		}
		/**
		 * 获取静态截图
		 * @param container	用于获取stage，有了stage才可以截图
		 * @param reDraw	是否需要重新截图，更新信息后需要的操作
		 * @return 
		 */
		public function getImage(reDraw:Boolean=false):Image{
			if(mImg && !reDraw) return mImg;
			
			if(!mRenderTexture){
				mRenderTexture = new RenderTexture(correctWidth, correctHeight);
				mImg = new Image(mRenderTexture);
				mImg.name = "mapLevel_"+this.id;
			}
			var tempx:int = this.x;
			var tempy:int = this.y;
			this.x = 0;
			this.y = 0;
			mRenderTexture.clear();
			mRenderTexture.draw(this);
			this.x = mImg.x = tempx;
			this.y = mImg.y = tempy;
			
			return mImg;
		}
		
		public function judgeVisible():Point{
			var point:Point = Point.changePoint(this.localToGlobal(new Point(this.x, this.y)));
			return point;
		}
		
		public function init(id:int, point:Point):void{
			this.id = id;
			this.x = point.x-correctX; 
			this.y = point.y-correctY;
			this.name = "mc_level_"+id;
			levelImg.texture = getCloseLevelTexture();
			tf_num.text = String(id);
		}
		public function onupdate(e:Event=null):void{
			this.unflatten();
			
			if(this.contains(levelBgImg)){
				removeChild(levelBgImg);
			}
			if(levelInfo.isOpen){
//				if(cloudImg.parent){
//					removeChild(cloudImg);
//				}
				this.levelImg.texture = getOpenLevelTexture();
				for(var i:int=1; i<=3; i++){
					var img:Image = this["mc_star_"+i] as Image;
					if(i<=levelInfo.maxStarNum){
						addChild(img);
					}else if(img.parent){
						removeChild(img);
					}
					img.texture = i<=levelInfo.maxStarNum ? getStarTexture() : getGrayStarTexture();
				}
				if(levelInfo.isHighLevelOpen){
					this.levelImg.texture = getHighLevelTexture();
					if(levelInfo.isHighLevelPass){
						this.levelBgImg.texture = getGrayLevelHighTexture();
					}else{
						this.levelBgImg.texture = getGrayLevelHighGrayTexture();
					}
					addChild(levelBgImg);
				} 
				this.touchable = true;
			}else{
				this.levelImg.texture = getCloseLevelTexture();
				for(i=1; i<=3; i++){
					if(this["mc_star_"+i].parent){
						removeChild(this["mc_star_"+i]);
					}
				}
				//				addChild(cloudImg);
				mc_star_1.texture = getGrayStarTexture();
				mc_star_2.texture = getGrayStarTexture();
				mc_star_3.texture = getGrayStarTexture();
				this.touchable = false;
			}
			getImage(true);
			this.flatten();
		}
		
		public function updateInfo(vo:LevelVO):void{
			if(this.levelInfo) this.levelInfo.removeEventListener(LevelVO.LEVEL_INFO_UPDATE, onupdate);
			this.levelInfo = vo;
			this.levelInfo.addEventListener(LevelVO.LEVEL_INFO_UPDATE, onupdate);
			onupdate();
		}
	}
}
