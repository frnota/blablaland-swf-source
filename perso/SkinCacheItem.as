// version 467 by nota

//perso.SkinCacheItem

package perso{
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

    public class SkinCacheItem extends Bitmap {

        private var _target:MovieClip;
        private var _action:Object;
        private var _actionObj:Object;
        private var _labelMemory:Object;
        private var _firstScaleX:Number;
        private var _firstScaleY:Number;
        public var scale:Number;
        public var curPos:uint;

        public function SkinCacheItem(){
            this.scale = 1;
            this._action = {"v":0};
        }

        public function dispose():*{
            this.clearCache();
            if (this._target){
                this._target.scaleX = this._firstScaleX;
                this._target.scaleY = this._firstScaleY;
            };
        }

        public function clearCache():*{
            var _local_1:*;
            for (_local_1 in this._labelMemory) {
                this.clearCacheObject(this._labelMemory[_local_1]);
            };
        }

        public function clearCacheObject(_arg_1:Object):*{
            var _local_2:*;
            for (_local_2 in _arg_1.cache) {
                _arg_1.cache[_local_2].bitmapData.dispose();
            };
            _arg_1.cache = new Object();
        }

        public function redraw():*{
            var _local_1:Object;
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            if (this._actionObj){
                _local_1 = this._actionObj.cache[this.curPos];
                if (!_local_1){
                    _local_1 = new Object();
                    this._actionObj.cache[this.curPos] = _local_1;
                    this._target.gotoAndStop((this.curPos + this._actionObj.startAt));
                    _local_2 = this._target.getBounds(this._target);
                    _local_1.bitmapData = new BitmapData((Math.ceil((_local_2.width * this.scale)) + 2), (Math.ceil((_local_2.height * this.scale)) + 2), true, 0);
                    _local_3 = new Matrix();
                    _local_3.translate((-(Math.floor(_local_2.left)) + 1), (-(Math.floor(_local_2.top)) + 1));
                    _local_4 = new Matrix();
                    _local_4.scale(this.scale, this.scale);
                    _local_3.concat(_local_4);
                    _local_1.bitmapData.draw(this._target, _local_3);
                    _local_1.x = (Math.floor(_local_2.left) - 1);
                    _local_1.y = (Math.floor(_local_2.top) - 1);
                    _local_1.scaleX = (_local_1.scaleY = (1 / this.scale));
                };
                bitmapData = _local_1.bitmapData;
                x = _local_1.x;
                y = _local_1.y;
                scaleX = (scaleY = _local_1.scaleX);
            };
        }

        public function nextFrame():*{
            if (((this._actionObj) && (!(this._actionObj.startAt == this._actionObj.endAt)))){
                this.curPos++;
                if ((this._actionObj.startAt + this.curPos) > this._actionObj.endAt){
                    this.curPos = 0;
                };
                this.redraw();
            };
        }

        public function get action():uint{
            return (this._action.v);
        }

        public function set action(_arg_1:uint):*{
            this._action = {"v":_arg_1};
            this.curPos = 0;
            this._actionObj = this._labelMemory[_arg_1];
            this.redraw();
        }

        public function get target():MovieClip{
            return (this._target);
        }

        public function set target(_arg_1:MovieClip):*{
            var _local_4:*;
            var _local_5:*;
            this._target = _arg_1;
            this._labelMemory = new Object();
            this._actionObj = null;
            this.curPos = 0;
            this._firstScaleX = _arg_1.scaleX;
            this._firstScaleY = _arg_1.scaleY;
            _arg_1.scaleX = (_arg_1.scaleY = 0.0001);
            var _local_2:Object;
            var _local_3:* = 0;
            while (_local_3 < this._target.currentLabels.length) {
                _local_4 = this._target.currentLabels[_local_3].name.split("action_");
                if (_local_4.length == 2){
                    _local_5 = new Object();
                    _local_5.cache = new Object();
                    _local_5.startAt = this._target.currentLabels[_local_3].frame;
                    if (_local_2){
                        _local_2.endAt = (_local_5.startAt - 1);
                    };
                    this._labelMemory[uint(_local_4[1])] = _local_5;
                    _local_2 = _local_5;
                };
                _local_3++;
            };
            _local_2.endAt = this._target.totalFrames;
        }


    }
}//package perso

