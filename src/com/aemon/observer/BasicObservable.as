package com.aemon.observer{

	public class BasicObservable implements IObservable{

		protected var _attached:Array;

		public function BasicObservable():void{
			_attached = [];
		}

		public function selectMany(f:Function /* T -> IObservable */ ):IObservable{
			var newO:BasicObservable = new BasicObservable();
			var eaO:IObservable;
			var watcher:IObserver = new BasicObserver(
				function(ea:*):void{
					if(eaO) eaO.close();
					eaO = IObservable(f(ea));
					eaO.attach(new BasicObserver(newO.next));
				},
				newO.close
			);
			this.attach(watcher);
			return newO;
		}

		public function select(f:Function /* T -> Q */ ):IObservable{
			var newO:BasicObservable = new BasicObservable();
			var watcher:IObserver = new BasicObserver(
				function(ea:*):void{
					newO.next(f(ea));
				},
				newO.close
			);
			this.attach(watcher);
			return newO;
		}

		public function until(o:IObservable):IObservable{
			var newO:IObservable = BasicObservable.echo(this);
			var watcher:BasicObserver = new BasicObserver();
			watcher.nextF = function(ea:*):void{
				o.unattach(watcher);
				newO.close();
			};
			watcher.completeF = function(ea:*):void{
				newO.close();
			};
			o.attach(watcher);
			return newO;
		}

		public function next(o:*):void{
			for each(var ea:IObserver in _attached){
				ea.next(o);
			}
		}

		public function attach(f:IObserver):void{
			_attached.push(f);
		}

		public function unattach(f:IObserver):void{
			var i:int = _attached.indexOf(f);
			if(i > -1) _attached.splice(i, 1);
		}

		public function close():void{
			for each(var ea:IObserver in _attached){
				ea.complete();
			}
			_attached = [];
		}

		public static function echo(o:IObservable):IObservable{
			var newO:BasicObservable = new BasicObservable();
			o.attach(new BasicObserver(newO.next, newO.close));
			return newO;
		}

	}
}