// version 467 by nota

//chatbbl.ChatInterface

package chatbbl{
    import bbl.ClickOptionItem;
    import ui.ScrollRectArea;
    import bbl.InfoBulle;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.utils.getTimer;
    import net.SocketMessage;
    import bbl.GlobalProperties;
    import flash.net.URLVariables;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.external.ExternalInterface;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import chatbbl.application.OptionUser;
    import fx.FxLoader;
    import bbl.ClickOptionPopup;
    import perso.User;
    import perso.WalkerPhysicEvent;
    import bbl.InterfaceEvent;
    import ui.PopupItemBase;
    import flash.display.MovieClip;
    import perso.SkinLoader;
    import map.MapLoader;
    import chatbbl.application.AlertList;
    import flash.events.TextEvent;
    import chatbbl.application.ContactList;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    import chatbbl.application.BBPOD;
    import map.MapSelector;
    import flash.net.navigateToURL;
    import perso.smiley.SmileyLoader;
    import perso.smiley.SmileyEvent;

    public class ChatInterface extends ChatBase {

        public var userInterface:Interface;
        public var userOptionAction:ClickOptionItem;
        private var serverSelector:Object;
        private var _ScrollRectArea:ScrollRectArea;

        public var currentBBL:uint = 0;
        public var newAlertCount:uint = 0;
        public var alertList:Array = new Array();
        private var infoBulleClip:InfoBulle = null;
        public var userOptionPopup:Object = null;
        private var friendPopup:Object = null;
        private var alertPopup:Object = null;
        private var firstAskUserKdo:Boolean = true;
        private var lastUpdateKdo:Number = -500000;
        private var updateKdoTimer:Timer = new Timer(1000);
        public var userOption:ClickOptionItem = new ClickOptionItem();

        public function ChatInterface(){
            this.updateKdoTimer.addEventListener("timer", this.kdoTimerEvt);
            var _local_1:ClickOptionItem = this.userOption.addChild();
            _local_1.clip = new UserOptionMp();
            _local_1.clip.width = _local_1.clipWidth;
            _local_1.clip.height = _local_1.clipHeight;
            _local_1.addEventListener("click", this.onOptionMpEvt, false);
            _local_1 = this.userOption.addChild();
            _local_1.clip = new UserOptionOption();
            _local_1.clip.width = _local_1.clipWidth;
            _local_1.clip.height = _local_1.clipHeight;
            _local_1.addEventListener("click", this.onOptionOptionEvt, false);
            _local_1 = this.userOption.addChild();
            _local_1.clip = new UserOptionJeux();
            _local_1.clip.width = _local_1.clipWidth;
            _local_1.clip.height = _local_1.clipHeight;
            _local_1 = _local_1.addChild();
            _local_1.clip = new UserOptionNavale();
            _local_1.clip.width = _local_1.clipWidth;
            _local_1.clip.height = _local_1.clipHeight;
            _local_1.addEventListener("click", this.onOptionNavaleEvt, false);
            _local_1 = this.userOption.addChild();
            _local_1.visible = false;
            _local_1.clip = new UserOptionAction();
            _local_1.clip.width = _local_1.clipWidth;
            _local_1.clip.height = _local_1.clipHeight;
            this.userOptionAction = _local_1;
            super();
        }

        public function kdoTimerEvt(_arg_1:Event):*{
            this.updateKdoTimer.delay = ((60 * 1000) * 2);
            this.updateKdoTimer.reset();
            this.updateKdoTimer.start();
            this.updateKdoList();
        }

        public function updateKdoList():*{
            var _local_2:*;
            this.firstAskUserKdo = false;
            var _local_1:Number = getTimer();
            if (this.lastUpdateKdo < (_local_1 - 5000)){
                this.lastUpdateKdo = getTimer();
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 5);
                _local_2.bitWriteUnsignedInt(8, 1);
                if (blablaland){
                    blablaland.send(_local_2);
                };
            }
            else {
                this.updateKdoTimer.reset();
                this.updateKdoTimer.delay = 5000;
                this.updateKdoTimer.start();
            };
        }

        override public function setLoadingClip(_arg_1:Boolean, _arg_2:uint=0):*{
            var _local_3:String;
            super.setLoadingClip(_arg_1, _arg_2);
            if (loadingClip){
                if (_arg_2 == 1){
                    _local_3 = stage.loaderInfo.parameters.DAILYMSGSECU;
                    if (((_local_3) && (this.userInterface))){
                        this.userInterface.addLocalMessage((("<span class='dailymsgsecu'>Bienvenue sur Blablaland !\nRappel de sécurité : " + _local_3) + "</span>"));
                    };
                };
            };
        }

        override public function initBlablaland():*{
            super.initBlablaland();
            blablaland.addEventListener("onWorldCounterUpdate", this.onWorldCounterUpdate, false, 0, true);
            blablaland.addEventListener("onXPChange", this.onXPChange, false, 0, true);
            blablaland.addEventListener("onReloadBBL", this.onReloadBBL, false, 0, true);
            this.userInterface.visible = false;
            this.userInterface.addEventListener("onSendPrivateMessage", this.onInterfaceSendPrivateMessage, false);
            this.userInterface.addEventListener("onSendMessage", this.onInterfaceSendMessage, false);
            this.userInterface.addEventListener("onSmile", this.onInterfaceSmile, false);
            this.userInterface.addEventListener("onShowMP", this.onInterfaceShowMP, false);
            this.userInterface.addEventListener("onModoMessage", this.onInterfaceModoMessage, false);
            this.userInterface.addEventListener("onSelectUser", this.onInterfaceSelectUser, false);
            this.userInterface.addEventListener("onCreve", this.onInterfaceCreve, false);
            this.userInterface.addEventListener("onDodo", this.onInterfaceDodo, false);
            this.userInterface.addEventListener("onPrison", this.onInterfacePrison, false);
            this.userInterface.addEventListener("onOpenAlert", this.onInterfaceOpenAlert, false);
            this.userInterface.addEventListener("onOpenFriend", this.onInterfaceOpenFriend, false);
            this.userInterface.addEventListener("onOpenDebug", this.onInterfaceOpenDebug, false);
            this.userInterface.addEventListener("onOpenBBPOD", this.onInterfaceOpenBBPOD, false);
            this.userInterface.addEventListener("onOpenChangeUnivers", this.onInterfaceChangeUnivers, false);
            this.userInterface.addEventListener("onOpenCarte", this.onInterfaceOpenCarte, false);
            this.userInterface.addEventListener("onOpenProfil", this.onInterfaceOpenProfil, false);
            this.userInterface.addEventListener("onWarEvent", this.onInterfaceWar, false);
            this.userInterface.addEventListener("onPoissonAvril", this.onInterfacePoissonAvril, false);
            this.userInterface.addEventListener("onReload", this.onInterfaceReload, false);
            this.userInterface.addEventListener("onAction", this.onInterfaceAction, false);
            this.userInterface.infoBulle = this.infoBulle;
        }

        override public function close():*{
            this.userInterface.visible = true;
            this.unEventInterface();
            if (blablaland){
                blablaland.removeEventListener("onWorldCounterUpdate", this.onWorldCounterUpdate, false);
                blablaland.removeEventListener("onXPChange", this.onXPChange, false);
                blablaland.removeEventListener("onReloadBBL", this.onReloadBBL, false);
            };
            super.close();
        }

        public function addBBL(_arg_1:int):*{
            this.setBBL((this.currentBBL + _arg_1));
        }

        public function getBBL():*{
            var _local_1:URLVariables = new URLVariables();
            _local_1.CACHE = new Date().getTime();
            _local_1.SESSION = session;
            var _local_2:URLRequest = new URLRequest((GlobalProperties.scriptAdr + "/chat/getBBL.php"));
            _local_2.method = "POST";
            _local_2.data = _local_1;
            var _local_3:URLLoader = new URLLoader();
            _local_3.dataFormat = "variables";
            _local_3.load(_local_2);
            _local_3.addEventListener("complete", this.onGetBBL, false, 0, true);
        }

        public function onGetBBL(_arg_1:Event):*{
            this.setBBL(Number(_arg_1.currentTarget.data.BBL));
        }

        public function setBBL(_arg_1:int):*{
            var _local_2:ChatAlertItem;
            if (((!(this.currentBBL == _arg_1)) && (this.currentBBL > 0))){
                this.userInterface.addLocalMessage((("<span class='info'>Tu as maintenant " + _arg_1) + " Blabillons</span>"));
                _local_2 = new ChatAlertItem();
                _local_2.texte = (("Tu as maintenant <font color='#ff0000'>" + _arg_1) + "</font> Blabillons !");
                _local_2.type = 5;
                this.addAlert(_local_2);
                ExternalInterface.call("bblinfos_setBBL", _arg_1);
            };
            this.currentBBL = _arg_1;
            this.userInterface.bbl = _arg_1;
        }

        public function clearAllAlert():*{
            this.alertList.splice(0, this.alertList.length);
            dispatchEvent(new Event("onAlertChange"));
        }

        public function addAlert(_arg_1:ChatAlertItem):*{
            this.alertList.unshift(_arg_1);
            while (this.alertList.length > 20) {
                this.alertList.pop();
            };
            this.newAlertCount++;
            this.userInterface.warnCount = this.newAlertCount;
            dispatchEvent(new Event("onAlertChange"));
        }

        public function addTextAlert(_arg_1:String, _arg_2:Boolean=false):*{
            var _local_3:ChatAlertItem = new ChatAlertItem();
            _local_3.texte = _arg_1;
            _local_3.type = 4;
            this.addAlert(_local_3);
        }

        public function onMapCountChange(_arg_1:Event):*{
            this.userInterface.mapCount = camera.userList.length;
        }

        public function onWorldCounterUpdate(_arg_1:Event):*{
            this.userInterface.worldCount = blablaland.worldCount;
            this.userInterface.universCount = blablaland.universCount;
            ExternalInterface.call("bblinfos_setNBC", blablaland.universCount);
        }

        public function onXPChange(_arg_1:Event):*{
            ExternalInterface.call("bblinfos_setXP", blablaland.xp);
            this.userInterface.xp = blablaland.xp;
        }

        public function onReloadBBL(_arg_1:Event):*{
            this.getBBL();
        }

        override public function onEvent(_arg_1:Event):*{
            var _local_2:String;
            if (_arg_1.type == "onFatalAlert"){
                _local_2 = this.userInterface.htmlEncode(Object(_arg_1).text);
                this.userInterface.addLocalMessage((("<span class='message_modo'>" + _local_2) + "</span>"));
            };
            if (((_arg_1.type == IOErrorEvent.IO_ERROR) || (_arg_1.type == SecurityErrorEvent.SECURITY_ERROR))){
                this.userInterface.addLocalMessage("<span class='message_modo'>\nLa connexion au jeu a échoué</span>");
            };
            if (_arg_1.type == Event.CLOSE){
                _local_2 = "La connexion au jeu vient d'être interrompue !";
                this.userInterface.addLocalMessage((("<span class='message_modo'>" + _local_2) + "</span>"));
            };
            super.onEvent(_arg_1);
        }

        override public function onGetCamera(_arg_1:Event):*{
            super.onGetCamera(_arg_1);
            this.firstAskUserKdo = true;
            camera.userInterface = this.userInterface;
            camera.addEventListener("onClickUser", this.CameraOnClickUser, false, 0, true);
            camera.addEventListener("onMapCountChange", this.onMapCountChange, false, 0, true);
            camera.quality = GlobalProperties.sharedObject.data.QUALITY.quality;
            if (blablaland.uid){
                this.getBBL();
            };
        }

        override public function onCameraEvent(_arg_1:Event=null):*{
            if (camera.cameraReady){
                this.userInterface.visible = true;
                if (((this.firstAskUserKdo) && (blablaland.uid))){
                    this.kdoTimerEvt(null);
                };
            };
            super.onCameraEvent(_arg_1);
        }

        public function addUserOption(_arg_1:ClickOptionItem=null):*{
            return (this.userOptionAction.addChild(_arg_1));
        }

        public function removeUserOption(_arg_1:ClickOptionItem):*{
            this.userOptionAction.removeChild(_arg_1);
        }

        public function onOptionMpEvt(_arg_1:Event):*{
            var _local_2:ClickOptionItem = ClickOptionItem(_arg_1.currentTarget);
            this.userInterface.setMP(_local_2.root.data["PSEUDO"]);
        }

        public function onOptionOptionEvt(_arg_1:Event):*{
            var _local_2:ClickOptionItem = ClickOptionItem(_arg_1.currentTarget);
            if (!blablaland.uid){
                msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Impossible !"
                }, {
                    "MSG":"Tu ne peux pas acceder aux options en étant touriste.",
                    "ACTION":"OK"
                });
            }
            else {
                if (!_local_2.root.data["UID"]){
                    msgPopup.open({
                        "APP":PopupMessage,
                        "TITLE":"Impossible !"
                    }, {
                        "MSG":"Il n'y a pas d'option sur un touriste.",
                        "ACTION":"OK"
                    });
                }
                else {
                    winPopup.open({
                        "APP":OptionUser,
                        "ID":("user_" + _local_2.root.data["UID"]),
                        "TITLE":("Options de " + _local_2.root.data["PSEUDO"])
                    }, {
                        "UID":_local_2.root.data["UID"],
                        "PSEUDO":_local_2.root.data["PSEUDO"]
                    });
                };
            };
        }

        public function onOptionNavaleEvt(_arg_1:Event):*{
            var _local_2:ClickOptionItem = ClickOptionItem(_arg_1.currentTarget);
            var _local_3:FxLoader = new FxLoader();
            _local_3.initData = {
                "CHAT":this,
                "ACTION":1,
                "UID":_local_2.root.data["UID"]
            };
            _local_3.loadFx(10);
        }

        public function clickUser(_arg_1:uint, _arg_2:String):*{
            var _local_3:uint;
            if (this.userOptionPopup){
                this.userOptionPopup.close();
            };
            this.userOption.data["UID"] = _arg_1;
            this.userOption.data["PSEUDO"] = _arg_2;
            _local_3 = 0;
            while (_local_3 < this.userOption.childList.length) {
                delete this.userOption.childList[_local_3].data.hideForSelf;
                if (this.userOption.childList[_local_3].data["showForSelf"] === false){
                    this.userOption.childList[_local_3].data.hideForSelf = (blablaland.uid == _arg_1);
                };
                if (((this.userOption.childList[_local_3].visible) && (!(this.userOption.childList[_local_3].data.hideForSelf)))){
                    _local_4++;
                };
                _local_3++;
            };
            var _local_4:uint;
            _local_3 = 0;
            while (_local_3 < this.userOptionAction.childList.length) {
                delete this.userOptionAction.childList[_local_3].data.hideForSelf;
                if (this.userOptionAction.childList[_local_3].data["showForSelf"] === false){
                    this.userOptionAction.childList[_local_3].data.hideForSelf = (blablaland.uid == _arg_1);
                };
                if (((this.userOptionAction.childList[_local_3].visible) && (!(this.userOptionAction.childList[_local_3].data.hideForSelf)))){
                    _local_4++;
                };
                _local_3++;
            };
            this.userOptionAction.visible = (_local_4 > 0);
            this.userOptionPopup = winPopup.open({"CLASS":ClickOptionPopup}, {"OPTIONLIST":this.userOption});
        }

        public function CameraOnClickUser(_arg_1:WalkerPhysicEvent):*{
            this.clickUser(User(_arg_1.walker).userId, User(_arg_1.walker).pseudo);
        }

        public function onInterfaceSelectUser(_arg_1:InterfaceEvent):*{
            this.clickUser(_arg_1.uid, _arg_1.pseudo);
        }

        public function _serverSelectorClose(_arg_1:Event):*{
            this.serverSelector = null;
        }

        public function openServerSelector(_arg_1:Object):Object{
            if (this.serverSelector){
                this.serverSelector.close();
            };
            var _local_2:Object = winPopup.open({
                "CLASS":PopupItemBase,
                "ID":"serverSelector"
            });
            _local_2.width = 300;
            _local_2.height = 200;
            _local_2.redraw();
            _local_2.addEventListener("onClose", this._serverSelectorClose);
            this.serverSelector = _local_2;
            var _local_3:MovieClip = new LoadingAnim();
            _local_2.addChild(_local_3);
            _local_3.x = 20;
            _local_3.y = 50;
            _arg_1.LC = _local_3;
            _arg_1.WIN = _local_2;
            _arg_1.GP = GlobalProperties;
            var _local_4:FxLoader = new FxLoader();
            _local_4.clearInitData = false;
            _local_4.initData = _arg_1;
            _local_4.addEventListener("onFxLoaded", this.onSelectorFxLoaded);
            _local_4.loadFx(31);
            return (_local_2);
        }

        public function onSelectorFxLoaded(_arg_1:Event):*{
            var _local_2:FxLoader = FxLoader(_arg_1.currentTarget);
            if (_local_2.initData.LC.parent){
                _local_2.initData.LC.parent.removeChild(_local_2.initData.LC);
            };
            _local_2.removeEventListener("onFxLoaded", this.onSelectorFxLoaded);
            var _local_3:Object = new _local_2.lastLoad.classRef();
            _local_2.initData.WIN.addChild(MovieClip(_local_3));
            _local_3.init();
        }

        public function infoBulle(_arg_1:String):InfoBulle{
            if (this.infoBulleClip){
                this.infoBulleClip.dispose();
                this.infoBulleClip = null;
            };
            if (_arg_1){
                this.infoBulleClip = new InfoBulle();
                this.infoBulleClip.text = _arg_1;
            };
            return (this.infoBulleClip);
        }

        public function unEventInterface():*{
            this.userInterface.removeEventListener("onSendPrivateMessage", this.onInterfaceSendPrivateMessage, false);
            this.userInterface.removeEventListener("onSendMessage", this.onInterfaceSendMessage, false);
            this.userInterface.removeEventListener("onSmile", this.onInterfaceSmile, false);
            this.userInterface.removeEventListener("onShowMP", this.onInterfaceShowMP, false);
            this.userInterface.removeEventListener("onModoMessage", this.onInterfaceModoMessage, false);
            this.userInterface.removeEventListener("onSelectUser", this.onInterfaceSelectUser, false);
            this.userInterface.removeEventListener("onCreve", this.onInterfaceCreve, false);
            this.userInterface.removeEventListener("onDodo", this.onInterfaceDodo, false);
            this.userInterface.removeEventListener("onPrison", this.onInterfacePrison, false);
            this.userInterface.removeEventListener("onOpenAlert", this.onInterfaceOpenAlert, false);
            this.userInterface.removeEventListener("onOpenFriend", this.onInterfaceOpenFriend, false);
            this.userInterface.removeEventListener("onOpenDebug", this.onInterfaceOpenDebug, false);
            this.userInterface.removeEventListener("onOpenBBPOD", this.onInterfaceOpenBBPOD, false);
            this.userInterface.removeEventListener("onWarEvent", this.onInterfaceWar, false);
            this.userInterface.removeEventListener("onOpenCarte", this.onInterfaceOpenCarte, false);
            this.userInterface.removeEventListener("onOpenChangeUnivers", this.onInterfaceChangeUnivers, false);
            this.userInterface.removeEventListener("onOpenProfil", this.onInterfaceOpenProfil, false);
            this.userInterface.removeEventListener("onPoissonAvril", this.onInterfacePoissonAvril, false);
            this.userInterface.removeEventListener("onReload", this.onInterfaceReload, false);
            this.userInterface.removeEventListener("onAction", this.onInterfaceAction, false);
            this.userInterface.closeInterface();
        }

        public function onInterfaceReload(_arg_1:InterfaceEvent):*{
            var _local_2:Number;
            var _local_3:Number;
            if ((((camera) && (camera.cameraReady)) && ((GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) >= 0) || (GlobalProperties.stage.loaderInfo.url.search(/file:\/\//) >= 0)))){
                if (GlobalProperties.stage.loaderInfo.url.search(/file:\/\//) == -1){
                    SkinLoader.cacheVersion++;
                    MapLoader.cacheVersion++;
                    FxLoader.cacheVersion++;
                };
                SkinLoader.clearAll();
                MapLoader.clearAll();
                FxLoader.clearAll();
                _local_2 = this.userInterface.utilsRectAreaA.content.y;
                _local_3 = this.userInterface.utilsRectAreaB.content.y;
                while (Object(this).utilList.length) {
                    Object(this).removeUtil(Object(this).utilList[0]);
                };
                Object(this).onObjectListChange(null);
                this.userInterface.utilsRectAreaA.content.y = _local_2;
                this.userInterface.utilsRectAreaB.content.y = _local_3;
                camera.forceReloadSkins();
            };
        }

        public function onInterfaceProfil(_arg_1:InterfaceEvent):*{
        }

        public function onInterfacePoissonAvril(_arg_1:InterfaceEvent):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 15);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID, 4);
            blablaland.send(_local_2);
        }

        public function onInterfaceWar(_arg_1:InterfaceEvent):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 12);
            _local_2.bitWriteUnsignedInt(4, 0);
            _local_2.bitWriteBoolean((_arg_1.text == "1"));
            blablaland.send(_local_2);
        }

        public function onInterfaceOpenDebug(_arg_1:Event):*{
            if (blablaland.grade >= 950){
                msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Debugger."
                }, {"ACTION":"DEBUG"});
            };
        }

        public function onAlertKilled(_arg_1:Event):*{
            this.alertPopup = null;
        }

        public function onInterfaceOpenAlert(_arg_1:TextEvent):*{
            var _local_2:FxLoader;
            var _local_3:Array;
            var _local_4:int;
            if (this.alertPopup){
                this.alertPopup.close();
            }
            else {
                _local_3 = _arg_1.text.split("=");
                if (((_local_3[0] == 6) && (_local_3[1]))){
                    _local_2 = new FxLoader();
                    _local_2.initData = {
                        "CHAT":GlobalChatProperties.chat,
                        "ACTION":2,
                        "UID":_local_3[1]
                    };
                    _local_2.loadFx(10);
                }
                else {
                    if (((_local_3[0] == 1) && (_local_3[1]))){
                        _local_3.shift();
                        _local_4 = _local_3[0];
                        _local_3.shift();
                        _local_2 = new FxLoader();
                        _local_2.initData = {
                            "GB":GlobalProperties,
                            "PARAM":_local_3.join("=")
                        };
                        _local_2.loadFx(_local_4);
                    }
                    else {
                        this.userInterface.warnCount = 0;
                        this.newAlertCount = 0;
                        this.alertPopup = winPopup.open({
                            "APP":AlertList,
                            "ID":"alertList",
                            "TITLE":"Dernières alertes"
                        }, {"ARGS":_arg_1.text});
                        this.alertPopup.addEventListener("onKill", this.onAlertKilled, false, 0, true);
                    };
                };
            };
        }

        public function onFriendKilled(_arg_1:Event):*{
            this.friendPopup = null;
        }

        public function openFriendList():*{
            if (this.friendPopup){
                this.friendPopup.close();
            }
            else {
                this.friendPopup = winPopup.open({
                    "APP":ContactList,
                    "ID":"ContactList",
                    "TITLE":"Contacts"
                });
                this.friendPopup.addEventListener("onKill", this.onFriendKilled, false, 0, true);
            };
        }

        public function onInterfaceShowMP(_arg_1:Event):*{
            var _local_2:Object;
            var _local_3:Sound;
            if (((camera) && (blablaland))){
                _local_2 = blablaland.externalLoader.getClass("SndMP");
                _local_3 = new (_local_2)();
                _local_3.play(0, 0, new SoundTransform(camera.quality.actionVolume));
            };
        }

        public function onInterfaceModoMessage(_arg_1:Event):*{
            var _local_2:Object;
            var _local_3:Sound;
            if (((camera) && (blablaland))){
                _local_2 = blablaland.externalLoader.getClass("SndModoMessage");
                _local_3 = new (_local_2)();
                _local_3.play(0, 0, new SoundTransform((camera.quality.actionVolume * 1.2)));
            };
        }

        public function onInterfaceOpenFriend(_arg_1:Event):*{
            this.openFriendList();
        }

        public function onInterfaceOpenBBPOD(_arg_1:Event):*{
            winPopup.open({
                "APP":BBPOD,
                "ID":"BBPOD",
                "TITLE":"Menus..."
            });
        }

        public function onChangeUnivers(_arg_1:Event):*{
            Object(_arg_1.currentTarget).params.teleport();
        }

        public function onInterfaceChangeUnivers(_arg_1:Event):*{
            var _local_2:Object = this.openServerSelector({"CAMERA":camera});
            _local_2.addEventListener("onSel", this.onChangeUnivers);
        }

        public function onInterfaceOpenCarte(_arg_1:Event):*{
            winPopup.open({
                "APP":MapSelector,
                "ID":"map",
                "TITLE":"Carte du monde :"
            }, {"SERVERID":blablaland.serverId});
        }

        public function onInterfaceOpenProfil(_arg_1:Event):*{
            navigateToURL(new URLRequest("/site/mon_compte.php"), "_self");
        }

        public function onInterfaceDodo(_arg_1:Event):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 7);
            blablaland.send(_local_2);
        }

        public function onInterfacePrison(_arg_1:Event):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 9);
            blablaland.send(_local_2);
        }

        public function onInterfaceCreve(_arg_1:InterfaceEvent):*{
            if ((((camera.mainUser) && (!(camera.mainUser.skinId == 404))) && (!(camera.mainUser.skinId == 405)))){
                camera.userDie(((blablaland.uid) ? _arg_1.text : ""));
            };
        }

        public function onInterfaceSendPrivateMessage(_arg_1:InterfaceEvent):*{
            var _local_2:*;
            if (!blablaland.uid){
                this.userInterface.addLocalMessage("<span class='info'>Les touristes ne peuvent pas parler. Vous devez <U><A HREF='/site/inscription.php' TARGET='_self'>créer un compte</A></U>.</span>");
            }
            else {
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 5);
                _local_2.bitWriteString(_arg_1.pseudo);
                _local_2.bitWriteString(_arg_1.text);
                blablaland.send(_local_2);
                this.userInterface.addLocalMessage((((("<span class='message_mp_to'>mp à </span><span class='user'>" + GlobalProperties.htmlEncode(_arg_1.pseudo)) + "</span><span class='message_mp_to'> : ") + GlobalProperties.htmlEncode(_arg_1.text)) + "</span>"));
            };
        }

        public function onInterfaceAction(_arg_1:InterfaceEvent):*{
            if (((_arg_1.action == "/pense") && (_arg_1.text.length > 0))){
                this.sendMessage(_arg_1.text, 1);
                _arg_1.valide = true;
            }
            else {
                if (((_arg_1.action == "/cri") && (_arg_1.text.length > 0))){
                    this.sendMessage(_arg_1.text, 2);
                    _arg_1.valide = true;
                }
                else {
                    if ((((_arg_1.action == "/me") || (_arg_1.action == "/moi")) && (_arg_1.text.length > 0))){
                        this.sendMessage(_arg_1.text, 3);
                        _arg_1.valide = true;
                    };
                };
            };
        }

        public function onInterfaceSendMessage(_arg_1:TextEvent):*{
            if (!blablaland.uid){
                this.userInterface.addLocalMessage("<span class='info'>Les touristes ne peuvent pas parler. Vous devez <U><A HREF='/site/inscription.php' TARGET='_self'>créer un compte</A></U>.</span>");
            }
            else {
                this.sendMessage(_arg_1.text);
            };
        }

        public function sendMessage(_arg_1:String, _arg_2:uint=0):*{
            var _local_3:* = new SocketMessage();
            _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 4);
            _local_3.bitWriteString(_arg_1);
            _local_3.bitWriteUnsignedInt(3, _arg_2);
            blablaland.send(_local_3);
        }

        public function onInterfaceSmile(_arg_1:SmileyEvent):*{
            var _local_2:*;
            var _local_3:SmileyLoader;
            var _local_4:Object;
            if (!blablaland.uid){
                this.userInterface.addLocalMessage("<span class='info'>Les touristes ne peuvent pas faire de smiley. Vous devez <U><A HREF='/site/inscription.php' TARGET='_self'>créer un compte</A></U>.</span>");
            }
            else {
                if (camera.cameraReady){
                    try {
                        _local_3 = new SmileyLoader();
                        _local_4 = _local_3.getSmileyById(_arg_1.packId);
                        GlobalProperties.mainApplication.onExternalFileLoaded(4, _arg_1.packId, _local_4.smileyByte);
                    }
                    catch(err) {
                    };
                    if (_arg_1.playLocal){
                        camera.mainUser.smile(_arg_1.packId, _arg_1.smileyId, _arg_1.data);
                    };
                    _local_2 = new SocketMessage();
                    _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
                    _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 8);
                    _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID, _arg_1.packId);
                    _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_SMILEY_ID, _arg_1.smileyId);
                    _local_2.bitWriteBinaryData(_arg_1.data);
                    _local_2.bitWriteBoolean(_arg_1.playCallBack);
                    blablaland.send(_local_2);
                };
            };
        }

        override public function dailyPopup(_arg_1:Event):*{
            super.dailyPopup(_arg_1);
            this.userInterface.scriptingLock = getLockUserState();
        }

        override public function onDailyMessageScritpClose(_arg_1:Event):*{
            super.onDailyMessageScritpClose(_arg_1);
            this.userInterface.scriptingLock = getLockUserState();
        }


    }
}//package chatbbl

