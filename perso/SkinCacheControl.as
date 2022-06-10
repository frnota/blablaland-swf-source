// version 467 by nota

//perso.SkinCacheControl

package perso{
    public class SkinCacheControl {

        public var itemList:Array;
        public var scale:Number;
        private var _action:Object;
        private var _step:uint;

        public function SkinCacheControl(){
            this.scale = 1;
            this._action = {"v":0};
            this.itemList = new Array();
            this._step = 0;
        }

        public function addItem():SkinCacheItem{
            var _local_1:* = new SkinCacheItem();
            this.itemList.push(_local_1);
            return (_local_1);
        }

        public function updateCache():*{
            var _local_1:* = 0;
            while (_local_1 < this.itemList.length) {
                this.itemList[_local_1].clearCache();
                this.itemList[_local_1].scale = this.scale;
                this.itemList[_local_1].redraw();
                _local_1++;
            };
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
            var _local_1:* = 0;
            while (_local_1 < this.itemList.length) {
                if (this.itemList[_local_1].parent){
                    this.itemList[_local_1].parent.removeChild(this.itemList[_local_1]);
                };
                this.itemList[_local_1].dispose();
                _local_1++;
            };
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

