// version 467 by nota

//map.LightEffect

package map{
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;

    public class LightEffect {

        public var itemList:Array;
        public var dayTime:Number;
        public var temperature:Number;
        public var stormy:Number;
        public var cloudDensity:Number;
        public var lastColorTransform:ColorTransform;
        public var lastUnColorTransform:ColorTransform;

        public function LightEffect(){
            this.itemList = new Array();
            this.temperature = 0.6;
            this.stormy = 0;
            this.cloudDensity = 0.2;
            this.dayTime = 0.4;
        }

        public function dispose():*{
            this.clearAllItem();
        }

        public function clearAllItem():*{
            var _local_1:LightEffectItem;
            while (this.itemList.length) {
                _local_1 = this.itemList.pop();
                if (_local_1.target){
                    _local_1.target.transform.colorTransform = new ColorTransform();
                };
            };
        }

        public function addItem(_arg_1:DisplayObject):LightEffectItem{
            var _local_2:LightEffectItem = new LightEffectItem();
            _local_2.target = _arg_1;
            _local_2.system = this;
            this.itemList.push(_local_2);
            return (_local_2);
        }

        public function removeItemByTarget(_arg_1:DisplayObject):*{
            var _local_3:LightEffectItem;
            var _local_2:* = 0;
            while (_local_2 < this.itemList.length) {
                _local_3 = this.itemList[_local_2];
                if (_local_3.target == _arg_1){
                    _arg_1.transform.colorTransform = new ColorTransform();
                    this.itemList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function redraw():*{
            var _local_4:ColorTransform;
            var _local_5:Number;
            var _local_1:Number = Math.pow(Math.sin((this.dayTime * Math.PI)), 2);
            var _local_2:Number = ((_local_1 * 0.5) + 0.5);
            var _local_3:ColorTransform = new ColorTransform(_local_2, _local_2, _local_2, 1, 0, 0, 0, 0);
            if (this.temperature < 0.5){
                _local_5 = (1 - (this.temperature * 2));
                _local_4 = new ColorTransform(1, 1, ((_local_5 * 0.3) + 1), 1, 0, 0, 0, 0);
            }
            else {
                _local_5 = ((this.temperature - 0.5) * 2);
                _local_4 = new ColorTransform((1 + (_local_5 * 0.1)), 1, 1, 1, 0, 0, 0, 0);
            };
            _local_2 = ((((this.stormy * 0.6) * Math.pow(this.cloudDensity, 2)) * 1.6) * -50);
            _local_2 = (_local_2 * ((_local_1 * 0.4) + 0.6));
            var _local_6:ColorTransform = new ColorTransform(1, 1, 1, 1, _local_2, _local_2, _local_2, 0);
            _local_3.concat(_local_4);
            _local_3.concat(_local_6);
            this.lastColorTransform = _local_3;
            var _local_7:* = new ColorTransform();
            var _local_8:* = new ColorTransform();
            _local_7.redMultiplier = (1 / _local_3.redMultiplier);
            _local_7.greenMultiplier = (1 / _local_3.greenMultiplier);
            _local_7.blueMultiplier = (1 / _local_3.blueMultiplier);
            _local_8.redOffset = -(_local_3.redOffset);
            _local_8.greenOffset = -(_local_3.greenOffset);
            _local_8.blueOffset = -(_local_3.blueOffset);
            _local_7.concat(_local_8);
            this.lastUnColorTransform = _local_7;
            var _local_9:uint;
            while (_local_9 < this.itemList.length) {
                this.itemList[_local_9].redraw();
                _local_9++;
            };
        }


    }
}//package map

