// version 467 by nota

//map.MapLoaderItem

package map{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.net.URLLoader;
    import flash.system.LoaderContext;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import bbl.GlobalProperties;

    public class MapLoaderItem extends EventDispatcher {

        public var id:Number;
        public var loaded:Boolean;
        public var classRef:Object;
        public var loader:Loader;
        public var instance:uint;
        public var urlLoader:URLLoader;
        public var mapByte:uint;
        private var loaderContext:LoaderContext;

        public function MapLoaderItem(){
            this.loaded = false;
            this.loader = new Loader();
            this.urlLoader = new URLLoader();
            this.instance = 0;
            this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initMapEvent, false, 0, false);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function load(_arg_1:URLRequest, _arg_2:LoaderContext):*{
            this.loaderContext = _arg_2;
            this.urlLoader.dataFormat = "binary";
            this.urlLoader.addEventListener("complete", this.completeEvent, false, 0, true);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, true);
            this.urlLoader.load(_arg_1);
        }

        public function completeEvent(_arg_1:Event):*{
            this.urlLoader.removeEventListener("complete", this.completeEvent, false);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
            this.loader.loadBytes(this.urlLoader.data, this.loaderContext);
        }

        public function initMapEvent(_arg_1:Event):*{
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initMapEvent, false);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
            this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Map");
            var _local_2:ByteArray = this.loader.contentLoaderInfo.bytes;
            var _local_3:uint = _local_2.length;
            this.mapByte = 0;
            var _local_4:uint;
            while (_local_4 < (_local_3 - 8)) {
                this.mapByte = (this.mapByte + (_local_4 * _local_2[(_local_4 + 8)]));
                _local_4 = (_local_4 + 5);
            };
            try {
                GlobalProperties.mainApplication.onExternalFileLoaded(3, this.id, this.mapByte);
            }
            catch(err) {
            };
            this.loader = null;
            this.loaded = true;
            dispatchEvent(_arg_1);
        }

        public function errLoader(_arg_1:Event):*{
            this.loader = null;
            dispatchEvent(_arg_1);
        }


    }
}//package map

