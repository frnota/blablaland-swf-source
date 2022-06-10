// version 467 by nota

//map.RainEffect

package map{
    import engine.SyncSteper;
    import flash.display.BitmapData;
    import flash.media.SoundChannel;
    import flash.utils.getTimer;
    import flash.media.SoundTransform;
    import flash.events.Event;
    import flash.display.BitmapDataChannel;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.filters.GlowFilter;

    public class RainEffect {

        public var syncSteper:SyncSteper;
        public var rainSndClass:Class;
        private var rainSndChannelList:Array;
        private var rainSndChannelNum:Number;
        public var screenWidth:Number;
        public var screenHeight:Number;
        public var temperature:Number;
        public var humidity:Number;
        public var cloudDensity:Number;
        public var itemList:Array;
        public var bmdRain:BitmapData;
        public var bmdSnow:BitmapData;
        public var sndVolume:Number;
        private var _rainRateQuality:uint;

        public function RainEffect(){
            this.syncSteper = new SyncSteper();
            this.syncSteper.addEventListener("onStep", this.step, false, 0, true);
            this.rainSndChannelList = new Array();
            this.sndVolume = 1;
            this.cloudDensity = 0;
            this.temperature = 0.6;
            this.humidity = 0.7;
            this.rainRateQuality = 3;
            this.screenWidth = 550;
            this.screenHeight = 400;
            this.itemList = new Array();
            this.bmdRain = null;
            this.bmdSnow = null;
            this.rainSndClass = null;
            this.rainSndChannelNum = 3;
        }

        public function getCurrentSnowFactor():Number{
            var _local_1:Number = Math.max(Math.min(((this.cloudDensity - 0.5) / 0.4), 1), 0);
            var _local_2:Number = ((this.temperature < 0.5) ? 1 : 0);
            var _local_3:Number = Math.max(Math.min(((this.humidity - 0.2) / 0.8), 1), 0);
            return ((_local_3 * _local_2) * _local_1);
        }

        public function getCurrentRainFactor():Number{
            var _local_1:Number = Math.max(Math.min(((this.cloudDensity - 0.5) / 0.4), 1), 0);
            var _local_2:Number = ((this.temperature >= 0.5) ? 1 : 0);
            var _local_3:Number = Math.max(Math.min(((this.humidity - 0.2) / 0.8), 1), 0);
            return ((_local_3 * _local_2) * _local_1);
        }

        public function step(_arg_1:Event=null):*{
            var _local_2:uint;
            var _local_3:SoundChannel;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:*;
            var _local_10:Number;
            if (this.rainSndClass){
                _local_4 = 0;
                if (this.itemList.length > 0){
                    _local_4 = this.getCurrentRainFactor();
                };
                _local_2 = 0;
                while (_local_2 < this.rainSndChannelNum) {
                    _local_5 = (1 / this.rainSndChannelNum);
                    _local_6 = (_local_2 * _local_5);
                    _local_7 = ((_local_2 + 1) * _local_5);
                    _local_8 = ((_local_4 - _local_6) / (_local_7 - _local_6));
                    if (_local_8 > 0){
                        if (this.rainSndChannelList.length <= _local_2){
                            _local_9 = new this.rainSndClass();
                            _local_10 = Math.round(((getTimer() + ((_local_2 * 5300) * _local_5)) % 5300));
                            _local_3 = _local_9.play(_local_10, 9999999);
                            if (_local_3){
                                this.rainSndChannelList.push(_local_3);
                            };
                        };
                        if (_local_2 < this.rainSndChannelList.length){
                            this.rainSndChannelList[_local_2].soundTransform = new SoundTransform(((_local_8 * 0.1) * this.sndVolume));
                        };
                    }
                    else {
                        if (this.rainSndChannelList.length > _local_2){
                            while (this.rainSndChannelList.length > _local_2) {
                                _local_3 = this.rainSndChannelList.pop();
                                _local_3.stop();
                            };
                            break;
                        };
                    };
                    _local_2++;
                };
            };
            _local_2 = 0;
            while (_local_2 < this.itemList.length) {
                this.itemList[_local_2].update();
                _local_2++;
            };
        }

        public function clearAllItem():*{
            var _local_1:*;
            while (this.itemList.length) {
                _local_1 = this.itemList.shift();
                _local_1.dispose();
            };
            this.step();
        }

        public function addItem():RainEffectItem{
            var _local_1:* = new RainEffectItem();
            this.itemList.push(_local_1);
            _local_1.master = this;
            _local_1.surfaceWidth = this.screenWidth;
            _local_1.surfaceHeight = this.screenHeight;
            return (_local_1);
        }

        private function subDispose():*{
            if (this.bmdRain){
                this.bmdRain.dispose();
                this.bmdSnow.dispose();
                this.bmdRain = null;
                this.bmdSnow = null;
            };
        }

        public function dispose():*{
            this.syncSteper.removeEventListener("onStep", this.step, false);
            this.syncSteper.dispose();
            this.clearAllItem();
            this.subDispose();
        }

        public function redraw():*{
            this.subDispose();
            var _local_1:BitmapData = new BitmapData(300, 300, true, 0);
            var _local_2:* = int((Math.random() * int.MAX_VALUE));
            _local_1.noise(_local_2, 0, 250, BitmapDataChannel.ALPHA, true);
            var _local_3:BlurFilter = new BlurFilter(0, 20, 2);
            var _local_4:BitmapData = new BitmapData(_local_1.width, (_local_1.height + (_local_3.blurY * 2)), true, 0);
            this.bmdRain = new BitmapData(_local_1.width, _local_1.height, true, 0);
            var _local_5:Number = 230;
            var _local_6:* = new ColorTransform(1, 1, 1, 120, _local_5, _local_5, _local_5, 0);
            var _local_7:* = new ColorTransform(0, 0, 0, 1, 0, 0, 0, -240);
            _local_6.concat(_local_7);
            _local_4.copyPixels(_local_1, _local_1.rect, new Point(0, _local_3.blurY), null, null, true);
            _local_4.colorTransform(_local_4.rect, _local_6);
            _local_4.applyFilter(_local_4, _local_4.rect, new Point(0, 0), _local_3);
            var _local_8:* = new Rectangle(0, _local_3.blurY, this.bmdRain.width, this.bmdRain.height);
            this.bmdRain.copyPixels(_local_4, _local_8, new Point(0, 0), null, null, true);
            _local_8.y = 0;
            _local_8.height = _local_3.blurY;
            this.bmdRain.copyPixels(_local_4, _local_8, new Point(0, (this.bmdRain.height - _local_3.blurY)), null, null, true);
            _local_8.y = (_local_4.height - _local_3.blurY);
            this.bmdRain.copyPixels(_local_4, _local_8, new Point(0, 0), null, null, true);
            _local_4.dispose();
            _local_5 = 220;
            _local_6 = new ColorTransform(1, 1, 1, 80, _local_5, _local_5, _local_5, 0);
            _local_7 = new ColorTransform(0, 0, 0, 1, 0, 0, 0, -249);
            _local_6.concat(_local_7);
            var _local_9:* = new GlowFilter((((_local_5 * 0x10000) + (_local_5 * 0x0100)) + _local_5), 1, 2, 2, 10, 1);
            this.bmdSnow = new BitmapData(_local_1.width, _local_1.height, true, 0);
            var _local_10:BitmapData = new BitmapData((_local_1.width + (_local_9.blurX * 2)), (_local_1.height + (_local_9.blurY * 2)), true, 0);
            _local_10.copyPixels(_local_1, _local_1.rect, new Point(_local_9.blurX, _local_9.blurY), null, null, true);
            _local_10.colorTransform(_local_10.rect, _local_6);
            _local_10.applyFilter(_local_10, _local_10.rect, new Point(0, 0), _local_9);
            _local_8 = new Rectangle(_local_9.blurX, _local_9.blurY, this.bmdSnow.width, this.bmdSnow.height);
            this.bmdSnow.copyPixels(_local_10, _local_8, new Point(0, 0), null, null, true);
            _local_8 = new Rectangle(_local_9.blurX, 0, this.bmdSnow.width, _local_9.blurY);
            this.bmdSnow.copyPixels(_local_10, _local_8, new Point(0, (this.bmdSnow.height - _local_9.blurY)), null, null, true);
            _local_8 = new Rectangle(_local_9.blurX, (_local_10.height - _local_9.blurY), this.bmdSnow.width, _local_9.blurY);
            this.bmdSnow.copyPixels(_local_10, _local_8, new Point(0, 0), null, null, true);
            _local_8 = new Rectangle(0, _local_9.blurY, _local_9.blurX, this.bmdSnow.height);
            this.bmdSnow.copyPixels(_local_10, _local_8, new Point((this.bmdSnow.width - _local_9.blurX), 0), null, null, true);
            _local_8 = new Rectangle((_local_10.width - _local_9.blurX), _local_9.blurY, _local_9.blurX, this.bmdSnow.height);
            this.bmdSnow.copyPixels(_local_10, _local_8, new Point(0, 0), null, null, true);
            _local_10.dispose();
            _local_1.dispose();
            var _local_11:* = 0;
            while (_local_11 < this.itemList.length) {
                this.itemList[_local_11].init();
                _local_11++;
            };
        }

        public function get rainRateQuality():uint{
            return (this._rainRateQuality);
        }

        public function set rainRateQuality(_arg_1:uint):*{
            this._rainRateQuality = _arg_1;
            this.syncSteper.rate = Math.pow(2, (6 - _arg_1));
        }


    }
}//package map

