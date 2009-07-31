package com.aemon.observer {

	import flash.events.*;

	public class Obs{

		public static function es(dispatcher:IEventDispatcher, eventType:String):IObservable{
			return new EventDispatcherAdaptor(dispatcher, eventType);
		}

		public static function f(f:Function, g:Function = null):IObserver{
			return new BasicObserver(f, g);
		}

	}

}

import flash.events.*;
import com.aemon.observer.*;

class EventDispatcherAdaptor extends BasicObservable {

	private var _eventType:String;
	private var _dispatcher:IEventDispatcher;

	public function EventDispatcherAdaptor(dispatcher:IEventDispatcher, eventType:String):void {
		_dispatcher = dispatcher;
		_eventType = eventType;
		_attached = [];
	}

	override public function attach(f:IObserver):void{
		_dispatcher.addEventListener(_eventType, f.next);
		_attached.push(f);
	}

	override public function unattach(f:IObserver):void{
		_dispatcher.removeEventListener(_eventType, f.next);
		var i:int = _attached.indexOf(f);
		if(i > -1) _attached.splice(i, 1);
	}

	override public function close():void{
		for each(var ea:IObserver in _attached){
			_dispatcher.removeEventListener(_eventType, ea.next);
			ea.complete();
		}
		_attached = [];
	}


}