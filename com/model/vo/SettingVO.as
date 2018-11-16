package com.model.vo {
//	import flash.media.SoundMixer;
//	import flash.media.SoundTransform;
	

	/**
	 * 
	 */
	public class SettingVO extends BaseObjectVO{
		public static const NAME:String="SettingVO";
		public static const SINGLETON_MSG:String="single_SettingVO_only";
		protected static var instance:SettingVO;
		public static function getInstance():SettingVO{
			if ( instance == null ) instance = new SettingVO();
			return instance;
		}

		/**
		 * 背景音乐是否开启
		 */
		public function get isMusicOpen():Boolean{
			return _isMusicOpen;
		}
		public function set isMusicOpen(value:Boolean):void{
			_isMusicOpen = value;
//			var transform:SoundTransform=SoundMixer.soundTransform;
//			transform.volume = value?1:0;
//			SoundMixer.soundTransform = transform;
			
			
//			SoundMixer.soundTransform.volume = value?1:0;
		}
		private var _isSoundOpen:Boolean = true;

		/**
		 * 游戏音效是否开启
		 */
		public function get isSoundOpen():Boolean{
			return _isSoundOpen;
		}
		public function set isSoundOpen(value:Boolean):void{
			_isSoundOpen = value;
//			if(!value) SoundMixer.stopAll();
		}
		private var _isMusicOpen:Boolean = true;
		
		
		
		/**
		 * 
		 * 
		 */
		public function SettingVO() {
			
		}
		
		public function updateInfo(info:Object):void{
			for (var i:Object in info) {
				if (this.hasOwnProperty(i)) {
					this[i]=info[i];
				}
			}
		}
	}
}
