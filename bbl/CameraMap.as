// version 467 by nota

//bbl.CameraMap

package bbl{
    import fx.MapFx;
    import engine.SyncSteper;
    import perso.User;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.display.Sprite;
    import perso.WalkerPhysicEvent;
    import flash.display.DisplayObjectContainer;
    import flash.utils.getDefinitionByName;

    public class CameraMap extends MapFx {

        public var cameraId:uint;
        public var peace:uint;
        public var lastFXMethode:uint;
        private var _traineList:Array;

        public var stepRate:uint = 15;
        public var mainUserChangingMap:Boolean = false;
        private var _clickUserState:Boolean = true;
        private var _floodPunished:Object = {"v":false};
        private var _scriptingLock:Boolean = false;
        private var _socketLock:Boolean = false;
        private var _lastEngineTime:Number = GlobalProperties.getTimer();
        private var _lastEngineCount:Number = 0;
        private var _engineNbStepToDo:Number = 0;
        public var activeKeyboard:Boolean = true;
        public var physicEngine:Boolean = true;
        public var graphicEngine:Boolean = true;
        public var screenWalkerSteper:SyncSteper = new SyncSteper();
        public var userList:Array = new Array();
        public var tempUserList:Array = new Array();
        private var _mainUser:User = null;
        public var cameraTarget:Object = null;
        private var _leftKey:Boolean = false;
        private var _rightKey:Boolean = false;
        private var _shiftKey:Boolean = false;
        private var _upKey:Boolean = false;
        private var _downKey:Boolean = false;

        public function CameraMap(){
            this.screenWalkerSteper.clock = GlobalProperties.screenSteper;
            this.screenWalkerSteper.addEventListener("onStep", this.onWalkerScreenStep, false, 0, true);
            GlobalProperties.stage.addEventListener(Event.ENTER_FRAME, this.enterFrame, false, 0, true);
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_UP, this.KeyUpEvent, false, 0, true);
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.KeyDnEvent, false, 0, true);
            GlobalProperties.stage.addEventListener(Event.DEACTIVATE, this.desactive, false, 0, true);
            super();
        }

        public function haveBlablaland():Boolean{
            return (false);
        }

        override public function onQualityChange(_arg_1:Event):*{
            super.onQualityChange(_arg_1);
            this.CameraMapUpdateQuality();
            var _local_2:* = 0;
            while (_local_2 < this.userList.length) {
                this.userList[_local_2].updateAll();
                _local_2++;
            };
        }

        public function CameraMapUpdateQuality():*{
            var _local_1:uint = (5 - quality.persoMoveQuality);
            var _local_2:Number = ((_local_1 * this.userList.length) / 10);
            this.screenWalkerSteper.rate = Math.pow(2, Math.min(Math.round(_local_2), 4));
        }

        public function forceReloadSkins():*{
            var _local_1:uint;
            while (_local_1 < this.userList.length) {
                this.userList[_local_1].forceReload();
                _local_1++;
            };
        }

        public function forceReloadSkinId(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < this.userList.length) {
                if (this.userList[_local_2].skinId == _arg_1){
                    this.userList[_local_2].forceReload();
                };
                _local_2++;
            };
        }

        public function _showTraine():*{
            if (((!(this.mainUser)) || (!(this.mainUser.parent)))){
                return;
            };
            if (!this._traineList){
                this._traineList = new Array();
            };
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.lineStyle(2, 0xFF0000, 1);
            _local_1.graphics.drawCircle(0, 0, 2);
            this._traineList.push(_local_1);
            this.mainUser.parent.addChild(_local_1);
            _local_1.x = this.mainUser.x;
            _local_1.y = this.mainUser.y;
            while (this._traineList.length > 100) {
                _local_1 = this._traineList.shift();
                _local_1.parent.removeChild(_local_1);
            };
        }

        public function onWalkerScreenStep(_arg_1:Event):*{
            var _local_2:*;
            if (this.graphicEngine){
                _local_2 = 0;
                while (_local_2 < this.userList.length) {
                    if (this.userList[_local_2] != this._mainUser){
                        this.userList[_local_2].screenStep();
                    };
                    _local_2++;
                };
            };
        }

        public function enterFrame(_arg_1:Event):*{
            var _local_5:*;
            var _local_2:Number = (GlobalProperties.getTimer() - this._lastEngineTime);
            var _local_3:Number = (_local_2 / this.stepRate);
            var _local_4:* = (_local_3 - this._lastEngineCount);
            _local_4 = Math.min(_local_4, (500 / this.stepRate));
            while (_local_4 > 0) {
                _local_4--;
                this._lastEngineCount++;
                if (this.physicEngine){
                    _local_5 = 0;
                    while (_local_5 < this.userList.length) {
                        this.userList[_local_5].step();
                        _local_5++;
                    };
                    this.dispatchEvent(new Event("onMoveStep"));
                };
            };
            if (this._mainUser){
                this._mainUser.screenStep();
            };
            scroller.step();
            if (((this.cameraTarget) && (!(this.mainUserChangingMap)))){
                scroller.stepScrollTo(this.cameraTarget.x, this.cameraTarget.y);
            };
        }

        public function removeAllUser():*{
            var _local_3:User;
            var _local_4:*;
            var _local_1:uint = this.userList.length;
            var _local_2:Array = this.userList.concat(this.tempUserList);
            this.userList.splice(0, this.userList.length);
            this.tempUserList.splice(0, this.tempUserList.length);
            while (_local_2.length) {
                _local_3 = _local_2.shift();
                _local_4 = new WalkerPhysicEvent("onLostUser");
                _local_4.walker = _local_3;
                dispatchEvent(_local_4);
                if (_local_3 == this.cameraTarget){
                    this.cameraTarget = null;
                };
                this.userRemoveListener(_local_3);
                currentMap.onLostUser(_local_3, 0);
                _local_3.camera = null;
                if (_local_3.parent){
                    _local_3.parent.removeChild(_local_3);
                };
                if (_local_3 != this._mainUser){
                    _local_3.dispose();
                };
            };
            if (_local_1 != this.userList.length){
                dispatchEvent(new Event("onMapCountChange"));
            };
            this.CameraMapUpdateQuality();
        }

        public function removeUserFromTemp(_arg_1:User):*{
            var _local_2:* = 0;
            while (_local_2 < this.tempUserList.length) {
                if (this.tempUserList[_local_2] == _arg_1){
                    this.tempUserList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function endLeaveMapFxOther(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener(_arg_1.type, this.endLeaveMapFxOther, false);
            this.subRemoveUser(User(_arg_1.currentTarget), this.lastFXMethode);
        }

        public function removeUser(_arg_1:User, _arg_2:uint=0):*{
            if (((_arg_1.moveFx) && (_arg_2))){
                this.lastFXMethode = _arg_2;
                _arg_1.addEventListener("endFx", this.endLeaveMapFxOther, false, 0, true);
                _arg_1.leaveMapFX(_arg_2);
            }
            else {
                this.subRemoveUser(_arg_1, _arg_2);
            };
        }

        public function subRemoveUser(_arg_1:User, _arg_2:uint=0):*{
            var _local_5:*;
            var _local_3:uint = this.userList.length;
            var _local_4:* = 0;
            while (_local_4 < this.userList.length) {
                if (this.userList[_local_4] == _arg_1){
                    _local_5 = new WalkerPhysicEvent("onLostUser");
                    _local_5.walker = _arg_1;
                    dispatchEvent(_local_5);
                    if (this.userList[_local_4] == this._mainUser){
                        this._mainUser = null;
                    };
                    if (this.userList[_local_4] == this.cameraTarget){
                        this.cameraTarget = null;
                    };
                    currentMap.onLostUser(this.userList[_local_4], _arg_2);
                    this.userList[_local_4].dispose();
                    this.userRemoveListener(this.userList[_local_4]);
                    this.userList[_local_4].camera = null;
                    this.userList.splice(_local_4, 1);
                    break;
                };
                _local_4++;
            };
            if (_local_3 != this.userList.length){
                dispatchEvent(new Event("onMapCountChange"));
            };
            this.CameraMapUpdateQuality();
        }

        public function getUserByUid(_arg_1:uint=0):User{
            var _local_2:uint;
            while (_local_2 < this.userList.length) {
                if (this.userList[_local_2].userId == _arg_1){
                    return (this.userList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function getUserByPid(_arg_1:uint=0):User{
            var _local_3:int;
            var _local_2:User;
            if (!_local_2){
                _local_3 = (this.tempUserList.length - 1);
                while (_local_3 >= 0) {
                    if (this.tempUserList[_local_3].userPid == _arg_1){
                        _local_2 = this.tempUserList[_local_3];
                        break;
                    };
                    _local_3--;
                };
            };
            if (!_local_2){
                _local_3 = (this.userList.length - 1);
                while (_local_3 >= 0) {
                    if (this.userList[_local_3].userPid == _arg_1){
                        _local_2 = this.userList[_local_3];
                        break;
                    };
                    _local_3--;
                };
            };
            return (_local_2);
        }

        public function endEnterMapFx(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener(_arg_1.type, this.endEnterMapFx, false);
            _arg_1.currentTarget.visible = true;
            _arg_1.currentTarget.paused = false;
            this.updateKeyEvent();
        }

        public function addUser(_arg_1:User, _arg_2:uint=0):*{
            userContent.addChild(_arg_1);
            this.userList.push(_arg_1);
            this.userAddListener(_arg_1);
            _arg_1.camera = this;
            _arg_1.clickable = this._clickUserState;
            _arg_1.addEventListener("endFx", this.endEnterMapFx, false, 0, true);
            _arg_1.enterMapFX(_arg_2);
            currentMap.onNewUser(_arg_1, _arg_2);
            _arg_1.screenStep();
            this.CameraMapUpdateQuality();
            var _local_3:* = new WalkerPhysicEvent("onNewUser");
            _local_3.walker = _arg_1;
            dispatchEvent(_local_3);
            dispatchEvent(new Event("onMapCountChange"));
        }

        public function moveUserContent(_arg_1:User, _arg_2:String):*{
            var _local_3:DisplayObjectContainer;
            if (_arg_1.parent){
                _local_3 = null;
                if (_arg_2){
                    _local_3 = getUserContentByName(_arg_2);
                }
                else {
                    _local_3 = userContent;
                };
                if (((_local_3) && (!(_local_3 == _arg_1.parent)))){
                    _arg_1.parent.removeChild(_arg_1);
                    _local_3.addChild(_arg_1);
                };
            };
        }

        public function onClickUser(_arg_1:Event):*{
            var _local_2:* = new WalkerPhysicEvent("onClickUser");
            _local_2.walker = _arg_1.currentTarget;
            dispatchEvent(_local_2);
        }

        public function userRemoveListener(_arg_1:User):*{
            _arg_1.removeEventListener("overLimit", currentMap.onOverLimitEvent, false);
            _arg_1.removeEventListener("floorEvent", currentMap.onFloorEvent, false);
            _arg_1.removeEventListener("environmentEvent", currentMap.onEnvironmentEvent, false);
            _arg_1.removeEventListener("interactivEvent", currentMap.onInteractivEvent, false);
            _arg_1.removeEventListener("onClickUser", this.onClickUser, false);
        }

        public function userAddListener(_arg_1:User):*{
            _arg_1.addEventListener("overLimit", currentMap.onOverLimitEvent, false, 0, true);
            _arg_1.addEventListener("floorEvent", currentMap.onFloorEvent, false, 0, true);
            _arg_1.addEventListener("environmentEvent", currentMap.onEnvironmentEvent, false, 0, true);
            _arg_1.addEventListener("interactivEvent", currentMap.onInteractivEvent, false, 0, true);
            _arg_1.addEventListener("onClickUser", this.onClickUser, false, 0, true);
        }

        override public function onMapLoaded(_arg_1:Event):*{
            super.onMapLoaded(_arg_1);
            this.CameraMapUpdateQuality();
            currentMap.camera = this;
            currentMap.onInitMap();
        }

        public function cameraClear():*{
            this.removeAllUser();
        }

        override public function unloadMap():*{
            this.cameraClear();
            super.unloadMap();
            scroller.reset();
        }

        override public function dispose():*{
            this.cameraClear();
            GlobalProperties.stage.removeEventListener(Event.ENTER_FRAME, this.enterFrame, false);
            GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_UP, this.KeyUpEvent, false);
            GlobalProperties.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.KeyDnEvent, false);
            GlobalProperties.stage.removeEventListener(Event.DEACTIVATE, this.desactive, false);
            this.screenWalkerSteper.dispose();
            this.screenWalkerSteper.removeEventListener("onStep", this.onWalkerScreenStep, false);
            super.dispose();
            if (this.mainUser){
                this.mainUser.dispose();
                this.mainUser = null;
            };
        }

        internal function desactive(_arg_1:Event=null):*{
            this._leftKey = false;
            this._upKey = false;
            this._shiftKey = false;
            this._rightKey = false;
            this._downKey = false;
            this.updateKeyEvent();
        }

        internal function KeyUpEvent(_arg_1:KeyboardEvent):*{
            this._shiftKey = _arg_1.shiftKey;
            if (_arg_1.keyCode == 37){
                this._leftKey = false;
            };
            if (_arg_1.keyCode == 38){
                this._upKey = false;
            };
            if (_arg_1.keyCode == 39){
                this._rightKey = false;
            };
            if (_arg_1.keyCode == 40){
                this._downKey = false;
            };
            this.updateKeyEvent();
        }

        public function get interfaceMoveLiberty():Boolean{
            return (true);
        }

        internal function KeyDnEvent(_arg_1:KeyboardEvent):*{
            this._shiftKey = _arg_1.shiftKey;
            if (((_arg_1.keyCode == 37) && (this.interfaceMoveLiberty))){
                this._leftKey = true;
            };
            if (((_arg_1.keyCode == 38) && (!(_arg_1.ctrlKey)))){
                this._upKey = true;
            };
            if (((_arg_1.keyCode == 39) && (this.interfaceMoveLiberty))){
                this._rightKey = true;
            };
            if (((_arg_1.keyCode == 40) && (!(_arg_1.ctrlKey)))){
                this._downKey = true;
            };
            this.updateKeyEvent();
        }

        public function updateKeyEvent():*{
            var _local_1:int;
            var _local_2:int;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:Boolean;
            if (this._mainUser){
                _local_1 = ((this._leftKey) ? -1 : ((this._rightKey) ? 1 : 0));
                _local_1 = (((this._leftKey) && (this._rightKey)) ? 0 : _local_1);
                _local_2 = ((this._upKey) ? 1 : ((this._downKey) ? -1 : 0));
                _local_2 = (((this._upKey) && (this._downKey)) ? 0 : _local_2);
                _local_3 = this._shiftKey;
                if ((((this.mainUser.floodPunished) || (this._scriptingLock)) || (this._socketLock))){
                    _local_1 = 0;
                    _local_2 = 0;
                    _local_3 = false;
                };
                if (((this.activeKeyboard) && (!(this.mainUserChangingMap)))){
                    _local_4 = (!(this._mainUser.walk == _local_1));
                    _local_5 = (!(this._mainUser.jump == _local_2));
                    _local_6 = (!(this._mainUser.shiftKey == _local_3));
                    this._mainUser.walk = _local_1;
                    this._mainUser.jump = _local_2;
                    this._mainUser.shiftKey = _local_3;
                    if ((((_local_4) || (_local_5)) || (_local_6))){
                        this.mainUserKeyEvent(_local_4, _local_5, _local_6);
                    };
                };
            };
        }

        public function mainUserKeyEvent(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean):*{
        }

        public function setClickUserState(_arg_1:Boolean):*{
            var _local_2:uint;
            this._clickUserState = _arg_1;
            _local_2 = 0;
            while (_local_2 < this.userList.length) {
                this.userList[_local_2].clickable = _arg_1;
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.tempUserList.length) {
                this.tempUserList[_local_2].clickable = _arg_1;
                _local_2++;
            };
        }

        public function getClassByName(_arg_1:String):Object{
            return (getDefinitionByName(_arg_1));
        }

        public function get mainUser():User{
            return (this._mainUser);
        }

        public function set mainUser(_arg_1:User):*{
            if (_arg_1 != this._mainUser){
                if (this._mainUser){
                    this._mainUser.clientControled = false;
                };
                if (_arg_1){
                    _arg_1.clientControled = true;
                };
                this._mainUser = _arg_1;
            };
        }

        public function get serverTime():Number{
            return (GlobalProperties.serverTime);
        }

        public function get floodPunished():Boolean{
            return (this._floodPunished.v);
        }

        public function set floodPunished(_arg_1:Boolean):*{
            this._floodPunished = {"v":_arg_1};
        }

        public function get scriptingLock():Boolean{
            return (this._scriptingLock);
        }

        public function set scriptingLock(_arg_1:Boolean):*{
            this._scriptingLock = _arg_1;
            this.updateKeyEvent();
        }

        public function get socketLock():Boolean{
            return (this._socketLock);
        }

        public function set socketLock(_arg_1:Boolean):*{
            this._socketLock = _arg_1;
            this.updateKeyEvent();
        }


    }
}//package bbl

