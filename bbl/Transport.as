// version 467 by nota

//bbl.Transport

package bbl{
    import engine.TimeValue;
    import map.ServerMap;
    import engine.TimeValueItem;
    import net.Binary;

    public class Transport {

        public var id:uint;
        public var mapTimeValue:TimeValue;
        public var mapList:Array;
        public var periode:uint;

        public function Transport(){
            this.id = 0;
            this.periode = 0;
            this.mapTimeValue = new TimeValue();
            this.mapList = new Array();
        }

        public function getMapTimeLeftAt(_arg_1:uint, _arg_2:Number):Number{
            var _local_6:ServerMap;
            var _local_3:uint = (_arg_2 % this.periode);
            var _local_4:int = -1;
            var _local_5:uint;
            while (_local_5 < this.mapTimeValue.itemList.length) {
                _local_6 = this.mapList[this.mapTimeValue.itemList[_local_5].value];
                if (_local_6.id == _arg_1){
                    if (_local_4 < 0){
                        _local_4 = this.mapTimeValue.itemList[_local_5].time;
                    };
                    if (this.mapTimeValue.itemList[_local_5].time > _local_3){
                        if (_local_5 > 0){
                            if (this.mapList[this.mapTimeValue.itemList[(_local_5 - 1)].value].id == _arg_1){
                                return (0);
                            };
                        };
                        return (this.mapTimeValue.itemList[_local_5].time - _local_3);
                    };
                };
                _local_5++;
            };
            return ((_local_4 + this.periode) - _local_3);
        }

        public function getMapDistanceAt(_arg_1:uint, _arg_2:Number):Number{
            var _local_3:uint = (_arg_2 % this.periode);
            var _local_4:Number = this.mapTimeValue.getValue(_local_3);
            var _local_5:ServerMap = this.mapList[Math.floor(_local_4)];
            var _local_6:ServerMap = this.mapList[Math.ceil(_local_4)];
            if (_local_5.id == _arg_1){
                return (_local_4 - Math.floor(_local_4));
            };
            if (_local_6.id == _arg_1){
                return (Math.ceil(_local_4) - _local_4);
            };
            return (1);
        }

        public function readBinary(_arg_1:Binary):*{
            var _local_3:uint;
            var _local_4:ServerMap;
            var _local_5:TimeValueItem;
            this.id = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID);
            var _local_2:uint;
            while (_arg_1.bitReadBoolean()) {
                _local_3 = _arg_1.bitReadUnsignedInt(4);
                if (_local_3 == 0){
                    while (_arg_1.bitReadBoolean()) {
                        _local_4 = new ServerMap();
                        _local_4.id = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                        this.mapList.push(_local_4);
                    };
                }
                else {
                    if (_local_3 == 1){
                        while (_arg_1.bitReadBoolean()) {
                            _local_5 = this.mapTimeValue.addItem();
                            _local_2 = (_local_2 + (_arg_1.bitReadUnsignedInt(10) * 1000));
                            _local_5.time = _local_2;
                            _local_5.value = _arg_1.bitReadUnsignedInt(5);
                        };
                    };
                };
            };
            this.periode = _local_2;
        }


    }
}//package bbl

