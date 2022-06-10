// version 467 by nota

//engine.SyncTimer

package engine{
    import flash.utils.Timer;
    import flash.events.Event;

    public class SyncTimer extends Timer {

        private var _syncTime:Number;
        private var _delay:Number;
        private var _intervalCount:Number;
        private var _timeOffset:Number;

        public function SyncTimer(_arg_1:Number, _arg_2:int=0){
            super(_arg_1, _arg_2);
            addEventListener("timer", this.timerEvent, false, 0, true);
            this._delay = _arg_1;
            this.syncTime = new Date().getTime();
        }

        public function timerEvent(_arg_1:Event):*{
            var _local_7:*;
            var _local_2:Number = (this._syncTime % this._delay);
            var _local_3:Number = ((new Date().getTime() - (this._syncTime - _local_2)) - this._timeOffset);
            var _local_4:Number = (_local_3 / this._delay);
            var _local_5:Number = Math.floor(_local_4);
            if (this._intervalCount < _local_5){
                _local_7 = 0;
                while (_local_7 < (_local_5 - this._intervalCount)) {
                    this._intervalCount++;
                    dispatchEvent(new Event("syncTimer"));
                    _local_7++;
                };
            };
            var _local_6:int = (this._delay - (_local_3 % this._delay));
            if (this._intervalCount > 1){
                _local_6 = Math.max(Math.min(_local_6, (this._delay + (this._delay * 0.5))), (this._delay - (this._delay * 0.5)));
            };
            super.delay = _local_6;
        }

        override public function reset():void{
            this.resetSync();
            super.reset();
        }

        public function set syncTime(_arg_1:Number):*{
            this._syncTime = _arg_1;
            this._timeOffset = (new Date().getTime() - this._syncTime);
            this.resetSync();
        }

        public function get syncTime():Number{
            return ((this._syncTime - (this._syncTime % this._delay)) + (this._delay * this._intervalCount));
        }

        override public function set delay(_arg_1:Number):void{
            this._delay = _arg_1;
            this.resetSync();
        }

        override public function get delay():Number{
            return (this._delay);
        }

        private function resetSync():*{
            var _local_1:Number = ((new Date().getTime() - (this._syncTime - (this._syncTime % this._delay))) - this._timeOffset);
            this._intervalCount = Math.floor((_local_1 / this._delay));
            super.delay = Math.round((this._delay - (_local_1 % this._delay)));
        }


    }
}//package engine

