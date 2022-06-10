// version 467 by nota

//bbl.BblCamera

package bbl{
    import flash.utils.Timer;
    import flash.events.Event;
    import perso.User;
    import net.SocketMessage;
    import net.Binary;
    import map.ServerMap;
    import flash.utils.getDefinitionByName;
    import flash.external.ExternalInterface;
    import perso.SkinLoader;
    import map.MapLoader;
    import fx.FxLoader;
    import net.SocketMessageEvent;

    public class BblCamera extends BblObject {

        public var cameraList:Array;
        public var newCamera:CameraMapControl;
        public var pseudo:String;
        public var worldCount:uint;
        public var universCount:uint;
        private var socketLockTimer:Timer;
        private var socketLocked:Boolean;

        public function BblCamera(){
            this.worldCount = 0;
            this.universCount = 0;
            this.socketLocked = false;
            this.cameraList = new Array();
            this.socketLockTimer = new Timer(300);
            this.socketLockTimer.addEventListener("timer", this.socketTimerEvt, false);
        }

        public function resetSocketLock():*{
            if (!this.socketLockTimer.running){
                this.socketLockTimer.reset();
                this.socketLockTimer.start();
            };
        }

        public function socketUnlock():*{
            var _local_1:*;
            this.socketLockTimer.reset();
            if (this.socketLocked){
                this.socketLocked = false;
                _local_1 = 0;
                while (_local_1 < this.cameraList.length) {
                    if (this.cameraList[_local_1].socketLock){
                        this.cameraList[_local_1].socketLock = false;
                    };
                    _local_1++;
                };
            };
        }

        public function socketTimerEvt(_arg_1:Event):*{
            this.socketLockTimer.reset();
            this.socketLocked = true;
            var _local_2:* = 0;
            while (_local_2 < this.cameraList.length) {
                this.cameraList[_local_2].socketLock = true;
                _local_2++;
            };
        }

        private function setMuteStateByUID(_arg_1:uint, _arg_2:Boolean):*{
            var _local_4:User;
            var _local_3:* = 0;
            while (_local_3 < this.cameraList.length) {
                _local_4 = this.cameraList[_local_3].getUserByUid(_arg_1);
                if (_local_4){
                    _local_4.mute = _arg_2;
                };
                _local_3++;
            };
        }

        override public function removeMute(_arg_1:uint):*{
            super.removeMute(_arg_1);
            this.setMuteStateByUID(_arg_1, false);
        }

        override public function addMute(_arg_1:uint, _arg_2:String):*{
            super.addMute(_arg_1, _arg_2);
            this.setMuteStateByUID(_arg_1, true);
        }

        override public function addBlackList(_arg_1:uint, _arg_2:String):*{
            super.addBlackList(_arg_1, _arg_2);
            this.setMuteStateByUID(_arg_1, true);
        }

        override public function removeBlackList(_arg_1:uint):*{
            super.removeBlackList(_arg_1);
            this.setMuteStateByUID(_arg_1, false);
        }

        public function createMainCamera():*{
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 3);
            _local_1.bitWriteUnsignedInt(32, "22144568");
            send(_local_1);
        }

        public function createNewCamera(_arg_1:uint=0):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 1);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID, _arg_1);
            send(_local_2);
        }

        public function removeCamera(_arg_1:CameraMapControl):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 2);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID, _arg_1.cameraId);
            var _local_3:* = 0;
            while (_local_3 < this.cameraList.length) {
                if (this.cameraList[_local_3] == _arg_1){
                    this.cameraList.splice(_local_3, 1);
                    break;
                };
                _local_3++;
            };
            _arg_1.dispose();
            send(_local_2);
        }

        public function moveCameraToMap(_arg_1:CameraMapControl, _arg_2:uint, _arg_3:uint=0, _arg_4:int=-1):*{
            var _local_5:*;
            if (!_arg_1.mainUser){
                _local_5 = new SocketMessage();
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 5);
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID, _arg_3);
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID, _arg_1.cameraId);
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, _arg_2);
                _local_5.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID, ((_arg_4 == -1) ? serverId : _arg_4));
                send(_local_5);
            };
        }

        public function movePersoToMap(_arg_1:CameraMapSocket, _arg_2:uint, _arg_3:Object=null):*{
            var _local_4:*;
            if (_arg_1.mainUser){
                if (!_arg_3){
                    _arg_3 = new Object();
                };
                if (_arg_3.METHODE == undefined){
                    _arg_3.METHODE = 1;
                };
                if (_arg_3.SERVERID == undefined){
                    _arg_3.SERVERID = serverId;
                };
                _local_4 = new SocketMessage();
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 5);
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_METHODE_ID, _arg_3.METHODE);
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID, _arg_1.cameraId);
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, _arg_2);
                _local_4.bitWriteUnsignedInt(GlobalProperties.BIT_SERVER_ID, _arg_3.SERVERID);
                _arg_1.mainUser.exportStateToMessage(_local_4, _arg_3);
                send(_local_4);
            };
        }

        public function getCameraById(_arg_1:uint):CameraMapControl{
            var _local_2:* = 0;
            while (_local_2 < this.cameraList.length) {
                if (this.cameraList[_local_2].cameraId == _arg_1){
                    return (this.cameraList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        override public function parsedEventMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:uint;
            var _local_8:String;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:uint;
            var _local_12:uint;
            var _local_13:uint;
            var _local_14:String;
            var _local_15:Object;
            var _local_16:Object;
            var _local_17:Boolean;
            var _local_18:String;
            var _local_19:Binary;
            var _local_20:uint;
            var _local_21:uint;
            var _local_22:uint;
            var _local_23:CameraMapControl;
            var _local_24:ServerMap;
            var _local_25:uint;
            var _local_26:uint;
            var _local_27:*;
            var _local_28:int;
            var _local_29:int;
            var _local_4:Boolean = true;
            if (_arg_1 == 1){
                if (_arg_2 == 5){
                    _local_9 = _arg_3.message.bitReadBoolean();
                    _local_10 = _arg_3.message.bitReadBoolean();
                    _local_11 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                    _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                    _local_8 = _arg_3.message.bitReadString();
                    _local_14 = _arg_3.message.bitReadString();
                    if (((_local_10) && (_local_12))){
                        _local_15 = getDefinitionByName("chatbbl.application.ConsoleChatUser");
                        _local_16 = GlobalProperties.mainApplication.winPopup.open({
                            "APP":_local_15,
                            "ID":("CONSOLEUSERCHAT_" + _local_12.toString()),
                            "TITLE":("Modérateur : " + _local_8)
                        }, {
                            "PSEUDO":_local_8,
                            "UID":_local_12
                        });
                        Object(_local_16.content).addMessage(_local_14, true);
                    };
                    if (((!(isMuted(_local_12))) || (_local_10))){
                        _local_6 = 0;
                        while (_local_6 < this.cameraList.length) {
                            if (this.cameraList[_local_6].userInterface){
                                this.cameraList[_local_6].userInterface.lastMpPseudo = _local_8;
                                this.cameraList[_local_6].userInterface.addUserMessage(_local_8, _local_14, {
                                    "ISHTML":_local_9,
                                    "ISMODO":_local_10,
                                    "PID":_local_11,
                                    "UID":_local_12,
                                    "ISPRIVATE":true
                                });
                            };
                            _local_6++;
                        };
                    };
                    if (((_local_10) && (_local_14.match(/^Kické : /)))){
                        GlobalProperties.mainApplication.closeCauseMsg = ((_local_8 + " -- ") + _local_14);
                    };
                }
                else {
                    if (_arg_2 == 6){
                        _local_9 = _arg_3.message.bitReadBoolean();
                        _local_17 = _arg_3.message.bitReadBoolean();
                        _local_14 = _arg_3.message.bitReadString();
                        _local_18 = null;
                        _local_6 = 0;
                        while (_local_6 < this.cameraList.length) {
                            if (this.cameraList[_local_6].userInterface){
                                if (!_local_18){
                                    if (!_local_9){
                                        _local_18 = this.cameraList[_local_6].userInterface.htmlEncode(_local_14);
                                    }
                                    else {
                                        _local_18 = _local_14;
                                    };
                                };
                                this.cameraList[_local_6].userInterface.addLocalMessage((("<span class='info'>" + _local_18) + "</span>"));
                                if (_local_18.match(/envoyer un message sur le forum/)){
                                    ExternalInterface.call("bblinfos_setMessages_up", 1);
                                };
                            };
                            _local_6++;
                        };
                        if (_local_17){
                            GlobalProperties.mainApplication.addTextAlert(_local_14, _local_9);
                        };
                    }
                    else {
                        if (_arg_2 == 7){
                            this.worldCount = _arg_3.message.bitReadUnsignedInt(16);
                            this.universCount = _arg_3.message.bitReadUnsignedInt(16);
                            dispatchEvent(new Event("onWorldCounterUpdate"));
                            _local_4 = false;
                        }
                        else {
                            if (_arg_2 == 10){
                                _local_19 = _arg_3.message.bitReadBinaryData();
                                _arg_1 = _local_19.bitReadUnsignedInt(4);
                                _local_20 = ((_arg_1 == 0) ? GlobalProperties.BIT_SKIN_ID : ((_arg_1 == 1) ? GlobalProperties.BIT_MAP_ID : GlobalProperties.BIT_FX_ID));
                                _local_21 = uint((new Date().getTime() / 1000));
                                if (_arg_1 == 0){
                                    SkinLoader.cacheVersion = _local_21;
                                }
                                else {
                                    if (_arg_1 == 1){
                                        MapLoader.cacheVersion = _local_21;
                                    }
                                    else {
                                        if (_arg_1 == 2){
                                            FxLoader.cacheVersion = _local_21;
                                        };
                                    };
                                };
                                if (_local_19.bitReadBoolean()){
                                    while (_local_19.bitReadBoolean()) {
                                        _local_22 = _local_19.bitReadUnsignedInt(_local_20);
                                        if (_arg_1 == 0){
                                            SkinLoader.clearById(_local_22);
                                            _local_6 = 0;
                                            while (_local_6 < this.cameraList.length) {
                                                this.cameraList[_local_6].forceReloadSkinId(_local_22);
                                                _local_6++;
                                            };
                                        }
                                        else {
                                            if (_arg_1 == 1){
                                                MapLoader.clearById(_local_22);
                                            }
                                            else {
                                                if (_arg_1 == 2){
                                                    FxLoader.clearById(_local_22);
                                                };
                                            };
                                        };
                                    };
                                }
                                else {
                                    if (_arg_1 == 0){
                                        SkinLoader.clearAll();
                                        _local_6 = 0;
                                        while (_local_6 < this.cameraList.length) {
                                            this.cameraList[_local_6].forceReloadSkins();
                                            _local_6++;
                                        };
                                    }
                                    else {
                                        if (_arg_1 == 1){
                                            MapLoader.clearAll();
                                        }
                                        else {
                                            if (_arg_1 == 2){
                                                FxLoader.clearAll();
                                            };
                                        };
                                    };
                                };
                            }
                            else {
                                if (_arg_2 == 11){
                                    this.socketUnlock();
                                }
                                else {
                                    if (_arg_2 == 14){
                                        _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                        if (GlobalProperties.data[("CONSOLEUSERCHAT_" + _local_12)]){
                                            GlobalProperties.data[("CONSOLEUSERCHAT_" + _local_12)].setAnswerState(false);
                                        };
                                    }
                                    else {
                                        _local_4 = false;
                                    };
                                };
                            };
                        };
                    };
                };
            }
            else {
                if (_arg_1 == 3){
                    if (_arg_2 == 1){
                        _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
                        this.newCamera = new CameraMapControl();
                        this.cameraList.push(this.newCamera);
                        this.newCamera.cameraId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
                        this.newCamera.blablaland = this;
                        this.dispatchEvent(new Event("onNewCamera"));
                    }
                    else {
                        if (_arg_2 == 5){
                            _local_23 = this.getCameraById(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID));
                            _local_24 = new ServerMap();
                            _local_24.id = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                            _local_24.serverId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                            _local_24.fileId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
                            _local_25 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
                            if (_local_23){
                                _local_23.changeMapStatus(_local_24, _local_7, _local_25);
                            };
                        }
                        else {
                            _local_4 = false;
                        };
                    };
                }
                else {
                    if (_arg_1 == 4){
                        _local_26 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
                        _local_6 = 0;
                        while (_local_6 < this.cameraList.length) {
                            if (this.cameraList[_local_6].cameraId == _local_26){
                                this.cameraList[_local_6].parsedMessage(_arg_1, _arg_2, _arg_3);
                                break;
                            };
                            _local_6++;
                        };
                    }
                    else {
                        if (_arg_1 == 5){
                            _local_5 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                            _local_27 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                            _local_6 = 0;
                            while (_local_6 < this.cameraList.length) {
                                _local_28 = -1;
                                _local_29 = -1;
                                if (this.cameraList[_local_6].nextMap){
                                    _local_28 = this.cameraList[_local_6].nextMap.id;
                                    _local_29 = this.cameraList[_local_6].nextMap.serverId;
                                };
                                if ((((this.cameraList[_local_6].mapId == _local_5) && (this.cameraList[_local_6].serverId == _local_27)) || ((_local_28 == _local_5) && (_local_29 == _local_27)))){
                                    this.cameraList[_local_6].parsedMessage(_arg_1, _arg_2, _arg_3.duplicate());
                                };
                                _local_6++;
                            };
                        }
                        else {
                            _local_4 = false;
                        };
                    };
                };
            };
            if (!_local_4){
                super.parsedEventMessage(_arg_1, _arg_2, _arg_3);
            };
        }


    }
}//package bbl

