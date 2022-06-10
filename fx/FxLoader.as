// version 467 by nota

//fx.FxLoader

package fx{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import bbl.GlobalProperties;
    import flash.system.SecurityDomain;
    import flash.net.URLRequest;

    public class FxLoader extends EventDispatcher {

        public static var fxList:Array = new Array();
        public static var fxAdr:String = "../data/fx/";
        public static var cacheVersion:uint = 0;

        public var lastLoad:FxLoaderItem;
        public var currentLoad:FxLoaderItem;
        public var initData:Object;
        public var clearInitData:Boolean;

        public function FxLoader(){
            this.lastLoad = null;
            this.currentLoad = null;
            this.clearInitData = true;
        }

        public static function clearAll():*{
            fxList.splice(0, fxList.length);
        }

        public static function clearById(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < fxList.length) {
                if (fxList[_local_2].id == _arg_1){
                    fxList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }


        public function initFxEvent(_arg_1:Event):*{
            this.lastLoad = this.currentLoad;
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
            this.doAtInit();
            this.dispatchEvent(new Event("onFxLoaded"));
        }

        public function errLoader(_arg_1:IOErrorEvent):void{
            dispatchEvent(_arg_1);
            var _local_2:uint;
            while (_local_2 < fxList.length) {
                if (fxList[_local_2] == this.currentLoad){
                    fxList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
        }

        public function doAtInit():*{
            var _local_1:Object;
            if (((this.lastLoad) && (this.initData))){
                _local_1 = new (this.lastLoad.classRef)();
                _local_1.initFx(this.initData);
                if (this.clearInitData){
                    this.initData = null;
                };
            };
        }

        public function getFxById(_arg_1:Number):FxLoaderItem{
            var _local_3:FxLoaderItem;
            var _local_2:uint;
            while (_local_2 < fxList.length) {
                if (fxList[_local_2].id == _arg_1){
                    _local_3 = fxList[_local_2];
                    fxList.splice(_local_2, 1);
                    fxList.push(_local_3);
                    return (_local_3);
                };
                _local_2++;
            };
            return (null);
        }

        public function loadFx(_arg_1:Number):FxLoaderItem{
            var _local_3:*;
            if (this.currentLoad){
                this.removeItemListener(this.currentLoad);
                this.currentLoad = null;
            };
            var _local_2:FxLoaderItem = this.getFxById(_arg_1);
            if (_local_2){
                if (_local_2.loaded){
                    this.lastLoad = _local_2;
                    this.doAtInit();
                    dispatchEvent(new Event("onFxLoaded"));
                    return (_local_2);
                };
                this.currentLoad = _local_2;
                this.addItemListener(this.currentLoad);
            }
            else {
                this.currentLoad = new FxLoaderItem();
                this.addItemListener(this.currentLoad);
                this.currentLoad.id = _arg_1;
                fxList.push(this.currentLoad);
                _local_3 = new LoaderContext();
                _local_3.applicationDomain = new ApplicationDomain();
                if (GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1){
                    _local_3.securityDomain = SecurityDomain.currentDomain;
                };
                this.currentLoad.loader.load(new URLRequest((((fxAdr + _arg_1) + "/fx.swf") + ((cacheVersion) ? ("?cacheVersion=" + cacheVersion) : ""))), _local_3);
            };
            return (null);
        }

        public function addItemListener(_arg_1:FxLoaderItem):*{
            _arg_1.addEventListener(Event.INIT, this.initFxEvent, false, 0, false);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function removeItemListener(_arg_1:FxLoaderItem):*{
            _arg_1.removeEventListener(Event.INIT, this.initFxEvent, false);
            _arg_1.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
        }


    }
}//package fx

