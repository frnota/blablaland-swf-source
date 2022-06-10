// version 467 by nota

//map.SnowEffect

package map{
    import flash.display.MovieClip;

    public class SnowEffect {

        public var itemList:Array;
        public var temperature:Number;

        public function SnowEffect(){
            this.itemList = new Array();
            this.temperature = 0.6;
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

        public function redraw():*{
            var _local_1:Number;
            var _local_3:Number;
            var _local_2:Number = this.temperature;
            _local_1 = 0;
            while (_local_1 < this.itemList.length) {
                _local_3 = Math.round((((this.itemList[_local_1].totalFrames - 1) * _local_2) + 1));
                if (_local_3 != this.itemList[_local_1].currentFrame){
                    this.itemList[_local_1].gotoAndStop(_local_3);
                };
                _local_1++;
            };
        }


    }
}//package map

