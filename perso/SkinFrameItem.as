// version 467 by nota

//perso.SkinFrameItem

package perso{
    import flash.display.Sprite;
    import flash.display.MovieClip;

    public class SkinFrameItem extends Sprite {

        private var _target:MovieClip;
        private var _action:Object;
        private var _actionObj:Object;
        private var _labelMemory:Object;
        public var curPos:uint;

        public function SkinFrameItem(){
            this.curPos = 0;
            this._action = {"v":0};
            this._actionObj = null;
        }

        public function set action(_arg_1:uint):*{
            this._action = {"v":_arg_1};
            this.curPos = 0;
            this._actionObj = this._labelMemory[_arg_1];
            if (this._actionObj){
                this._target.gotoAndStop(this._actionObj.startAt);
            };
        }

        public function nextFrame():*{
            if (((this._actionObj) && (!(this._actionObj.startAt == this._actionObj.endAt)))){
                this.curPos++;
                if ((this._actionObj.startAt + this.curPos) > this._actionObj.endAt){
                    this.curPos = 0;
                };
                this._target.gotoAndStop((this._actionObj.startAt + this.curPos));
            };
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
            var _local_2:Object;
            var _local_3:* = 0;
            while (_local_3 < this._target.currentLabels.length) {
                _local_4 = this._target.currentLabels[_local_3].name.split("action_");
                if (_local_4.length == 2){
                    _local_5 = new Object();
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

