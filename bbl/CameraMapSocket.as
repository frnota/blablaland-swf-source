// version 467 by nota

//bbl.CameraMapSocket

package bbl{
    import map.ServerMap;
    import flash.utils.Timer;
    import flash.events.Event;
    import perso.WalkerPhysicEvent;
    import perso.User;
    import net.Binary;
    import net.SocketMessageEvent;
    import net.SocketMessage;

    public class CameraMapSocket extends CameraInterface {

        public var cameraReady:Boolean;
        public var actionList:Array;
        public var latence:Number;
        public var nextMap:ServerMap;
        public var delayedMapMessage:Array;
        private var _blablaland:BblCamera;
        private var flushTimer:Timer;
        private var userStateResendTimer:Timer;
        private var _mapId:Object;
        private var _headTimeOut:Timer;
        private var _firstHeadLocation:Boolean;

        public function CameraMapSocket(){
            this._firstHeadLocation = true;
            this.delayedMapMessage = new Array();
            this.mapId = 0;
            this.nextMap = null;
            this.cameraReady = false;
            this.actionList = new Array();
            this.setDefaultLatence();
            this.userStateResendTimer = new Timer(3000);
            this.userStateResendTimer.addEventListener("timer", this.userStateResendTimerEvt, false);
            this.flushTimer = new Timer(1000);
            this._headTimeOut = new Timer(6000);
            this._headTimeOut.addEventListener("timer", this.headTimerEvt);
        }

        override public function onMapLoaded(_arg_1:Event):*{
            var _local_2:*;
            super.onMapLoaded(_arg_1);
            this.setDefaultLatence();
            if (((this.blablaland) && (userInterface))){
                _local_2 = this.blablaland.getServerMapById(this.mapId);
                if (_local_2){
                    userInterface.mapName = _local_2.nom;
                }
                else {
                    userInterface.mapName = null;
                };
                userInterface.uniName = this.blablaland.serverList[serverId].nom;
            };
        }

        public function clearDelayedMapMessage():*{
            this.delayedMapMessage.splice(0, this.delayedMapMessage.length);
        }

        public function flushDelayedMapMessage():*{
            while (this.delayedMapMessage.length) {
                currentMap.onSocketMessage(this.delayedMapMessage.shift());
            };
        }

        override public function set userInterface(_arg_1:InterfaceSmiley):*{
            var _local_2:Boolean;
            if (((!(userInterface == _arg_1)) && (_arg_1))){
                _local_2 = true;
            };
            super.userInterface = _arg_1;
            if (_local_2){
                this.onSmileyListChangeEvt();
            };
        }

        public function onSmileyListChangeEvt(_arg_1:Event=null):*{
            var _local_2:*;
            if (((userInterface) && (this.blablaland))){
                userInterface.removeAllAllowedPack();
                _local_2 = 0;
                while (_local_2 < this.blablaland.smileyAllowList.length) {
                    userInterface.addAllowedPack(this.blablaland.smileyAllowList[_local_2]);
                    _local_2++;
                };
            };
        }

        public function setDefaultLatence():*{
            this.latence = 40;
        }

        public function setLatence(_arg_1:uint):*{
            this.latence = _arg_1;
        }

        override public function haveBlablaland():Boolean{
            return (!(this.blablaland == null));
        }

        override public function enterFrame(_arg_1:Event):*{
            this.flushAction();
            super.enterFrame(_arg_1);
        }

        public function addActionList(_arg_1:Object):*{
            this.actionList.push(_arg_1);
        }

        public function flushAction(_arg_1:Event=null):*{
            var _local_2:uint;
            var _local_4:*;
            var _local_5:WalkerPhysicEvent;
            var _local_3:* = 0;
            while (_local_3 < this.actionList.length) {
                _local_4 = this.actionList[_local_3];
                if ((_local_4[2].currentTimer >= (_local_4[1] + this.latence))){
                    if (_local_4[0] == 2){
                        _local_2 = _local_4[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                        removeUser(_local_4[2], _local_2);
                    }
                    else {
                        if (_local_4[0] == 3){
                            _local_4[2].readStateFromMessage(_local_4[3]);
                        }
                        else {
                            if (_local_4[0] == 4){
                                _local_4[2].readStateFromMessage(_local_4[3]);
                                _local_5 = WalkerPhysicEvent.getEventFromMessage(_local_4[3]);
                                _local_5.walker = _local_4[2];
                                _local_5.certified = true;
                                _local_4[2].dispatchEvent(_local_5);
                            }
                            else {
                                if (_local_4[0] == 6){
                                    _local_4[2].readFXChange(_local_4[3]);
                                }
                                else {
                                    if (_local_4[0] == 9){
                                        _local_4[2].addEventListener("endFx", this.onEndLeaveMapTeleportSameMap, false, 0, true);
                                        _local_4[2].lastSocketMessage = _local_4[3];
                                        _local_2 = _local_4[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                                        _local_4[2].leaveMapFX(_local_2);
                                    }
                                    else {
                                        if (_local_4[0] == 1001){
                                            _local_2 = _local_4[3].bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                                            removeUserFromTemp(_local_4[2]);
                                            addUser(_local_4[2], _local_2);
                                        };
                                    };
                                };
                            };
                        };
                    };
                    this.actionList.splice(_local_3, 1);
                    _local_3--;
                };
                _local_3++;
            };
        }

        override public function removeAllUser():*{
            this.actionList.splice(0, this.actionList.length);
            super.removeAllUser();
        }

        override public function subRemoveUser(_arg_1:User, _arg_2:uint=0):*{
            var _local_3:uint;
            while (_local_3 < this.actionList.length) {
                if (this.actionList[2] == _arg_1){
                    this.actionList.splice(_local_3, 1);
                    _local_3--;
                };
                _local_3++;
            };
            super.subRemoveUser(_arg_1, _arg_2);
        }

        public function movePersoToMap(_arg_1:uint, _arg_2:Object=null):*{
            if (this.blablaland){
                if (mainUser){
                    mainUser.paused = true;
                    mainUser.visible = false;
                };
                mainUserChangingMap = true;
                this.blablaland.movePersoToMap(this, _arg_1, _arg_2);
            };
        }

        public function changeMapStatus(_arg_1:ServerMap, _arg_2:uint, _arg_3:uint):*{
            mainUserChangingMap = false;
            if (!_arg_2){
                this.gotoMap(_arg_1, _arg_3);
            }
            else {
                if (((currentMap) && (!(_arg_2 == 3)))){
                    currentMap.onChangeMapError(_arg_2);
                };
            };
            if (((_arg_2 == 17) && (userInterface))){
                userInterface.addLocalMessage("<span class='info'>Désolé, cet univers est actuellement fermé...</span>");
            };
            this.updateKeyEvent();
        }

        public function headTimerEvt(_arg_1:Event):*{
            this._headTimeOut.stop();
            if (mainUser){
                mainUser.removeHeadLocation(this);
            };
        }

        public function addHeadLocation():*{
            if (!this._headTimeOut.running){
                mainUser.addHeadLocation(this);
            };
            this._headTimeOut.reset();
            this._headTimeOut.start();
        }

        public function parsedMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_4:uint;
            var _local_5:uint;
            var _local_6:Binary;
            var _local_7:uint;
            var _local_8:uint;
            var _local_9:uint;
            var _local_10:User;
            var _local_11:*;
            var _local_12:User;
            var _local_13:uint;
            var _local_14:uint;
            var _local_15:uint;
            var _local_16:uint;
            var _local_17:Boolean;
            var _local_18:Boolean;
            var _local_19:Boolean;
            var _local_20:uint;
            var _local_21:uint;
            var _local_22:String;
            var _local_23:uint;
            var _local_24:String;
            var _local_25:*;
            var _local_26:uint;
            var _local_27:uint;
            var _local_28:Binary;
            var _local_29:Boolean;
            if (_arg_1 == 4){
                if (_arg_2 == 1){
                    this.blablaland.socketUnlock();
                    _local_4 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
                    _local_5 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                    if (!_local_4){
                        mapXpos = _arg_3.message.bitReadSignedInt(17);
                        mapYpos = _arg_3.message.bitReadSignedInt(17);
                        meteoId = _arg_3.message.bitReadUnsignedInt(5);
                        transport = this.blablaland.getTransportById(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID));
                        peace = _arg_3.message.bitReadUnsignedInt(16);
                        initMeteo();
                        currentMap.onStartMap();
                        while (_arg_3.message.bitReadBoolean()) {
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                            _local_8 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                            if (this.blablaland.pid == _local_8){
                                this.blablaland.pseudo = _arg_3.message.bitReadString();
                                _local_9 = _arg_3.message.bitReadUnsignedInt(3);
                                _arg_3.message.bitReadUnsignedInt(32);
                                if (mainUser){
                                    mainUser.sex = _local_9;
                                    _local_6 = _arg_3.message.bitReadBinaryData();
                                    mainUser.readStateFromMessage(_local_6);
                                    addUser(mainUser, _local_5);
                                    if (this.blablaland){
                                        if (((Object(this.blablaland).xp < 6) || (this._firstHeadLocation))){
                                            this._firstHeadLocation = false;
                                            this.addHeadLocation();
                                        };
                                    };
                                    cameraTarget = mainUser;
                                    scroller.stepScrollTo(mainUser.position.x, mainUser.position.y, {"forceBinary":true});
                                };
                            }
                            else {
                                _local_10 = new User();
                                _local_10.userId = _local_7;
                                _local_10.userPid = _local_8;
                                _local_10.pseudo = _arg_3.message.bitReadString();
                                _local_10.sex = _arg_3.message.bitReadUnsignedInt(3);
                                _local_10.receiveNewCurrentTimer(_arg_3.message.bitReadUnsignedInt(32));
                                _local_6 = _arg_3.message.bitReadBinaryData();
                                _local_10.readStateFromMessage(_local_6);
                                addUser(_local_10, 5);
                            };
                        };
                        readFXMessageEffect(_arg_3.message);
                        this.cameraReady = true;
                        dispatchEvent(new Event("onCameraReady"));
                        this.updateKeyEvent();
                    };
                }
                else {
                    if (_arg_2 == 2){
                        _local_11 = new ServerMap();
                        _local_11.id = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                        _local_11.serverId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                        _local_11.fileId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
                        this.gotoMap(_local_11, _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID));
                    }
                    else {
                        if (_arg_2 == 3){
                            if (currentMap){
                                currentMap.onSocketMessage(_arg_3);
                            }
                            else {
                                this.delayedMapMessage.push(_arg_3);
                            };
                        };
                    };
                };
            }
            else {
                if (_arg_1 == 5){
                    if (((_arg_2 == 1) && (this.cameraReady))){
                        _local_15 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                        _local_16 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                        _local_12 = new User();
                        _local_12.userId = _local_15;
                        _local_12.userPid = _local_16;
                        _local_12.pseudo = _arg_3.message.bitReadString();
                        _local_12.sex = _arg_3.message.bitReadUnsignedInt(3);
                        _local_13 = _arg_3.message.bitReadUnsignedInt(32);
                        _local_12.receiveNewCurrentTimer(_local_13);
                        _local_12.readStateFromMessage(_arg_3.message);
                        tempUserList.push(_local_12);
                        this.addActionList([(_arg_2 + 1000), _local_13, _local_12, _arg_3.message]);
                    }
                    else {
                        if (((_arg_2 == 2) && (this.cameraReady))){
                            _local_12 = getUserByPid(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                            if (((_local_12) && (!(_local_12 == mainUser)))){
                                this.addActionList([_arg_2, _local_12.currentTimer, _local_12, _arg_3.message]);
                            };
                        }
                        else {
                            if (((_arg_2 == 3) || (_arg_2 == 4))){
                                _local_12 = getUserByPid(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                                if (((_local_12) && (!(_local_12 == mainUser)))){
                                    _local_13 = _arg_3.message.bitReadUnsignedInt(32);
                                    _local_12.receiveNewCurrentTimer(_local_13);
                                    this.addActionList([_arg_2, _local_13, _local_12, _arg_3.message]);
                                };
                            }
                            else {
                                if (_arg_2 == 5){
                                    _local_14 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                    _local_12 = null;
                                    if (mainUser){
                                        if (mainUser.userPid == _local_14){
                                            _local_12 = mainUser;
                                        };
                                    };
                                    if (!_local_12){
                                        _local_12 = getUserByPid(_local_14);
                                    };
                                    if (_local_12){
                                        _local_12.dodo = _arg_3.message.bitReadBoolean();
                                    };
                                }
                                else {
                                    if (_arg_2 == 6){
                                        _local_14 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                        _local_17 = _arg_3.message.bitReadBoolean();
                                        _local_12 = getUserByPid(_local_14);
                                        if (mainUser){
                                            if (mainUser.userPid == _local_14){
                                                _local_12 = mainUser;
                                            };
                                        };
                                        if (_local_12){
                                            if (((_local_12 == mainUser) || (!(_local_17)))){
                                                _local_12.readFXChange(_arg_3.message);
                                            }
                                            else {
                                                if (_local_12){
                                                    this.addActionList([_arg_2, _local_12.currentTimer, _local_12, _arg_3.message]);
                                                };
                                            };
                                        };
                                    }
                                    else {
                                        if (_arg_2 == 7){
                                            _local_18 = _arg_3.message.bitReadBoolean();
                                            _local_19 = _arg_3.message.bitReadBoolean();
                                            _local_14 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                            _local_20 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                            _local_21 = _arg_3.message.bitReadUnsignedInt(3);
                                            _local_22 = _arg_3.message.bitReadString();
                                            _local_23 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                                            _local_24 = _arg_3.message.bitReadString();
                                            _arg_1 = _arg_3.message.bitReadUnsignedInt(3);
                                            if (((!(this.blablaland.isMuted(_local_20))) || (_local_19))){
                                                _local_25 = new InterfaceEvent("onMessageMap");
                                                _local_25.text = _local_24;
                                                _local_25.pseudo = _local_22;
                                                _local_25.pid = _local_14;
                                                _local_25.uid = _local_20;
                                                _local_25.serverId = _local_23;
                                                dispatchEvent(_local_25);
                                                _local_12 = getUserByPid(_local_14);
                                                _local_24 = _local_25.text;
                                                if ((((_local_25.transmitTalk) && (_local_12)) && (!(_arg_1 == 3)))){
                                                    _local_12.talk(_local_24, _arg_1);
                                                };
                                                if (((_local_25.transmitInterface) && (userInterface))){
                                                    if (mainUser){
                                                        if (_local_20 == mainUser.userId){
                                                            _local_20 = 0;
                                                            _local_14 = 0;
                                                        };
                                                    };
                                                    userInterface.addUserMessage(_local_22, _local_24, {
                                                        "ISHTML":_local_18,
                                                        "ISMODO":_local_19,
                                                        "PID":_local_14,
                                                        "UID":_local_20,
                                                        "SEX":_local_21,
                                                        "SERVERID":_local_23,
                                                        "TYPE":_arg_1
                                                    });
                                                };
                                            };
                                        }
                                        else {
                                            if (_arg_2 == 8){
                                                _local_14 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                                _local_26 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID);
                                                _local_27 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_ID);
                                                _local_28 = _arg_3.message.bitReadBinaryData();
                                                _local_12 = getUserByPid(_local_14);
                                                if (_local_12){
                                                    if (!this.blablaland.isMuted(_local_12.userId)){
                                                        _local_12.smile(_local_26, _local_27, _local_28);
                                                    };
                                                };
                                            }
                                            else {
                                                if (_arg_2 == 9){
                                                    _local_12 = getUserByPid(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID));
                                                    if (_local_12){
                                                        if (_local_12 == mainUser){
                                                            _local_12.addEventListener("endFx", this.onEndLeaveMapTeleportSameMap, false, 0, true);
                                                            _local_12.lastSocketMessage = _arg_3.message;
                                                            _local_5 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
                                                            _local_12.leaveMapFX(_local_5);
                                                        }
                                                        else {
                                                            this.addActionList([_arg_2, _local_12.currentTimer, _local_12, _arg_3.message]);
                                                        };
                                                    };
                                                }
                                                else {
                                                    if (_arg_2 == 10){
                                                        readFXChange(_arg_3.message);
                                                    }
                                                    else {
                                                        if (_arg_2 == 11){
                                                            _local_18 = _arg_3.message.bitReadBoolean();
                                                            _local_29 = _arg_3.message.bitReadBoolean();
                                                            _local_24 = _arg_3.message.bitReadString();
                                                            if (userInterface){
                                                                if (!_local_18){
                                                                    _local_24 = userInterface.htmlEncode(_local_24);
                                                                };
                                                                userInterface.addLocalMessage((("<span class='info'>" + _local_24) + "</span>"));
                                                            };
                                                            if (_local_29){
                                                                GlobalProperties.mainApplication.addTextAlert(_local_24, _local_18);
                                                            };
                                                        }
                                                        else {
                                                            if (_arg_2 == 12){
                                                                if (currentMap){
                                                                    currentMap.onSocketMessage(_arg_3);
                                                                }
                                                                else {
                                                                    this.delayedMapMessage.push(_arg_3);
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        override public function onMapReady(_arg_1:Event=null):*{
            var _local_2:*;
            this.flushTimer.start();
            super.onMapReady(_arg_1);
            if (this.blablaland){
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 3);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 6);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_CAMERA_ID, cameraId);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, this.mapId);
                this.blablaland.send(_local_2);
            }
            else {
                this.cameraReady = true;
                dispatchEvent(new Event("onCameraReady"));
            };
        }

        override public function dispose():*{
            if (this._blablaland){
                this._blablaland.removeEventListener("onSmileyListChange", this.onSmileyListChangeEvt, false);
            };
            this.cameraReady = false;
            this.headTimerEvt(null);
            super.dispose();
        }

        override public function unloadMap():*{
            if (userInterface){
                userInterface.mapName = null;
            };
            this.flushTimer.stop();
            this.cameraReady = false;
            super.unloadMap();
            this.clearDelayedMapMessage();
        }

        public function endLeaveMapFxSelf(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener(_arg_1.type, this.endLeaveMapFxSelf, false);
            this.gotoMap(this.nextMap);
            this.nextMap = null;
        }

        public function endEnterMapFxTeleportSameMap(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("endFx", this.endEnterMapFxTeleportSameMap, false);
            endEnterMapFx(_arg_1);
            _arg_1.currentTarget.onFloor = false;
            _arg_1.currentTarget.checkEnvironmentColor();
        }

        public function onEndLeaveMapTeleportSameMap(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("endFx", this.onEndLeaveMapTeleportSameMap, false);
            _arg_1.currentTarget.lastSocketMessage.bitPosition = (_arg_1.currentTarget.lastSocketMessage.bitPosition - GlobalProperties.BIT_METHODE_ID);
            var _local_2:uint = _arg_1.currentTarget.lastSocketMessage.bitReadUnsignedInt(GlobalProperties.BIT_METHODE_ID);
            _arg_1.currentTarget.readStateFromMessage(_arg_1.currentTarget.lastSocketMessage);
            _arg_1.currentTarget.addEventListener("endFx", this.endEnterMapFxTeleportSameMap, false, 0, true);
            _arg_1.currentTarget.enterMapFX(_local_2);
        }

        public function gotoMap(_arg_1:ServerMap, _arg_2:uint=0):*{
            if ((((_arg_2) && (mainUser)) && (this.cameraReady))){
                this.nextMap = _arg_1;
                mainUser.addEventListener("endFx", this.endLeaveMapFxSelf, false, 0, true);
                mainUser.leaveMapFX(_arg_2);
            }
            else {
                if (((!(_arg_1.serverId == serverId)) && (mainUser))){
                    dispatchEvent(new Event("onChangeServerId"));
                }
                else {
                    this.mapId = _arg_1.id;
                    serverId = _arg_1.serverId;
                    loadMap(_arg_1.fileId);
                };
            };
        }

        override public function mainUserKeyEvent(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean):*{
            if (mainUser){
                if (((((_arg_3) && (!(mainUser.walk == 0))) || (_arg_1)) || ((_arg_2) && ((!(mainUser.onFloor)) || (!(mainUser.jump == 1)))))){
                    this.sendMainUserState();
                };
            };
        }

        override public function updateKeyEvent():*{
            if (this.cameraReady){
                super.updateKeyEvent();
            };
        }

        public function userStateResendTimerEvt(_arg_1:Event):*{
            this.sendMainUserState();
        }

        public function sendMainUserState():*{
            var _local_1:*;
            if ((((mainUser) && (this.blablaland)) && (this.cameraReady))){
                _local_1 = new SocketMessage();
                _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
                _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 1);
                _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, this.mapId);
                _local_1.bitWriteUnsignedInt(32, GlobalProperties.getTimer());
                mainUser.exportStateToMessage(_local_1);
                this.blablaland.resetSocketLock();
                this.blablaland.send(_local_1);
                this.userStateResendTimer.reset();
                if (((!(mainUser.walk == 0)) || (!(mainUser.jump == 0)))){
                    this.userStateResendTimer.delay = 1500;
                    this.userStateResendTimer.start();
                }
                else {
                    if (mainUser.activity){
                        this.userStateResendTimer.delay = 3000;
                        this.userStateResendTimer.start();
                    };
                };
            };
        }

        public function mainUserGrimpeTimeOut(_arg_1:Event):*{
            this.sendMainUserState();
        }

        public function mainUserEvent(_arg_1:WalkerPhysicEvent):*{
            var _local_2:*;
            if (((((_arg_1.eventType < 40) && (this.blablaland)) && (this.cameraReady)) && (!(mainUserChangingMap)))){
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 2);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, this.mapId);
                _local_2.bitWriteUnsignedInt(32, GlobalProperties.getTimer());
                mainUser.exportStateToMessage(_local_2);
                _arg_1.exportEvent(_local_2);
                this.blablaland.resetSocketLock();
                this.blablaland.send(_local_2);
                this.userStateResendTimer.reset();
                if (((!(mainUser.walk == 0)) || (!(mainUser.jump == 0)))){
                    this.userStateResendTimer.delay = 1500;
                    this.userStateResendTimer.start();
                }
                else {
                    if (mainUser.activity){
                        this.userStateResendTimer.delay = 3000;
                        this.userStateResendTimer.start();
                    };
                };
            };
        }

        override public function set mainUser(_arg_1:User):*{
            if (_arg_1 != mainUser){
                if (mainUser){
                    mainUser.removeEventListener("floorEvent", this.mainUserEvent, false);
                    mainUser.removeEventListener("environmentEvent", this.mainUserEvent, false);
                    mainUser.removeEventListener("onGrimpeTimeOut", this.mainUserGrimpeTimeOut, false);
                };
                if (_arg_1){
                    _arg_1.addEventListener("floorEvent", this.mainUserEvent, false, 1, true);
                    _arg_1.addEventListener("environmentEvent", this.mainUserEvent, false, 1, true);
                    _arg_1.addEventListener("onGrimpeTimeOut", this.mainUserGrimpeTimeOut, false, 1, true);
                };
                super.mainUser = _arg_1;
            };
        }

        public function set mapId(_arg_1:uint):*{
            this._mapId = {"val":_arg_1};
        }

        public function get mapId():uint{
            return (this._mapId.val);
        }

        public function set blablaland(_arg_1:BblCamera):*{
            if (((this._blablaland) && (!(_arg_1 == this._blablaland)))){
                this._blablaland.removeEventListener("onSmileyListChange", this.onSmileyListChangeEvt, false);
            };
            if (((_arg_1) && (!(_arg_1 == this._blablaland)))){
                _arg_1.addEventListener("onSmileyListChange", this.onSmileyListChangeEvt, false, 0, true);
            };
            this._blablaland = _arg_1;
        }

        public function get blablaland():BblCamera{
            return (this._blablaland);
        }


    }
}//package bbl

