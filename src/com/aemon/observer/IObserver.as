package com.aemon.observer {

	public interface IObserver{

		function complete():void;
		function next(ea:*):void;

	}
}