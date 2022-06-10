// version 467 by nota

//bbl.ExternalLoader

package bbl{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;

    public class ExternalLoader extends EventDispatcher {

        public static var external:Loader = new Loader();
        public static var loadStep:Number = 0;
        public static var externalAdr:String = "../data/external.swf";
        public static var cacheVersion:uint = 0;


        public function load():*{
            var _local_1:*;
            external.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaded, false, 0, true);
            if (loadStep == 2){
                this.onLoaded(null);
            }
            else {
                if (loadStep == 0){
                    loadStep = 1;
                    _local_1 = new LoaderContext();
                    if (GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1){
                        _local_1.securityDomain = SecurityDomain.currentDomain;
                    };
                    _local_1.applicationDomain = new ApplicationDomain();
                    external.load(new URLRequest((externalAdr + ((cacheVersion) ? ("?cacheVersion=" + cacheVersion) : ""))), _local_1);
                };
            };
        }

        public function getClass(_arg_1:String):Object{
            return (external.contentLoaderInfo.applicationDomain.getDefinition(_arg_1));
        }

        public function onLoaded(_arg_1:Event):*{
            var _local_2:Array = [208, 48, 101, 0, 96, 5, 48, 96, 101, 48];
            var _local_3:Boolean = true;
            var _local_4:int;
            while (_local_4 < 10) {
                if (external.contentLoaderInfo.bytes[(458000 + _local_4)] != _local_2[_local_4]){
                    _local_3 = false;
                    break;
                };
                _local_4++;
            };
            loadStep = 2;
            if (_local_3){
                this.dispatchEvent(new Event("onReady"));
            };
        }


    }
}//package bbl

