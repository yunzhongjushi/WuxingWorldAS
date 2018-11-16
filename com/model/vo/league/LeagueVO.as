package com.model.vo.league {
	
	/**
	 * 家族对象
	 */
	public class LeagueVO {
		public static const LEAGUE_JOB_1:String="1";
		public static const LEAGUE_JOB_2:String="2";
		public static const LEAGUE_JOB_3:String="3";
		
		/**
		 * 联盟/家族
		 */
		public function get league():String {
			return _league;
		}
		public function set league(value:String):void {
			if (!value) {
				_league="";
				return ;
			}
			_league=value;
		}
		private var _league:String="";
		/**
		 * 自己在联盟中的职位
		 * 1:族长 2：副族长 3：族人
		 */
		//		public var leagueJob:String="";
		/**
		 * 自己在联盟名字
		 */
		//		public var leagueName:String="";
		
		private var _id:int; //家族ID
		private var _user_id:int; //家族创始人用户id
		private var _chuangshiren_nickname:String; //家族创始人昵称
		private var _name:String; //家族名称
		private var _info:String; //家族简介
		private var _affiche:String; //家族公告
		private var _num_top:int; //家族人数上限
		private var _ingroup:int; //家族属于那个门派的ID
		private var _honor:int; //家族总荣誉
		private var _associator_count:int; //家族当前的总人数
		private var _state:int; //家族状态(1为正常,2为关闭)
		private var _found_time:String; //家族创建时间
		private var _bangzhu_user_id:int; //族长id
		private var _bangzhu_nickname:String; //族长昵称
		private var _fubangzhu_user:Object=new Object(); //副族长的id和昵称对应关系
		private var _fubangzhu_user_string:String=""; //副族长的昵称
		
		public function LeagueVO() {
		}
		
		public function setFubangzhu(fubangzhu_user_ids:String, fubangzhu_user_nicknames:String):void {
			
			if (fubangzhu_user_ids==null||fubangzhu_user_nicknames==null) {
				return ;
			}
			
			var fb_ids:Array=fubangzhu_user_ids.split(",");
			var fb_nicks:Array=fubangzhu_user_nicknames.split(",");
			if (fb_ids.length==fb_nicks.length) {
				for (var i:int=0; i<fb_ids.length; i++) {
					_fubangzhu_user[fb_ids[i]]=fb_nicks[i];
					_fubangzhu_user_string+=fb_nicks[i]+" ";
				}
			} else {
				trace("副族长数据异常，id和昵称数量不一致");
			}
		}
		
		/**
		 * 获取副族长昵称字符串
		 * @return
		 *
		 */
		public function getFubangzhuStr():String {
			return _fubangzhu_user_string;
		}
		
		public function getFubangzhu(fb_id:String):String {
			return _fubangzhu_user[fb_id];
		}
		
		public function getFubangzhuMap():Object {
			return _fubangzhu_user;
		}
		
		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id=value;
		}
		
		public function get user_id():int {
			return _user_id;
		}
		
		public function set user_id(value:int):void {
			_user_id=value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			if (!value) {
				_name="";
				return ;
			}
			_name=value;
		}
		
		public function get info():String {
			return _info;
		}
		
		public function set info(value:String):void {
			if (!value) {
				_info="";
				return ;
			}
			_info=value;
		}
		
		public function get affiche():String {
			return _affiche;
		}
		
		public function set affiche(value:String):void {
			if (!value) {
				_affiche="";
				return ;
			}
			_affiche=value;
		}
		
		public function get num_top():int {
			return _num_top;
		}
		
		public function set num_top(value:int):void {
			_num_top=value;
		}
		
		public function get ingroup():int {
			return _ingroup;
		}
		
		public function set ingroup(value:int):void {
			_ingroup=value;
		}
		
		public function get honor():int {
			return _honor;
		}
		
		public function set honor(value:int):void {
			_honor=value;
		}
		
		public function get associator_count():int {
			return _associator_count;
		}
		
		public function set associator_count(value:int):void {
			_associator_count=value;
		}
		
		public function get state():int {
			return _state;
		}
		
		public function set state(value:int):void {
			_state=value;
		}
		
		public function get found_time():String {
			return _found_time;
		}
		
		public function set found_time(value:String):void {
			if (value) {
				//				_found_time = TimeFormatUtil.unix2ASDate(value);
			} else {
				_found_time="";
			}
			
		}
		
		public function get bangzhu_user_id():int {
			return _bangzhu_user_id;
		}
		
		public function set bangzhu_user_id(value:int):void {
			_bangzhu_user_id=value;
		}
		
		public function get bangzhu_nickname():String {
			return _bangzhu_nickname;
		}
		
		public function set bangzhu_nickname(value:String):void {
			if (!value) {
				_bangzhu_nickname="";
				return ;
			}
			_bangzhu_nickname=value;
		}
		
		public function get chuangshiren_nickname():String {
			return _chuangshiren_nickname;
		}
		
		public function set chuangshiren_nickname(value:String):void {
			if (!value) {
				_chuangshiren_nickname="";
				return ;
			}
			_chuangshiren_nickname=value;
		}
		
		
		
	}
}