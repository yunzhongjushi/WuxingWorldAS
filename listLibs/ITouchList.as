package listLibs
{
	import flas.geom.Rectangle;

	/**
	 * 循环显示需实现该接口
	 * 
	 * fixRect(viewRect:Rectangle):void
	 * 
	 * viewRect 是显示范围，实现循环显示时将该显示范围外的显示对象移除
	 * 
	 * @author CC5
	 * 
	 */	
	public interface ITouchList
	{
		function fixRect(viewRect:Rectangle):void;
	}
}