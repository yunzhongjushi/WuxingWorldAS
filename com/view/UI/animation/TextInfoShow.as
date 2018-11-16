package com.view.UI.animation {
	import com.greensock.TweenLite;
	import com.model.vo.animation.InfoShowVO;
	
	import flash.display.MovieClip;
	import flas.geom.Point;
	import flash.text.TextField;
	


	public class TextInfoShow extends MovieClip {
		public var tf_info:TextField;
		
		/**
		 * 正在展示中的文字数组，用于判断文字展示重叠后的处理
		 */
		public static var showArr:Array = [];
		
		private static var pool:Array = [];
		public static function getTextInfo(vo:InfoShowVO):TextInfoShow{
			var info:TextInfoShow;
			if(pool.length){
				info = pool.pop();
			}else{
				info = new TextInfoShow();
			}
			
			info.scaleX = info.scaleY = vo.infoScale;
			info.updateInfo(vo.info, vo.point, vo.color, vo.continuedTime, vo.delay);
			
			for(var i:int=0; i<showArr.length; i++){
				var info1:TextInfoShow = showArr[i];
				if(Math.abs(info1.x-info.x)<info1.width/2 && Math.abs(info1.y-info.y)<info1.height/2){
//					info.x = info1.x
					info.y = info1.y+info1.height/2;
				}
			}
			showArr.push(info);
			
			return info;
		}
		
		
		
		public function TextInfoShow() {
			this.alpha=0;
			this.mouseChildren=this.mouseEnabled=false;
		}
		
		/**
		 * 
		 * @param str
		 * @param point
		 * @param color
		 * @param time 秒
		 * @return 
		 */
		public function updateInfo(str:String, point:Point, color:Number=0xFFEB46, time:Number=1, delay:Number=0):void{
			this.alpha=1;
			this.x=point.x;
			this.y=point.y;
			this.tf_info.text=str;
			this.tf_info.textColor=color;
			this.tf_info.width = this.tf_info.textWidth+5;
			this.tf_info.x = -tf_info.width/2;
			TweenLite.to(this, time, {delay:delay, alpha:0, y:this.y-this.height*1.2, onComplete:clear});
		}
		
		private function clear():void{
			this.x = this.y = 0;
			pool.push(this);
			if(parent){ 
				parent.removeChild(this);
			}
			var n:int = showArr.indexOf(this);
			if(n!=-1){
				showArr.splice(n, 1);
			}
		}
	}
}