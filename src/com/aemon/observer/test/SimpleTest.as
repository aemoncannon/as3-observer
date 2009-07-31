package com.aemon.observer.test{
	import flexunit.framework.TestCase;
 	import flexunit.framework.TestSuite;
	import flash.utils.*;
	import com.aemon.observer.*;


	public class SimpleTest extends RichTestCase {
		
		public function testMouseDrag():void{
			var mouseDown:BasicObservable = new BasicObservable();
			var mouseMove:BasicObservable = new BasicObservable();
			var mouseUp:BasicObservable = new BasicObservable();
			
			var mouseDrag:IObservable = mouseDown.selectMany(function(ea:String):IObservable{
					return mouseMove.until(mouseUp).select(function(ea:String):String{ return "mouseDrag"; });
				});

			var dragCount:int = 0;
			mouseDrag.attach(Obs.f(function(ea:String):void{
						dragCount += 1; 
					}));

			mouseDown.next("mouseDown");
			mouseMove.next("mouseMove");
			mouseMove.next("mouseMove");
			mouseMove.next("mouseMove");
			mouseMove.next("mouseMove");
			mouseUp.next("mouseUp");

			assertEquals("Should have been 4 drag events.", 4, dragCount);

			mouseMove.next("mouseMove");
			mouseMove.next("mouseMove");

			assertEquals("Should STILL be 4 drag events.", 4, dragCount);

			mouseMove.next("mouseMove");
			mouseMove.next("mouseMove");
			mouseDown.next("mouseDown");
			mouseMove.next("mouseMove");
			mouseUp.next("mouseUp");

			assertEquals("Should now be 5 drag events.", 5, dragCount);
		}

	}

}