// version 467 by nota

//map.FogEffectItem

package map{
    import flash.display.Sprite;

    public class FogEffectItem {

        public var target:Sprite;
        public var plan:Number;
        public var screenWidth:Number;
        public var screenHeight:Number;


        public function init():*{
            var _local_1:Sprite = new Sprite();
            this.target.addChild(_local_1);
            _local_1.graphics.lineStyle(0, 0, 0);
            _local_1.graphics.beginFill(0xF0F0F0, 1);
            _local_1.graphics.lineTo(this.screenWidth, 0);
            _local_1.graphics.lineTo(this.screenWidth, this.screenHeight);
            _local_1.graphics.lineTo(0, this.screenHeight);
            _local_1.graphics.lineTo(0, 0);
            _local_1.graphics.endFill();
        }


    }
}//package map

