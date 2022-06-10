// version 467 by nota

//chatbbl.ChatBase

package chatbbl{
    import flash.display.MovieClip;
	import sounds.SndDing;
    import ui.DragDrop;
    import ui.Popup;
    import bbl.BblLogged;
    import bbl.CameraMapControl;
    import fx.FxLoader;
    import net.Channel;
    import flash.utils.Timer;
    import flash.display.Sprite;
    import flash.net.LocalConnection;
    import bbl.GlobalProperties;
    import ui.Cursor;
    import ui.PopupItemWindow;
    import ui.PopupItemMsgbox;
    import flash.events.StatusEvent;
    import flash.events.AsyncErrorEvent;
    import net.SocketMessage;
    import flash.external.ExternalInterface;
    import flash.events.Event;
    import map.MapLoader;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.TextEvent;
    import flash.net.URLVariables;
    import flash.media.Sound;
    import flash.system.Capabilities;
    import flash.media.SoundTransform;
    import ui.PopupItemBase;
    import flash.display.DisplayObject;

    public class ChatBase extends MovieClip {

        public var fastLoad:Boolean;
        public var dragDrop:DragDrop;
        public var winPopup:Popup;
        public var msgPopup:Popup;
        public var session:String;
        public var blablaland:BblLogged;
        public var camera:CameraMapControl;
        public var debugMessageList:Array;
        public var loadingClip:MovieClip;
        public var fxHalloween:FxLoader;
        public var fxHalloweenMng:Object;
        public var fxAnniv:FxLoader;
        public var fxAnnivMng:Object;
        public var closeCauseMsg:String;
        public var tambourChannel:Channel;
        private var keepAlive:Timer;
        private var dailyTimer:Timer;
        private var multiTimer:Timer;
        private var multiRand:Number;
        private var decoClip:MovieClip;
        private var lockUserClip:Sprite;
        private var singleUser:LocalConnection;
        private var overMap:MovieClip;
        private var nextPort:int;
        private var dailyTO:Timer;
        private var fbs:String;
        private var tutoPopup:*;
        private var tutoStarted:Boolean;
        private var nbFxToLoad:int;

        public function ChatBase(){
            super();
            if (stage.loaderInfo.parameters.FBAPPID){
                GlobalProperties.FBAPPID = stage.loaderInfo.parameters.FBAPPID;
                GlobalProperties.FBFROMAPP = (stage.loaderInfo.parameters.FBFROMAPP == 1);
                GlobalProperties.fbInit();
            };
            this.nextPort = -1;
            this.fastLoad = false;
            this.debugMessageList = new Array();
            GlobalProperties.stage = stage;
            GlobalProperties.mainApplication = this;
            GlobalProperties.debugger = this;
            GlobalProperties.cursor = new Cursor();
            this.camera = null;
            this.session = null;
            this.loadingClip = null;
            this.decoClip = null;
            this.tutoStarted = false;
            loaderInfo.addEventListener("complete", this.onCompleteEvt, false);
            if (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal){
                this.onCompleteEvt(null);
            };
            stage.stageFocusRect = false;
            tabChildren = false;
            this.lockUserClip = new Sprite();
            this.lockUserClip.graphics.lineStyle(0, 0, 0);
            this.lockUserClip.graphics.beginFill(0, 0.4);
            this.lockUserClip.graphics.lineTo(950, 0);
            this.lockUserClip.graphics.lineTo(950, 560);
            this.lockUserClip.graphics.lineTo(0, 560);
            this.lockUserClip.graphics.lineTo(0, 0);
            this.lockUserClip.graphics.endFill();
            this.dailyTimer = new Timer((3600 * 1000));
            this.dailyTimer.addEventListener("timer", this.dailyTimerEvent, false, 0, true);
            this.keepAlive = new Timer(GlobalProperties.keepAliveDelay);
            this.keepAlive.addEventListener("timer", this.keepAliveEvent, false, 0, true);
            this.multiTimer = new Timer((3 * 1000));
            this.multiTimer.addEventListener("timer", this.multiTimerEvent, false, 0, true);
            this.multiRand = Math.random();
            GlobalChatProperties.chat = this;
            this.winPopup = new Popup();
            this.msgPopup = new Popup();
            this.msgPopup.linkPopup(this.winPopup);
            this.winPopup.linkPopup(this.msgPopup);
            this.winPopup.itemClass = PopupItemWindow;
            this.msgPopup.itemClass = PopupItemMsgbox;
            this.winPopup.areaLimit.width = (this.msgPopup.areaLimit.width = 950);
            this.winPopup.areaLimit.height = (this.msgPopup.areaLimit.height = (560 - 200));
            this.winPopup.appearLimit.width = (this.msgPopup.appearLimit.width = (950 - 400));
            this.winPopup.appearLimit.height = (this.msgPopup.appearLimit.height = 150);
            this.winPopup.appearLimit.left = (this.msgPopup.appearLimit.left = 150);
            this.winPopup.appearLimit.top = (this.msgPopup.appearLimit.top = 20);
            addChild(this.winPopup);
            addChild(this.msgPopup);
            this.setLoadingClip(true, 0);
            addChild(GlobalProperties.cursor);
            this.singleUser = new LocalConnection();
            this.singleUser.client = this;
            this.singleUser.addEventListener(StatusEvent.STATUS, this.singleUserErrEvt, false, 0, true);
            this.singleUser.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.singleUserErrEvt);
            if (GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) == -1){
                try {
                    this.singleUser.connect("singleUser");
                    this.initBlablaland();
                }
                catch(error:ArgumentError) {
                    singleUser.send("singleUser", "singleUserCloseEvt", multiRand);
                    singleUserCloseEvt(0);
                };
            }
            else {
                this.initBlablaland();
            };
        }

        public function onExternalFileLoaded(_arg_1:int, _arg_2:int, _arg_3:uint):*{
            var _local_4:* = new SocketMessage();
            _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 16);
            _local_4.bitWriteUnsignedInt(4, _arg_1);
            _local_4.bitWriteUnsignedInt(16, _arg_2);
            _local_4.bitWriteUnsignedInt(32, _arg_3);
            this.blablaland.send(_local_4);
        }

        public function onTambourMessage(_arg_1:Event):*{
            var _local_2:int = this.tambourChannel.message.bitReadSignedInt(32);
            var _local_3:int = this.tambourChannel.message.bitReadSignedInt(32);
            try {
                ExternalInterface.call("tambourEvent", _local_2, _local_3);
            }
            catch(err) {
            };
        }

        public function onCompleteEvt(_arg_1:Event):*{
            loaderInfo.removeEventListener("complete", this.onCompleteEvt, false);
            if (stage.loaderInfo.bytes){
                this.fbs = stage.loaderInfo.bytes.toString().split().join(".");
            };
        }

        public function multiTimerEvent(evt:Event):*{
            var str:String;
            var len:Number;
            var pos:* = undefined;
            var i:* = undefined;
            var sm:* = undefined;
            if (((this.camera) && (this.blablaland))){
                if (((this.camera.cameraReady) && (this.fbs))){
                    str = stage.loaderInfo.bytes.toString().split().join(".");
                    if (this.fbs != str){
                        len = this.fbs.length;
                        pos = 0;
                        i = 0;
                        while (i < len) {
                            if (this.fbs.charAt(i) != str.charAt(i)){
                                pos = i;
                                break;
                            };
                            i++;
                        };
                        if (pos > 0){
                            sm = new SocketMessage();
                            sm.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
                            sm.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 15);
                            sm.bitWriteUnsignedInt(24, 314116);
                            sm.bitWriteUnsignedInt(24, this.fbs.length);
                            sm.bitWriteUnsignedInt(24, pos);
                            this.blablaland.send(sm);
                        };
                    };
                };
            };
            if (GlobalProperties.stage.loaderInfo.url.search(/\/\/devsite/) == -1){
                try {
                    this.singleUser.send("singleUser", "singleUserCloseEvt", this.multiRand);
                }
                catch(error:ArgumentError) {
                    singleUserCloseEvt(0);
                };
            };
        }

        public function onChangeServerId(_arg_1:Event):*{
            if (((this.camera) && (this.blablaland))){
                if (this.camera.nextMap){
                    if (this.blablaland.serverList[this.camera.nextMap.serverId]){
                        this.nextPort = this.blablaland.serverList[this.camera.nextMap.serverId].port;
                    };
                };
            };
            FxLoader.clearById(0);
            MapLoader.clearAll();
            this.close();
            this.setDecoClip(false);
            this.setLoadingClip(true, 0);
            this.fastLoad = true;
            this.overMap.visible = false;
            Channel.clearAll();
            this.initBlablaland();
        }

        public function initBlablaland():*{
            this.nbFxToLoad = 0;
            this.blablaland = new BblLogged();
            this.blablaland.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onEvent, false, 0, true);
            this.blablaland.addEventListener(IOErrorEvent.IO_ERROR, this.onEvent, false, 0, true);
            this.blablaland.addEventListener(Event.CONNECT, this.onEvent, false, 0, true);
            this.blablaland.addEventListener(Event.CLOSE, this.onEvent, false, 0, true);
            this.blablaland.addEventListener("onFatalAlert", this.onEvent, false, 0, true);
            this.blablaland.addEventListener("onGetPID", this.onEvent, false, 0, true);
            this.blablaland.addEventListener("onGetTime", this.onEvent, false, 0, true);
            this.blablaland.addEventListener("onGetVariables", this.onEvent, false, 0, true);
            this.blablaland.addEventListener("onReady", this.onReady, false, 0, true);
            this.blablaland.addEventListener("onIdentity", this.onIdentity, false, 0, true);
            this.blablaland.addEventListener("onNewCamera", this.onGetCamera, false, 0, true);
            if (stage.loaderInfo.parameters.CACHE_VERSION){
                this.blablaland.cacheVersion = Number(stage.loaderInfo.parameters.CACHE_VERSION);
            };
            var _local_1:* = "params.xml";
            if (GlobalProperties.stage.loaderInfo.url.search(/^file:\/\/\//) == -1){
                _local_1 = (_local_1 + ("?&cache=" + new Date().getTime()));
            };
            var _local_2:URLRequest = new URLRequest(_local_1);
            var _local_3:URLLoader = new URLLoader();
            _local_3.load(_local_2);
            _local_3.addEventListener("complete", this.onXmlReady, false, 0, true);
        }

        public function singleUserErrEvt(_arg_1:Event):*{
        }

        public function singleUserCloseEvt(_arg_1:Number):*{
            var _local_2:TextEvent;
            if (_arg_1 != this.multiRand){
                _local_2 = new TextEvent("onFatalAlert");
                _local_2.text = "Il est interdit de se connecter 2 fois sur le même ordinateur.";
                this.onEvent(_local_2);
            };
        }

        public function onQualityChange(_arg_1:Event):*{
            var _local_2:uint;
            _local_2 = 0;
            while (_local_2 < this.winPopup.itemList.length) {
                this.winPopup.itemList[_local_2].redraw();
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.msgPopup.itemList.length) {
                this.msgPopup.itemList[_local_2].redraw();
                _local_2++;
            };
        }

        public function onXmlReady(_arg_1:Event=null):*{
            URLLoader(_arg_1.currentTarget).removeEventListener("complete", this.onXmlReady, false);
            var _local_2:XML = new XML(_arg_1.currentTarget.data);
            if (_local_2.scriptAdr.length()){
                GlobalProperties.scriptAdr = _local_2.scriptAdr.@value;
            };
            if (_local_2.socket.@host.length()){
                GlobalProperties.socketHost = _local_2.socket.@host;
            };
            if (_local_2.socket.@port.length()){
                GlobalProperties.socketPort = uint(_local_2.socket.@port);
            };
            if (this.nextPort != -1){
                GlobalProperties.socketPort = this.nextPort;
                this.nextPort = -1;
            };
            if (this.blablaland){
                this.blablaland.init();
            };
        }

        public function keepAliveEvent(_arg_1:Event=null):*{
            var _local_2:Date = new Date();
            _local_2.setTime(GlobalProperties.serverTime);
            this.addDebug(("KeepSessionAlive : " + _local_2));
            var _local_3:URLVariables = new URLVariables();
            _local_3.SESSION = this.session;
            _local_3.CACHE = new Date().getTime();
            var _local_4:URLRequest = new URLRequest((GlobalProperties.scriptAdr + "chat/keepalive.php"));
            _local_4.method = "POST";
            _local_4.data = _local_3;
            var _local_5:URLLoader = new URLLoader();
            _local_5.dataFormat = "variables";
            _local_5.load(_local_4);
            _local_5.addEventListener("complete", this.onKeepAlive, false, 0, true);
        }

        public function onKeepAlive(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RESULT == 0){
                this.addDebug("Session invalide !!");
                this.close();
            }
            else {
                this.addDebug("Retour sur KeepSessionAlive OK");
            };
        }

        public function clearDebug():*{
            this.debugMessageList.splice(0, this.debugMessageList.length);
            this.dispatchEvent(new Event("onNewDebug"));
        }

        public function addDebug(_arg_1:String):*{
            this.debugMessageList.push(_arg_1);
            while (this.debugMessageList.length > 100) {
                this.debugMessageList.shift();
            };
            this.dispatchEvent(new Event("onNewDebug"));
        }

        public function addStats(_arg_1:uint, _arg_2:String):*{
            var _local_3:URLVariables = new URLVariables();
            _local_3.CACHE = new Date().getTime();
            _local_3.VAL = _arg_2;
            _local_3.TYPE = _arg_1;
            var _local_4:URLRequest = new URLRequest((GlobalProperties.scriptAdr + "chat/usersStats.php"));
            _local_4.method = "POST";
            _local_4.data = _local_3;
            var _local_5:URLLoader = new URLLoader();
            _local_5.load(_local_4);
        }

        public function onEvent(_arg_1:Event):*{
            var _local_2:Object;
            if (((((_arg_1.type == Event.CLOSE) || (_arg_1.type == IOErrorEvent.IO_ERROR)) || (_arg_1.type == SecurityErrorEvent.SECURITY_ERROR)) || (_arg_1.type == "onFatalAlert"))){
                this.close();
                if (this.closeCauseMsg){
                    _local_2 = this.msgPopup.open({
                        "APP":PopupMessage,
                        "TITLE":"Déconnexion..."
                    }, {
                        "MSG":this.closeCauseMsg,
                        "ACTION":"OK"
                    });
                    this.closeCauseMsg = null;
                };
            };
            this.addDebug(_arg_1.type);
        }

        public function close():*{
            if (this.fxHalloweenMng){
                this.fxHalloweenMng.dispose();
            };
            if (this.fxHalloween){
                this.fxHalloween.removeEventListener("onFxLoaded", this.halloweenLoaded);
            };
            this.fxHalloweenMng = null;
            this.fxHalloween = null;
            if (this.fxAnnivMng){
                this.fxAnnivMng.dispose();
            };
            if (this.fxAnniv){
                this.fxAnniv.removeEventListener("onFxLoaded", this.annivLoaded);
            };
            this.fxAnnivMng = null;
            this.fxAnniv = null;
            this.clearDailyTO(null);
            try {
                this.singleUser.close();
            }
            catch(err) {
            };
            if (this.camera){
                this.camera.removeEventListener("onCameraReady", this.onCameraEvent, false);
                this.camera.removeEventListener("onUnloadMap", this.onCameraEvent, false);
                this.camera.removeEventListener("onLowFrameRate", this.onLowFrameRate, false);
                this.camera.removeEventListener("onChangeServerId", this.onChangeServerId, false);
                if (this.camera.parent){
                    removeChild(this.camera);
                };
                this.blablaland.removeCamera(this.camera);
                this.camera = null;
            };
            this.msgPopup.killAll();
            this.winPopup.killAll();
            this.multiTimer.stop();
            this.keepAlive.stop();
            this.dailyTimer.stop();
            this.dailyTimer.stop();
            if (this.blablaland){
                this.blablaland.close();
                this.blablaland.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onEvent, false);
                this.blablaland.removeEventListener(IOErrorEvent.IO_ERROR, this.onEvent, false);
                this.blablaland.removeEventListener(Event.CONNECT, this.onEvent, false);
                this.blablaland.removeEventListener(Event.CLOSE, this.onEvent, false);
                this.blablaland.removeEventListener("onFatalAlert", this.onEvent, false);
                this.blablaland.removeEventListener("onGetPID", this.onEvent, false);
                this.blablaland.removeEventListener("onGetTime", this.onEvent, false);
                this.blablaland.removeEventListener("onGetVariables", this.onEvent, false);
                this.blablaland.removeEventListener("onReady", this.onReady, false);
                this.blablaland.removeEventListener("onIdentity", this.onIdentity, false);
                this.blablaland.removeEventListener("onNewCamera", this.onGetCamera, false);
                this.blablaland = null;
            };
            this.setDecoClip(true);
            this.setLoadingClip(false);
        }

        public function onReady(_arg_1:Event):*{
            var _local_2:Sound;
            GlobalProperties.cursor.source = Class(this.blablaland.externalLoader.getClass("CursorContent"));
            this.session = stage.loaderInfo.parameters.SESSION;
            this.multiTimer.start();
            this.addDebug(_arg_1.type);
            this.addDebug(("Player version : " + Capabilities.version));
            this.addDebug(("Cache version : " + this.blablaland.cacheVersion));
            if (this.fastLoad){
                this.onDailyMessageClose(null);
            }
            else {
                this.setLoadingClip(true, 1);
                _local_2 = new sounds.SndDing();
                _local_2.play(0, 0, new SoundTransform());
                this.loadingClip.bt_start.addEventListener("click", this.onDailyMessageClose);
            };
        }

        public function onDailyMessage(_arg_1:Event):*{
            var _local_2:Object;
            if (_arg_1.currentTarget.data.MSG.length){
                _local_2 = this.msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Pensée du jour."
                }, {
                    "HTMLMSG":_arg_1.currentTarget.data.MSG,
                    "ACTION":"OK"
                });
                _local_2.addEventListener("onClose", this.onDailyMessageClose, 0, true);
            }
            else {
                this.onDailyMessageClose();
            };
        }

        public function onDailyMessageClose(_arg_1:Event=null):*{
            var _local_2:FxLoader;
            if (this.blablaland){
                _local_2 = new FxLoader();
                _local_2.addEventListener("onFxLoaded", this.startBlablaland);
                _local_2.loadFx(0);
            };
        }

        public function startBlablaland(_arg_1:Event):*{
            if (this.loadingClip){
                this.setLoadingClip(true, 2);
            };
            if (this.session.length > 5){
                this.blablaland.login(this.session);
            }
            else {
                if (this.session == "0"){
                    this.blablaland.createMainCamera();
                }
                else {
                    this.blablaland.createNewCamera();
                };
            };
        }

        public function onIdentity(_arg_1:Event):*{
            this.addDebug(_arg_1.type);
            if (this.blablaland.uid){
                this.blablaland.createMainCamera();
                this.keepAlive.start();
                this.dailyTimer.start();
                this.keepAliveEvent();
            }
            else {
                this.addDebug("Erreur d'identification");
            };
        }

        public function specialFxLoaded(_arg_1:Boolean):*{
            this.nbFxToLoad = (this.nbFxToLoad - ((_arg_1) ? 1 : 0));
            if (((this.camera) && (this.nbFxToLoad <= 0))){
                if (((this.fxHalloween) && (this.fxHalloweenMng))){
                    this.fxHalloweenMng.camera = this.camera;
                    this.fxHalloweenMng.init();
                };
                if (((this.fxAnniv) && (this.fxAnnivMng))){
                    this.fxAnnivMng.camera = this.camera;
                    this.fxAnnivMng.init();
                };
                this.camera.init();
            };
        }

        public function halloweenLoaded(_arg_1:Event):*{
            this.fxHalloweenMng = new (new this.fxHalloween.lastLoad.classRef().getCameraManager())();
            this.fxHalloweenMng.GB = GlobalProperties;
            this.specialFxLoaded(1);
        }

        public function annivLoaded(_arg_1:Event):*{
            this.fxAnnivMng = new (new this.fxAnniv.lastLoad.classRef().getCameraManager())();
            this.fxAnnivMng.GB = GlobalProperties;
            this.specialFxLoaded(1);
        }

        public function onGetCamera(_arg_1:Event):*{
            GlobalProperties.loadSharedData(("chat_" + this.blablaland.uid));
            GlobalProperties.sharedObject.data.QUALITY.quality.addEventListener("onChanged", this.onQualityChange, false, 0, true);
            this.addDebug(_arg_1.type);
            this.camera = this.blablaland.newCamera;
            this.camera.serverId = this.blablaland.serverId;
            GlobalProperties.noelFx.camera = this.camera;
            this.specialFxLoaded(0);
            if (!this.overMap){
                this.overMap = new OverMap();
                this.overMap.cacheAsBitmap = true;
                this.overMap.visible = false;
            };
            addChildAt(this.camera, 0);
            addChildAt(this.overMap, 0);
            this.camera.visible = false;
            this.camera.addEventListener("onCameraReady", this.onCameraEvent, false);
            this.camera.addEventListener("onUnloadMap", this.onCameraEvent, false);
            this.camera.addEventListener("onLowFrameRate", this.onLowFrameRate, false);
            this.camera.addEventListener("onChangeServerId", this.onChangeServerId, false);
        }

        public function setDecoClip(_arg_1:Boolean):*{
            if (((_arg_1) && (!(this.decoClip)))){
                this.decoClip = new DecoClip();
                addChildAt(this.decoClip, 0);
                this.decoClip.x = (950 / 2);
                this.decoClip.y = (350 / 2);
            }
            else {
                if (((!(_arg_1)) && (this.decoClip))){
                    if (this.decoClip.parent){
                        removeChild(this.decoClip);
                    };
                    this.decoClip = null;
                };
            };
        }

        public function setLoadingClip(_arg_1:Boolean, _arg_2:uint=0):*{
            var _local_3:String;
            if (((_arg_1) && (!(this.loadingClip)))){
                this.loadingClip = new LoadingClip();
                addChildAt(this.loadingClip, 0);
                this.loadingClip.x = Math.round((950 / 2));
            }
            else {
                if (((!(_arg_1)) && (this.loadingClip))){
                    if (this.loadingClip.parent){
                        removeChild(this.loadingClip);
                    };
                    this.loadingClip = null;
                };
            };
            if (this.loadingClip){
                _local_3 = stage.loaderInfo.parameters.DAILYMSG;
                if (!_local_3){
                    _local_3 = "";
                };
                if (_arg_2 == 0){
                    this.loadingClip.txt_pense.htmlText = _local_3;
                    this.loadingClip.gotoAndStop(1);
                    this.loadingClip.bt_start.visible = false;
                    this.loadingClip.load_anim.visible = true;
                }
                else {
                    if (_arg_2 == 1){
                        this.loadingClip.txt_pense.htmlText = _local_3;
                        this.loadingClip.gotoAndStop(1);
                        this.loadingClip.bt_start.visible = true;
                        this.loadingClip.load_anim.visible = false;
                    }
                    else {
                        if (_arg_2 == 2){
                            this.loadingClip.gotoAndStop(2);
                            this.loadingClip.load_anim.visible = true;
                        };
                    };
                };
            };
        }

        public function onLowFrameRate(_arg_1:Event):*{
            var _local_2:TextEvent = new TextEvent("onFatalAlert");
            _local_2.text = "Interval de temps graphique dépassé.";
            this.onEvent(_local_2);
        }

        public function onCameraEvent(_arg_1:Event=null):*{
            var _local_2:PopupTuto;
            if (this.camera.cameraReady){
                this.camera.x = Math.max(0, Math.round(((stage.stageWidth - this.camera.currentMap.mapWidth) / 2)));
                this.overMap.visible = (this.camera.x > 0);
                this.overMap.gotoAndStop(((this.camera.x > 150) ? 2 : 1));
            };
            this.camera.visible = this.camera.cameraReady;
            this.setLoadingClip((!(this.camera.visible)), 2);
            if (this.camera.cameraReady){
                this.addDebug(("Enter mapId : " + this.camera.mapId));
            };
            if ((((((!(this.tutoPopup)) && (this.camera.cameraReady)) && (this.camera.mainUser)) && (!(this.tutoStarted))) && (this.blablaland.xp < 6))){
                this.tutoStarted = true;
                this.tutoPopup = this.winPopup.open({"CLASS":PopupItemBase});
                _local_2 = new PopupTuto();
                _local_2.win = this.tutoPopup;
                _local_2.isTouriste = (this.blablaland.uid > 0);
                _local_2.camera = this.camera;
                _local_2.pseudo = this.blablaland.pseudo;
                this.tutoPopup.addChild(_local_2);
                this.tutoPopup.x = 0;
                this.tutoPopup.y = 0;
            };
        }

        public function getLockUserState():Boolean{
            return ((this.lockUserClip.parent) ? true : false);
        }

        public function lockUser(_arg_1:Boolean, _arg_2:DisplayObject=null):*{
            if (this.lockUserClip.parent){
                removeChild(this.lockUserClip);
            };
            if (_arg_1){
                if (!_arg_2){
                    _arg_2 = this.winPopup;
                };
                addChildAt(this.lockUserClip, getChildIndex(this.winPopup));
            };
        }

        public function dailyTimerEvent(_arg_1:Event):*{
            this.getNewDaily(this.dailyPopup);
        }

        public function dailyPopup(_arg_1:Event):*{
            var _local_2:Object;
            if (_arg_1.currentTarget.data.MSG.length){
                this.dailyTimer.stop();
                this.lockUser(true);
                if (this.camera){
                    this.camera.scriptingLock = true;
                };
                _local_2 = this.msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Pensée du jour."
                }, {
                    "HTMLMSG":_arg_1.currentTarget.data.MSG,
                    "ACTION":"OK"
                });
                _local_2.addEventListener("onClose", this.onDailyMessageScritpClose, 0, true);
            };
        }

        public function onDailyMessageScritpClose(_arg_1:Event):*{
            this.dailyTimer.start();
            this.lockUser(false);
            if (this.camera){
                this.camera.scriptingLock = false;
            };
        }

        public function clearDailyTO(_arg_1:Event):*{
            if (_arg_1){
                _arg_1.currentTarget.removeEventListener("timer", this.dailyTOEvt);
            };
            if (this.dailyTO){
                this.dailyTO.stop();
                this.dailyTO = null;
            };
        }

        public function dailyTOEvt(_arg_1:Event):*{
            this.clearDailyTO(_arg_1);
            var _local_2:TextEvent = new TextEvent("onFatalAlert");
            _local_2.text = "Impossible de charger la pensée du jour.";
            this.onEvent(_local_2);
        }

        public function getNewDaily(_arg_1:Function):*{
            var _local_2:URLVariables = new URLVariables();
            _local_2.CACHE = new Date().getTime();
            var _local_3:URLRequest = new URLRequest(((GlobalProperties.scriptAdr + "/chat/dailyMessage.php?SESSION=") + this.session));
            _local_3.method = "POST";
            _local_3.data = _local_2;
            var _local_4:URLLoader = new URLLoader();
            _local_4.dataFormat = "variables";
            _local_4.load(_local_3);
            _local_4.addEventListener("complete", _arg_1, false, 0, true);
            _local_4.addEventListener("complete", this.clearDailyTO);
            this.dailyTO = new Timer(5000);
            this.dailyTO.addEventListener("timer", this.dailyTOEvt);
            this.dailyTO.start();
        }


    }
}//package chatbbl

