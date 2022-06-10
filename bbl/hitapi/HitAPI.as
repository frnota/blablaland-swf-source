// version 467 by nota

//bbl.hitapi.HitAPI

package bbl.hitapi{
    import flash.geom.Point;
    import net.Binary;
    import engine.CollisionObject;
    import bbl.ExternalLoader;
    import flash.media.Sound;
    import flash.display.Sprite;
    import net.SocketMessage;
    import bbl.GlobalProperties;
    import flash.media.SoundTransform;
    import perso.User;
    import engine.DDpoint;
    import engine.Segment;
    import flash.events.Event;

    public class HitAPI {

        public static var pidCount:uint = 1;

        public var hitList:Array;
        public var hitId:uint;
        public var camera:Object;
        public var floodDuration:uint;
        public var hitSelf:Boolean;
        public var hitControled:HitData;
        public var fromUid:uint;
        public var fromFxId:uint;
        public var fromMapId:int;
        public var fromHitId:uint;
        public var walkerHitPush:Point;
        public var walkerHitSndClass:Class;
        public var walkerHitSndVolume:Number;
        public var walkerHitVisualClass:Class;
        public var serverFunction:Boolean;
        public var serverFunctionData:Binary;
        public var maxWalkerHit:int;
        public var visualDebug:uint;
        public var maxRayLength:uint;
        public var checkCollision:Boolean;
        public var checkCollisionCloud:Boolean;
        public var collisionData:CollisionObject;
        public var collisionHitSndClass:Class;
        public var collisionHitSndVolume:Number;
        public var collisionHitVisualClass:Class;
        private var externalLoader:ExternalLoader;

        public function HitAPI(){
            this.hitList = new Array();
            this.fromUid = 0;
            this.fromHitId = 0;
            this.fromFxId = 0;
            this.fromMapId = -1;
            this.maxWalkerHit = -1;
            this.hitSelf = false;
            this.walkerHitPush = new Point(0.1, -0.3);
            this.floodDuration = 5000;
            this.serverFunctionData = new Binary();
            this.visualDebug = 0;
            this.maxRayLength = 1200;
            this.checkCollision = true;
            this.checkCollisionCloud = false;
            this.collisionData = null;
            this.collisionHitSndClass = null;
            this.collisionHitSndVolume = 0.5;
            this.collisionHitVisualClass = null;
            this.externalLoader = new ExternalLoader();
            this.externalLoader.load();
            this.walkerHitSndClass = Class(this.externalLoader.getClass("HitCoupSnd"));
            this.walkerHitSndVolume = 0.4;
            this.walkerHitVisualClass = Class(this.externalLoader.getClass("HitImpact"));
            this.updateHitId();
        }

        public function updateHitId(_arg_1:int=-1):*{
            if (_arg_1 < 0){
                pidCount++;
                this.hitId = pidCount;
            }
            else {
                this.hitId = _arg_1;
            };
        }

        public function getUserShield(_arg_1:Object, _arg_2:int=0):Object{
            var _local_3:*;
            if (_arg_1.data.SHIELDLIST){
                _local_3 = 0;
                while (_local_3 < _arg_1.data.SHIELDLIST.length) {
                    if (_arg_1.data.SHIELDLIST[_local_3].getShieldType(_arg_2)){
                        return (_arg_1.data.SHIELDLIST[_local_3]);
                    };
                    _local_3++;
                };
            };
            return (null);
        }

        public function doHitList():*{
            var _local_1:int;
            var _local_2:Sound;
            var _local_3:Sprite;
            var _local_8:HitData;
            var _local_9:*;
            var _local_10:Boolean;
            var _local_11:Object;
            var _local_12:Boolean;
            var _local_13:Boolean;
            var _local_14:Boolean;
            var _local_15:Boolean;
            var _local_16:Boolean;
            var _local_17:Boolean;
            var _local_18:Point;
            var _local_19:SocketMessage;
            if (!this.hitList.length){
                return;
            };
            var _local_4:Boolean;
            var _local_5:Number = GlobalProperties.serverTime;
            var _local_6:HitData;
            var _local_7:* = ((this.camera.peace & 0x01) == 1);
            if (this.collisionData){
                if (this.collisionHitSndClass){
                    _local_2 = new this.collisionHitSndClass();
                    _local_2.play(0, 0, new SoundTransform((this.camera.quality.actionVolume * this.collisionHitSndVolume)));
                };
                if (this.collisionHitVisualClass){
                    this.collisionData.calculateNormal();
                    _local_3 = new this.collisionHitVisualClass();
                    _local_3.rotation = ((Math.atan2(this.collisionData.normal.y, this.collisionData.normal.x) * 180) / Math.PI);
                    _local_3.x = this.collisionData.colPoint.x;
                    _local_3.y = this.collisionData.colPoint.y;
                    this.camera.userContent.addChild(_local_3);
                };
            };
            _local_1 = 0;
            while (_local_1 < this.hitList.length) {
                _local_8 = this.hitList[_local_1];
                _local_9 = _local_8.walker;
                if (_local_9.clientControled){
                    _local_10 = this.camera.blablaland.isMuted(this.fromUid);
                    _local_11 = _local_9.data.WAROPEN;
                    _local_12 = ((_local_11) && (_local_11.dead));
                    _local_13 = ((_local_11) && (_local_11.waitStart));
                    if (((this.walkerHitPush) && (!(_local_12)))){
                        _local_18 = this.walkerHitPush.clone();
                        _local_18.x = (_local_18.x * ((_local_8.vector.x >= 0) ? 1 : -1));
                        if (((_local_8.shield) || ((((_local_9.dodo) || (_local_7)) || (_local_10)) && (!(_local_11))))){
                            _local_18.x = 0;
                            _local_18.y = 0;
                        };
                        if (!_local_11){
                            _local_18.x = 0;
                        };
                        if (((!(_local_18.x == 0)) || (!(_local_18.y == 0)))){
                            if (_local_9.onFloor){
                                _local_9.speed.y = _local_18.y;
                                _local_9.speed.x = _local_18.x;
                                _local_9.onFloor = false;
                            }
                            else {
                                _local_9.speed.y = (_local_9.speed.y + _local_18.y);
                                _local_9.speed.x = (_local_9.speed.x + _local_18.x);
                            };
                            _local_9.accroche = false;
                            this.camera.sendMainUserState();
                        };
                    };
                    _local_14 = (((this.fromUid) || (this.fromFxId)) || (this.fromMapId >= 0));
                    _local_15 = ((((!(_local_9.dodo)) && (!(_local_7))) && (!(_local_8.shield))) && (!(_local_10)));
                    _local_16 = ((_local_15) && ((!(_local_11)) || (this.serverFunction)));
                    _local_17 = (((_local_11) && (!(_local_12))) && (!(_local_13)));
                    if (((_local_14) && ((_local_16) || (_local_17)))){
                        _local_19 = new SocketMessage();
                        _local_19.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
                        _local_19.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 12);
                        _local_19.bitWriteUnsignedInt(4, 2);
                        _local_19.bitWriteUnsignedInt(10, _local_8.distance);
                        if (this.fromUid){
                            _local_19.bitWriteUnsignedInt(4, 1);
                            _local_19.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID, this.fromUid);
                        };
                        if (this.fromFxId){
                            _local_19.bitWriteUnsignedInt(4, 2);
                            _local_19.bitWriteUnsignedInt(GlobalProperties.BIT_FX_ID, this.fromFxId);
                        };
                        if (this.fromMapId >= 0){
                            _local_19.bitWriteUnsignedInt(4, 3);
                            _local_19.bitWriteUnsignedInt(GlobalProperties.BIT_MAP_ID, this.fromMapId);
                        };
                        if (this.fromHitId){
                            _local_19.bitWriteUnsignedInt(4, 4);
                            _local_19.bitWriteUnsignedInt(3, this.fromHitId);
                        };
                        if (this.serverFunctionData.bitLength){
                            _local_19.bitWriteUnsignedInt(4, 5);
                            _local_19.bitWriteBinaryData(this.serverFunctionData);
                        };
                        this.camera.blablaland.send(_local_19);
                    };
                };
                if (_local_8.shield){
                    _local_8.shield.hitShield();
                }
                else {
                    if (((!(_local_4)) && (this.walkerHitSndClass))){
                        _local_2 = new this.walkerHitSndClass();
                        _local_2.play(0, 0, new SoundTransform((this.camera.quality.actionVolume * this.walkerHitSndVolume)));
                        _local_4 = true;
                    };
                    if (this.walkerHitVisualClass){
                        _local_3 = new this.walkerHitVisualClass();
                        _local_3.x = _local_8.impactPoint.x;
                        _local_3.y = _local_8.impactPoint.y;
                        _local_9.parent.addChild(_local_3);
                    };
                };
                this.addHitFlood(_local_9, _local_5);
                _local_1++;
            };
        }

        public function getWalkerDirectionVector(_arg_1:User, _arg_2:Point):Point{
            var _local_3:Point = _arg_2.clone();
            if (!_arg_1.direction){
                _local_3.x = (_local_3.x * -1);
            };
            return (_local_3);
        }

        public function getWalkerPoint(_arg_1:User, _arg_2:Point):Point{
            var _local_3:Point = _arg_2.clone();
            _local_3 = this.getWalkerDirectionVector(_arg_1, _local_3);
            _local_3.x = (_local_3.x * _arg_1.skinScale);
            _local_3.y = (_local_3.y * _arg_1.skinScale);
            _local_3.x = (_local_3.x + _arg_1.position.x);
            _local_3.y = (_local_3.y + _arg_1.position.y);
            return (_local_3);
        }

        public function getWalkerHitDataByPoint(_arg_1:User, _arg_2:Point, _arg_3:uint=4):HitData{
            var _local_4:Point = new Point();
            var _local_5:Number = this.getWalkerCenterRadius(_arg_1, _local_4);
            if (this.visualDebug){
                this.showDebugByPoint(_local_4, _local_5, 0.7, 0xFF);
            };
            var _local_6:Number = Point.distance(_local_4, _arg_2);
            var _local_7:HitData;
            if (((_local_6 <= (_arg_3 + _local_5)) && ((this.hitSelf) || (!(this.fromUid == _arg_1.userId))))){
                _local_7 = new HitData();
                _local_7.walker = _arg_1;
                _local_7.walkerRadius = _local_5;
                _local_7.walkerPoint = _local_4;
                _local_7.hitRadius = _arg_3;
                _local_7.hitPoint = _arg_2;
                _local_7.distance = _local_6;
                _local_7.shield = this.getUserShield(_arg_1);
            };
            return (_local_7);
        }

        public function hitCameraByPoint(_arg_1:Point, _arg_2:uint=6):*{
            var _local_5:User;
            var _local_6:HitData;
            this.hitList = new Array();
            this.hitControled = null;
            if (this.visualDebug){
                this.showDebugByPoint(_arg_1, _arg_2, 0.7, 0xFF0000);
            };
            var _local_3:Number = GlobalProperties.serverTime;
            var _local_4:int;
            while (_local_4 < this.camera.userList.length) {
                _local_5 = this.camera.userList[_local_4];
                if ((((this.isWalkerFloodReady(_local_5, _local_3)) && (_local_5.parent)) && (!(_local_5.paused)))){
                    _local_6 = this.getWalkerHitDataByPoint(_local_5, _arg_1, _arg_2);
                    if (_local_5.clientControled){
                        this.hitControled = _local_6;
                    };
                    if (_local_6){
                        this.hitList.push(_local_6);
                    };
                };
                _local_4++;
            };
        }

        public function hitCameraByRay(_arg_1:Point, _arg_2:Point, _arg_3:uint=4):*{
            this.hitCameraBySegment(_arg_1, new Point((_arg_1.x + (_arg_2.x * this.maxRayLength)), (_arg_1.y + (_arg_2.y * this.maxRayLength))), _arg_3);
        }

        public function hitCameraBySegment(_arg_1:Point, _arg_2:Point, _arg_3:uint=4):*{
            var _local_9:User;
            var _local_10:Point;
            var _local_11:Number;
            var _local_12:DDpoint;
            var _local_13:Point;
            var _local_14:HitData;
            this.hitList = new Array();
            this.hitControled = null;
            var _local_4:Number = GlobalProperties.serverTime;
            var _local_5:Point;
            var _local_6:Segment = new Segment();
            _local_6.init();
            _local_6.ptA.x = _arg_1.x;
            _local_6.ptA.y = _arg_1.y;
            _local_6.ptB.x = _arg_2.x;
            _local_6.ptB.y = _arg_2.y;
            _local_6.lineCoef();
            this.collisionData = null;
            if (((this.checkCollision) && (this.camera.physic))){
                this.collisionData = this.camera.physic.getSurfaceCollision(_local_6, (((this.checkCollisionCloud) && (_local_6.a >= 0)) ? this.camera.physic.cloudTile : null));
                if (this.collisionData){
                    _local_6.ptB.x = this.collisionData.colPoint.x;
                    _local_6.ptB.y = this.collisionData.colPoint.y;
                    _local_6.lineCoef();
                };
            };
            if (this.visualDebug){
                this.showDebugBySegment(new Point(_local_6.ptA.x, _local_6.ptA.y), new Point(_local_6.ptB.x, _local_6.ptB.y), _arg_3);
            };
            var _local_7:int;
            if (this.maxWalkerHit == -1){
                _local_7 = -99999;
            };
            var _local_8:int;
            while (((_local_7 < this.maxWalkerHit) && (_local_8 < this.camera.userList.length))) {
                _local_9 = this.camera.userList[_local_8];
                if ((((this.isWalkerFloodReady(_local_9, _local_4)) && (_local_9.parent)) && (!(_local_9.paused)))){
                    _local_10 = new Point();
                    _local_11 = this.getWalkerCenterRadius(_local_9, _local_10);
                    _local_12 = _local_6.orthoProjection(_local_10.x, _local_10.y);
                    if (_local_6.pointIsInSegment(_local_12.x, _local_12.y)){
                        _local_13 = new Point(_local_12.x, _local_12.y);
                        _local_14 = this.getWalkerHitDataByPoint(_local_9, _local_13, _arg_3);
                        if (_local_14){
                            if (!_local_5){
                                _local_5 = new Point((_arg_2.x - _arg_1.x), (_arg_2.y - _arg_1.y));
                                _local_5.normalize(1);
                            };
                            _local_14.vector = _local_5;
                            _local_7++;
                            if (_local_9.clientControled){
                                this.hitControled = _local_14;
                            };
                            this.hitList.push(_local_14);
                        };
                    };
                };
                _local_8++;
            };
        }

        private function isWalkerFloodReady(_arg_1:User, _arg_2:Number):Boolean{
            return (this.getWalkerLastHit(_arg_1) < (_arg_2 - this.floodDuration));
        }

        private function getWalkerLastHit(_arg_1:User):Number{
            var _local_2:Number = 0;
            var _local_3:Object = _arg_1.data["HITAPI"];
            if (((_local_3) && (_local_3[("ID_" + this.hitId)]))){
                _local_2 = _local_3[("ID_" + this.hitId)];
            };
            return (_local_2);
        }

        private function addHitFlood(_arg_1:User, _arg_2:Number):*{
            var _local_4:*;
            var _local_3:* = _arg_1.data["HITAPI"];
            if (!_local_3){
                _local_3 = new Object();
                _local_3.lastClear = _arg_2;
                _arg_1.data["HITAPI"] = _local_3;
            }
            else {
                if (((_arg_1.clientControled) && (_local_3.lastClear < (_arg_2 - 300000)))){
                    for (_local_4 in _local_3) {
                        if (_local_3[_local_4] < (_arg_2 - 30000)){
                            delete _local_3[_local_4];
                        };
                    };
                    _local_3.lastClear = _arg_2;
                };
            };
            _local_3[("ID_" + this.hitId)] = _arg_2;
        }

        private function getWalkerCenterRadius(_arg_1:User, _arg_2:Point):Number{
            var _local_3:Number = (_arg_1.skinPhysicHeight / 2);
            _arg_2.x = _arg_1.position.x;
            _arg_2.y = (_arg_1.position.y - _local_3);
            return (_local_3 + 2);
        }

        private function showDebugBySegment(_arg_1:Point, _arg_2:Point, _arg_3:int, _arg_4:Number=0.3, _arg_5:Number=0xFFFF00):*{
            var _local_6:Sprite = new Sprite();
            _local_6.name = GlobalProperties.serverTime.toString();
            _local_6.addEventListener("enterFrame", this.debugEnterFrameEvt);
            this.camera.userContent.addChild(_local_6);
            _local_6.graphics.lineStyle((_arg_3 * 2), _arg_5, _arg_4);
            _local_6.graphics.moveTo(_arg_1.x, _arg_1.y);
            _local_6.graphics.lineTo(_arg_2.x, _arg_2.y);
        }

        private function showDebugByPoint(_arg_1:Point, _arg_2:int, _arg_3:Number=0.6, _arg_4:Number=0xFF0000):*{
            var _local_5:Sprite = new Sprite();
            _local_5.name = GlobalProperties.serverTime.toString();
            _local_5.addEventListener("enterFrame", this.debugEnterFrameEvt);
            this.camera.userContent.addChild(_local_5);
            _local_5.graphics.lineStyle(2, _arg_4, _arg_3);
            _local_5.graphics.drawCircle(_arg_1.x, _arg_1.y, _arg_2);
        }

        public function debugEnterFrameEvt(_arg_1:Event):*{
            var _local_2:Number = GlobalProperties.serverTime;
            var _local_3:Sprite = Sprite(_arg_1.currentTarget);
            if (Number(_local_3.name) < (_local_2 - this.visualDebug)){
                _local_3.removeEventListener("enterFrame", this.debugEnterFrameEvt);
                if (_local_3.parent){
                    _local_3.parent.removeChild(_local_3);
                };
            };
        }


    }
}//package bbl.hitapi

