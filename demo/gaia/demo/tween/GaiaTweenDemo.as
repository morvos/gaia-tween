package gaia.demo.tween
{
	import gaia.lib.time.SimpleTime;
	import gaia.lib.time.Time;
	import gaia.lib.tween.Tween;
	import gaia.lib.tween.Tweens;
	import gaia.lib.tween.form.property.PropertyTweenForm;
	import gaia.lib.tween.form.property.PropertyTweenMap;
	import gaia.lib.tween.form.property.SimplePropertyTweenForm;
	import gaia.lib.util.Random;

	import flash.display.Sprite;
	
	public class GaiaTweenDemo implements TweenDemo
	{
		
		private static const X:String = "x";
		private static const Y:String = "y";
		
		private var time:Time;
		private var random:Random;
		private var tweens:Tweens;
		private var list:Vector.<Tween>;
		
		private var count:uint;
		private var forms:Vector.<PropertyTweenForm>;
		private var map:PropertyTweenMap;
		
		private var tween:Tween;
		
		public function GaiaTweenDemo()
		{
			time = new SimpleTime();
			random = new Random();
			map = new PropertyTweenMap();
		}
		
		public function init(sprites:Vector.<Sprite>):void
		{
			count = sprites.length;
			tweens = new Tweens(time, count);
			list = new Vector.<Tween>(count, true);
			forms = new Vector.<PropertyTweenForm>(count, true);
			
			var i:int = count;
			while (i--)
			{
				var x:int = random.nextInt(700) + 50;
				var y:int = random.nextInt(500) + 50;
				forms[i] = new SimplePropertyTweenForm(sprites[i], {x:x, y:y}, map);
			}
		}

		public function start():void
		{
			restart();
		}

		public function stop():void
		{
			tween.completed.remove(restart);
			
			var i:int = count;
			while (i--)
				list[i].cancel();
		}

		private function restart(t:Tween = null):void
		{
			var i:int = count;
			while (i--)
			{
				var form:PropertyTweenForm = forms[i];
				form.set(X, random.nextInt(700) + 50);
				form.set(Y, random.nextInt(500) + 50);

				list[i] = tween = tweens.add(form, 1000);
			}
			
			tween.completed.addOnce(restart);
		}
		
	}
}
