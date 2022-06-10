// version 467 by nota

//map.RainEffectItem

package map{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.utils.getTimer;
    import flash.geom.Point;

    public class RainEffectItem extends Sprite {

        public var master:RainEffect;
        public var rainSpeed:Number;
        public var snowSpeed:Number;
        public var surfaceWidth:Number;
        public var surfaceHeight:Number;
        public var content:Bitmap;
        public var rainMask:Sprite;
        public var rainUnMask:Sprite;
        private var contentBmd:BitmapData;
        private var mainMask:Sprite;
        private var unRainMaskMask:Sprite;

        public function RainEffectItem(){
            this.rainSpeed = 40;
            this.snowSpeed = 4;
            blendMode = "layer";
            this.content = new Bitmap();
            this.rainMask = new Sprite();
            this.rainMask.blendMode = "alpha";
            this.rainUnMask = new Sprite();
            this.rainUnMask.blendMode = "erase";
            this.unRainMaskMask = new Sprite();
            this.rainUnMask.mask = this.unRainMaskMask;
        }

        public function update():*{
            var _local_1:Number = this.master.getCurrentRainFactor();
            var _local_2:Number = this.master.getCurrentSnowFactor();
            if (((_local_1 > 0.04) || (_local_2 > 0.04))){
                this.subInit();
                this.contentBmd.lock();
                this.contentBmd.fillRect(this.contentBmd.rect, 0);
                this.updateRain(_local_1);
                this.updateSnow(_local_2);
                this.contentBmd.unlock();
            }
            else {
                this.subDispose();
            };
        }

        public function updateRain(_arg_1:Number):*{
            var _local_2:* = Math.round((((this.master.rainRateQuality * this.rainSpeed) * getTimer()) / 1000));
            var _local_3:* = Math.ceil((_arg_1 * 15));
            var _local_4:uint;
            while (_local_4 < _local_3) {
                this.addPass(this.master.bmdRain, new Point(((_local_4 / _local_3) * this.contentBmd.width), (_local_2 + ((_local_4 / _local_3) * this.contentBmd.height))));
                _local_4++;
            };
        }

        public function updateSnow(_arg_1:*):*{
            var _local_5:Number;
            var _local_2:* = Math.round((((this.master.rainRateQuality * this.snowSpeed) * getTimer()) / 1000));
            var _local_3:* = Math.ceil((_arg_1 * 15));
            var _local_4:uint;
            while (_local_4 < _local_3) {
                _local_5 = ((Math.cos(((getTimer() / 2000) + _local_4)) * 20) + (_local_4 * 30));
                this.addPass(this.master.bmdSnow, new Point(((((_local_4 / _local_3) * this.contentBmd.width) + _local_5) + 100), (_local_2 + ((_local_4 / _local_3) * this.contentBmd.height))));
                _local_4++;
            };
        }

        public function addPass(_arg_1:BitmapData, _arg_2:Point):*{
            var _local_6:int;
            var _local_3:uint = (_arg_2.x % _arg_1.width);
            var _local_4:uint = (_arg_2.y % _arg_1.height);
            var _local_5:int = -((_arg_1.width - _local_3) % this.contentBmd.width);
            while (_local_5 < this.contentBmd.width) {
                _local_6 = -((_arg_1.height - _local_4) % this.contentBmd.height);
                while (_local_6 < this.contentBmd.height) {
                    this.contentBmd.copyPixels(_arg_1, _arg_1.rect, new Point(_local_5, _local_6), null, null, true);
                    _local_6 = (_local_6 + _arg_1.height);
                };
                _local_5 = (_local_5 + _arg_1.width);
            };
        }

        public function subDispose():*{
            if (this.contentBmd){
                this.contentBmd.dispose();
                this.contentBmd = null;
                removeChild(this.content);
                removeChild(this.rainMask);
                removeChild(this.rainUnMask);
                visible = false;
            };
        }

        public function subInit():*{
            if (!this.contentBmd){
                this.contentBmd = new BitmapData(this.surfaceWidth, this.surfaceHeight, true, 0);
                this.content.bitmapData = this.contentBmd;
                addChild(this.content);
                addChild(this.rainMask);
                addChild(this.rainUnMask);
                visible = true;
                this.rainUnMask.x = -(x);
                this.rainUnMask.y = -(y);
                this.unRainMaskMask.graphics.beginFill(0);
                this.unRainMaskMask.graphics.lineTo(this.surfaceWidth, 0);
                this.unRainMaskMask.graphics.lineTo(this.surfaceWidth, this.surfaceHeight);
                this.unRainMaskMask.graphics.lineTo(0, this.surfaceHeight);
                this.unRainMaskMask.graphics.lineTo(0, 0);
                this.unRainMaskMask.graphics.endFill();
            };
        }

        public function dispose():*{
            this.subDispose();
        }

        public function init():*{
            this.subDispose();
        }


    }
}//package map

