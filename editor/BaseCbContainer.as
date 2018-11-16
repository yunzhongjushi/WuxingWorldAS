package editor{
	import flash.display.Sprite;
	import flas.utils.describeType;

	public class BaseCbContainer extends Sprite {
		public function BaseCbContainer() {
			var instanceInfo:XML = describeType(this);
			var properties:XMLList = instanceInfo.accessor.(@access != "writeonly") + instanceInfo.variable;
			for each (var propertyInfo:XML in properties) {
				var propertyName:String=propertyInfo.@name;
				if(propertyName.indexOf("cb_")==0){
					this[propertyName].rowCount = 15;
				}
			}
		}
	}
}
