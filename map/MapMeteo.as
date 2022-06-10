// version 467 by nota

//map.MapMeteo

package map{
    import engine.TimeValue;
    import engine.SyncTimer;
    import engine.SyncSteper;
    import engine.TimeValueItem;
    import bbl.GlobalProperties;
    import flash.events.Event;

    public class MapMeteo extends MapEnvironnementBuilder {

        public var mapXpos:int;
        public var mapYpos:int;
        public var meteoId:int;
        public var dayTime:TimeValue;
        public var cloudDensity:TimeValue;
        public var stormy:TimeValue;
        public var temperature:TimeValue;
        public var fogDensity:TimeValue;
        public var humidity:TimeValue;
        public var season:TimeValue;
        public var intervalTimer:SyncTimer;
        private var cloudSteper:SyncSteper;
        private var fogSteper:SyncSteper;
        private var astroSteper:SyncSteper;
        private var skySteper:SyncSteper;
        private var lightEffectSteper:SyncSteper;
        private var snowEffectSteper:SyncSteper;
        private var daytimeEffectSteper:SyncSteper;
        private var seasonEffectSteper:SyncSteper;
        private var rainEffectSteper:SyncSteper;
        private var lightningTimer:SyncTimer;

        public function MapMeteo(){
            var _local_1:TimeValueItem;
            super();
            this.meteoId = 0;
            this.lightningTimer = new SyncTimer(500);
            this.intervalTimer = new SyncTimer(1000);
            this.dayTime = new TimeValue();
            this.cloudDensity = new TimeValue();
            this.fogDensity = new TimeValue();
            this.stormy = new TimeValue();
            this.temperature = new TimeValue();
            this.humidity = new TimeValue();
            this.season = new TimeValue();
            _local_1 = this.dayTime.addItem();
            _local_1.value = 0.4;
            _local_1 = this.cloudDensity.addItem();
            _local_1.value = 0.2;
            _local_1 = this.fogDensity.addItem();
            _local_1.value = 0;
            _local_1 = this.stormy.addItem();
            _local_1.value = 0;
            _local_1 = this.temperature.addItem();
            _local_1.value = 0.8;
            _local_1 = this.humidity.addItem();
            _local_1.value = 0;
            _local_1 = this.season.addItem();
            _local_1.value = 0.5;
            this.astroSteper = new SyncSteper();
            this.astroSteper.clock = GlobalProperties.screenSteper;
            this.astroSteper.addEventListener("onStep", this.astroSteperEvent, false, 0, true);
            this.fogSteper = new SyncSteper();
            this.fogSteper.clock = GlobalProperties.screenSteper;
            this.fogSteper.addEventListener("onStep", this.fogSteperEvent, false, 0, true);
            this.cloudSteper = new SyncSteper();
            this.cloudSteper.clock = GlobalProperties.screenSteper;
            this.cloudSteper.addEventListener("onStep", this.cloudSteperEvent, false, 0, true);
            this.skySteper = new SyncSteper();
            this.skySteper.clock = GlobalProperties.screenSteper;
            this.skySteper.addEventListener("onStep", this.skySteperEvent, false, 0, true);
            this.lightEffectSteper = new SyncSteper();
            this.lightEffectSteper.clock = GlobalProperties.screenSteper;
            this.lightEffectSteper.addEventListener("onStep", this.lightEffectSteperEvent, false, 0, true);
            this.snowEffectSteper = new SyncSteper();
            this.snowEffectSteper.clock = GlobalProperties.screenSteper;
            this.snowEffectSteper.addEventListener("onStep", this.snowEffectSteperEvent, false, 0, true);
            this.daytimeEffectSteper = new SyncSteper();
            this.daytimeEffectSteper.clock = GlobalProperties.screenSteper;
            this.daytimeEffectSteper.addEventListener("onStep", this.daytimeEffectSteperEvent, false, 0, true);
            this.seasonEffectSteper = new SyncSteper();
            this.seasonEffectSteper.clock = GlobalProperties.screenSteper;
            this.seasonEffectSteper.addEventListener("onStep", this.seasonEffectSteperEvent, false, 0, true);
            this.rainEffectSteper = new SyncSteper();
            this.rainEffectSteper.clock = GlobalProperties.screenSteper;
            this.rainEffectSteper.addEventListener("onStep", this.rainEffectSteperEvent, false, 0, true);
        }

        override public function onMapLoaded(_arg_1:Event):*{
            super.onMapLoaded(_arg_1);
            this.updateInterval();
            this.updateAllEnvironnement();
        }

        public function updateAllEnvironnement():*{
            this.fogSteperEvent();
            this.rainEffectSteperEvent();
            rainEffect.step();
            this.cloudSteperEvent();
            this.skySteperEvent();
            this.astroSteperEvent();
            this.snowEffectSteperEvent();
            this.daytimeEffectSteperEvent();
            this.seasonEffectSteperEvent();
            this.lightEffectSteperEvent();
        }

        override public function dispose():*{
            super.dispose();
            this.astroSteper.dispose();
            this.fogSteper.dispose();
            this.cloudSteper.dispose();
            this.skySteper.dispose();
            this.lightEffectSteper.dispose();
            this.snowEffectSteper.dispose();
            this.daytimeEffectSteper.dispose();
            this.seasonEffectSteper.dispose();
            this.rainEffectSteper.dispose();
        }

        override public function onMapReady(_arg_1:Event=null):*{
            this.lightningTimer.addEventListener("syncTimer", this.lightningTimerRandom, false, 0, true);
            this.lightningTimer.syncTime = GlobalProperties.serverTime;
            this.lightningTimer.start();
            this.intervalTimer.addEventListener("syncTimer", this.updateInterval, false, 0, true);
            this.intervalTimer.syncTime = GlobalProperties.serverTime;
            this.intervalTimer.start();
            super.onMapReady();
        }

        override public function unloadMap():*{
            this.intervalTimer.removeEventListener("syncTimer", this.updateInterval, false);
            this.intervalTimer.stop();
            this.lightningTimer.removeEventListener("syncTimer", this.lightningTimerRandom, false);
            this.lightningTimer.stop();
            this.meteoId = 0;
            super.unloadMap();
        }

        public function updateInterval(_arg_1:Event=null):*{
            var _local_3:Number;
            var _local_2:Number = GlobalProperties.serverTime;
            var _local_4:Number = Math.abs(this.season.getSpeedAt(_local_2));
            var _local_5:Number = Math.abs(this.dayTime.getSpeedAt(_local_2));
            var _local_6:Number = Math.abs(this.cloudDensity.getSpeedAt(_local_2));
            var _local_7:Number = Math.abs(this.fogDensity.getSpeedAt(_local_2));
            var _local_8:Number = Math.abs(this.stormy.getSpeedAt(_local_2));
            var _local_9:Number = Math.abs(this.temperature.getSpeedAt(_local_2));
            var _local_10:Number = Math.abs(this.humidity.getSpeedAt(_local_2));
            this.fogSteper.rate = ((_local_7 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_7 * 30)) / 8)) * 8), 4), 0x0200));
            this.astroSteper.rate = ((_local_5 == 0) ? 0 : Math.min(Math.max(Math.round((1 / (_local_5 * 100))), 2), 128));
            this.snowEffectSteper.rate = ((_local_9 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_9 * 20)) / 4)) * 4), 4), 0x0200));
            this.daytimeEffectSteper.rate = ((_local_5 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_5 * 20)) / 4)) * 4), 4), 0x0200));
            this.seasonEffectSteper.rate = ((_local_4 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_4 * 20)) / 4)) * 4), 4), 0x0200));
            _local_3 = Math.max(Math.max(_local_6, _local_9), _local_10);
            this.rainEffectSteper.rate = ((_local_3 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_3 * 5)) / 4)) * 4), 16), 0x0200));
            _local_3 = Math.max(Math.max(_local_6, _local_8), (_local_5 * 4));
            this.cloudSteper.rate = Math.min(Math.max((Math.round(((1 / (_local_3 * 10)) / 8)) * 8), 4), 128);
            this.skySteper.rate = ((_local_5 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_5 * 30)) / 4)) * 4), 4), 0x0200));
            _local_3 = Math.max(Math.max(Math.max((_local_5 * 2), (_local_9 / 2)), _local_8), _local_6);
            this.lightEffectSteper.rate = ((_local_3 == 0) ? 0 : Math.min(Math.max((Math.round(((1 / (_local_3 * 8)) / 4)) * 4), 8), 0x0200));
        }

        public function lightningTimerRandom(_arg_1:Event=null):*{
            if (!sky){
                return (false);
            };
            var _local_2:Number = this.lightningTimer.syncTime;
            sky.stormy = Math.min(Math.max(this.stormy.getValue(_local_2), 0), 1);
            sky.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(_local_2), 0), 1);
            sky.lightningTimerRandom(_local_2);
        }

        public function skySteperEvent(_arg_1:Event=null):*{
            if (!sky){
                return (false);
            };
            sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
            sky.updateSky();
        }

        public function astroSteperEvent(_arg_1:Event=null):*{
            if (!sky){
                return (false);
            };
            sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
            sky.updateAstro();
        }

        public function cloudSteperEvent(_arg_1:Event=null):*{
            if (!sky){
                return (false);
            };
            sky.stormy = Math.min(Math.max(this.stormy.getValue(GlobalProperties.serverTime), 0), 1);
            sky.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime), 0), 1);
            sky.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
            sky.updateCloud(GlobalProperties.serverTime);
        }

        public function fogSteperEvent(_arg_1:Event=null):*{
            if (!fogEffect){
                return (false);
            };
            fogEffect.fogDensity = Math.min(Math.max(this.fogDensity.getValue(GlobalProperties.serverTime), 0), 1);
            fogEffect.redraw();
        }

        public function lightEffectSteperEvent(_arg_1:Event=null):*{
            if (!lightEffect){
                return (false);
            };
            lightEffect.dayTime = this.dayTime.getValue(GlobalProperties.serverTime);
            lightEffect.stormy = Math.min(Math.max(this.stormy.getValue(GlobalProperties.serverTime), 0), 1);
            lightEffect.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime), 0), 1);
            lightEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime), 0), 1);
            lightEffect.redraw();
        }

        public function snowEffectSteperEvent(_arg_1:Event=null):*{
            if (!snowEffect){
                return (false);
            };
            snowEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime), 0), 1);
            snowEffect.redraw();
        }

        public function daytimeEffectSteperEvent(_arg_1:Event=null):*{
            if (!daytimeEffect){
                return (false);
            };
            daytimeEffect.daytime = this.dayTime.getValue(GlobalProperties.serverTime);
            daytimeEffect.redraw();
        }

        public function seasonEffectSteperEvent(_arg_1:Event=null):*{
            if (!seasonEffect){
                return (false);
            };
            seasonEffect.season = this.season.getValue(GlobalProperties.serverTime);
            seasonEffect.redraw();
        }

        public function rainEffectSteperEvent(_arg_1:Event=null):*{
            if (!rainEffect){
                return (false);
            };
            rainEffect.humidity = Math.min(Math.max(this.humidity.getValue(GlobalProperties.serverTime), 0), 1);
            rainEffect.temperature = Math.min(Math.max(this.temperature.getValue(GlobalProperties.serverTime), 0), 1);
            rainEffect.cloudDensity = Math.min(Math.max(this.cloudDensity.getValue(GlobalProperties.serverTime), 0), 1);
        }


    }
}//package map

