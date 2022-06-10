// version 467 by nota

//map.SndEnvironnement

package map{
    import engine.SyncTimer;
    import flash.media.SoundChannel;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import flash.media.SoundTransform;
    import engine.Srandom;

    public class SndEnvironnement {

        public var camera:MapSndEnvironnement;
        public var soundClass:Object;
        public var channelList:Array;
        public var timer:SyncTimer;
        public var seed:Number;
        public var volume:Number;
        public var rate:Number;
        public var mode:uint;
        public var lightMode:uint;
        public var temperatureMode:uint;
        public var rainMode:uint;
        public var snowMode:uint;
        public var lightThreshold:Number;
        public var hotThreshold:Number;
        public var rainThreshold:Number;
        public var snowThreshold:Number;
        public var meteoOnRate:Boolean;
        public var meteoOnVolume:Boolean;
        private var _generalVolume:*;

        public function SndEnvironnement(){
            this.rainMode = 0;
            this.snowMode = 0;
            this.lightMode = 0;
            this.temperatureMode = 0;
            this.lightThreshold = 0.5;
            this.rainThreshold = 0.2;
            this.snowThreshold = 0.2;
            this.hotThreshold = 0.78;
            this.meteoOnRate = true;
            this.meteoOnVolume = false;
            this.seed = 0;
            this.rate = 0.8;
            this.channelList = new Array();
            this.timer = new SyncTimer(1000);
            this.timer.addEventListener("syncTimer", this.syncTimer, false, 0, true);
            this.mode = 0;
            this.volume = 1;
            this._generalVolume = 1;
        }

        public function start():*{
            var _local_1:Object;
            var _local_2:SoundChannel;
            if (this.soundClass){
                if (this.mode == 0){
                    _local_1 = new this.soundClass();
                    _local_2 = _local_1.play((GlobalProperties.serverTime % Math.round(_local_1.length)), 0, this.getSoundTransform());
                    if (_local_2){
                        _local_2.addEventListener("soundComplete", this.continueEvent, false, 0, true);
                        this.channelList.push(_local_2);
                    };
                }
                else {
                    if (this.mode == 1){
                        this.timer.syncTime = GlobalProperties.serverTime;
                        this.timer.start();
                        this.timer.dispatchEvent(new Event("syncTimer"));
                    }
                    else {
                        if (this.mode == 2){
                            this.timer.syncTime = GlobalProperties.serverTime;
                            this.timer.start();
                        };
                    };
                };
            };
        }

        public function continueEvent(_arg_1:Event):*{
            this.removeChannel(_arg_1.currentTarget);
            var _local_2:Object = new this.soundClass();
            var _local_3:SoundChannel = _local_2.play(0, 99999, this.getSoundTransform());
            if (_local_3){
                this.channelList.push(_local_3);
            };
        }

        public function getMeteoPrct():*{
            var _local_1:Number = Math.pow(Math.sin((this.camera.dayTime.getValue(this.timer.syncTime) * Math.PI)), 2);
            var _local_2:* = this.camera.temperature.getValue(this.timer.syncTime);
            var _local_3:Number = Math.max(Math.min(((this.camera.cloudDensity.getValue(this.timer.syncTime) - 0.5) / 0.4), 1), 0);
            var _local_4:Number = Math.max(Math.min(((this.camera.temperature.getValue(this.timer.syncTime) - 0.4) / 0.2), 1), 0);
            var _local_5:Number = Math.max(Math.min((((1 - this.camera.temperature.getValue(this.timer.syncTime)) - 0.4) / 0.2), 1), 0);
            var _local_6:Number = Math.max(Math.min(((this.camera.humidity.getValue(this.timer.syncTime) - 0.2) / 0.8), 1), 0);
            var _local_7:* = ((_local_3 * _local_4) * _local_6);
            var _local_8:* = ((_local_3 * _local_5) * _local_6);
            var _local_9:* = 1;
            if (this.lightMode == 1){
                _local_9 = (_local_9 * ((_local_1 > this.lightThreshold) ? 1 : 0));
            };
            if (this.lightMode == 2){
                _local_9 = (_local_9 * ((_local_1 < this.lightThreshold) ? 1 : 0));
            };
            if (this.temperatureMode == 1){
                _local_9 = (_local_9 * ((_local_2 > this.hotThreshold) ? 1 : 0));
            };
            if (this.rainMode == 1){
                _local_9 = (_local_9 * ((_local_7 < this.rainThreshold) ? 1 : 0));
            };
            if (this.snowMode == 1){
                _local_9 = (_local_9 * ((_local_8 < this.snowThreshold) ? 1 : 0));
            };
            return (_local_9);
        }

        public function getSoundTransform():SoundTransform{
            var _local_2:Number;
            var _local_3:*;
            var _local_1:* = new SoundTransform();
            if (this.mode == 0){
                _local_1.volume = (this.volume * this.generalVolume);
            }
            else {
                _local_2 = (this.volume * this.generalVolume);
                if (this.meteoOnVolume){
                    _local_3 = this.getMeteoPrct();
                    _local_2 = (_local_2 * _local_3);
                };
                _local_1.volume = _local_2;
            };
            return (_local_1);
        }

        public function syncTimer(_arg_1:Event):*{
            var _local_5:Object;
            var _local_6:SoundChannel;
            var _local_2:Srandom = new Srandom();
            _local_2.seed = (_arg_1.currentTarget.syncTime + this.seed);
            var _local_3:Number = _local_2.generate(3);
            var _local_4:* = this.getMeteoPrct();
            if (this.meteoOnRate){
                _local_3 = (_local_3 * _local_4);
            };
            if (this.mode == 1){
                if (((_local_3 < (1 - this.rate)) && (this.channelList.length))){
                    this.disposeAllChannel();
                }
                else {
                    if (((_local_3 > (1 - this.rate)) && (!(this.channelList.length)))){
                        _local_5 = new this.soundClass();
                        _local_6 = _local_5.play(0, 99999, this.getSoundTransform());
                        if (_local_6){
                            this.channelList.push(_local_6);
                        };
                    };
                };
            }
            else {
                if (this.mode == 2){
                    if (_local_3 > (1 - this.rate)){
                        _local_5 = new this.soundClass();
                        _local_6 = _local_5.play(0, 0, this.getSoundTransform());
                        if (_local_6){
                            _local_6.addEventListener("soundComplete", this.eventEvent, false, 0, true);
                            this.channelList.push(_local_6);
                        };
                    };
                };
            };
        }

        public function eventEvent(_arg_1:Event):*{
            this.removeChannel(_arg_1.currentTarget);
        }

        public function removeChannel(_arg_1:*):*{
            var _local_2:* = 0;
            while (_local_2 < this.channelList.length) {
                if (this.channelList[_local_2] == _arg_1){
                    _arg_1.removeEventListener("soundComplete", this.continueEvent, false);
                    _arg_1.removeEventListener("soundComplete", this.eventEvent, false);
                    _arg_1.stop();
                    this.channelList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function disposeAllChannel():*{
            while (this.channelList.length) {
                this.removeChannel(this.channelList[0]);
            };
        }

        public function dispose():*{
            this.timer.removeEventListener("syncTimer", this.syncTimer, false);
            this.timer.stop();
            this.disposeAllChannel();
        }

        public function get generalVolume():Number{
            return (this._generalVolume);
        }

        public function set generalVolume(_arg_1:Number):*{
            var _local_2:* = 0;
            while (_local_2 < this.channelList.length) {
                this.channelList[_local_2].soundTransform = this.getSoundTransform();
                _local_2++;
            };
            this._generalVolume = _arg_1;
        }


    }
}//package map

