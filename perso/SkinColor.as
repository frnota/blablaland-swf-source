// version 467 by nota

//perso.SkinColor

package perso{
    public class SkinColor {

        public var nbSlot:uint;
        public var color:Array;

        public function SkinColor(){
            this.nbSlot = 10;
            this.color = new Array();
            var _local_1:uint;
            while (_local_1 < this.nbSlot) {
                this.color.push(0);
                _local_1++;
            };
        }

        public function duplicate():SkinColor{
            var _local_1:SkinColor = new SkinColor();
            _local_1.readSkinColor(this);
            return (_local_1);
        }

        public function readSkinColor(_arg_1:SkinColor):*{
            var _local_2:uint;
            while (_local_2 < this.nbSlot) {
                this.color[_local_2] = _arg_1.color[_local_2];
                _local_2++;
            };
        }

        public function setAllColor(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < this.nbSlot) {
                this.color[_local_2] = _arg_1;
                _local_2++;
            };
        }

        public function setValue(_arg_1:Array):*{
            var _local_2:uint;
            while (((_local_2 < _arg_1.length) && (_local_2 < this.nbSlot))) {
                this.color[_local_2] = _arg_1[_local_2];
                _local_2++;
            };
        }

        public function readStringColor(_arg_1:String):*{
            var _local_2:uint;
            while (((_local_2 < this.nbSlot) && (_local_2 < _arg_1.length))) {
                this.color[_local_2] = (_arg_1.charCodeAt(_local_2) - 1);
                _local_2++;
            };
        }

        public function exportStringColor():String{
            var _local_1:* = "";
            var _local_2:uint;
            while (_local_2 < this.nbSlot) {
                _local_1 = (_local_1 + String.fromCharCode((this.color[_local_2] + 1)));
                _local_2++;
            };
            return (_local_1);
        }

        public function readBinaryColor(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this.nbSlot) {
                this.color[_local_2] = _arg_1.bitReadUnsignedInt(8);
                _local_2++;
            };
        }

        public function exportBinaryColor(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this.nbSlot) {
                _arg_1.bitWriteUnsignedInt(8, this.color[_local_2]);
                _local_2++;
            };
        }


    }
}//package perso

