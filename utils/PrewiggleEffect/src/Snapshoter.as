/**
 * Author: Alexey
 * Date: 8/20/12
 * Time: 12:29 AM
 */
package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.getSize;
	import flash.utils.ByteArray;

	import starling.core.Starling;

	public class Snapshoter
{
	private static var areaSelectorInited:Boolean;
	private static var rectNotFinished:Boolean;
	private static var areaRect:Shape;
	public static var startX:Number;
	public static var startY:Number;
	public static var endX:Number;
	public static var endY:Number;
	private static var stage:Stage;

	public static function initAreaSelector(stageLink:Stage):void
	{
		stage = stageLink;
		areaSelectorInited = true;
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		areaRect = new Shape();
		stage.addChild(areaRect);
	}

	/**
	 * Manually defining area
	 * @param sstartX
	 * @param sstartY
	 * @param eendX
	 * @param eendY
	 */
	public static function setRectangle(sstartX:Number, sstartY:Number, eendX:Number, eendY:Number):void
	{
		startX = sstartX;
		startY = sstartY;
		endX = eendX;
		endY = eendY;
		rectNotFinished = false;
		areaRect.graphics.clear();
		areaRect.graphics.lineStyle(3, 0xFF0000, 0.5); //set alpha to 1
		areaRect.graphics.beginFill(0, 0);
		areaRect.graphics.drawRect(startX, startY, endX - startX, endY - startY);
		areaRect.graphics.endFill();
	}

	private static function onMouseDown(event:MouseEvent):void
	{
		if (event.shiftKey && areaSelectorInited)
		{
			startX = event.stageX;
			startY = event.stageY;
			rectNotFinished = true;
		}
	}

	private static function onMouseMove(event:MouseEvent):void
	{
		if (event.shiftKey && areaSelectorInited && rectNotFinished)
		{
			areaRect.graphics.clear();
			areaRect.graphics.lineStyle(3, 0xFF0000);
			areaRect.graphics.beginFill(0, 0);
			areaRect.graphics.drawRect(startX, startY, stage.mouseX - startX, stage.mouseY - startY);
		}
	}

	private static function onMouseUp(event:MouseEvent):void
	{
		if (event.shiftKey && areaSelectorInited)
		{
			endX = event.stageX;
			endY = event.stageY;
			rectNotFinished = false;
			areaRect.graphics.endFill();
		}
	}

	public static function snapshot(target:DisplayObject, width:int, height:int, transparent:Boolean = false, fillColor:uint = 0xFFFFFF):Bitmap //#302D26 - bd color
	{
		var bd:BitmapData = new BitmapData(width, height, transparent, fillColor);
		bd.draw(target);
		return new Bitmap(bd);
	}

	/**
	 * Gets snaphot as ByteArray
	 * @return
	 */
	public static function getBASnaphot():ByteArray
	{
		var byteArray:ByteArray = new ByteArray();
		return byteArray;


	}

	private static function getAreaBitmapData():BitmapData
	{
		return new BitmapData(2,2);
	}

	public static function get ready():Boolean
	{
		return Math.abs(startX - endX) > 0 && Math.abs(startY - endY) > 0;
	}

	public static function get areaWidth():int
	{
		return Math.abs(startX - endX);
	}

	public static function get areaHeight():int
	{
		return Math.abs(startY - endY);
	}
}
}

