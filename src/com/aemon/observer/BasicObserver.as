package com.aemon.observer {

	public class BasicObserver implements IObserver{

		private var _nextF:Function;
		public function set nextF(val:Function):void { _nextF = val; }

		private var _completeF:Function;
		public function set completeF(val:Function):void { _completeF = val; }

		public function BasicObserver(nextF:Function = null, completeF:Function = null):void{
			_nextF = nextF || function(ea:*):void{};
			_completeF = completeF || function():void{};
		}

		public function complete():void{
			_completeF();
		}
		public function next(ea:*):void{
			_nextF(ea);
		}

	}
}