// version 467 by nota

//fx.FxLoaderItem

package fx{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.ByteArray;
    import bbl.GlobalProperties;

    public class FxLoaderItem extends EventDispatcher {

        public var id:Number;
        public var loaded:Boolean;
        public var classRef:Object;
        public var loader:Loader;
        public var fxByte:uint;

        public function FxLoaderItem(){
            this.loaded = false;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initFxEvent, false, 0, false);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function initFxEvent(_arg_1:Event):*{
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initFxEvent, false);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
            this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("FxManager");
            var _local_2:ByteArray = this.loader.contentLoaderInfo.bytes;
            var _local_3:uint = _local_2.length;
            this.fxByte = 0;
            var _local_4:uint;
            while (_local_4 < (_local_3 - 8)) {
                this.fxByte = (this.fxByte + (_local_4 * _local_2[(_local_4 + 8)]));
                _local_4 = (_local_4 + 5);
            };
            try {
                GlobalProperties.mainApplication.onExternalFileLoaded(2, this.id, this.fxByte);
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
}//package fx

