// version 467 by nota

//engine.TimeValue

package engine{
    public class TimeValue {

        public var itemList:Array;
        private var lastIndex:uint;

        public function TimeValue(){
            this.itemList = new Array();
            this.lastIndex = 0;
        }

        public function removeItem(_arg_1:Object):void{
            var _local_2:int = this.itemList.indexOf(_arg_1);
            if (_local_2 >= 0){
                this.itemList.splice(_local_2, 1);
            };
        }

        public function addItem():TimeValueItem{
            var _local_1:* = new TimeValueItem();
            this.itemList.push(_local_1);
            return (_local_1);
        }

        public function clearAllItem():*{
            this.itemList.splice(0, this.itemList.length);
        }

        public function order():*{
            this.itemList.sortOn("time", 16);
        }

        public function getSpeedAt(_arg_1:Number=0):Number{
            var _local_2:* = this.getInterval(_arg_1);
            if (_local_2.length <= 1){
                return (0);
            };
            return ((_local_2[1].value - _local_2[0].value) / ((_local_2[1].time - _local_2[0].time) / 1000));
        }

        public function getValue(_arg_1:Number):Number{
            var _local_3:Number;
            var _local_4:Number;
            var _local_2:* = this.getInterval(_arg_1);
            if (_local_2.length == 0){
                return (0);
            };
            if (_local_2.length == 1){
                return (_local_2[0].value);
            };
            _local_3 = (_local_2[1].value - _local_2[0].value);
            _local_4 = (_local_2[1].time - _local_2[0].time);
            return (((_local_3 * (_arg_1 - _local_2[0].time)) / _local_4) + _local_2[0].value);
        }

        public function getInterval(_arg_1:Number):Array{
            var _local_4:uint;
            var _local_5:*;
            var _local_6:*;
            if (this.itemList.length == 0){
                return ([]);
            };
            if (this.itemList.length == 1){
                return ([this.itemList[0]]);
            };
            if (_arg_1 >= this.itemList[(this.itemList.length - 1)].time){
                this.lastIndex = (this.itemList.length - 1);
                return ([this.itemList[(this.itemList.length - 1)]]);
            };
            if (_arg_1 < this.itemList[0].time){
                this.lastIndex = 0;
                return ([this.itemList[0]]);
            };
            var _local_2:TimeValueItem;
            var _local_3:TimeValueItem;
            if (this.lastIndex >= this.itemList.length){
                this.lastIndex = (this.itemList.length - 1);
            };
            if (this.lastIndex < (this.itemList.length - 1)){
                _local_4 = this.lastIndex;
                while (_local_4 < (this.itemList.length - 1)) {
                    _local_5 = this.itemList[_local_4];
                    _local_6 = this.itemList[(_local_4 + 1)];
                    if (((_local_5.time <= _arg_1) && (_local_6.time > _arg_1))){
                        _local_2 = _local_5;
                        _local_3 = _local_6;
                        this.lastIndex = _local_4;
                        break;
                    };
                    _local_4++;
                };
            };
            if (((this.lastIndex > 0) && (!(_local_2)))){
                _local_4 = (this.lastIndex - 1);
                while (_local_4 >= 0) {
                    _local_5 = this.itemList[_local_4];
                    _local_6 = this.itemList[(_local_4 + 1)];
                    if (((_local_5.time <= _arg_1) && (_local_6.time > _arg_1))){
                        _local_2 = _local_5;
                        _local_3 = _local_6;
                        this.lastIndex = _local_4;
                        break;
                    };
                    _local_4--;
                };
            };
            if (_local_2){
                return ([_local_2, _local_3]);
            };
            return ([]);
        }

        public function getLastValue():Number{
            if (this.itemList.length == 0){
                return (0);
            };
            return (this.itemList[(this.itemList.length - 1)].value);
        }

        public function setSingleValue(_arg_1:Number, _arg_2:Number, _arg_3:Number):*{
            var _local_4:* = this.getValue(_arg_1);
            this.clearAllItem();
            var _local_5:* = this.addItem();
            _local_5.time = _arg_1;
            _local_5.value = _local_4;
            _local_5 = this.addItem();
            _local_5.time = (_arg_1 + _arg_3);
            _local_5.value = _arg_2;
        }


    }
}//package engine

