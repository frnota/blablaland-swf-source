// version 467 by nota

//perso.smiley.SmileyLoader

package perso.smiley{
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import bbl.GlobalProperties;
    import flash.system.SecurityDomain;
    import flash.net.URLRequest;

    public class SmileyLoader extends EventDispatcher {

        public static var smileyList:Array = new Array();
        public static var smileyAdr:String = "../data/smiley/";
        public static var cacheVersion:uint = 0;


        public static function clearAll():*{
            smileyList.splice(0, smileyList.length);
        }


        public function errLoader(_arg_1:IOErrorEvent):void{
            var _local_2:uint;
            while (_local_2 < smileyList.length) {
                if (smileyList[_local_2] == _arg_1.currentTarget){
                    smileyList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            _arg_1.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false);
        }

        public function getSmileyById(_arg_1:Number):SmileyLoaderItem{
            var _local_3:SmileyLoaderItem;
            var _local_2:uint;
            while (_local_2 < smileyList.length) {
                if (smileyList[_local_2].id == _arg_1){
                    _local_3 = smileyList[_local_2];
                    smileyList.splice(_local_2, 1);
                    smileyList.push(_local_3);
                    return (_local_3);
                };
                _local_2++;
            };
            return (null);
        }

        public function loadPack(_arg_1:Number):SmileyPack{
            var _local_4:*;
            var _local_2:SmileyLoaderItem = this.getSmileyById(_arg_1);
            if (!_local_2){
                _local_2 = new SmileyLoaderItem();
                _local_2.addEventListener(IOErrorEvent.IO_ERROR, this.errLoader, false, 0, false);
                _local_2.id = _arg_1;
                smileyList.push(_local_2);
                _local_4 = new LoaderContext();
                _local_4.applicationDomain = new ApplicationDomain();
                if (GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1){
                    _local_4.securityDomain = SecurityDomain.currentDomain;
                };
                _local_2.loader.load(new URLRequest((((smileyAdr + _arg_1) + "/SmileyPack.swf") + ((cacheVersion) ? ("?cacheVersion=" + cacheVersion) : ""))), _local_4);
            };
            var _local_3:SmileyPack = new SmileyPack();
            _local_3.loaderItem = _local_2;
            return (_local_3);
        }


    }
}//package perso.smiley

