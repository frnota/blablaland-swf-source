// version 467 by nota

//perso.User

package perso{
    import utils.AntiFlood;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import bbl.CameraMap;
    import flash.utils.getTimer;

    public class User extends UserInteractiv {

        private var _currentTimerOffset:int;
        private var _newSurfaceBody:uint;
        private var antiMsgFlood:AntiFlood;
        public var lastDataTime:uint;
        public var useLockDataTime:Boolean;
        public var currentTimerNotSet:Boolean;

        public function User(){
            this.useLockDataTime = true;
            this._newSurfaceBody = 0;
            this._currentTimerOffset = 0;
            this.lastDataTime = 0;
            this.currentTimerNotSet = true;
            this.antiMsgFlood = new AntiFlood();
            this.antiMsgFlood.lostValue = (5 / 100);
        }

        override public function onSkinReady(_arg_1:Event):*{
            var _local_2:SkinLoader;
            var _local_3:Object;
            try {
                if (clientControled){
                    _local_2 = new SkinLoader();
                    _local_3 = _local_2.getSkinById(skinId);
                    GlobalProperties.mainApplication.onExternalFileLoaded(1, skinId, _local_3.skinByte);
                };
            }
            catch(err) {
            };
            super.onSkinReady(_arg_1);
        }

        public function receiveNewCurrentTimer(_arg_1:uint):*{
            if (((_arg_1 > this.currentTimer) || (this.currentTimerNotSet))){
                this.currentTimer = _arg_1;
            };
        }

        public function set currentTimer(_arg_1:uint):*{
            this._currentTimerOffset = (GlobalProperties.getTimer() - _arg_1);
            this.currentTimerNotSet = false;
        }

        public function get currentTimer():uint{
            return ((this.currentTimerNotSet) ? 0 : (GlobalProperties.getTimer() - this._currentTimerOffset));
        }

        override public function set camera(_arg_1:CameraMap):*{
            if (_arg_1){
                surfaceBody = _arg_1.physic.getCollisionBodyById(this._newSurfaceBody);
                this.setBodyPosition();
            };
            super.camera = _arg_1;
        }

        public function setBodyPosition():*{
            if (surfaceBody){
                position.x = (position.x + surfaceBody.position.x);
                position.y = (position.y + surfaceBody.position.y);
                x = Math.round(((position.x + skinOffset.x) + _subSkinOffset.x));
                y = Math.round(((position.y + skinOffset.y) + _subSkinOffset.y));
            };
        }

        override public function step():*{
            if (((!(clientControled)) && (this.useLockDataTime))){
                if (((!(jump == 0)) || (!(walk == 0)))){
                    if ((getTimer() - this.lastDataTime) > 1600){
                        walk = 0;
                        jump = 0;
                    };
                };
            };
            super.step();
        }

        public function readStateFromMessage(_arg_1:Object):*{
            if (this.antiMsgFlood.getValue() > 100){
                return;
            };
            this.antiMsgFlood.hit(5);
            jump = _arg_1.bitReadSignedInt(2);
            walk = _arg_1.bitReadSignedInt(2);
            shiftKey = _arg_1.bitReadBoolean();
            this.lastDataTime = getTimer();
            direction = _arg_1.bitReadBoolean();
            onFloor = _arg_1.bitReadBoolean();
            underWater = _arg_1.bitReadBoolean();
            grimpe = _arg_1.bitReadBoolean();
            accroche = _arg_1.bitReadBoolean();
            if (_arg_1.bitReadBoolean()){
                position.x = (_arg_1.bitReadSignedInt(21) / 100);
                position.y = (_arg_1.bitReadSignedInt(21) / 100);
                this._newSurfaceBody = _arg_1.bitReadUnsignedInt(8);
                if (camera){
                    surfaceBody = camera.physic.getCollisionBodyById(this._newSurfaceBody);
                    this.setBodyPosition();
                };
                speed.x = (_arg_1.bitReadSignedInt(18) / 10000);
                speed.y = (_arg_1.bitReadSignedInt(18) / 10000);
            };
            if (_arg_1.bitReadBoolean()){
                skinId = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
                skinColor.readBinaryColor(_arg_1);
                updateSkinColor();
                dodo = _arg_1.bitReadBoolean();
            };
            readFXMessageEffect(_arg_1);
        }

        public function exportStateToMessage(_arg_1:Object, _arg_2:Object=null):*{
            if (!_arg_2){
                _arg_2 = new Object();
            };
            if (_arg_2.SENDPOSITION === undefined){
                _arg_2.SENDPOSITION = true;
            };
            _arg_1.bitWriteSignedInt(2, jumping);
            _arg_1.bitWriteSignedInt(2, walking);
            _arg_1.bitWriteBoolean(shiftKey);
            _arg_1.bitWriteBoolean(direction);
            _arg_1.bitWriteBoolean(onFloor);
            _arg_1.bitWriteBoolean(underWater);
            _arg_1.bitWriteBoolean(grimpe);
            _arg_1.bitWriteBoolean(accroche);
            if (_arg_2.SENDPOSITION){
                _arg_1.bitWriteBoolean(true);
                if (_arg_2.POSITION){
                    _arg_1.bitWriteSignedInt(21, Math.round((_arg_2.POSITION.x * 100)));
                    _arg_1.bitWriteSignedInt(21, Math.round((_arg_2.POSITION.y * 100)));
                    _arg_1.bitWriteUnsignedInt(8, 0);
                }
                else {
                    if (surfaceBody){
                        _arg_1.bitWriteSignedInt(21, Math.round(((position.x - surfaceBody.position.x) * 100)));
                        _arg_1.bitWriteSignedInt(21, Math.round(((position.y - surfaceBody.position.y) * 100)));
                        _arg_1.bitWriteUnsignedInt(8, surfaceBody.id);
                    }
                    else {
                        _arg_1.bitWriteSignedInt(21, Math.round((position.x * 100)));
                        _arg_1.bitWriteSignedInt(21, Math.round((position.y * 100)));
                        _arg_1.bitWriteUnsignedInt(8, 0);
                    };
                };
                if (_arg_2.SPEED){
                    _arg_1.bitWriteSignedInt(18, Math.round((_arg_2.SPEED.x * 10000)));
                    _arg_1.bitWriteSignedInt(18, Math.round((_arg_2.SPEED.y * 10000)));
                }
                else {
                    _arg_1.bitWriteSignedInt(18, Math.round((speed.x * 10000)));
                    _arg_1.bitWriteSignedInt(18, Math.round((speed.y * 10000)));
                };
            }
            else {
                _arg_1.bitWriteBoolean(false);
            };
            if (_arg_2.SENDSKIN){
                _arg_1.bitWriteBoolean(true);
                skinColor.exportBinaryColor(_arg_1);
            }
            else {
                _arg_1.bitWriteBoolean(false);
            };
        }


    }
}//package perso

