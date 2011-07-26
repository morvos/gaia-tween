package gaia.demo.tween
{
	import gaia.demo.util.DemoRandom;
	import gaia.lib.time.PausableTime;
	import gaia.lib.time.pause.IntrinsicTimeStrategy;
	import gaia.lib.tween.Tween;
	import gaia.lib.tween.Tweens;
	import gaia.lib.tween.easing.Quad;
	import gaia.lib.tween.form.color.SimpleColorTweenForm;
	import gaia.lib.tween.form.manager.TweenOverlapManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="800", height="600")]
	public class ColorDemo extends Sprite
	{
		private static const SIZE:uint = 40;
		
		private var _time:PausableTime;
		private var _random:DemoRandom;
		private var _manager:TweenOverlapManager;
		
		private var _grid:Vector.<Sprite>;
		private var _count:uint;
		private var _tweens:Tweens;
		
		private var _forms:Vector.<SimpleColorTweenForm>;
		
		private var _tween:Tween;
		
		public function ColorDemo()
		{
			_time = new PausableTime(new IntrinsicTimeStrategy());
			_time.pause();
			
			_random = new DemoRandom(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_manager = new TweenOverlapManager();
			
			_grid = generateGrid();
			_count = _grid.length;
			_tweens = new Tweens(_time, _count);
			_forms = generateForms();
			
			restart();
			
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}

		private function onMouseOver(event:MouseEvent):void
		{
			_time.resume();
		}

		private function onMouseLeave(event:Event):void
		{
			_time.pause();
		}
		
		private function restart(t:Tween = null):void
		{
			var i:int = _count;
			while (i--)
			{
				var form:SimpleColorTweenForm = _forms[i];
				form.color = _random.nextColor();
				_tween = _tweens.add(form, 1000, 0, Quad.easeInOut);
			}
			
			_tween.completed.addOnce(restart);
		}
		
		private function generateForms():Vector.<SimpleColorTweenForm>
		{
			var forms:Vector.<SimpleColorTweenForm> = new Vector.<SimpleColorTweenForm>(_count, true);
			
			var i:int = _count;
			while (i--)
				forms[i] = new SimpleColorTweenForm(_grid[i], 0, _manager);
			
			return forms;
		}
		
		private function generateGrid():Vector.<Sprite>
		{
			var xx:uint = 800 / SIZE;
			var yy:uint = 600 / SIZE;

			var grid:Vector.<Sprite> = new Vector.<Sprite>();
			
			for (var x:int = 0; x < xx; x++)
			{
				for (var y:int = 0; y < yy; y++)
					grid.push(generateSquare(x, y));
			}
			
			return grid;
		}

		private function generateSquare(x:int, y:int):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.drawRect(0, 0, SIZE, SIZE);
			s.graphics.endFill();

			var t:ColorTransform = s.transform.colorTransform;
			t.color = _random.nextColor();
			s.transform.colorTransform = t;
			
			s.x = x * SIZE;
			s.y = y * SIZE;
			
			addChild(s);
			return s;
		}
		
	}
}
