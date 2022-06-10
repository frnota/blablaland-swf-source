// version 467 by nota

//map.FogEffect

package map{
    import flash.display.Sprite;

    public class FogEffect {

        public var itemList:Array;
        public var screenWidth:Number;
        public var screenHeight:Number;
        public var fogDensity:Number;

        public function FogEffect(){
            this.itemList = new Array();
            this.screenWidth = 100;
            this.screenHeight = 100;
            this.fogDensity = 0;
        }

        public function dispose():*{
            this.clearAllItem();
        }

        public function clearAllItem():*{
            this.itemList.splice(0, this.itemList.length);
        }

        public function addItem(_arg_1:Sprite, _arg_2:Number):FogEffectItem{
            var _local_3:FogEffectItem = new FogEffectItem();
            _local_3.target = _arg_1;
            _local_3.plan = _arg_2;
            _local_3.screenWidth = this.screenWidth;
            _local_3.screenHeight = this.screenHeight;
            _local_3.init();
            this.itemList.push(_local_3);
            return (_local_3);
        }

        public function redraw():*{
            var _local_1:* = 0.3;
            var _local_2:uint;
            var _local_3:Number = 0;
            while (_local_3 < this.itemList.length) {
                _local_2 = Math.max(_local_2, this.itemList[_local_3].plan);
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < this.itemList.length) {
                this.itemList[_local_3].target.getChildAt(0).alpha = ((this.fogDensity * 0.4) * (((this.itemList[_local_3].plan / _local_2) * _local_1) + (1 - _local_1)));
                _local_3++;
            };
        }


    }
}//package map

