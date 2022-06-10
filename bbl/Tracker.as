// version 467 by nota

//bbl.Tracker

package bbl{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class Tracker extends EventDispatcher {

        public var ip:uint;
        public var uid:uint;
        public var pid:uint;
        public var mapInform:Boolean;
        public var msgInform:Boolean;
        private var _trackerInstance:BblTrackerInstance;

        public function Tracker(_arg_1:*, _arg_2:*=0, _arg_3:*=0, _arg_4:*=false, _arg_5:*=false){
            this.ip = _arg_1;
            this.uid = _arg_2;
            this.pid = _arg_3;
            this.mapInform = _arg_4;
            this.msgInform = _arg_5;
        }

        public function trackerEvent(_arg_1:Event):*{
            this.dispatchEvent(new Event(_arg_1.type));
        }

        public function get trackerInstance():BblTrackerInstance{
            return (this._trackerInstance);
        }

        public function set trackerInstance(_arg_1:BblTrackerInstance):*{
            if (_arg_1){
                _arg_1.addEventListener("onChanged", this.trackerEvent, false, 0, true);
                _arg_1.addEventListener("onMessage", this.trackerEvent, false, 0, true);
                _arg_1.addEventListener("onTextEvent", this.trackerEvent, false, 0, true);
            }
            else {
                if (this._trackerInstance){
                    this._trackerInstance.removeEventListener("onChanged", this.trackerEvent, false);
                    this._trackerInstance.removeEventListener("onMessage", this.trackerEvent, false);
                };
            };
            this._trackerInstance = _arg_1;
        }

        public function get userList():Array{
            if (this._trackerInstance){
                return (this._trackerInstance.userList);
            };
            return (new Array());
        }

        public function get trackerId():uint{
            if (this._trackerInstance){
                return (this._trackerInstance.id);
            };
            return (0);
        }

        public function get textEventList():Array{
            if (this._trackerInstance){
                return (this._trackerInstance.textEventList);
            };
            return (new Array());
        }

        public function get textEventLast():String{
            if (this._trackerInstance){
                return (this._trackerInstance.textEventLast);
            };
            return (null);
        }


    }
}//package bbl

