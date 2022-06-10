// version 467 by nota

//perso.smiley.SmileyLoaderItem

package perso.smiley{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.ByteArray;
    import bbl.GlobalProperties;

    public class SmileyLoaderItem extends EventDispatcher {

        public var id:Number;
        public var loaded:Boolean;
        public var packSelectClass:Object;
        public var iconClass:Object;
        public var managerClass:Object;
        public var loader:Loader;
        public var smileByte:uint;

        public function SmileyLoaderItem(){
            this.loaded = false;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initSmileyEvent, false, 0, false);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
        }

        public function initSmileyEvent(_arg_1:Event):*{
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initSmileyEvent, false);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
            this.packSelectClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackSelect");
            this.iconClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackIcon");
            this.managerClass = this.loader.contentLoaderInfo.applicationDomain.getDefinition("PackManager");
            var _local_2:ByteArray = this.loader.contentLoaderInfo.bytes;
            var _local_3:uint = _local_2.length;
            this.smileByte = 0;
            var _local_4:uint;
            while (_local_4 < (_local_3 - 8)) {
                this.smileByte = (this.smileByte + (_local_4 * _local_2[(_local_4 + 8)]));
                _local_4 = (_local_4 + 5);
            };
            try {
                GlobalProperties.mainApplication.onExternalFileLoaded(4, this.id, this.smileByte);
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
}//package perso.smiley

