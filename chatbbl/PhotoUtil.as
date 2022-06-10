// version 467 by nota

//chatbbl.PhotoUtil

package chatbbl{
    import flash.display.SimpleButton;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import flash.display.BitmapData;

    public class PhotoUtil extends SimpleButton {

        public var utilItem:ChatUtilItem;
        public var photoWin:Object;

        public function PhotoUtil(_arg_1:*){
            this.photoWin = null;
            addEventListener("click", this.onClickEvt, false, 0, true);
            _arg_1.addEventListener("onRemove", this.onRemove, false, 0, true);
            if (((GlobalProperties.mainApplication.camera) && (GlobalProperties.mainApplication.camera.userInterface))){
                GlobalProperties.mainApplication.camera.userInterface.addEventListener("onAction", this.onActionEvt);
            };
        }

        public function onActionEvt(_arg_1:Object):*{
            if (_arg_1.action == "/photo"){
                this.onClickEvt(null);
                _arg_1.stopImmediatePropagation();
            };
        }

        public function onRemove(_arg_1:Event):*{
            if (((GlobalProperties.mainApplication.camera) && (GlobalProperties.mainApplication.camera.userInterface))){
                GlobalProperties.mainApplication.camera.userInterface.removeEventListener("onAction", this.onActionEvt);
            };
        }

        public function clear(_arg_1:Event=null):*{
            this.clearWin();
        }

        public function clearWin(_arg_1:Event=null):*{
            if (this.photoWin){
                this.photoWin.kill();
            };
        }

        public function onClickEvt(_arg_1:Event):*{
            this.clear();
            if (GlobalProperties.mainApplication.camera){
                if (GlobalProperties.mainApplication.camera.mainUser){
                    GlobalProperties.mainApplication.camera.mainUser.jumping = 0;
                    GlobalProperties.mainApplication.camera.mainUser.walking = 0;
                    GlobalProperties.mainApplication.camera.sendMainUserState();
                };
            };
            var _local_2:BitmapData = new BitmapData(950, 560, false, 0);
            _local_2.draw(GlobalProperties.mainApplication);
            this.photoWin = GlobalProperties.mainApplication.winPopup.open({
                "APP":PhotoUtilPopup,
                "ID":"PhotoUtilPopup",
                "TITLE":"Photo du Tchat"
            });
            this.photoWin.addEventListener("onKill", this.onKillWin);
            Object(this.photoWin.content).image = _local_2;
            Object(this.photoWin.content).init();
        }

        public function onKillWin(_arg_1:Event):*{
            this.photoWin = null;
        }


    }
}//package chatbbl

