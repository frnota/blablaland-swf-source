// version 467 by nota

//map.MapLoader

package map{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;

    public class MapLoader extends EventDispatcher {

        public static var mapList:Array = new Array();
        public static var mapAdr:String = "../data/map/";
        public static var cacheVersion:uint = 0;

        public var lastLoad:MapLoaderItem;
        public var currentLoad:MapLoaderItem;

        public function MapLoader(){
            this.lastLoad = null;
            this.currentLoad = null;
        }

        public static function clearAll():*{
            mapList.splice(0, mapList.length);
        }

        public static function clearById(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < mapList.length) {
                if (mapList[_local_2].id == _arg_1){
                    mapList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }


        public function initMapEvent(_arg_1:Event):*{
            this.lastLoad = this.currentLoad;
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
            this.dispatchEvent(new Event("onMapLoaded"));
        }

        public function errLoader(_arg_1:IOErrorEvent):void{
            dispatchEvent(_arg_1);
            this.removeById(this.currentLoad.id);
            this.removeItemListener(this.currentLoad);
            this.currentLoad = null;
        }

        public function removeById(_arg_1:Number):*{
            var _local_2:uint;
            while (_local_2 < mapList.length) {
                if (mapList[_local_2].id == _arg_1){
                    mapList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function getMapById(_arg_1:Number):MapLoaderItem{
            var _local_3:MapLoaderItem;
            var _local_2:uint;
            while (_local_2 < mapList.length) {
                if (mapList[_local_2].id == _arg_1){
                    _local_3 = mapList[_local_2];
                    mapList.splice(_local_2, 1);
                    mapList.push(_local_3);
                    return (_local_3);
                };
                _local_2++;
            };
            return (null);
        }

        public function abortLoad():*{
            if (this.currentLoad){
                this.removeItemListener(this.currentLoad);
                if (this.currentLoad.instance == 0){
                    this.removeById(this.currentLoad.id);
                    try {
                        this.currentLoad.urlLoader.close();
                    }
                    catch(e) {
                    };
                };
                this.currentLoad = null;
            };
        }

        public function loadMap(_arg_1:Number):void{
            var _local_3:*;
            this.abortLoad();
            var _local_2:MapLoaderItem = this.getMapById(_arg_1);
            if (_local_2){
                if (_local_2.loaded){
                    this.lastLoad = _local_2;
                    dispatchEvent(new Event("onMapLoaded"));
                }
                else {
                    this.currentLoad = _local_2;
                    this.addItemListener(this.currentLoad);
                };
            }
            else {
                this.currentLoad = new MapLoaderItem();
                this.addItemListener(this.currentLoad);
                this.currentLoad.id = _arg_1;
                mapList.push(this.currentLoad);
                _local_3 = new LoaderContext();
                _local_3.applicationDomain = new ApplicationDomain();
                this.currentLoad.load(new URLRequest((((mapAdr + _arg_1) + "/map.swf") + ((cacheVersion) ? ("?cacheVersion=" + cacheVersion) : ""))), _local_3);
            };
        }

        public function addItemListener(_arg_1:MapLoaderItem):*{
            _arg_1.instance++;
            _arg_1.addEventListener(Event.INIT, this.initMapEvent, false, 0, false);
            _arg_1.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function removeItemListener(_arg_1:MapLoaderItem):*{
            _arg_1.instance--;
            _arg_1.removeEventListener(Event.INIT, this.initMapEvent, false);
            _arg_1.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
        }


    }
}//package map

