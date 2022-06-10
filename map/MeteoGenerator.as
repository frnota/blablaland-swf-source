// version 467 by nota

//map.MeteoGenerator

package map{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import engine.Tween;

    public class MeteoGenerator {

        public var meteoId:uint;
        public var positionX:Number;
        public var positionY:Number;
        public var seed:Number;
        public var dayCicleDelay:Number;
        public var seasonCicleDelay:Number;
        public var startTime:Number;
        public var endTime:Number;
        public var serverId:uint;
        public var width:uint;
        public var dure:Number;
        public var pixelTime:Number;
        public var cloudBMD:BitmapData;
        public var humidityBMD:BitmapData;
        public var stormyBMD:BitmapData;
        public var fogBMD:BitmapData;
        public var temperatureBMD:BitmapData;
        private var timeOffset:Number;
        private var waveWidth:Number;
        private var waveHeight:Number;

        public function MeteoGenerator(){
            this.dure = 600000;
            this.pixelTime = 60000;
            this.waveWidth = 30;
            this.waveHeight = 30;
            this.positionX = 0;
            this.positionY = 0;
            this.serverId = 0;
            this.width = this.waveWidth;
        }

        public function dispose():*{
            if (this.cloudBMD){
                this.cloudBMD.dispose();
            };
            if (this.humidityBMD){
                this.humidityBMD.dispose();
            };
            if (this.stormyBMD){
                this.stormyBMD.dispose();
            };
            if (this.fogBMD){
                this.fogBMD.dispose();
            };
            if (this.temperatureBMD){
                this.temperatureBMD.dispose();
            };
        }

        public function generate():*{
            this.seed = (310 + (this.serverId * 50));
            this.dayCicleDelay = ((2.5 * 3600) * 1000);
            this.seasonCicleDelay = 0x90321000;
            this.startTime = (this.startTime - (this.startTime % this.pixelTime));
            this.generateBmd();
        }

        private function generateBmd():*{
            var _local_1:* = (Math.ceil((this.width / this.waveWidth)) * this.waveWidth);
            if (_local_1 < (this.waveWidth * 2)){
                _local_1 = (this.waveWidth * 2);
            };
            var _local_2:* = (Math.ceil(((this.dure / this.pixelTime) / this.waveHeight)) * this.waveHeight);
            if (_local_2 < (this.waveHeight * 2)){
                _local_2 = (this.waveHeight * 2);
            };
            this.endTime = (this.startTime + (_local_2 * this.pixelTime));
            if (this.cloudBMD){
                this.cloudBMD.dispose();
            };
            this.cloudBMD = new BitmapData(_local_1, _local_2, false, 50);
            if (this.humidityBMD){
                this.humidityBMD.dispose();
            };
            this.humidityBMD = new BitmapData(_local_1, _local_2, false, 50);
            if (this.stormyBMD){
                this.stormyBMD.dispose();
            };
            this.stormyBMD = new BitmapData(_local_1, _local_2, false, 50);
            if (this.fogBMD){
                this.fogBMD.dispose();
            };
            this.fogBMD = new BitmapData(_local_1, _local_2, false, 50);
            if (this.temperatureBMD){
                this.temperatureBMD.dispose();
            };
            this.temperatureBMD = new BitmapData(_local_1, _local_2, false, 50);
            this.generateCloud();
            this.generateHumidity();
            this.generateStormy();
            this.generateFog();
            this.generateTemperature();
        }

        private function generateCloud():*{
            var _local_1:* = new Point((this.positionX - (this.cloudBMD.width / 2)), (Math.floor((this.startTime / this.pixelTime)) - 0x3B9ACA00));
            this.cloudBMD.perlinNoise(this.waveWidth, this.waveHeight, 1, (this.seed + 100), false, false, 7, true, [_local_1, _local_1, _local_1, _local_1]);
            this.cloudBMD.colorTransform(this.cloudBMD.rect, new ColorTransform(1.8, 1.8, 1.8));
            var _local_2:* = new BitmapData(this.cloudBMD.width, this.cloudBMD.height, true, 0);
            _local_2.perlinNoise(this.waveWidth, this.waveHeight, 1, (this.seed + 20), false, true, 8, false, [_local_1, _local_1, _local_1, _local_1]);
            _local_2.colorTransform(_local_2.rect, new ColorTransform(1, 1, 1, 1, 50, 50, 50, 0));
            this.cloudBMD.draw(_local_2, null, null, "add");
            _local_2.dispose();
        }

        private function generateHumidity():*{
            var _local_1:* = new Point((this.positionX - (this.humidityBMD.width / 2)), (Math.floor((this.startTime / this.pixelTime)) - 0x3B9ACA00));
            this.humidityBMD.perlinNoise(this.waveWidth, this.waveHeight, 1, (this.seed + 80), false, true, 7, true, [_local_1, _local_1, _local_1, _local_1]);
            this.humidityBMD.colorTransform(this.humidityBMD.rect, new ColorTransform(1, 1, 1, 1, -100, -100, -100));
            this.humidityBMD.colorTransform(this.humidityBMD.rect, new ColorTransform(2.5, 2.5, 2.5));
        }

        private function generateStormy():*{
            var _local_1:* = new Point((this.positionX - (this.stormyBMD.width / 2)), (Math.floor((this.startTime / this.pixelTime)) - 0x3B9ACA00));
            this.stormyBMD.perlinNoise(this.waveWidth, this.waveHeight, 1, (this.seed + 165), false, true, 7, true, [_local_1, _local_1, _local_1, _local_1]);
            this.stormyBMD.colorTransform(this.stormyBMD.rect, new ColorTransform(1, 1, 1, 1, -50, -50, -50));
            this.stormyBMD.colorTransform(this.stormyBMD.rect, new ColorTransform(1.7, 1.7, 1.7));
        }

        private function generateFog():*{
            var _local_1:* = new Point((this.positionX - (this.fogBMD.width / 2)), (Math.floor((this.startTime / this.pixelTime)) - 0x3B9ACA00));
            this.fogBMD.perlinNoise(this.waveWidth, this.waveHeight, 1, (this.seed + 985), false, false, 7, true, [_local_1, _local_1, _local_1, _local_1]);
            this.fogBMD.colorTransform(this.fogBMD.rect, new ColorTransform(1, 1, 1, 1, -40, -40, -40));
            this.fogBMD.colorTransform(this.fogBMD.rect, new ColorTransform(2.4, 2.4, 2.4));
        }

        private function generateTemperature():*{
            var _local_1:* = new Point((this.positionX - (this.temperatureBMD.width / 2)), (Math.floor((this.startTime / this.pixelTime)) - 0x3B9ACA00));
            this.temperatureBMD.perlinNoise((this.waveWidth * 2), (this.waveHeight * 2), 1, (this.seed + 193), false, true, 7, true, [_local_1, _local_1, _local_1, _local_1]);
            this.temperatureBMD.colorTransform(this.temperatureBMD.rect, new ColorTransform(1, 1, 1, 1, -50, -50, -50));
            this.temperatureBMD.colorTransform(this.temperatureBMD.rect, new ColorTransform(1.7, 1.7, 1.7));
        }

        public function getHeatSeason(_arg_1:Number):*{
            var _local_2:* = new Tween();
            _local_2.mode = 5;
            _local_2.factor = 2;
            var _local_3:* = this.getSeason(_arg_1);
            _local_3 = Math.sin((Math.PI * _local_3));
            return (_local_2.generate(_local_3));
        }

        public function getSeason(_arg_1:Number):*{
            var _local_3:uint;
            var _local_4:uint;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:*;
            var _local_2:Number = ((_arg_1 / this.seasonCicleDelay) % 1);
            if (this.meteoId == 1){
                _local_3 = 3;
                _local_4 = 9;
                _local_5 = 0.25;
                _local_6 = ((0.5 + ((_local_5 * _local_2) * 2)) - _local_5);
                _local_7 = Math.max(Math.min(((this.positionX - _local_3) / (_local_4 - _local_3)), 1), 0);
                _local_2 = ((_local_2 * (1 - _local_7)) + (_local_6 * _local_7));
            }
            else {
                if (this.meteoId == 2){
                    _local_2 = 0.5;
                }
                else {
                    if (this.meteoId == 3){
                        _local_2 = 0;
                    };
                };
            };
            return (_local_2);
        }

        public function getSunTime(_arg_1:Number):*{
            var _local_2:* = new Tween();
            _local_2.mode = 5;
            _local_2.factor = 2;
            var _local_3:Number = this.dayCicleDelay;
            if (this.serverId == 1){
                _local_3 = (_local_3 + (((60 * 60) * 1.5) * 1000));
            };
            var _local_4:* = ((_arg_1 / _local_3) % 1);
            var _local_5:* = Math.sin((Math.PI * _local_4));
            return (_local_2.generate(_local_5));
        }


    }
}//package map

