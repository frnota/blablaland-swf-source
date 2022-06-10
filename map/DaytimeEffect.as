// version 467 by nota

//map.DaytimeEffect

package map{
    import flash.display.MovieClip;

    public class DaytimeEffect {

        public var itemList:Array;
        public var daytime:Number;

        public function DaytimeEffect(){
            this.itemList = new Array();
            this.daytime = 0.6;
        }

        public function dispose():*{
            this.clearAllItem();
        }

        public function clearAllItem():*{
            this.itemList.splice(0, this.itemList.length);
        }

        public function addItem(_arg_1:MovieClip):*{
            _arg_1.stop();
            this.itemList.push(_arg_1);
        }

        public function removeItem(_arg_1:MovieClip):*{
            var _local_2:Number = 0;
            while (_local_2 < this.itemList.length) {
                if (this.itemList[_local_2] == _arg_1){
                    this.itemList.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
        }

        public function applyTo(_arg_1:MovieClip):*{
            var _local_2:Number = Math.round((((_arg_1.totalFrames - 1) * this.daytime) + 1));
            if (_local_2 != _arg_1.currentFrame){
                _arg_1.gotoAndStop(_local_2);
            };
        }

        public function redraw():*{
            var _local_1:Number = 0;
            while (_local_1 < this.itemList.length) {
                this.applyTo(this.itemList[_local_1]);
                _local_1++;
            };
        }


    }
}//package map

