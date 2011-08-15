package gaia.lib.tween.form
{
	import gaia.lib.tween.Tween;
	import gaia.lib.tween.easing.Ease;
	import gaia.lib.tween.form.manager.ManagedTweenForm;
	import gaia.lib.tween.form.manager.TweenOverlapManager;

	import flash.display.DisplayObject;

	final public class MotionTweenForm implements ManagedTweenForm
	{
		private static const KEYS:Vector.<String> = Vector.<String>(["x","y"]);
		
		private var _subject:DisplayObject;
		private var _manager:TweenOverlapManager;
		
		private var _isDisabled:Boolean;
		
		private var _sx:Number, _sy:Number;
		private var _dx:Number, _dy:Number;
		private var _ex:Number, _ey:Number;
		
		private var _isEase:Boolean;
		private var _ease:Ease;
		private var _ease_fn:Function;
		
		public function MotionTweenForm(subject:DisplayObject, x:Number, y:Number, manager:TweenOverlapManager, ease:Ease = null)
		{
			_subject = subject;
			_manager = manager;
			
			_ex = x;
			_ey = y;
			
			_isEase = ease != null;
			if (_isEase)
			{
				_ease = ease;
				_ease_fn = _ease.fn;
			}
		}
		
		public function set(x:Number, y:Number):void
		{
			_ex = x;
			_ey = y;
			
			if (_isDisabled)
				return;
			
			_sx = _subject.x;
			_sy = _subject.y;
			_dx = _ex - _sx;
			_dy = _ey - _sy;
		}
		
		public function bind(tween:Tween):void
		{
			_manager.bind(_subject, KEYS, this);
			_isDisabled = false;
			
			_sx = _subject.x;
			_sy = _subject.y;
			_dx = _ex - _sx;
			_dy = _ey - _sy;
		}

		public function update(proportion:Number):void
		{
			if (_isDisabled)
				return;
			
			if (_isEase)
				proportion = _ease_fn(proportion);
			
			_subject.x = _sx + proportion * _dx;
			_subject.y = _sy + proportion * _dy;
		}

		public function unbind(tween:Tween):void
		{
			_manager.unbind(_subject, KEYS);
		}

		public function disable(key:String):void
		{
			_isDisabled = true;
		}
	}
}
