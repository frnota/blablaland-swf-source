// version 467 by nota

//chatbbl.ChatUtilItem

package chatbbl{
    import flash.events.EventDispatcher;
    import bbl.InterfaceUtilsItem;
    import fx.FxLoader;
    import flash.utils.Timer;
    import flash.events.Event;

    public class ChatUtilItem extends EventDispatcher {

        public var utilInterface:InterfaceUtilsItem;
        public var chat:ChatUtils;
        public var data:Object;
        public var id:uint;
        public var sid:uint;
        public var fxLoader:FxLoader;
        public var fxManager:Object;
        private var timer:Timer;

        public function ChatUtilItem(){
            this.timer = null;
            this.data = new Object();
            this.fxManager = null;
            this.fxLoader = null;
            this.id = 0;
            this.sid = 0;
        }

        public function removeUtil():*{
            this.chat.removeUtil(this);
        }

        public function dispose():*{
            if (this.fxLoader){
                this.fxLoader.removeEventListener("onFxLoaded", this.onFxLoaded);
            };
            if (this.fxManager){
                this.fxManager.dispose();
            };
            this.clearTimer();
        }

        public function onFxLoaded(_arg_1:Event):*{
            var _local_2:Object = this.fxLoader.lastLoad.classRef;
            this.fxManager = new (_local_2)();
            this.fxManager.camera = this.chat.camera;
            this.fxManager.walker = this.chat.camera.mainUser;
            this.fxManager.setUtil(this);
        }

        public function loadFx(_arg_1:uint, _arg_2:uint, _arg_3:uint):*{
            if (!this.fxLoader){
                this.fxLoader = new FxLoader();
                this.fxLoader.addEventListener("onFxLoaded", this.onFxLoaded, false, 0, true);
            };
            this.id = _arg_2;
            this.sid = _arg_3;
            this.fxLoader.loadFx(_arg_1);
        }

        public function setExpireTimer(_arg_1:uint):*{
            this.clearTimer();
            if (_arg_1){
                this.timer = new Timer(_arg_1);
                this.timer.addEventListener("timer", this.onTimerEvent, false, 0, true);
                this.timer.start();
            };
        }

        public function onTimerEvent(_arg_1:Event):*{
            this.timer.stop();
            this.removeUtil();
        }

        public function clearTimer():*{
            if (this.timer){
                this.timer.stop();
                this.timer.removeEventListener("timer", this.onTimerEvent, false);
                this.timer = null;
            };
        }


    }
}//package chatbbl

