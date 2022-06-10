// version 467 by nota

//net.Channel

package net{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public class Channel extends EventDispatcher {

        public static var channelList:Object = new Object();
        public static var nextId:uint = 1000;

        public var message:Binary;
        private var _id:uint;

        public function Channel(){
            this._id = 0;
            var _local_1:uint;
            while (((channelList[("id_" + nextId)]) && (_local_1 < 2))) {
                nextId++;
                if (nextId >= 65534){
                    nextId = 1000;
                    _local_1++;
                };
            };
            if (!channelList[("id_" + nextId)]){
                this.id = nextId;
                nextId++;
            };
        }

        public static function clearAll():*{
            nextId = 1000;
            channelList = new Object();
        }

        public static function dispatchMesage(_arg_1:uint, _arg_2:Binary):*{
            var _local_4:uint;
            var _local_5:uint;
            var _local_6:Event;
            var _local_3:Array = channelList[("id_" + _arg_1)];
            if (_local_3){
                _local_3 = _local_3.slice();
                _local_4 = _arg_2.bitPosition;
                _local_5 = 0;
                while (_local_5 < _local_3.length) {
                    _local_6 = new Event("onMessage");
                    _local_3[_local_5].message = _arg_2;
                    _local_3[_local_5].dispatchEvent(_local_6);
                    _arg_2.bitPosition = _local_4;
                    _local_5++;
                };
            };
        }


        public function dispose():*{
            this.id = 0;
        }

        public function get id():uint{
            return (this._id);
        }

        public function set id(_arg_1:uint):*{
            var _local_2:uint;
            var _local_3:Array = channelList[("id_" + this._id)];
            if (((this._id) && (_local_3))){
                _local_2 = 0;
                while (_local_2 < _local_3.length) {
                    if (_local_3[_local_2] == this){
                        _local_3.splice(_local_2, 1);
                        if (!_local_3.length){
                            delete channelList[("id_" + this._id)];
                        };
                        break;
                    };
                    _local_2++;
                };
            };
            this._id = _arg_1;
            if (_arg_1){
                _local_3 = channelList[("id_" + this._id)];
                if (!_local_3){
                    _local_3 = new Array();
                    channelList[("id_" + this._id)] = _local_3;
                };
                _local_3.push(this);
            };
        }


    }
}//package net

