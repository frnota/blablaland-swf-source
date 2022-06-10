// version 467 by nota

//engine.SyncSteper

package engine{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class SyncSteper extends EventDispatcher {

        public var rate:Number;
        private var _clock:SyncSteperClock;

        public function SyncSteper(){
            this.rate = 128;
            this._clock = null;
        }

        public function dispose():*{
            if (this._clock){
                this._clock.removeEventListener("onStep", this.step, false);
                this._clock = null;
            };
        }

        public function step(_arg_1:Event):*{
            dispatchEvent(new Event("onUnsyncStep"));
            if (((this._clock) && (this.rate))){
                if ((this._clock.counter % this.rate) == 0){
                    dispatchEvent(new Event("onStep"));
                };
            };
        }

        public function get clock():SyncSteperClock{
            return (this._clock);
        }

        public function set clock(_arg_1:SyncSteperClock):*{
            if (this._clock){
                this._clock.removeEventListener("onStep", this.step, false);
                this._clock = null;
            };
            if (_arg_1){
                this._clock = _arg_1;
                this._clock.addEventListener("onStep", this.step, false, 0, true);
            };
        }


    }
}//package engine

