// version 467 by nota

//map.Meteo

package map{
    import engine.TimeValueItem;
    import engine.TimeValue;
    import engine.Tween;

    public class Meteo extends MeteoGenerator {


        public function readDayTime(_arg_1:TimeValue):*{
            var _local_3:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:TimeValueItem = _arg_1.addItem();
            _local_2.time = (startTime - (startTime % dayCicleDelay));
            _local_2.value = 0;
            if (serverId == 1){
                _local_2.time = (_local_2.time - (((60 * 60) * 1.5) * 1000));
            };
            while (_local_2.time < endTime) {
                _local_3 = _local_2;
                _local_2 = _arg_1.addItem();
                _local_2.time = (_local_3.time + dayCicleDelay);
                _local_2.value = 1;
                _local_2 = _arg_1.addItem();
                _local_2.time = ((_local_3.time + dayCicleDelay) + 1);
                _local_2.value = 0;
            };
        }

        public function readCloud(_arg_1:TimeValue):*{
            var _local_4:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:* = new Tween();
            _local_2.mode = 1;
            _local_2.factor = 2;
            var _local_3:* = 0;
            while (_local_3 < cloudBMD.height) {
                _local_4 = _arg_1.addItem();
                _local_4.time = (startTime + (_local_3 * pixelTime));
                _local_4.value = _local_2.generate(((cloudBMD.getPixel((cloudBMD.width / 2), _local_3) & 0xFF) / 0xFF));
                _local_3++;
            };
        }

        public function readHumidity(_arg_1:TimeValue):*{
            var _local_3:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:* = 0;
            while (_local_2 < humidityBMD.height) {
                _local_3 = _arg_1.addItem();
                _local_3.time = (startTime + (_local_2 * pixelTime));
                _local_3.value = ((humidityBMD.getPixel((humidityBMD.width / 2), _local_2) & 0xFF) / 0xFF);
                if (serverId == 2){
                    _local_3.value = 0;
                };
                _local_2++;
            };
        }

        public function readStormy(_arg_1:TimeValue):*{
            var _local_3:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:* = 0;
            while (_local_2 < stormyBMD.height) {
                _local_3 = _arg_1.addItem();
                _local_3.time = (startTime + (_local_2 * pixelTime));
                _local_3.value = ((stormyBMD.getPixel((stormyBMD.width / 2), _local_2) & 0xFF) / 0xFF);
                if (serverId == 2){
                    _local_3.value = 1;
                };
                _local_2++;
            };
        }

        public function readFog(_arg_1:TimeValue):*{
            var _local_4:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:* = new Tween();
            _local_2.mode = 1;
            _local_2.factor = 3;
            var _local_3:* = 0;
            while (_local_3 < fogBMD.height) {
                _local_4 = _arg_1.addItem();
                _local_4.time = (startTime + (_local_3 * pixelTime));
                _local_4.value = _local_2.generate(((fogBMD.getPixel((fogBMD.width / 2), _local_3) & 0xFF) / 0xFF));
                if (serverId == 2){
                    _local_4.value = 0;
                };
                _local_3++;
            };
        }

        public function readSeason(_arg_1:TimeValue):*{
            var _local_3:TimeValueItem;
            _arg_1.clearAllItem();
            var _local_2:* = 0;
            while (_local_2 < fogBMD.height) {
                _local_3 = _arg_1.addItem();
                _local_3.time = (startTime + (_local_2 * pixelTime));
                _local_3.value = getSeason(_local_3.time);
                _local_2++;
            };
        }

        public function readTemperature(_arg_1:TimeValue):*{
            var _local_6:TimeValueItem;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            _arg_1.clearAllItem();
            var _local_2:* = new Tween();
            _local_2.mode = 6;
            _local_2.factor = 2;
            var _local_3:* = new Tween();
            _local_3.mode = 6;
            _local_3.factor = 5;
            var _local_4:* = new Tween();
            _local_4.mode = 2;
            _local_4.factor = 2;
            var _local_5:* = 0;
            while (_local_5 < temperatureBMD.height) {
                _local_6 = _arg_1.addItem();
                _local_6.time = (startTime + (_local_5 * pixelTime));
                if (meteoId == 2){
                    _local_6.value = ((Math.max(Math.min((-(positionY) / 40), 1), 0) * 0.3) + 0.7);
                }
                else {
                    _local_7 = ((_local_2.generate(((temperatureBMD.getPixel((temperatureBMD.width / 2), _local_5) & 0xFF) / 0xFF)) * 2) - 1);
                    _local_8 = ((getHeatSeason(_local_6.time) * 2) - 1);
                    _local_9 = ((getSunTime(_local_6.time) * 2) - 1);
                    _local_6.value = (((_local_8 * 0.6) + (_local_7 * 0.25)) + (_local_9 * 0.2));
                    _local_6.value = ((_local_6.value / 2) + 0.5);
                    _local_6.value = ((_local_3.generate(_local_6.value) * 0.6) + (_local_4.generate(_local_6.value) * 0.4));
                    _local_6.value = Math.max(Math.min(_local_6.value, 1), 0);
                    if (serverId == 2){
                        _local_6.value = 0.8;
                    };
                };
                _local_5++;
            };
        }


    }
}//package map

