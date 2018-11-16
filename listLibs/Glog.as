package listLibs {
	import com.model.vo.level.LevelVO;
	import com.model.vo.user.UserVO;

	public class Glog {
		public static var turn:int=0;
		public static var verbose:Boolean=false;

		public static function get log():String {
			return _log;
		}

		public static function set addlog(value:String):void {
			if(verbose) {
				trace(value);
			}
			o_log+=value+"\n";
			if(logAll==false&&t_log==false) {
				return
			}
			_log+=value+"\n";
			t_log=false;
		}
		private static var _log:String="";
		public static var o_log:String="";
		public static var logAll:Boolean=false;
		public static var t_log:Boolean=false;
		public static var onEnd:Function;

		public static function start(levelVO:LevelVO):void {
			turn=0;
			o_log=_log="";
			t_log=true;
			addlog="********** Start Game **********\n"+"帐号："+UserVO.getInstance().nickName+"  关卡："+levelVO.id+"\n"
//				"关卡信息："+levelVO.data; 
			turnOver();
		}

		public static function end():void {

		}

		public static var turnCount:int;

		public static function turnOver():void {
			if(wuxingArr) {
				var wuxingLog:String="";
				for(var i:String in wuxingArr) {
					var arr:Array=wuxingArr[i] as Array;
					var total:int=0;
					if(arr.length>0) {
						wuxingLog+=i+" : ";
						for(var j:int=0; j<arr.length; j++) {
							wuxingLog+=fixNumber(String(arr[j]), 4)+" - ";
//							total+=arr[j];
						}
//						wuxingLog += "total: "+total+"\n"; 
						wuxingLog+="\n";
					}
				}
//				t_log = true;
				addlog=wuxingLog;
			}
			wuxingArr=[];
			scoreCount=0;
			turn++;
			t_log=true;
			addlog="<font color='#D10B6A'>_____________________________________ "+(turn%2==1?"敌人":"己方")+"回合:"+turn+"</font>";
			turnCount=0;

			if(Glog["onEnd"])
				onEnd();
			if(turn==23) {
				trace();
			}
		}

		private static var scoreCount:int=0;
		public static var wuxingArr:Array

		public static function matchScore(wuxing:int, num:int):void {
			if(wuxingArr[wuxing]) {
			} else {
				wuxingArr[wuxing]=[];
			}
			scoreCount++;
			(wuxingArr[wuxing] as Array).push(num+"("+scoreCount+")");
		}

		public static function trig(who:String, cast:String):void {
			if(cast=="基础攻击")
				return;
			addlog=header+"[<font color='#7C7CB3'>"+fix(who)+"</font>]"+" <font color='#FFFF00'>触发技能</font> -》  "+fix(cast);
		}

		public static function effect(who:String, buff:String, effectID:int, effectValue:int, ap:int, to:String):void {
			if(effectID==119) {
				buffGen=who;
			} else if(effectID==100&&buff=="基础攻击") {
				t_log=true;
				addlog=getHeng(4)+"[<font color='#7C7CB3'>"+fix(who)+"</font>]"+" <font color='#DDDDDD'>发动普攻</font> -》 "+" [<font color='#C173BB'>"+fix(to, 4)+"</font>] "+"威力："+fixNumber(effectValue, 4)+" AP:"+ap;

			} else {
				t_log=true;
				addlog=getHeng(4)+"[<font color='#7C7CB3'>"+fix(who)+"</font>]"+" <font color='#5791DA'>"+fix(buff, 4)+"</font> -》 "+" [<font color='#C173BB'>"+fix(to, 4)+"</font>] "+"威力："+fixNumber(effectValue, 4)+" AP:"+ap+"  ID："+fixNumber(effectID, 4)

			}


		}
		private static var buffGen:String

		public static function buff(who:String, cast:String, last:int):void {
			addlog=getHeng(4)+"[<font color='#7C7CB3'>"+fix(buffGen)+"</font>]"+" <font color='#AAAA00'>生成BUFF</font> -》  "+fix(cast, 4)+"("+fixNumber(last, 2)+"回合)"

			addlog=getHeng(4)+"[<font color='#7C7CB3'>"+fix(who)+"</font>]"+" <font color='#AAAA00'>获得BUFF</font>  《- "+fix(cast, 4);
		}

		public static function udbuff(buff:String, last:int):void {
			addlog="____<font color='#77DDFF'>BUFF更新</font>--》 "+fix(buff, 4)+"("+"持续："+fixNumber(last, 2)+"回合)";
		}

		public static function clbuff(buff:String):void {
			addlog="____<font color='#AA0000'>BUFF清除</font>--》 "+fix(buff, 4)
		}
		private static var seed:Number;

		public static function chance1(_rand:Number):void {
			seed=_rand;
		}

		public static function chance2(skill:String, total:Number):void {
			if(total>=1)
				return;
			var rand:Number=seed%10000/10000;
			addlog="____<font color='#77DDFF'>命中"+fix((total>rand), 3)+"</font>-》"+fix(skill, 4)+"___________________________随机"+fixNumber(rand.toFixed(4), 6)+"(0---"+fixNumber(total.toFixed(4), 6)+") "+" seed:"+seed;
		}

		public static function beatk(who:String, damage:int, cuHP:int, dp:int):void {
			t_log=true;
			addlog=getHeng(36, " ")+" <font color='#FF0000'>"+fix("-"+damage, 4)+"</font>"+" ( HP:"+fixNumber(cuHP, 4)+" DP:"+fixNumber(dp, 4)+" )" // +"-》 "+" ["+fix(who,4)+"]</font>"
		}

		public static function heal(who:String, heal:int, to:String):void {
			addlog=header+"【"+fix(who)+"】"+"发出治疗 ->"+" "+fix(heal)+" "+"目标"+"【"+to+"】";
		}

		public static function gameaction(actions:String):void {
			t_log=true;
			addlog=actions;
		}

		private static function get header():String {
			turnCount++;
			return fixNumber(turn+"."+turnCount, 4);
		}

		private static function fix(_str:*, num:int=8):String {
			var str:String=String(_str);
			var intnum:int=0
			for(var i:int=0; i<str.length; i++) {
				if(!isNaN(Number(str.charAt(i)))) {
					intnum++;
				}
			}

			var add:int=num*2-(str.length*2-intnum);
			while(add>0) {
				str+="\u0020";
				add--;
			}
			return str;
		}

		private static function fixNumber(_str:*, num:int=8):String {
			var str:String=String(_str);
			var add:int=num-str.length;
			while(add>0) {
				str+="\u0020";
				add--;
			}
			return str;
		}

		private static function getHeng(num:int, symbol:String="-"):String {
			var str:String="";
			for(var i:int=0; i<num; i++) {
				str+=symbol
			}
			return str;
		}

	}
}