// version 467 by nota

//fx.MapFx

package fx{
    import map.MapSndEnvironnement;
    import flash.display.MovieClip;
    import perso.User;
    import map.EarthQuakeItem;
    import net.Binary;
    import bbl.GlobalProperties;
    import flash.events.Event;

    public class MapFx extends MapSndEnvironnement {

        public var fxLoader:FxLoader;
        public var fxMemory:Array;
        private var _delayedUserObject:Array;

        public function MapFx(){
            this._delayedUserObject = new Array();
            this.fxLoader = new FxLoader();
            this.fxMemory = new Array();
        }

        public function getLoadedFX(_arg_1:uint):Object{
            var _local_3:*;
            var _local_2:FxLoaderItem = this.fxLoader.loadFx(_arg_1);
            if (_local_2){
                _local_3 = new _local_2.classRef();
                _local_3.camera = this;
                return (_local_3);
            };
            return (null);
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

        public function fxClear():*{
            var _local_1:Object;
            while (this.fxMemory.length) {
                _local_1 = this.fxMemory.shift();
                _local_1.endCause = 0;
                _local_1.dispose();
            };
            this.fxMemory = new Array();
        }

        override public function dispose():*{
            this.fxClear();
            super.dispose();
        }

        override public function unloadMap():*{
            var _local_1:FxUserObject;
            while (this._delayedUserObject.length) {
                _local_1 = this._delayedUserObject.pop();
                _local_1.dispose();
            };
            this._delayedUserObject = new Array();
            this.fxClear();
            super.unloadMap();
        }

        public function waterFx(_arg_1:Number, _arg_2:Number, _arg_3:Object=null):*{
            var _local_4:Object = this.getLoadedFX(0);
            if (_local_4){
                _local_4.PloofEffect(_arg_1, _arg_2, _arg_3);
            };
        }

        public function getUserShield(_arg_1:Object):Object{
            var _local_2:*;
            if (_arg_1.data.SHIELDLIST){
                _arg_1.data.SHIELDLIST = _arg_1.data.SHIELDLIST.slice();
                _local_2 = 0;
                while (_local_2 < _arg_1.data.SHIELDLIST.length) {
                    if (_arg_1.data.SHIELDLIST[_local_2].getShieldType(2)){
                        return (_arg_1.data.SHIELDLIST[_local_2]);
                    };
                    _local_2++;
                };
            };
            return (null);
        }

        public function executeFXMessage(_arg_1:Object, _arg_2:uint, _arg_3:uint, _arg_4:Boolean, _arg_5:Boolean, _arg_6:uint):*{
            var _local_7:uint;
            var _local_8:uint;
            var _local_9:Object;
            var _local_10:uint;
            var _local_11:uint;
            var _local_12:uint;
            var _local_13:uint;
            var _local_14:uint;
            var _local_15:String;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Object;
            var _local_19:Boolean;
            var _local_20:MovieClip;
            var _local_21:User;
            var _local_22:Object;
            var _local_23:EarthQuakeItem;
            var _local_24:Binary;
            var _local_25:FxUserObject;
            if (_arg_2 == 1){
                if (_arg_4){
                    _local_7 = _arg_1.bitReadSignedInt(17);
                    _local_8 = _arg_1.bitReadSignedInt(17);
                    _local_14 = _arg_1.bitReadUnsignedInt(8);
                    _local_15 = _arg_1.bitReadString();
                    _local_9 = this.getLoadedFX(0);
                    if (_local_9){
                        _local_9.addDie(_arg_3, _local_7, _local_8, _local_14, _local_15);
                        this.fxMemory.push(_local_9);
                    };
                }
                else {
                    this.clearFxByIdSid(1, _arg_3, _arg_6);
                };
            }
            else {
                if (_arg_2 == 2){
                    _local_11 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                    _local_12 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                    _local_13 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_OID);
                    _local_7 = _arg_1.bitReadSignedInt(17);
                    _local_8 = _arg_1.bitReadSignedInt(17);
                    _local_16 = (_arg_1.bitReadSignedInt(17) / 10000);
                    _local_17 = (_arg_1.bitReadSignedInt(17) / 10000);
                    _local_9 = this.getLoadedFX(_local_12);
                    if (_local_9){
                        _local_18 = _local_9.addFlyingObject(_local_13);
                        _local_9.fxSid = (_local_18.fxSid = _arg_3);
                        _local_18.senderPid = _local_11;
                        _local_18.objectId = _local_13;
                        _local_18.position.x = _local_7;
                        _local_18.position.y = _local_8;
                        _local_18.speed.x = _local_16;
                        _local_18.speed.y = _local_17;
                        this.fxMemory.push(_local_9);
                    };
                }
                else {
                    if (_arg_2 == 3){
                        _local_11 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                        _local_12 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                        _local_13 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_OID);
                        _local_7 = _arg_1.bitReadSignedInt(17);
                        _local_8 = _arg_1.bitReadSignedInt(17);
                        _local_19 = _arg_1.bitReadBoolean();
                        _local_9 = this.getLoadedFX(_local_12);
                        if (_local_9){
                            if (!_local_19){
                                _local_21 = Object(this).getUserByPid(_local_11);
                                if (_local_21){
                                    _local_22 = this.getUserShield(_local_21);
                                    if (_local_22){
                                        _local_22.hitShield({
                                            "XPOS":_local_7,
                                            "YPOS":_local_8
                                        });
                                    };
                                };
                            };
                            _local_20 = _local_9.addImpactObject(_local_13);
                            _local_20.x = _local_7;
                            _local_20.y = _local_8;
                            userContent.addChild(_local_20);
                            this.clearFxByIdSid(2, _arg_3, _arg_6);
                        };
                    }
                    else {
                        if (_arg_2 == 4){
                            if (((mapFileId < 491) || (mapFileId > 496))){
                                _local_23 = earthQuake.addItem();
                                _local_23.startAt = (_arg_1.bitReadUnsignedInt(32) * 1000);
                                _local_23.amplitude = (_arg_1.bitReadUnsignedInt(8) / 100);
                                _local_23.duration = (_arg_1.bitReadUnsignedInt(8) * 1000);
                            };
                        }
                        else {
                            if (_arg_2 == 5){
                                if (_arg_4){
                                    _local_12 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_ID);
                                    _local_13 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_FX_SID);
                                    _local_24 = null;
                                    if (_arg_1.bitReadBoolean()){
                                        _local_24 = _arg_1.bitReadBinaryData();
                                        _local_24.bitPosition = 0;
                                    };
                                    _local_25 = new FxUserObject();
                                    this._delayedUserObject.push(_local_25);
                                    _local_25.fxSid = _arg_3;
                                    _local_25.newOne = _arg_5;
                                    _local_25.fxFileId = _local_12;
                                    _local_25.objectId = _local_13;
                                    _local_25.data = _local_24;
                                    _local_25.addEventListener("onUserObjectLoaded", this.onUserObjectLoaded, false, 0, true);
                                    _local_25.init();
                                }
                                else {
                                    this.clearFxByIdSid(5, _arg_3, _arg_6);
                                };
                            }
                            else {
                                if (_arg_2 == 6){
                                    currentMap.onMapFxActivity(_arg_1, _arg_3, _arg_4, _arg_5);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function onUserObjectLoaded(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("onUserObjectLoaded", this.onUserObjectLoaded, false);
            _arg_1.currentTarget.fxManager.fxId = 5;
            _arg_1.currentTarget.fxManager.camera = this;
            var _local_2:* = 0;
            while (_local_2 < this._delayedUserObject.length) {
                if (this._delayedUserObject[_local_2] == _arg_1.currentTarget){
                    this._delayedUserObject.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        override public function onQualitySoundChange(_arg_1:Event):*{
            earthQuake.volume = quality.ambiantVolume;
            super.onQualitySoundChange(_arg_1);
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


    }
}//package fx

