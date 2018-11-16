
		package com.view.UI.item
		{
			import com.model.vo.item.ItemVO;
			
			import flash.display.MovieClip;
			import flash.text.TextField;
			
			import listLibs.ITouchPadBar;
			
			public class ItemBarRectangle extends MovieClip implements ITouchPadBar
			{
				private var _running_vo:ItemVO
				public function ItemBarRectangle(){
					super();
				}
				public function updateInfo(_vo:*):void{
					if(_vo==null){
						this.visible=false;
						return;
					}
					running_vo = _vo as ItemVO;
					this.visible=true;
				}
				
				public function set running_vo(_vo:ItemVO){
					_running_vo=_vo
//					tf_count.text = String(_running_vo.getHaveNum());
//					tf_title.text = String(_running_vo.name);
//					tf_description.text = String(_running_vo.getSubDesc());
//					
//					itemPicArr.gotoAndStop(_running_vo.pic)
				}
				public function get running_vo():ItemVO{
					return _running_vo
				} 
				//
				//场景元素
				
				//
				public var tf_count:TextField;
				public var tf_title:TextField;
				public var tf_description:TextField;
				public var itemPicArr:MovieClip;
	
			}
		}