// version 467 by nota

//perso.SkinLoader

package perso{
    import flash.events.EventDispatcher;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.system.LoaderContext;
    import bbl.GlobalProperties;
    import flash.system.SecurityDomain;
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;

    public class SkinLoader extends EventDispatcher {

        public static var skinList:Array = new Array();
        public static var skinAdr:String = "../data/skin/";
        public static var cacheVersion:uint = 0;

        public var lastLoad:SkinLoaderItem;
        public var currentLoad:SkinLoaderItem;
        private var maxTry:uint;
        private var retryTimer:Timer;

        public function SkinLoader(){
            this.lastLoad = null;
            this.currentLoad = null;
            this.maxTry = 3;
            this.retryTimer = new Timer(4000);
            this.retryTimer.addEventListener("timer", this.retryTimerEvt);
        }

        public static function clearAll():*{
            skinList.splice(0, skinList.length);
        }

        public static function clearById(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < skinList.length) {
                if (skinList[_local_2].id == _arg_1){
                    skinList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }


        public function initSkinEvent(_arg_1:Event):*{
            this.lastLoad = this.currentLoad;
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
            this.retryTimer.stop();
            this.dispatchEvent(new Event("onSkinLoaded"));
        }

        public function retryTimerEvt(_arg_1:Event):*{
            this.retryTimer.stop();
            if (this.currentLoad){
                this.currentLoad.loader.load(this.currentLoad.urlr, this.currentLoad.ldc);
            };
        }

        public function errLoader(_arg_1:IOErrorEvent):void{
            var _local_2:uint;
            if (this.currentLoad){
                if (this.currentLoad.nbTry >= this.maxTry){
                    dispatchEvent(_arg_1);
                    _local_2 = 0;
                    while (_local_2 < skinList.length) {
                        if (skinList[_local_2] == this.currentLoad){
                            skinList.splice(_local_2, 1);
                            break;
                        };
                        _local_2++;
                    };
                    this.removeItemListener(this.currentLoad);
                    this.currentLoad = null;
                }
                else {
                    this.currentLoad.nbTry++;
                    this.retryTimer.reset();
                    this.retryTimer.start();
                };
            };
        }

        public function getSkinById(_arg_1:Number):SkinLoaderItem{
            var _local_3:SkinLoaderItem;
            var _local_2:uint;
            while (_local_2 < skinList.length) {
                if (skinList[_local_2].id == _arg_1){
                    _local_3 = skinList[_local_2];
                    skinList.splice(_local_2, 1);
                    skinList.push(_local_3);
                    return (_local_3);
                };
                _local_2++;
            };
            return (null);
        }

        public function loadSkin(_arg_1:Number):void{
            if (this.currentLoad){
                this.removeItemListener(this.currentLoad);
                this.retryTimer.stop();
                this.currentLoad = null;
            };
            var _local_2:SkinLoaderItem = this.getSkinById(_arg_1);
            if (_local_2){
                if (_local_2.loaded){
                    this.lastLoad = _local_2;
                    dispatchEvent(new Event("onSkinLoaded"));
                }
                else {
                    this.currentLoad = _local_2;
                    this.addItemListener(this.currentLoad);
                };
            }
            else {
                this.currentLoad = new SkinLoaderItem();
                this.addItemListener(this.currentLoad);
                this.currentLoad.id = _arg_1;
                skinList.push(this.currentLoad);
                this.currentLoad.ldc = new LoaderContext();
                if (GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1){
                    this.currentLoad.ldc.securityDomain = SecurityDomain.currentDomain;
                };
                this.currentLoad.ldc.applicationDomain = new ApplicationDomain();
                this.currentLoad.urlr = new URLRequest((((skinAdr + _arg_1) + "/skin.swf") + ((cacheVersion) ? ("?cacheVersion=" + cacheVersion) : "")));
                this.currentLoad.loader.load(this.currentLoad.urlr, this.currentLoad.ldc);
            };
        }

        public function addItemListener(_arg_1:SkinLoaderItem):*{
            _arg_1.addEventListener(Event.INIT, this.initSkinEvent, false, 0, false);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function removeItemListener(_arg_1:SkinLoaderItem):*{
            _arg_1.removeEventListener(Event.INIT, this.initSkinEvent, false);
            _arg_1.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
        }


    }
}//package perso

