package gaia.lib.tween
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertNotNull;
	import asunit.asserts.fail;
	import asunit.framework.Async;

	import gaia.lib.time.SimpleTime;
	import gaia.lib.time.Time;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TweensTest
	{
		
		private var time:Time;
		private var tweens:Tweens;
		private var mock:MockTweenForm;
		private var alt:MockTweenForm;
		private var tween:Tween;
		private var count:uint;
		
		[Inject]
		public var async:Async;
		
		[Before]
		public function before():void
		{
			time = new SimpleTime();
			tweens = new Tweens(time, 20);
			count = 0;
		}
		
		[After]
		public function after():void
		{
			time = null;
			tweens = null;
		}
		
		[Test]
		public function can_add_a_tween():void
		{
			mock = new MockTweenForm("a");
			tween = tweens.add(mock, 100);
			assertNotNull(tween);
		}
		
		[Test]
		public function on_adding_a_tween_progresses():void
		{
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, async.add(onTimerComplete, 220));
			timer.start();
			
			mock = new MockTweenForm("a");
			tween = tweens.add(mock, 100);
		}
		private function onTimerComplete(event:TimerEvent):void
		{
			assertEquals(1, mock.proportion);
		}
		
		[Test]
		public function when_a_tween_completes_it_notifies_listeners():void
		{
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, async.add(onTimerComplete2, 300));
			timer.start();
			
			mock = new MockTweenForm("a");
			tweens.add(mock, 100).completed.addOnce(onSignalCompleted);
		}
		private function onSignalCompleted(tween:Tween):void
		{
			++count;
		}
		private function onTimerComplete2(event:TimerEvent):void
		{
			assertEquals(1, count);
		}
		
		[Test]
		public function a_cancelled_tween_does_not_complete():void
		{
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, async.add(onTimerComplete3, 220));
			timer.start();
			
			mock = new MockTweenForm("a");
			tween = tweens.add(mock, 100);
			tween.completed.addOnce(onSignalCompleted2);
			tween.cancel();
		}
		private function onSignalCompleted2(tween:Tween):void
		{
			fail("this signal should not be called");
		}
		private function onTimerComplete3(event:TimerEvent):void
		{
			// pass
		}
		
		[Test]
		public function the_tween_form_is_accessible_in_the_notification_handler():void
		{
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, async.add(onTimerComplete4, 220));
			timer.start();
			
			mock = new MockTweenForm("a");
			tweens.add(mock, 100).completed.addOnce(onSignalCompleted3);
		}
		private function onSignalCompleted3(tween:Tween):void
		{
			if (mock == tween.form)
				++count;
		}
		private function onTimerComplete4(event:TimerEvent):void
		{
			assertEquals(1, count);
		}
		
		[Test]
		public function tweens_that_complete_together_can_reinitialize_together():void
		{
			var timer:Timer = new Timer(300, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, async.add(onTimerComplete5, 320));
			timer.start();
			
			mock = new MockTweenForm("a");
			alt = new MockTweenForm("b");
			tweens.add(mock, 100).completed.addOnce(onSignalCompleted4);
			tweens.add(alt, 100);
		}
		private function onSignalCompleted4(tween:Tween):void
		{
			tweens.add(mock, 100);
			tweens.add(alt, 100);
		}
		private function onTimerComplete5(event:TimerEvent):void
		{
			// pass
		}
		
	}
	
}
