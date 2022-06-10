// version 467 by nota

//bbl.BblLoader

package bbl{
    import fx.FxLoader;
    import perso.SkinLoader;
    import flash.utils.Timer;
    import bbl.hitapi.HitAPI;
    import flash.events.Event;
    import flash.events.TextEvent;
    import flash.utils.getTimer;
    import map.MapLoader;
    import perso.smiley.SmileyLoader;

    public class BblLoader extends BblWebRadio {

        public var fxLoader:FxLoader;
        public var externalLoader:ExternalLoader;
        public var skinLoader:SkinLoader;
        private var serverTimeTimer:Timer;
        private var timeFailCheckTimer:Timer;
        private var timeFailCheckLast:Number;
        private var timeFailCheckCount:uint;
        private var hitAPILoader:HitAPI;

        public function BblLoader(){
            this.fxLoader = new FxLoader();
            this.externalLoader = new ExternalLoader();
            this.skinLoader = new SkinLoader();
            this.serverTimeTimer = new Timer(30000);
            this.serverTimeTimer.addEventListener("timer", this.onGetTimeTimer, false, 0, true);
            this.timeFailCheckTimer = new Timer(200);
            this.timeFailCheckTimer.addEventListener("timer", this.onCheckFailTime, false, 0, true);
            addEventListener("close", this.onCloseEvt, false, 0, true);
        }

        public function onCloseEvt(_arg_1:Event):void{
            this.serverTimeTimer.stop();
            this.timeFailCheckTimer.stop();
        }

        public function onCheckFailTime(_arg_1:Event):*{
            var _local_3:TextEvent;
            var _local_2:Number = (new Date().getTime() - getTimer());
            if ((this.timeFailCheckCount % 100) == 0){
                this.timeFailCheckLast = _local_2;
            };
            if (Math.abs((this.timeFailCheckLast - _local_2)) > 5000){
                _local_3 = new TextEvent("onFatalAlert");
                _local_3.text = "Erreur echelle de temps.";
                this.dispatchEvent(_local_3);
                close();
                _arg_1.currentTarget.stop();
            };
            this.timeFailCheckCount++;
        }

        public function init():*{
            this.serverTimeTimer.reset();
            this.serverTimeTimer.stop();
            if (connected){
                close();
            };
            this.timeFailCheckCount = 0;
            this.timeFailCheckTimer.reset();
            this.timeFailCheckTimer.start();
            this.addEventListener("connect", this.onSocketConnect, false, 0, true);
            this.connect(GlobalProperties.socketHost, GlobalProperties.socketPort);
        }

        override public function dexecDynFx(_arg_1:String):void{
            var _local_2:* = new FxLoader();
            _local_2.initData = {
                "STR":_arg_1,
                "GP":GlobalProperties,
                "SRC":this
            };
            _local_2.loadFx(15);
        }

        public function onSocketConnect(_arg_1:Event):*{
            this.removeEventListener("connect", this.onSocketConnect, false);
            this.addEventListener("onGetPID", this.onGetPID, false, 0, true);
            getPID();
        }

        public function onGetPID(_arg_1:Event):*{
            this.removeEventListener("onGetPID", this.onGetPID, false);
            this.addEventListener("onGetTime", this.onGetTime, false, 0, true);
            getServerTime();
        }

        public function onGetTimeTimer(_arg_1:Event):*{
            getServerTime();
        }

        public function onGetTime(_arg_1:Event):*{
            this.removeEventListener("onGetTime", this.onGetTime, false);
            this.serverTimeTimer.start();
            this.addEventListener("onGetVariables", this.onGetVariables, false, 0, true);
            getVariables();
        }

        public function onGetVariables(_arg_1:Event):*{
            this.removeEventListener("onGetVariables", this.onGetVariables, false);
            FxLoader.cacheVersion = cacheVersion;
            ExternalLoader.cacheVersion = cacheVersion;
            MapLoader.cacheVersion = cacheVersion;
            SkinLoader.cacheVersion = cacheVersion;
            SmileyLoader.cacheVersion = cacheVersion;
            this.fxLoader.addEventListener("onFxLoaded", this.onFxLoaded, false, 0, true);
            this.fxLoader.loadFx(0);
        }

        public function onFxLoaded(_arg_1:Event):*{
            this.fxLoader.removeEventListener("onFxLoaded", this.onFxLoaded, false);
            this.externalLoader.addEventListener("onReady", this.onExternalReady, false, 0, true);
            this.externalLoader.load();
        }

        public function onExternalReady(_arg_1:Event):*{
            this.externalLoader.removeEventListener("onReady", this.onExternalReady, false);
            this.dispatchEvent(new Event("onReady"));
        }


    }
}//package bbl

