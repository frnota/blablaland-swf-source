// version 467 by nota

//map.MapMeteoControl

package map{
    import bbl.Transport;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import engine.TimeValueItem;
    import engine.TimeValue;

    public class MapMeteoControl extends MapMeteo {

        public var meteoList:Array;
        public var transport:Transport;

        public function MapMeteoControl(){
            this.meteoList = new Array();
            this.transport = null;
        }

        public function clearMeteo():*{
            var _local_1:uint;
            while (_local_1 < this.meteoList.length) {
                this.meteoList[_local_1].dispose();
                _local_1++;
            };
            this.meteoList.splice(0, this.meteoList.length);
        }

        override public function dispose():*{
            this.clearMeteo();
            super.dispose();
        }

        override public function updateInterval(_arg_1:Event=null):*{
            if (this.meteoList.length){
                if ((((this.meteoList[0].endTime < (GlobalProperties.serverTime + (intervalTimer.delay * 2))) && (mapReady)) && (meteoId))){
                    this.generateMeteo();
                };
            };
            super.updateInterval(_arg_1);
        }

        public function generateMeteo():*{
            var _local_1:uint;
            while (_local_1 < this.meteoList.length) {
                this.meteoList[_local_1].startTime = GlobalProperties.serverTime;
                this.meteoList[_local_1].generate();
                _local_1++;
            };
            this.readMeteo();
            if (currentMap){
                currentMap.onMeteoGenerated();
            };
        }

        public function readMeteo():*{
            if (this.meteoList.length){
                this.readMeteoPart("readDayTime", dayTime);
                this.readMeteoPart("readCloud", cloudDensity);
                this.readMeteoPart("readHumidity", humidity);
                this.readMeteoPart("readStormy", stormy);
                this.readMeteoPart("readFog", fogDensity);
                this.readMeteoPart("readTemperature", temperature);
                this.readMeteoPart("readSeason", season);
            };
            dispatchEvent(new Event("onMeteoGenerated"));
            this.updateInterval();
            updateAllEnvironnement();
        }

        public function readMeteoPart(_arg_1:String, _arg_2:TimeValue):*{
            var _local_3:Array;
            var _local_4:uint;
            var _local_5:TimeValueItem;
            var _local_6:TimeValue;
            var _local_7:Number;
            var _local_8:int;
            _arg_2.clearAllItem();
            if (this.transport){
                _local_3 = new Array();
                _local_4 = 0;
                while (_local_4 < this.meteoList.length) {
                    _local_6 = new TimeValue();
                    var _local_9:* = this.meteoList[_local_4];
                    (_local_9[_arg_1](_local_6));
                    _local_3.push(_local_6);
                    _local_4++;
                };
                _local_7 = GlobalProperties.serverTime;
                while (_local_7 < (this.meteoList[0].endTime + this.transport.periode)) {
                    _local_8 = (_local_7 % this.transport.periode);
                    _local_4 = 0;
                    while (_local_4 < this.transport.mapTimeValue.itemList.length) {
                        _local_5 = _arg_2.addItem();
                        _local_5.time = ((_local_7 + this.transport.mapTimeValue.itemList[_local_4].time) - _local_8);
                        _local_5.value = _local_3[this.transport.mapTimeValue.itemList[_local_4].value].getValue(_local_5.time);
                        _local_4++;
                    };
                    _local_7 = (_local_7 + this.transport.periode);
                };
            }
            else {
                _local_9 = this.meteoList[0];
                (_local_9[_arg_1](_arg_2));
            };
        }

        public function initMeteo():*{
            var _local_1:uint;
            var _local_2:Meteo;
            var _local_3:ServerMap;
            this.clearMeteo();
            if (!this.transport){
                this.meteoList.push(new Meteo());
                this.meteoList[0].serverId = serverId;
                this.meteoList[0].meteoId = meteoId;
                this.meteoList[0].positionX = mapXpos;
                this.meteoList[0].positionY = mapYpos;
            }
            else {
                _local_1 = 0;
                while (_local_1 < this.transport.mapList.length) {
                    _local_2 = new Meteo();
                    _local_3 = this.transport.mapList[_local_1];
                    this.meteoList.push(_local_2);
                    _local_2.serverId = serverId;
                    _local_2.meteoId = _local_3.meteoId;
                    _local_2.positionX = _local_3.mapXpos;
                    _local_2.positionY = _local_3.mapYpos;
                    _local_1++;
                };
            };
            this.generateMeteo();
        }


    }
}//package map

