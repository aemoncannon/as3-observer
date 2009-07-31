package com.aemon.observer {
	public interface IObservable{

		function selectMany(f:Function /* T -> IObservable */ ):IObservable;
		function select(f:Function /* T -> Q */ ):IObservable;
		function until(o:IObservable):IObservable;
		function attach(f:IObserver):void;
		function unattach(f:IObserver):void;
		function close():void;

	}
}