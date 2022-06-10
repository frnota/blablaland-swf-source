// version 467 by nota

//perso.SkinFrameControl

package perso{
    public class SkinFrameControl {

        public var itemList:Array;
        private var _action:Object;
        private var _step:uint;

        public function SkinFrameControl(){
            this.itemList = new Array();
            this._step = 0;
        }

        public function addItem():SkinFrameItem{
            var _local_1:* = new SkinFrameItem();
            this.itemList.push(_local_1);
            return (_local_1);
        }

        public function nextFrame():*{
            var _local_1:*;
            if (this._step >= 2){
                _local_1 = 0;
                while (_local_1 < this.itemList.length) {
                    this.itemList[_local_1].nextFrame();
                    _local_1++;
                };
                this._step = 0;
            };
            this._step++;
        }

        public function removeAllItem():*{
            this.itemList.splice(0, this.itemList.length);
        }

        public function get action():uint{
            return (this._action.v);
        }

        public function set action(_arg_1:uint):*{
            this._action = {"v":_arg_1};
            this._step = 0;
            var _local_2:* = 0;
            while (_local_2 < this.itemList.length) {
                this.itemList[_local_2].action = _arg_1;
                _local_2++;
            };
        }


    }
}//package perso

