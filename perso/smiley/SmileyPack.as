// version 467 by nota

//perso.smiley.SmileyPack

package perso.smiley{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class SmileyPack extends EventDispatcher {

        public var loaderItem:SmileyLoaderItem;


        public function SmileyManager():*{
        }

        public function initEvent(_arg_1:Event):*{
            this.loaderItem.removeEventListener(Event.INIT, this.initEvent, false);
            this.loaderItem.removeEventListener(IOErrorEvent.IO_ERROR, this.errEvent, false);
            dispatchEvent(new Event("onPackLoaded"));
        }

        public function errEvent(_arg_1:Event):*{
            this.loaderItem.removeEventListener(Event.INIT, this.initEvent, false);
            this.loaderItem.removeEventListener(IOErrorEvent.IO_ERROR, this.errEvent, false);
            dispatchEvent(_arg_1);
        }

        override public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void{
            super.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if (((this.loaderItem.loaded) && (_arg_1 == "onPackLoaded"))){
                dispatchEvent(new Event("onPackLoaded"));
            }
            else {
                this.loaderItem.addEventListener(Event.INIT, this.initEvent, false, 0, true);
                this.loaderItem.addEventListener(IOErrorEvent.IO_ERROR, this.errEvent, false, 0, true);
            };
        }


    }
}//package perso.smiley

