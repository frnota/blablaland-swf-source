// version 467 by nota

//bbl.BblObject

package bbl{
    import flash.events.Event;
    import net.SocketMessage;

    public class BblObject extends BblContact {

        public var objectList:Array;
        public var smileyAllowList:Array;

        public function BblObject(){
            this.smileyAllowList = new Array();
            this.smileyAllowList.push(0);
        }

        override public function init():*{
            this.objectList = new Array();
            super.init();
        }

        public function getObjectById(_arg_1:Number):UserObject{
            var _local_2:uint;
            while (_local_2 < this.objectList.length) {
                if (this.objectList[_local_2].id == _arg_1){
                    return (this.objectList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function removeObjectById(_arg_1:Number):*{
            var _local_2:uint;
            while (_local_2 < this.objectList.length) {
                if (this.objectList[_local_2].id == _arg_1){
                    this.objectList[_local_2].dispose();
                    this.objectList.splice(_local_2, 1);
                };
                _local_2++;
            };
        }

        public function userObjectEvent(_arg_1:SocketMessage):*{
            var _local_4:uint;
            var _local_2:Boolean;
            var _local_3:UserObject;
            while (_arg_1.bitReadBoolean()) {
                _local_4 = _arg_1.bitReadUnsignedInt(8);
                if (_local_4 == 0){
                    _local_3 = new UserObject();
                    _local_3.id = _arg_1.bitReadUnsignedInt(32);
                    _local_3.fxFileId = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                    _local_3.objectId = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
                    _local_3.count = _arg_1.bitReadUnsignedInt(32);
                    _local_3.expire = (_arg_1.bitReadUnsignedInt(32) * 1000);
                    _local_3.visibility = _arg_1.bitReadUnsignedInt(3);
                    _local_3.genre = _arg_1.bitReadUnsignedInt(5);
                    _local_3.data = _arg_1.bitReadBinaryData();
                    this.objectList.push(_local_3);
                    _local_2 = true;
                }
                else {
                    if (_local_4 == 1){
                        _local_3 = this.getObjectById(_arg_1.bitReadUnsignedInt(32));
                        if (_local_3){
                            _local_3.count = _arg_1.bitReadUnsignedInt(32);
                            _local_3.expire = (_arg_1.bitReadUnsignedInt(32) * 1000);
                            _local_3.data = _arg_1.bitReadBinaryData();
                            _local_3.dispatchEvent(new Event("onChanged"));
                        };
                    };
                };
            };
            if (_local_2){
                this.dispatchEvent(new Event("onObjectListChange"));
            };
        }


    }
}//package bbl

