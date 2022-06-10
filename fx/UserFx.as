// version 467 by nota

//fx.UserFx

package fx{
    import perso.Emotional;
    import net.SocketMessage;
    import flash.filters.GlowFilter;
    import perso.SkinColor;
    import flash.events.Event;
    import net.Binary;
    import bbl.GlobalProperties;
    import bbl.CameraMap;
    import map.LightEffectItem;
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;

    public class UserFx extends Emotional {

        public var fxLoader:FxLoader;
        public var fxMemory:Array;
        public var fxPersistent:Array;
        public var moveFx:Object;
        public var overloadList:Array;
        public var peinture:UserFxOverloadItem;
        public var lastSocketMessage:SocketMessage;
        public var leaveMapFXMethode:uint;
        public var enterMapFXMethode:uint;
        public var lightEffectSize:Number;
        private var _skinFilter:Array;
        private var _delayedUserObject:Array;
        private var _delayedCameraFx:Array;
        private var _delayedAction:Array;
        private var _floodPunished:Object;
        private var _lightEffectColor:uint;
        private var _lightEffect:Object;
        private var _lightEffectFlip:Boolean;
        private var _lightAdded:Boolean;
        private var _lightFilter:GlowFilter;
        private var _overWalkSpeed:Object;
        private var _overSwimSpeed:Object;
        private var _overSkinScale:Number;
        private var _overGravity:Object;
        private var _overSkinAction:UserFxOverloadItem;
        private var _firstSkinAction:uint;
        private var _firstSkinActionPriority:uint;
        private var _overDirection:UserFxOverloadItem;
        private var _firstDirection:Number;
        private var _overJumpStrength:Object;
        private var _overSkinColor:SkinColor;
        private var _firstSkinColor:SkinColor;
        private var _firstSkinId:Object;
        private var _firstShift:Boolean;
        private var _overShift:int;
        private var _overHide:int;
        private var _firstWalk:int;
        private var _overWalk:int;
        private var _firstJump:int;
        private var _overJump:int;
        private var _overHaveFoot:Object;
        private var _overPseudo:UserFxOverloadItem;

        public function UserFx(){
            this.leaveMapFXMethode = 0;
            this.enterMapFXMethode = 0;
            this._overHaveFoot = {"v":0};
            this._overWalk = -2;
            this._overHide = -2;
            this._overShift = -2;
            this._overJump = -2;
            this._overPseudo = null;
            this._skinFilter = new Array();
            this._delayedUserObject = new Array();
            this._delayedAction = new Array();
            this._delayedCameraFx = new Array();
            this._floodPunished = {"v":false};
            this.fxLoader = new FxLoader();
            this.fxPersistent = new Array();
            this.fxMemory = new Array();
            this._lightAdded = false;
            this._lightEffect = {"v":false};
            this.lightEffectSize = 5;
            this.overloadList = new Array();
            this.peinture = null;
            this._overWalkSpeed = {"v":1};
            this._overSwimSpeed = {"v":1};
            this._overJumpStrength = {"v":1};
            this._overGravity = {"v":1};
            this._overDirection = null;
            this._firstDirection = 0;
            this._overSkinScale = 1;
            this._firstSkinId = {"v":-1};
            this._overSkinAction = null;
            this._overSkinColor = null;
            this._firstSkinColor = null;
            this.moveFx = null;
            this.fxLoader.addEventListener("onFxLoaded", this.onMoveFxLoaded, false, 0, true);
            this.fxLoader.loadFx(0);
        }

        public function onMoveFxLoaded(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("onFxLoaded", this.onMoveFxLoaded, false);
            this.moveFx = new _arg_1.currentTarget.lastLoad.classRef();
            this.moveFx.walker = this;
            this.moveFx.camera = camera;
        }

        public function clearFxByIdSid(_arg_1:uint, _arg_2:uint, _arg_3:uint):*{
            this.fxMemory = this.fxMemory.slice();
            var _local_4:* = 0;
            while (_local_4 < this.fxMemory.length) {
                if (((this.fxMemory[_local_4].fxId == _arg_1) && (this.fxMemory[_local_4].fxSid == _arg_2))){
                    this.fxMemory[_local_4].endCause = _arg_3;
                    this.fxMemory[_local_4].dispose();
                    this.fxMemory.splice(_local_4, 1);
                    return;
                };
                _local_4++;
            };
        }

        public function clearFxPersistentByIdSid(_arg_1:uint, _arg_2:uint, _arg_3:uint):*{
            this.fxPersistent = this.fxPersistent.slice();
            var _local_4:* = 0;
            while (_local_4 < this.fxPersistent.length) {
                if (((this.fxPersistent[_local_4].fxId == _arg_1) && (this.fxPersistent[_local_4].fxSid == _arg_2))){
                    this.fxPersistent[_local_4].endCause = _arg_3;
                    this.fxPersistent[_local_4].dispose();
                    this.fxPersistent.splice(_local_4, 1);
                    return;
                };
                _local_4++;
            };
        }

        public function clearFX():*{
            this.stopGrimpeFx();
            this.stopWalkFx();
            this.stopSwimFx();
            var _local_1:* = 0;
            while (_local_1 < this.fxMemory.length) {
                this.fxMemory[_local_1].endCause = 0;
                this.fxMemory[_local_1].dispose();
                _local_1++;
            };
            this.fxMemory = new Array();
        }

        override public function dispose():*{
            var _local_1:FxUserObject;
            var _local_2:Object;
            var _local_3:UserFxOverloadItem;
            this.clearFX();
            if (this.moveFx){
                this.moveFx.dispose();
                this.moveFx = null;
            };
            this._delayedCameraFx.splice(0, this._delayedCameraFx.length);
            while (this._delayedUserObject.length) {
                _local_1 = this._delayedUserObject.pop();
                _local_1.dispose();
            };
            while (this.fxPersistent.length) {
                _local_2 = this.fxPersistent.pop();
                _local_2.dispose();
            };
            while (this.overloadList.length) {
                _local_3 = this.overloadList.pop();
                if (_local_3.fxTarget){
                    _local_3.fxTarget.dispose();
                };
            };
            this._delayedUserObject = new Array();
            this.fxPersistent = new Array();
            this.overloadList = new Array();
            super.dispose();
        }

        public function haveFoot():Boolean{
            var _local_1:Boolean = true;
            if (skin){
                _local_1 = skin.haveFoot;
            };
            if (this._overHaveFoot.v){
                _local_1 = ((_local_1) && (Boolean((this._overHaveFoot.v - 1))));
            };
            return (_local_1);
        }

        public function landdingFx(_arg_1:Object, _arg_2:Object=null):*{
            if (((this.moveFx) && (this.haveFoot()))){
                this.moveFx.landdingEffect(_arg_1, _arg_2);
            };
        }

        public function stopWalkFx(_arg_1:Object=null):*{
            if (this.moveFx){
                this.moveFx.stopWalk();
            };
        }

        public function startWalkFx(_arg_1:Object=null):*{
            if (((this.moveFx) && (this.haveFoot()))){
                this.moveFx.startWalk(_arg_1);
            };
        }

        public function stopGrimpeFx(_arg_1:Object=null):*{
            if (this.moveFx){
                this.moveFx.stopGrimpe();
            };
        }

        public function startGrimpeFx(_arg_1:Object=null):*{
            if (this.moveFx){
                this.moveFx.startGrimpe(_arg_1);
            };
        }

        public function stopSwimFx(_arg_1:Object=null):*{
            if (this.moveFx){
                this.moveFx.stopSwim();
            };
        }

        public function startSwimFx(_arg_1:Object=null):*{
            if (this.moveFx){
                this.moveFx.startSwim(_arg_1);
            };
        }

        public function leaveMapFX(_arg_1:uint, _arg_2:Object=null):*{
            this.leaveMapFXMethode = _arg_1;
            if (this.moveFx){
                this.moveFx.leaveMapFX(_arg_1, _arg_2);
            };
        }

        public function enterMapFX(_arg_1:uint, _arg_2:Object=null):*{
            this.enterMapFXMethode = _arg_1;
            if (this.moveFx){
                this.moveFx.enterMapFX(_arg_1, _arg_2);
            };
        }

        public function setPeinture(_arg_1:SkinColor):*{
            var _local_2:* = 0;
            while (_local_2 < this.overloadList.length) {
                if (this.overloadList[_local_2] == this.peinture){
                    this.overloadList.splice(_local_2, 1);
                    this.peinture = null;
                    break;
                };
                _local_2++;
            };
            if (_arg_1){
                this.peinture = new UserFxOverloadItem(0, 0);
                this.overloadList.push(this.peinture);
                this.peinture.skinColor = true;
                this.peinture.skinColorValue = _arg_1;
            };
            this.updateOverloadCache();
        }

        public function executeFXMessage(_arg_1:Object, _arg_2:uint, _arg_3:uint, _arg_4:Boolean, _arg_5:Boolean, _arg_6:uint):*{
            var _local_7:uint;
            var _local_8:SkinColor;
            var _local_9:UserFxOverloadItem;
            var _local_10:UserFxOverloadEvent;
            var _local_11:uint;
            var _local_12:Binary;
            var _local_13:SkinAction;
            var _local_14:Boolean;
            var _local_15:*;
            var _local_16:*;
            var _local_17:Binary;
            var _local_18:FxUserObject;
            if (_arg_2 == 1){
                this.lightEffect = _arg_4;
                if (_arg_4){
                    this.lightEffectColor = _arg_1.bitReadUnsignedInt(24);
                };
            }
            else {
                if (_arg_2 == 2){
                    this.floodPunished = _arg_4;
                }
                else {
                    if (_arg_2 == 3){
                        if (_arg_4){
                            _local_8 = new SkinColor();
                            _local_8.readBinaryColor(_arg_1);
                            this.setPeinture(_local_8);
                        }
                        else {
                            if (this.peinture){
                                this.setPeinture(null);
                            };
                        };
                    }
                    else {
                        if (_arg_2 == 4){
                            _local_9 = null;
                            if (_arg_4){
                                _local_7 = 0;
                                while (_local_7 < this.overloadList.length) {
                                    if (((this.overloadList[_local_7].fxId == _arg_2) && (this.overloadList[_local_7].fxSid == _arg_3))){
                                        _local_9 = this.overloadList[_local_7];
                                        break;
                                    };
                                    _local_7++;
                                };
                                if (!_local_9){
                                    _local_9 = new UserFxOverloadItem(_arg_2, _arg_3);
                                    this.overloadList.push(_local_9);
                                };
                                _local_9.newOne = _arg_5;
                                while (_arg_1.bitReadBoolean()) {
                                    _local_11 = _arg_1.bitReadUnsignedInt(6);
                                    if (_local_11 == 2){
                                        _local_9.walkSpeed = true;
                                        _local_9.walkSpeedValue = (_arg_1.bitReadSignedInt(9) / 100);
                                    }
                                    else {
                                        if (_local_11 == 3){
                                            _local_9.jumpStrength = true;
                                            _local_9.jumpStrengthValue = (_arg_1.bitReadSignedInt(9) / 100);
                                        }
                                        else {
                                            if (_local_11 == 4){
                                                _local_9.swimSpeed = true;
                                                _local_9.swimSpeedValue = (_arg_1.bitReadSignedInt(9) / 100);
                                            }
                                            else {
                                                if (_local_11 == 5){
                                                    _local_9.skinId = true;
                                                    _local_9.skinIdValue = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
                                                }
                                                else {
                                                    if (_local_11 == 6){
                                                        _local_9.skinColorValue = new SkinColor();
                                                        _local_9.skinColor = true;
                                                        _local_9.skinColorValue.readBinaryColor(_arg_1);
                                                    }
                                                    else {
                                                        if (_local_11 == 8){
                                                            _local_9.pseudoValue = _arg_1.bitReadString();
                                                            _local_9.pseudo = true;
                                                        }
                                                        else {
                                                            if (_local_11 == 9){
                                                                _local_10 = new UserFxOverloadEvent("onOverLoadData");
                                                                _local_10.uol = _local_9;
                                                                _local_10.walker = this;
                                                                _local_12 = _arg_1.bitReadBinaryData();
                                                                _local_10.data = _local_12;
                                                                if (camera){
                                                                    camera.dispatchEvent(_local_10);
                                                                };
                                                            }
                                                            else {
                                                                if (_local_11 == 10){
                                                                    _local_9.data = _arg_1.bitReadBinaryData();
                                                                    _local_9.data.bitPosition = 0;
                                                                }
                                                                else {
                                                                    if (_local_11 == 11){
                                                                        if (_arg_1.bitReadBoolean()){
                                                                            _local_9.floorAccel = true;
                                                                            _local_9.floorAccelValue = _arg_1.bitReadBoolean();
                                                                        };
                                                                        if (_arg_1.bitReadBoolean()){
                                                                            _local_9.floorAccelFactor = true;
                                                                            _local_9.floorAccelFactorValue = (_arg_1.bitReadUnsignedInt(10) / 10000);
                                                                        };
                                                                        if (_arg_1.bitReadBoolean()){
                                                                            _local_9.floorDecel = true;
                                                                            _local_9.floorDecelValue = _arg_1.bitReadBoolean();
                                                                        };
                                                                        if (_arg_1.bitReadBoolean()){
                                                                            _local_9.floorDecelFactor = true;
                                                                            _local_9.floorDecelFactorValue = (_arg_1.bitReadUnsignedInt(10) / 10000);
                                                                        };
                                                                    }
                                                                    else {
                                                                        if (_local_11 == 12){
                                                                            if (_arg_1.bitReadBoolean()){
                                                                                _local_9.flyAccel = true;
                                                                                _local_9.flyAccelValue = _arg_1.bitReadBoolean();
                                                                            };
                                                                            if (_arg_1.bitReadBoolean()){
                                                                                _local_9.flyAccelFactor = true;
                                                                                _local_9.flyAccelFactorValue = (_arg_1.bitReadUnsignedInt(10) / 10000);
                                                                            };
                                                                            if (_arg_1.bitReadBoolean()){
                                                                                _local_9.flyDecel = true;
                                                                                _local_9.flyDecelValue = _arg_1.bitReadBoolean();
                                                                            };
                                                                            if (_arg_1.bitReadBoolean()){
                                                                                _local_9.flyDecelFactor = true;
                                                                                _local_9.flyDecelFactorValue = (_arg_1.bitReadUnsignedInt(10) / 10000);
                                                                            };
                                                                        }
                                                                        else {
                                                                            if (_local_11 == 13){
                                                                                _local_9.skinScale = true;
                                                                                _local_9.skinScaleValue = (_arg_1.bitReadSignedInt(9) / 100);
                                                                            }
                                                                            else {
                                                                                if (_local_11 == 14){
                                                                                    _local_9.startAt = (_arg_1.bitReadUnsignedInt(32) * 1000);
                                                                                    _local_9.expireAt = (_arg_1.bitReadUnsignedInt(32) * 1000);
                                                                                }
                                                                                else {
                                                                                    if (_local_11 == 15){
                                                                                        _local_9.type = _arg_1.bitReadUnsignedInt(2);
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
                                if (_local_9.newOne){
                                    _local_10 = new UserFxOverloadEvent("onNewOverLoad");
                                    _local_10.uol = _local_9;
                                    _local_10.walker = this;
                                    this.dispatchEvent(_local_10);
                                };
                            }
                            else {
                                _local_7 = 0;
                                while (_local_7 < this.overloadList.length) {
                                    if (((this.overloadList[_local_7].fxId == _arg_2) && (this.overloadList[_local_7].fxSid == _arg_3))){
                                        this.overloadList[_local_7].endCause = _arg_6;
                                        _local_10 = new UserFxOverloadEvent("onRemoveOverLoad");
                                        _local_10.uol = this.overloadList[_local_7];
                                        _local_10.walker = this;
                                        this.dispatchEvent(_local_10);
                                        this.overloadList[_local_7].dispose();
                                        this.overloadList.splice(_local_7, 1);
                                        break;
                                    };
                                    _local_7++;
                                };
                            };
                            this.updateOverloadCache();
                        }
                        else {
                            if (_arg_2 == 5){
                                _local_13 = new SkinAction();
                                _local_13.skinByte = _arg_1.bitReadUnsignedInt(32);
                                _local_13.delayed = _arg_1.bitReadBoolean();
                                _local_13.fxSid = _arg_3;
                                _local_13.newOne = _arg_5;
                                _local_13.activ = _arg_4;
                                _local_13.endCause = _arg_6;
                                _local_14 = _arg_1.bitReadBoolean();
                                if (_local_14){
                                    _local_13.data = _arg_1.bitReadBinaryData();
                                    _local_13.data.bitPosition = 0;
                                };
                                if (((skin) && ((_local_13.endCause == 1) || (skinByte == _local_13.skinByte)))){
                                    skin.onFxAction(_local_13);
                                }
                                else {
                                    if (((_local_13.delayed) && (_local_13.activ))){
                                        this._delayedAction.push(_local_13);
                                    }
                                    else {
                                        if (_local_13.delayed){
                                            _local_7 = 0;
                                            while (_local_7 < this._delayedAction.length) {
                                                if (this._delayedAction[_local_7].fxSid == _arg_3){
                                                    this._delayedAction.splice(_local_7, 1);
                                                    break;
                                                };
                                                _local_7++;
                                            };
                                        };
                                    };
                                };
                            }
                            else {
                                if (_arg_2 == 6){
                                    if (_arg_4){
                                        _local_15 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                                        _local_16 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
                                        _local_17 = null;
                                        if (_arg_1.bitReadBoolean()){
                                            _local_17 = _arg_1.bitReadBinaryData();
                                            _local_17.bitPosition = 0;
                                        };
                                        _local_18 = new FxUserObject();
                                        this._delayedUserObject.push(_local_18);
                                        _local_18.fxSid = _arg_3;
                                        _local_18.newOne = _arg_5;
                                        _local_18.fxFileId = _local_15;
                                        _local_18.objectId = _local_16;
                                        _local_18.data = _local_17;
                                        _local_18.addEventListener("onUserObjectLoaded", this.onUserObjectLoaded, false, 0, true);
                                        if (camera){
                                            _local_18.init();
                                        };
                                    }
                                    else {
                                        this.clearFxByIdSid(6, _arg_3, _arg_6);
                                        this.clearFxPersistentByIdSid(6, _arg_3, _arg_6);
                                    };
                                }
                                else {
                                    if (_arg_2 == 8){
                                        if (!camera){
                                            this._delayedCameraFx.push([_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6]);
                                        }
                                        else {
                                            camera.currentMap.onUserFxActivity(this, _arg_1, _arg_3, _arg_4, _arg_5);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function onUserObjectLoaded(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("onUserObjectLoaded", this.onUserObjectLoaded, false);
            _arg_1.currentTarget.fxManager.fxId = 6;
            _arg_1.currentTarget.fxManager.camera = camera;
            _arg_1.currentTarget.fxManager.walker = this;
            var _local_2:* = 0;
            while (_local_2 < this._delayedUserObject.length) {
                if (this._delayedUserObject[_local_2] == _arg_1.currentTarget){
                    this._delayedUserObject.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function readFXChange(_arg_1:Object):*{
            var _local_2:Boolean = _arg_1.bitReadBoolean();
            var _local_3:uint;
            if (!_local_2){
                _local_3 = _arg_1.bitReadUnsignedInt(2);
            };
            var _local_4:uint = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
            var _local_5:uint = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
            var _local_6:Binary = _arg_1.bitReadBinaryData();
            this.executeFXMessage(_local_6, _local_4, _local_5, _local_2, true, _local_3);
        }

        public function readFXMessageEffect(_arg_1:Object):*{
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:Binary;
            while (_arg_1.bitReadBoolean()) {
                _local_2 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                _local_3 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
                _local_4 = _arg_1.bitReadBinaryData();
                this.executeFXMessage(_local_4, _local_2, _local_3, true, false, 0);
            };
        }

        override public function get direction():Boolean{
            return ((this._firstDirection == 0) ? super.direction : this._overDirection.directionValue);
        }

        override public function set direction(_arg_1:Boolean):*{
            if (this._firstDirection == 0){
                super.direction = _arg_1;
            }
            else {
                this._firstDirection = ((Number(_arg_1) * 2) - 1);
            };
        }

        override public function get walkSpeed():Number{
            return (((this.shiftKey) ? 1 : this._overWalkSpeed.v) * super.walkSpeed);
        }

        override public function get jumpStrength():Number{
            return (((this.shiftKey) ? 1 : this._overJumpStrength.v) * super.jumpStrength);
        }

        override public function get gravity():Number{
            return (this._overGravity.v * super.gravity);
        }

        override public function get swimSpeed():Number{
            return (((this.shiftKey) ? 1 : this._overSwimSpeed.v) * super.swimSpeed);
        }

        override public function unloadSkin():*{
            if (skin){
                this._delayedAction.splice(this._delayedAction, this._delayedAction.length);
            };
            this.removeUnLight();
            super.unloadSkin();
            action = 0;
        }

        override public function onSkinReady(_arg_1:Event):*{
            var _local_2:SkinAction;
            super.onSkinReady(_arg_1);
            if (this._overHide == 1){
                skin.visible = false;
            };
            skin.walker = this;
            this.updateLightEffect();
            this.checkForUnlight();
            while (this._delayedAction.length) {
                _local_2 = this._delayedAction.shift();
                if (((_local_2.skinByte == skinByte) || (_local_2.endCause == 1))){
                    skin.onFxAction(_local_2);
                };
            };
            this.setFilter(null, 3);
        }

        override public function set camera(_arg_1:CameraMap):*{
            var _local_2:uint;
            var _local_3:Array;
            if (this.moveFx){
                this.moveFx.camera = _arg_1;
            };
            if (((!(_arg_1)) && (camera))){
                this.removeUnLight();
                this.clearFX();
            };
            super.camera = _arg_1;
            if (_arg_1){
                _local_3 = this._delayedUserObject.slice();
                _local_2 = 0;
                while (_local_2 < _local_3.length) {
                    _local_3[_local_2].init();
                    _local_2++;
                };
                if (UserFx(_arg_1.mainUser) == this){
                    _arg_1.floodPunished = this.floodPunished;
                };
                if (((accroche) && ((!(jumping == 0)) || (!(walking == 0))))){
                    startGrimpe();
                };
                if ((((onFloor) && (jumping <= 0)) && (!(walking == 0)))){
                    startWalk();
                };
                _local_2 = 0;
                while (_local_2 < this._delayedCameraFx.length) {
                    this.executeFXMessage(this._delayedCameraFx[_local_2][0], this._delayedCameraFx[_local_2][1], this._delayedCameraFx[_local_2][2], this._delayedCameraFx[_local_2][3], this._delayedCameraFx[_local_2][4], this._delayedCameraFx[_local_2][5]);
                    _local_2++;
                };
                this._delayedCameraFx.splice(0, this._delayedCameraFx.length);
            };
            this.checkForUnlight();
        }

        override public function set underWater(_arg_1:Boolean):void{
            var _local_2:Object;
            if (((((_arg_1) && (!(super.underWater))) && (this.peinture)) && (clientControled))){
                this.setPeinture(null);
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 2);
                Object(camera).blablaland.send(_local_2);
            };
            super.underWater = _arg_1;
        }

        public function get floodPunished():Boolean{
            return (this._floodPunished.v);
        }

        public function set floodPunished(_arg_1:Boolean):*{
            this._floodPunished = {"v":_arg_1};
            alpha = ((_arg_1) ? 0.5 : 1);
            if (camera){
                if (UserFx(camera.mainUser) == this){
                    camera.floodPunished = _arg_1;
                };
            };
        }

        public function setFilter(_arg_1:Object, _arg_2:uint=0, _arg_3:Array=null):*{
            var _local_4:uint;
            var _local_5:*;
            if (!_arg_3){
                _arg_3 = this._skinFilter;
            };
            if (_arg_2 == 0){
                _arg_3.push(_arg_1);
            }
            else {
                if (_arg_2 == 1){
                    _local_5 = false;
                    _local_4 = 0;
                    while (_local_4 < _arg_3.length) {
                        if (_arg_3[_local_4] == _arg_1){
                            _local_5 = true;
                            break;
                        };
                        _local_4++;
                    };
                    if (!_local_5){
                        _arg_3.push(_arg_1);
                    };
                }
                else {
                    if (_arg_2 == 2){
                        _local_4 = 0;
                        while (_local_4 < _arg_3.length) {
                            if (_arg_3[_local_4] == _arg_1){
                                _arg_3.splice(_local_4, 1);
                                _local_4--;
                            };
                            _local_4++;
                        };
                    }
                    else {
                        if (_arg_2 == 3){
                        };
                    };
                };
            };
            if (((_arg_3 == this._skinFilter) && (skin))){
                skin.filters = _arg_3;
            };
        }

        override public function screenStep():*{
            if (this.lightEffect){
                if (this._lightEffectFlip){
                    this.lightEffectSize = ((Math.random() * 8) + 6);
                    this.updateLightEffect();
                };
                this._lightEffectFlip = (!(this._lightEffectFlip));
            };
            super.screenStep();
        }

        public function updateLightEffect():*{
            if (skin){
                if (this.lightEffect){
                    if (this._lightFilter){
                        this._lightFilter.color = this.lightEffectColor;
                        this._lightFilter.blurX = (this._lightFilter.blurY = this.lightEffectSize);
                        this.setFilter(this._lightFilter, 3);
                    }
                    else {
                        this._lightFilter = new GlowFilter(this.lightEffectColor, 1, this.lightEffectSize, this.lightEffectSize, 2, 1);
                        this.setFilter(this._lightFilter, 0);
                    };
                }
                else {
                    if (((!(this.lightEffect)) && (this._lightFilter))){
                        this.setFilter(this._lightFilter, 2);
                        this._lightFilter = null;
                    };
                };
            };
        }

        public function get lightEffect():Boolean{
            return (this._lightEffect.v);
        }

        public function set lightEffect(_arg_1:Boolean):*{
            this._lightEffect = {"v":_arg_1};
            this.checkForUnlight();
            this.updateLightEffect();
        }

        public function get lightEffectColor():uint{
            return (this._lightEffectColor);
        }

        public function set lightEffectColor(_arg_1:uint):*{
            this._lightEffectColor = _arg_1;
            this.updateLightEffect();
        }

        override public function set walk(_arg_1:Number):void{
            this._firstWalk = _arg_1;
            if (this._overWalk == -2){
                super.walk = _arg_1;
            };
        }

        override public function get walk():Number{
            if (this._overWalk != -2){
                return (this._overWalk);
            };
            return (super.walk);
        }

        override public function set shiftKey(_arg_1:Boolean):void{
            this._firstShift = _arg_1;
            if (this._overShift == -2){
                super.shiftKey = _arg_1;
            };
        }

        override public function get shiftKey():Boolean{
            if (this._overShift != -2){
                return (this._overShift == 1);
            };
            return (super.shiftKey);
        }

        override public function set jump(_arg_1:int):void{
            this._firstJump = _arg_1;
            if (this._overJump == -2){
                super.jump = _arg_1;
            };
        }

        override public function get jump():int{
            if (this._overJump != -2){
                return (this._overJump);
            };
            return (super.jump);
        }

        override public function set skinColor(_arg_1:SkinColor):*{
            if (this._firstSkinColor){
                this._firstSkinColor = _arg_1;
            }
            else {
                super.skinColor = _arg_1;
            };
        }

        override public function get skinColor():SkinColor{
            return ((this._firstSkinColor) ? this._overSkinColor : super.skinColor);
        }

        public function get originalSkinColor():SkinColor{
            return ((this._firstSkinColor) ? this._firstSkinColor : super.skinColor);
        }

        override public function set skinAction(_arg_1:uint):*{
            if (this._overSkinAction){
                this._firstSkinAction = _arg_1;
            }
            else {
                super.skinAction = _arg_1;
            };
        }

        override public function get skinAction():uint{
            return ((this._overSkinAction) ? this._overSkinAction.skinActionValue : super.skinAction);
        }

        override public function set skinActionPriority(_arg_1:uint):*{
            if (this._overSkinAction){
                this._firstSkinActionPriority = _arg_1;
            }
            else {
                super.skinActionPriority = _arg_1;
            };
        }

        override public function get skinActionPriority():uint{
            return ((this._overSkinAction) ? this._overSkinAction.skinActionPriorityValue : super.skinActionPriority);
        }

        public function updateOverloadCache():*{
            var _local_13:SkinColor;
            var _local_14:Boolean;
            this.overloadList = this.overloadList.slice();
            this._overWalkSpeed = {"v":1};
            this._overSwimSpeed = {"v":1};
            this._overJumpStrength = {"v":1};
            this._overGravity = {"v":1};
            this._overHaveFoot = {"v":0};
            var _local_1:Number = this._overHide;
            this._overHide = -2;
            var _local_2:Number = this._overShift;
            this._overShift = -2;
            var _local_3:Number = this._overWalk;
            this._overWalk = -2;
            var _local_4:Number = this._overJump;
            this._overJump = -2;
            var _local_5:Number = this._overSkinScale;
            this._overSkinScale = 1;
            var _local_6:UserFxOverloadItem;
            var _local_7:UserFxOverloadItem = this._overSkinAction;
            this._overSkinAction = null;
            var _local_8:SkinColor = this._overSkinColor;
            this._overSkinColor = null;
            var _local_9:UserFxOverloadItem = this._overDirection;
            var _local_10:Boolean = super.direction;
            this._overDirection = null;
            var _local_11:int = -1;
            _subSkinOffset.x = (_subSkinOffset.y = 0);
            resetAcceleration();
            var _local_12:* = 0;
            while (_local_12 < this.overloadList.length) {
                if (this.overloadList[_local_12].type == 0){
                    if (this.overloadList[_local_12].walkSpeed){
                        this._overWalkSpeed = {"v":(this._overWalkSpeed.v + this.overloadList[_local_12].walkSpeedValue)};
                    };
                    if (this.overloadList[_local_12].swimSpeed){
                        this._overSwimSpeed = {"v":(this._overSwimSpeed.v + this.overloadList[_local_12].swimSpeedValue)};
                    };
                    if (this.overloadList[_local_12].jumpStrength){
                        this._overJumpStrength = {"v":(this._overJumpStrength.v + this.overloadList[_local_12].jumpStrengthValue)};
                    };
                    if (this.overloadList[_local_12].gravity){
                        this._overGravity = {"v":(this._overGravity.v + this.overloadList[_local_12].gravityValue)};
                    };
                    if (this.overloadList[_local_12].skinScale){
                        this._overSkinScale = (this._overSkinScale + this.overloadList[_local_12].skinScaleValue);
                    };
                    if (this.overloadList[_local_12].skinOffsetX){
                        _subSkinOffset.x = (_subSkinOffset.x + this.overloadList[_local_12].skinOffsetXValue);
                    };
                    if (this.overloadList[_local_12].skinOffsetY){
                        _subSkinOffset.y = (_subSkinOffset.y + this.overloadList[_local_12].skinOffsetYValue);
                    };
                }
                else {
                    if (this.overloadList[_local_12].type == 1){
                        if (this.overloadList[_local_12].walkSpeed){
                            this._overWalkSpeed = {"v":(this._overWalkSpeed.v * this.overloadList[_local_12].walkSpeedValue)};
                        };
                        if (this.overloadList[_local_12].swimSpeed){
                            this._overSwimSpeed = {"v":(this._overSwimSpeed.v * this.overloadList[_local_12].swimSpeedValue)};
                        };
                        if (this.overloadList[_local_12].jumpStrength){
                            this._overJumpStrength = {"v":(this._overJumpStrength.v * this.overloadList[_local_12].jumpStrengthValue)};
                        };
                        if (this.overloadList[_local_12].gravity){
                            this._overGravity = {"v":(this._overGravity.v * this.overloadList[_local_12].gravityValue)};
                        };
                        if (this.overloadList[_local_12].skinScale){
                            this._overSkinScale = (this._overSkinScale * this.overloadList[_local_12].skinScaleValue);
                        };
                    }
                    else {
                        if (this.overloadList[_local_12].type == 2){
                            if (this.overloadList[_local_12].walkSpeed){
                                this._overWalkSpeed = {"v":this.overloadList[_local_12].walkSpeedValue};
                            };
                            if (this.overloadList[_local_12].swimSpeed){
                                this._overSwimSpeed = {"v":this.overloadList[_local_12].swimSpeedValue};
                            };
                            if (this.overloadList[_local_12].jumpStrength){
                                this._overJumpStrength = {"v":this.overloadList[_local_12].jumpStrengthValue};
                            };
                            if (this.overloadList[_local_12].gravity){
                                this._overGravity = {"v":this.overloadList[_local_12].gravityValue};
                            };
                            if (this.overloadList[_local_12].skinScale){
                                this._overSkinScale = this.overloadList[_local_12].skinScaleValue;
                            };
                            if (this.overloadList[_local_12].skinOffsetX){
                                _subSkinOffset.x = this.overloadList[_local_12].skinOffsetXValue;
                            };
                            if (this.overloadList[_local_12].skinOffsetY){
                                _subSkinOffset.y = this.overloadList[_local_12].skinOffsetYValue;
                            };
                        };
                    };
                };
                if (this.overloadList[_local_12].hideSkin){
                    this._overHide = Number(this.overloadList[_local_12].hideSkinValue);
                };
                if (this.overloadList[_local_12].shift){
                    this._overShift = Number(this.overloadList[_local_12].shiftValue);
                };
                if (this.overloadList[_local_12].walk){
                    this._overWalk = this.overloadList[_local_12].walkValue;
                };
                if (this.overloadList[_local_12].jump){
                    this._overJump = this.overloadList[_local_12].jumpValue;
                };
                if (this.overloadList[_local_12].skinAction){
                    this._overSkinAction = this.overloadList[_local_12];
                };
                if (this.overloadList[_local_12].haveFoot){
                    this._overHaveFoot = {"v":((this.overloadList[_local_12].haveFootValue) ? 2 : 1)};
                };
                if (this.overloadList[_local_12].floorNormalAccel){
                    floorNormalAccel = this.overloadList[_local_12].floorNormalAccelValue;
                };
                if (this.overloadList[_local_12].floorAccel){
                    floorAccel = this.overloadList[_local_12].floorAccelValue;
                };
                if (this.overloadList[_local_12].floorAccelFactor){
                    floorAccelFactor = this.overloadList[_local_12].floorAccelFactorValue;
                };
                if (this.overloadList[_local_12].floorDecel){
                    floorDecel = this.overloadList[_local_12].floorDecelValue;
                };
                if (this.overloadList[_local_12].floorDecelFactor){
                    floorDecelFactor = this.overloadList[_local_12].floorDecelFactorValue;
                };
                if (this.overloadList[_local_12].flyAccel){
                    flyAccel = this.overloadList[_local_12].flyAccelValue;
                };
                if (this.overloadList[_local_12].flyAccelFactor){
                    flyAccelFactor = this.overloadList[_local_12].flyAccelFactorValue;
                };
                if (this.overloadList[_local_12].flyDecel){
                    flyDecel = this.overloadList[_local_12].flyDecelValue;
                };
                if (this.overloadList[_local_12].flyDecelFactor){
                    flyDecelFactor = this.overloadList[_local_12].flyDecelFactorValue;
                };
                if (this.overloadList[_local_12].pseudo){
                    _local_6 = this.overloadList[_local_12];
                };
                if (this.overloadList[_local_12].direction){
                    this._overDirection = this.overloadList[_local_12];
                };
                if (((this.overloadList[_local_12].skinColor) && (this.overloadList[_local_12].skinColorValue))){
                    this._overSkinColor = this.overloadList[_local_12].skinColorValue;
                };
                if (this.overloadList[_local_12].skinId){
                    if (this._firstSkinId.v < 0){
                        this._firstSkinId = {"v":skinId};
                    };
                    _local_11 = this.overloadList[_local_12].skinIdValue;
                };
                _local_12++;
            };
            this._overWalkSpeed = {"v":Math.max(Math.min(this._overWalkSpeed.v, 10), 0.2)};
            if (skin){
                if (((_local_1 == -2) && (!(this._overHide == -2)))){
                    skin.visible = (this._overHide == 0);
                }
                else {
                    if (((!(_local_1 == -2)) && (this._overHide == -2))){
                        skin.visible = true;
                    }
                    else {
                        if (_local_1 != this._overHide){
                            skin.visible = (this._overHide == 0);
                        };
                    };
                };
            };
            if (((_local_2 == -2) && (!(this._overShift == -2)))){
                super.shiftKey = (this._overShift == 1);
            }
            else {
                if (((!(_local_2 == -2)) && (this._overShift == -2))){
                    super.shiftKey = this._firstShift;
                }
                else {
                    if (_local_2 != this._overShift){
                        super.shiftKey = (this._overShift == 1);
                    };
                };
            };
            if (((_local_3 == -2) && (!(this._overWalk == -2)))){
                super.walk = this._overWalk;
            }
            else {
                if (((!(_local_3 == -2)) && (this._overWalk == -2))){
                    super.walk = this._firstWalk;
                }
                else {
                    if (_local_3 != this._overWalk){
                        super.walk = this._overWalk;
                    };
                };
            };
            if (((_local_4 == -2) && (!(this._overJump == -2)))){
                super.jump = this._overJump;
            }
            else {
                if (((!(_local_4 == -2)) && (this._overJump == -2))){
                    super.jump = this._firstJump;
                }
                else {
                    if (_local_4 != this._overJump){
                        super.jump = this._overJump;
                    };
                };
            };
            if (_local_5 != this._overSkinScale){
                skinScale = this._overSkinScale;
            };
            if (((_local_6) && (!(this.overPseudo)))){
                this.overPseudo = _local_6.duplicate();
            }
            else {
                if (((!(_local_6)) && (this.overPseudo))){
                    this.overPseudo = null;
                }
                else {
                    if (((_local_6) && (this.overPseudo))){
                        if (((!(_local_6.pseudoValue == this.overPseudo.pseudoValue)) || (!(_local_6.type == this.overPseudo.type)))){
                            this.overPseudo = _local_6.duplicate();
                        };
                    };
                };
            };
            if (((this._overSkinAction) && (!(_local_7)))){
                this._firstSkinAction = super.skinAction;
                this._firstSkinActionPriority = super.skinActionPriority;
                super.skinAction = this._overSkinAction.skinActionValue;
                super.skinActionPriority = this._overSkinAction.skinActionPriorityValue;
            }
            else {
                if (((!(this._overSkinAction)) && (_local_7))){
                    super.skinAction = this._firstSkinAction;
                    super.skinActionPriority = this._firstSkinActionPriority;
                    this._overSkinAction = null;
                }
                else {
                    if (_local_7 != this._overSkinAction){
                        super.skinAction = this._overSkinAction.skinActionValue;
                        super.skinActionPriority = this._overSkinAction.skinActionPriorityValue;
                    };
                };
            };
            if (((this._overSkinColor) && (!(_local_8)))){
                this._firstSkinColor = super.skinColor;
                updateSkinColor();
            }
            else {
                if (((!(this._overSkinColor)) && (_local_8))){
                    _local_13 = this._firstSkinColor;
                    this._firstSkinColor = null;
                    this.skinColor = _local_13;
                }
                else {
                    if (_local_8 != this._overSkinColor){
                        updateSkinColor();
                    };
                };
            };
            if (((this._overDirection) && (!(_local_9)))){
                this._firstDirection = ((Number(super.direction) * 2) - 1);
                super.direction = this._overDirection.directionValue;
            }
            else {
                if (((!(this._overDirection)) && (_local_9))){
                    _local_14 = (this._firstDirection == 1);
                    this._firstDirection = 0;
                    this.direction = _local_14;
                }
                else {
                    if (this._overDirection){
                        super.direction = this._overDirection.directionValue;
                    };
                };
            };
            if (((_local_11 < 0) && (this._firstSkinId.v >= 0))){
                skinId = this._firstSkinId.v;
                this._firstSkinId = {"v":-1};
            }
            else {
                if (_local_11 >= 0){
                    skinId = _local_11;
                };
            };
        }

        public function get originalSkinId():int{
            if (this._firstSkinId.v > 0){
                return (this._firstSkinId.v);
            };
            return (skinId);
        }

        public function set overPseudo(_arg_1:UserFxOverloadItem):*{
            this._overPseudo = _arg_1;
        }

        public function get overPseudo():UserFxOverloadItem{
            return (this._overPseudo);
        }

        public function checkForUnlight():*{
            if (((this._lightAdded) && (!(this._lightEffect.v)))){
                this.removeUnLight();
            }
            else {
                if (((!(this._lightAdded)) && (this._lightEffect.v))){
                    this.addUnLight();
                };
            };
        }

        public function addUnLight():*{
            var _local_1:LightEffectItem;
            if (((camera) && (skin))){
                if (camera.lightEffect){
                    _local_1 = camera.lightEffect.addItem(DisplayObject(skin));
                    _local_1.invertLight = true;
                    _local_1.redraw();
                    this._lightAdded = true;
                };
            };
        }

        public function removeUnLight():*{
            this._lightAdded = false;
            if (((camera) && (skin))){
                if (camera.lightEffect){
                    camera.lightEffect.removeItemByTarget(DisplayObject(skin));
                    skin.transform.colorTransform = new ColorTransform();
                };
            };
        }


    }
}//package fx

