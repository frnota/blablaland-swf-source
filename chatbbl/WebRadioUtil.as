// version 467 by nota

//chatbbl.WebRadioUtil

package chatbbl{
    import flash.display.SimpleButton;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import ui.PopupItemBase;

    public class WebRadioUtil extends SimpleButton {

        public var utilItem:ChatUtilItem;
        public var popup:Object;
        public var radio:WebRadioPopup;
        public var webRRef:Object;
        public var activity:Object;

        public function WebRadioUtil(_arg_1:*){
            var _local_2:Boolean;
            var _local_3:Number;
            super();
            this.activity = null;
            this.utilItem = _arg_1;
            addEventListener("click", this.onClickEvt, false, 0, true);
            _arg_1.addEventListener("onRemove", this.onRemove, false, 0, true);
            if (((GlobalProperties.mainApplication.camera) && (GlobalProperties.mainApplication.camera.userInterface))){
                GlobalProperties.mainApplication.camera.userInterface.addEventListener("onAction", this.onActionEvt);
            };
            this.webRRef = GlobalProperties.data["WEBRADIOREF"];
            if (this.webRRef){
                _local_2 = GlobalProperties.mainApplication.blablaland.haveWRRef(this.webRRef);
                if (!_local_2){
                    GlobalProperties.mainApplication.blablaland.addWRRef(this.webRRef);
                };
            }
            else {
                if (!this.webRRef){
                    _local_3 = 0.75;
                    if (((GlobalProperties.sharedObject) && (!(GlobalProperties.sharedObject.data.WEBRADIO)))){
                        GlobalProperties.sharedObject.data.WEBRADIO = {"volume":_local_3};
                    }
                    else {
                        _local_3 = GlobalProperties.sharedObject.data.WEBRADIO.volume;
                    };
                    this.webRRef = {
                        "power":false,
                        "volume":_local_3
                    };
                    GlobalProperties.data["WEBRADIOREF"] = this.webRRef;
                    GlobalProperties.mainApplication.blablaland.addWRRef(this.webRRef);
                };
            };
            this.update();
        }

        public function onActionEvt(_arg_1:Object):*{
            if (_arg_1.action == "/radio"){
                if (this.webRRef){
                    if (((_arg_1.actionList.length == 0) || (_arg_1.actionList[0] == ""))){
                        this.onClickEvt(null);
                    }
                    else {
                        if (((_arg_1.actionList[0] == "oui") || (_arg_1.actionList[0] == "on"))){
                            if (this.webRRef.volume < 0.1){
                                this.webRRef.volume = 0.1;
                            };
                            this.webRRef.power = true;
                            this.update();
                            if (this.radio){
                                this.radio.updateUI();
                            };
                        }
                        else {
                            if (((_arg_1.actionList[0] == "non") || (_arg_1.actionList[0] == "off"))){
                                this.webRRef.power = false;
                                this.update();
                                if (this.radio){
                                    this.radio.updateUI();
                                };
                            }
                            else {
                                this.onClickEvt(null);
                            };
                        };
                    };
                    _arg_1.stopImmediatePropagation();
                };
            };
        }

        public function onRemove(_arg_1:Event):*{
            if (((GlobalProperties.mainApplication.camera) && (GlobalProperties.mainApplication.camera.userInterface))){
                GlobalProperties.mainApplication.camera.userInterface.removeEventListener("onAction", this.onActionEvt);
            };
            this.setActivity(false);
            this.clear();
        }

        public function activityClick(_arg_1:Event):*{
            this.webRRef.power = false;
            if (this.radio){
                this.radio.updateUI();
            };
            this.update();
        }

        public function setActivity(_arg_1:Boolean):*{
            if (((_arg_1) && (!(this.activity)))){
                this.activity = GlobalProperties.mainApplication.camera.addIcon();
                this.activity.overBulle = "Couper la radio ExtraDance";
                this.activity.iconContent.addChild(new WRActivity());
                this.activity.iconContent.addEventListener("click", this.activityClick);
                this.activity.clickable = true;
            }
            else {
                if (((!(_arg_1)) && (this.activity))){
                    this.activity.removeIcon();
                    this.activity = null;
                };
            };
        }

        public function update():*{
            GlobalProperties.mainApplication.blablaland.setWRRefVolume(this.webRRef, ((this.webRRef.power) ? this.webRRef.volume : 0));
            this.setActivity(this.webRRef.power);
            if (((GlobalProperties.sharedObject) && (GlobalProperties.sharedObject.data.WEBRADIO))){
                GlobalProperties.sharedObject.data.WEBRADIO.volume = this.webRRef.volume;
            };
        }

        public function onKillEvt(_arg_1:Event=null):*{
            this.popup = null;
            this.radio = null;
        }

        public function clear(_arg_1:Event=null):*{
            if (this.popup){
                this.popup.close();
                this.popup = null;
                this.radio = null;
            };
        }

        public function onClickEvt(_arg_1:Event):*{
            if (this.popup){
                this.clear();
                return;
            };
            if (!GlobalProperties.mainApplication.blablaland.webRadioAllowed){
                this.clear();
                return;
            };
            this.popup = GlobalProperties.mainApplication.winPopup.open({"CLASS":PopupItemBase});
            this.popup.addEventListener("onKill", this.onKillEvt);
            this.radio = new WebRadioPopup();
            this.radio.win = this.popup;
            this.radio.util = this;
            this.popup.addChild(this.radio);
            this.radio.init();
        }


    }
}//package chatbbl

