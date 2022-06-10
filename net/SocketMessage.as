// version 467 by nota

//net.SocketMessage

package net{
    import flash.utils.ByteArray;

    public class SocketMessage extends Binary {


        public function duplicate():SocketMessage{
            var _local_1:SocketMessage = new SocketMessage();
            _local_1.writeBytes(this, 0, this.length);
            _local_1.bitLength = bitLength;
            _local_1.bitPosition = bitPosition;
            return (_local_1);
        }

        public function readMessage(_arg_1:ByteArray):*{
            var _local_2:* = 0;
            while (_local_2 < _arg_1.length) {
                if (_arg_1[_local_2] == 1){
                    _local_2++;
                    this.writeByte(((_arg_1[_local_2] == 2) ? 1 : 0));
                }
                else {
                    this.writeByte(_arg_1[_local_2]);
                };
                _local_2++;
            };
            bitLength = (length * 8);
        }

        public function exportMessage():ByteArray{
            var _local_1:* = new ByteArray();
            var _local_2:* = 0;
            while (_local_2 < this.length) {
                if (this[_local_2] == 0){
                    _local_1.writeByte(1);
                    _local_1.writeByte(3);
                }
                else {
                    if (this[_local_2] == 1){
                        _local_1.writeByte(1);
                        _local_1.writeByte(2);
                    }
                    else {
                        _local_1.writeByte(this[_local_2]);
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }


    }
}//package net

