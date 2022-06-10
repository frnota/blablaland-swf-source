// version 467 by nota

//perso.SkinLoaderItem

package perso{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.ByteArray;

    public class SkinLoaderItem extends EventDispatcher {

        public var loaded:Boolean;
        public var classRef:Object;
        public var loader:Loader;
        public var ldc:LoaderContext;
        public var urlr:URLRequest;
        public var nbTry:uint;
        public var skinByte:uint;
        private var sMod:uint;
        private var _id:Number;

        public function SkinLoaderItem(){
            this.nbTry = 0;
            this.loaded = false;
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.initSkinEvent, false, 0, false);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
            this.sMod = ((Math.random() * 1000) + 1);
        }

        public function initSkinEvent(_arg_1:Event):*{
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT, this.initSkinEvent, false);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
            this.classRef = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Skin");
            var _local_2:ByteArray = this.loader.contentLoaderInfo.bytes;
            var _local_3:uint = _local_2.length;
            this.skinByte = 0;
            var _local_4:uint;
            while (_local_4 < (_local_3 - 8)) {
                this.skinByte = (this.skinByte + (_local_4 * _local_2[(_local_4 + 8)]));
                _local_4 = (_local_4 + 5);
            };
            this.loader = null;
            this.loaded = true;
            dispatchEvent(_arg_1);
        }

        public function errLoader(_arg_1:Event):*{
            dispatchEvent(_arg_1);
        }

        public function get id():Number{
            return (this._id / this.sMod);
        }

        public function set id(_arg_1:Number):*{
            this._id = (_arg_1 * this.sMod);
        }


    }
}//package perso

