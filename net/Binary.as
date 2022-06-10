// version 467 by nota

//net.Binary

package net{
    import flash.utils.ByteArray;

    public class Binary extends ByteArray {

        public static var powList:Array;
        public static var __init:Boolean = _init();

        public var bitLength:Number;
        public var bitPosition:Number;

        public function Binary(){
            this.bitLength = 0;
            this.bitPosition = 0;
        }

        public static function _init():Boolean{
            powList = new Array();
            var _local_1:uint;
            while (_local_1 <= 32) {
                powList.push(Math.pow(2, _local_1));
                _local_1++;
            };
            return (true);
        }


        public function getDebug():String{
            var _local_1:Array = new Array();
            _local_1.push(this.bitPosition);
            _local_1.push(this.bitLength);
            var _local_2:uint;
            while (_local_2 < length) {
                _local_1.push(this[_local_2].toString());
                _local_2++;
            };
            return (_local_1.join("="));
        }

        public function setDebug(_arg_1:String):*{
            var _local_2:Array = _arg_1.split("=");
            this.bitPosition = _local_2[0];
            this.bitLength = _local_2[1];
            var _local_3:uint = 2;
            while (_local_3 < _local_2.length) {
                this.writeByte(Number(_local_2[_local_3]));
                _local_3++;
            };
        }

        public function bitReadString():String{
            var _local_4:uint;
            var _local_1:* = "";
            var _local_2:* = this.bitReadUnsignedInt(16);
            var _local_3:* = 0;
            while (_local_3 < _local_2) {
                _local_4 = this.bitReadUnsignedInt(8);
                if (_local_4 == 0xFF){
                    _local_4 = 8364;
                };
                _local_1 = (_local_1 + String.fromCharCode(_local_4));
                _local_3++;
            };
            return (_local_1);
        }

        public function bitReadBoolean():Boolean{
            if (this.bitPosition == this.bitLength){
                return (false);
            };
            var _local_1:* = Math.floor((this.bitPosition / 8));
            var _local_2:* = (this.bitPosition % 8);
            this.bitPosition++;
            return (((this[_local_1] >> (7 - _local_2)) & 0x01) == 1);
        }

        public function bitReadUnsignedInt(_arg_1:Number):Number{
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:*;
            var _local_7:*;
            var _local_8:Number;
            if ((this.bitPosition + _arg_1) > this.bitLength){
                this.bitPosition = this.bitLength;
                return (0);
            };
            var _local_2:* = 0;
            var _local_3:Number = _arg_1;
            while (_local_3 > 0) {
                _local_4 = Math.floor((this.bitPosition / 8));
                _local_5 = (this.bitPosition % 8);
                _local_6 = (8 - _local_5);
                _local_7 = Math.min(_local_6, _local_3);
                _local_8 = ((this[_local_4] >> (_local_6 - _local_7)) & (powList[_local_7] - 1));
                _local_2 = (_local_2 + (_local_8 * powList[(_local_3 - _local_7)]));
                _local_3 = (_local_3 - _local_7);
                this.bitPosition = (this.bitPosition + _local_7);
            };
            return (_local_2);
        }

        public function bitReadSignedInt(_arg_1:Number):Number{
            var _local_2:Boolean = this.bitReadBoolean();
            return (this.bitReadUnsignedInt((_arg_1 - 1)) * ((_local_2) ? 1 : -1));
        }

        public function bitReadBinaryData():Binary{
            var _local_1:* = this.bitReadUnsignedInt(16);
            return (this.bitReadBinary(_local_1));
        }

        public function bitReadBinary(_arg_1:uint):Binary{
            var _local_4:uint;
            var _local_5:uint;
            var _local_2:Binary = new Binary();
            var _local_3:uint = this.bitPosition;
            while ((this.bitPosition - _local_3) < _arg_1) {
                if (this.bitPosition == this.bitLength){
                    return (_local_2);
                };
                _local_5 = Math.min(8, ((_arg_1 - this.bitPosition) + _local_3));
                _local_2.bitWriteUnsignedInt(_local_5, this.bitReadUnsignedInt(_local_5));
            };
            return (_local_2);
        }

        public function bitWriteString(_arg_1:String):void{
            var _local_4:uint;
            var _local_2:* = Math.min(_arg_1.length, (powList[16] - 1));
            this.bitWriteUnsignedInt(16, _local_2);
            var _local_3:* = 0;
            while (_local_3 < _local_2) {
                _local_4 = _arg_1.charCodeAt(_local_3);
                if (_local_4 == 8364){
                    _local_4 = 0xFF;
                };
                this.bitWriteUnsignedInt(8, _local_4);
                _local_3++;
            };
        }

        public function bitWriteSignedInt(_arg_1:Number, _arg_2:Number):void{
            this.bitWriteBoolean((_arg_2 >= 0));
            this.bitWriteUnsignedInt((_arg_1 - 1), Math.abs(_arg_2));
        }

        public function bitWriteUnsignedInt(_arg_1:Number, _arg_2:Number):void{
            var _local_4:Number;
            var _local_5:*;
            var _local_6:*;
            var _local_7:Number;
            _arg_2 = Math.min((powList[_arg_1] - 1), _arg_2);
            var _local_3:Number = _arg_1;
            while (_local_3 > 0) {
                _local_4 = (this.bitLength % 8);
                if (_local_4 == 0){
                    writeBoolean(false);
                };
                _local_5 = (8 - _local_4);
                _local_6 = Math.min(_local_5, _local_3);
                _local_7 = this.Rshift(_arg_2, Number((_local_3 - _local_6)));
                this[(this.length - 1)] = (this[(this.length - 1)] + (_local_7 * powList[(_local_5 - _local_6)]));
                _arg_2 = (_arg_2 - (_local_7 * powList[(_local_3 - _local_6)]));
                _local_3 = (_local_3 - _local_6);
                this.bitLength = (this.bitLength + _local_6);
            };
        }

        public function bitWriteUnsignedIntOLD(_arg_1:Number, _arg_2:Number):void{
            _arg_2 = Math.min((powList[_arg_1] - 1), Math.abs(_arg_2));
            var _local_3:* = _arg_2.toString(2);
            while (_local_3.length < _arg_1) {
                _local_3 = ("0" + _local_3);
            };
            var _local_4:* = 0;
            while (_local_4 < _arg_1) {
                this.bitWriteBoolean((_local_3.charAt(_local_4) == "1"));
                _local_4++;
            };
        }

        public function bitWriteBoolean(_arg_1:Boolean):void{
            var _local_2:Number = (this.bitLength % 8);
            if (_local_2 == 0){
                writeBoolean(false);
            };
            if (_arg_1){
                this[(this.length - 1)] = (this[(this.length - 1)] + powList[(7 - _local_2)]);
            };
            this.bitLength++;
        }

        public function bitWriteBinaryData(_arg_1:Binary):void{
            var _local_2:* = Math.min(_arg_1.bitLength, (powList[16] - 1));
            this.bitWriteUnsignedInt(16, _local_2);
            this.bitWriteBinary(_arg_1);
        }

        public function bitWriteBinary(_arg_1:Binary):void{
            var _local_3:uint;
            var _local_4:uint;
            _arg_1.bitPosition = 0;
            var _local_2:uint = _arg_1.bitLength;
            while (_local_2) {
                _local_3 = Math.min(8, _local_2);
                _local_4 = _arg_1.bitReadUnsignedInt(_local_3);
                this.bitWriteUnsignedInt(_local_3, _local_4);
                _local_2 = (_local_2 - _local_3);
            };
        }

        public function bitCopyObject(_arg_1:Object):*{
            this.bitPosition = _arg_1.bitPosition;
            this.bitLength = _arg_1.bitLength;
            _arg_1.position = 0;
            var _local_2:uint;
            while (_local_2 < _arg_1.length) {
                writeByte(_arg_1.readByte());
                _local_2++;
            };
        }

        public function Rshift(_arg_1:Number, _arg_2:int):Number{
            return (Math.floor((_arg_1 / powList[_arg_2])));
        }

        public function Lshift(_arg_1:Number, _arg_2:int):Number{
            return (_arg_1 * powList[_arg_2]);
        }


    }
}//package net

