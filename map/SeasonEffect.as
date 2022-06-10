// version 467 by nota

//map.SeasonEffect

package map{
    import flash.display.MovieClip;

    public class SeasonEffect {

        public var itemList:Array;
        public var season:Number;

        public function SeasonEffect(){
            this.itemList = new Array();
            this.season = 0;
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
            var _local_2:Number;
            _local_1 = 0;
            while (_local_1 < this.itemList.length) {
                _local_2 = Math.round((((this.itemList[_local_1].totalFrames - 1) * this.season) + 1));
                if (_local_2 != this.itemList[_local_1].currentFrame){
                    this.itemList[_local_1].gotoAndStop(_local_2);
                };
                _local_1++;
            };
        }


    }
}//package map

