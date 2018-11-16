package com.view.UI.tip {
	import com.model.vo.config.guide.GuideAskConfigVO;
	import com.view.BasePanel;
	import com.view.touch.CommonBtn;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flas.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 首次进入引导关提示语
	 * @author hunterxie
	 */
	public class GuideAskTip extends BasePanel {
		public static const NAME:String = "GuideAskTip";
		public static const SINGLETON_MSG:String="single_GuideAskTip_only";
		protected static var instance:GuideAskTip;
		public static function getInstance():GuideAskTip{
			if ( instance == null ) instance=new GuideAskTip();
			return instance as GuideAskTip;
		}
		
		public var mc_mapContainer:MovieClip;
		public var mc_frame:Sprite;
		public var tf_title:TextField;
		public var tf_info:TextField;
		public var btn_new:CommonBtn;
		public var btn_old:CommonBtn;
		
		public var vo:GuideAskConfigVO;
		
		public function GuideAskTip() {
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			this.alignInfo = ALIGN_MIDDLE;
			btn_new.setNameTxt("我是新手");
			btn_new.addEventListener(MouseEvent.CLICK, onChoose);
			btn_old.setNameTxt("我是高手");
			btn_old.addEventListener(MouseEvent.CLICK, onChoose);
		}
		
		public function updateInfo(vo:GuideAskConfigVO):void{
			this.vo = vo; 
			
			mc_mapContainer.gotoAndStop(vo.id);
			btn_new.setNameTxt(vo.choose1);
			btn_old.setNameTxt(vo.choose2);
			tf_info.text = vo.info;
		}
		
		public function onChoose(e:*=null):void{
			if(e.currentTarget==btn_new){
				vo.choosed = 1;
			}else if(e.currentTarget==btn_old){
				vo.choosed = 2;
			}
			close();
		}
		
		/**
		 * 
		 * @param title
		 * @param info
		 * @param key
		 * @param arr		可供选择按钮数组
		 */
		public static function showPanel(vo:GuideAskConfigVO):void{
			getInstance().updateInfo(vo);
			instance.event(BasePanel.SHOW_PANEL);
		}
		
		public static function getShowName(vo:GuideAskConfigVO):String{
			getInstance().updateInfo(vo);
			return NAME;
		}
	}
}
