package perso {
    import engine.DDpoint;
    import flash.geom.Point;
    import flash.utils.Timer;
    import engine.PhysicBody;
    import engine.Physic;
    import flash.events.Event;
    import engine.CollisionObject;
    import engine.Segment;
    import engine.PhysicBodyEvent;

    public class Walker extends SkinManager {

        public var data:Object;
        public var speed:DDpoint;
        public var skinOffset:DDpoint;
        public var clientControled:Boolean;
        public var isCertified:Boolean;
        public var _subSkinOffset:Point;
        private var _flyDecel:Object;
        private var _flyDecelFactor:Object;
        private var _flyAccel:Object;
        private var _flyAccelFactor:Object;
        private var _floorDecel:Object;
        private var _floorDecelFactor:Object;
        private var _floorAccel:Object;
        private var _floorAccelFactor:Object;
        public var walkTemp:int;
        private var _stepRate:Object;
        private var _accroche:Object;
        private var _shiftKey:Object;
        private var _jumping:Object;
        private var _jumpTemp:Object;
        private var _floorSlide:Object;
        private var _floorNormalAccel:Object;
        private var _gravity:Number;
        private var _walkSpeed:Object;
        private var _swimSpeed:Object;
        private var _jumpStrength:Object;
        private var _grimpeTimeOut:Timer;
        private var _surfaceBody:PhysicBody;
        private var _paused:Object;
        private var _physic:Physic;
        private var _walking:Object;
        private var processList:Array;
        private var _activity:Object;
        private var _dodo:Object;
        private var _walkSubStep:Number;
        private var _onFloor:Object;
        private var _floorColor:Object;
        private var _lastEnvironmentColor:Object;
        private var _underWater:Object;
        private var _grimpe:Object;
        private var _position:DDpoint;
        private var _skinAction:Object;
        private var _skinActionPriority:Object;
        private var _canAccroche:Object;
        private var _floorProcess:Boolean;
        private var _nextJump:uint;
        private var _nextWalk:uint;
        private var _stepCount:uint;
        private var _processing:Boolean;

        public function Walker(){
            this._subSkinOffset = new Point();
            this._shiftKey = {"v":false};
            this.isCertified = false;
            this._processing = false;
            this._nextJump = 0;
            this._nextWalk = 0;
            this._stepCount = 0;
            this._walkSubStep = 0;
            this._canAccroche = {"v":true};
            this.data = new Object();
            this._skinActionPriority = {"v":1};
            this._skinAction = {"v":0};
            this.skinOffset = new DDpoint();
            this.skinOffset.init();
            this.stepRate = 15;
            this.processList = new Array();
            this._paused = {"v":false};
            this._dodo = {"v":false};
            this.speed = new DDpoint();
            this.speed.init();
            this._position = new DDpoint();
            this.position.init();
            this._onFloor = {"v":false};
            this._walking = {"v":0};
            this.walkTemp = 0;
            this.floorSlide = 0;
            this.floorNormalAccel = 0;
            this.jumping = 0;
            this.jumpTemp = 0;
            this._underWater = {"v":false};
            this._grimpe = {"v":false};
            this._accroche = {"v":false};
            this.activity = true;
            this._lastEnvironmentColor = {"v":0};
            this._floorColor = {"v":0};
            this.clientControled = false;
            this._jumpStrength = {"v":1};
            this._walkSpeed = {"v":1};
            this._swimSpeed = {"v":1};
            this._gravity = 1;
            this.resetAcceleration();
            this._grimpeTimeOut = new Timer(15000);
            this._grimpeTimeOut.addEventListener("timer", this.onGrimpeTimeOut, false, 0, true);
        }

        public function screenStep():*{
            var _local_3:uint;
            var _local_1:uint = Math.round(((this.position.x + this.skinOffset.x) + this._subSkinOffset.x));
            var _local_2:uint = Math.round(((this.position.y + this.skinOffset.y) + this._subSkinOffset.y));
            if (_local_1 != x){
                x = _local_1;
            };
            if (_local_2 != y){
                y = _local_2;
            };
            if (!this.paused){
                if (this.walking != 0){
                    direction = (this.walking > 0);
                };
                if (((this._grimpe.v) && (this._accroche.v))){
                    _local_3 = (((!(this.walking == 0)) || (!(this.jumping == 0))) ? 21 : 20);
                }
                else {
                    if (this._underWater.v){
                        _local_3 = 30;
                    }
                    else {
                        if (this._onFloor.v){
                            if (this.walking != 0){
                                _local_3 = 1;
                            }
                            else {
                                if (this.dodo){
                                    _local_3 = 50;
                                }
                                else {
                                    _local_3 = 0;
                                };
                            };
                        }
                        else {
                            _local_3 = ((this.speed.y > 0) ? 11 : 10);
                        };
                    };
                };
                if (((this.skinAction) || (this.skinActionPriority))){
                    if ((((this.skinActionPriority & 0x01) == 1) && (_local_3 == 0))){
                        _local_3 = this.skinAction;
                    }
                    else {
                        if ((((this.skinActionPriority & 0x02) == 2) && (_local_3 == 1))){
                            _local_3 = this.skinAction;
                        }
                        else {
                            if ((((this.skinActionPriority & 0x04) == 4) && (_local_3 == 10))){
                                _local_3 = this.skinAction;
                            }
                            else {
                                if ((((this.skinActionPriority & 0x08) == 8) && (_local_3 == 11))){
                                    _local_3 = this.skinAction;
                                }
                                else {
                                    if ((((this.skinActionPriority & 0x10) == 16) && (_local_3 == 20))){
                                        _local_3 = this.skinAction;
                                    }
                                    else {
                                        if ((((this.skinActionPriority & 0x20) == 32) && (_local_3 == 21))){
                                            _local_3 = this.skinAction;
                                        }
                                        else {
                                            if ((((this.skinActionPriority & 0x40) == 64) && (_local_3 == 30))){
                                                _local_3 = this.skinAction;
                                            }
                                            else {
                                                if ((((this.skinActionPriority & 0x80) == 128) && (_local_3 == 50))){
                                                    _local_3 = this.skinAction;
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                action = _local_3;
            };
            super.step();
        }

        public function resetAcceleration():*{
            this.floorDecel = false;
            this.floorDecelFactor = 0.001;
            this.floorAccel = false;
            this.floorAccelFactor = 0.0004;
            this.flyDecel = true;
            this.flyDecelFactor = 0.002;
            this.flyAccel = true;
            this.flyAccelFactor = 0.0007;
        }

        override public function dispose():*{
            this._grimpeTimeOut.stop();
            this.surfaceBody = null;
            super.dispose();
        }

        override public function unloadSkin():*{
            super.unloadSkin();
            this.skinAction = 0;
            this.skinActionPriority = 1;
        }

        override public function step():*{
            var _local_1:uint;
            var _local_2:*;
            if (((this.activity) && (!(this.paused)))){
                this._stepCount++;
                this.processList = new Array();
                if (((this._grimpe.v) && (this._accroche.v))){
                    this.processList.push(3);
                }
                else {
                    if (this._underWater.v){
                        this.processList.push(2);
                    }
                    else {
                        if (this._onFloor.v){
                            this.processList.push(1);
                        }
                        else {
                            this.processList.push(0);
                        };
                    };
                };
                _local_1 = 0;
                this._floorProcess = false;
                while (((this.processList.length) && (_local_1 < 5))) {
                    _local_2 = this.processList.shift();
                    if (((_local_2 == 0) && (!(this._onFloor.v)))){
                        this.flyProcess();
                    };
                    if (((_local_2 == 1) && (this._onFloor.v))){
                        this.floorProcess();
                        this._floorProcess = true;
                    };
                    if (((_local_2 == 2) && (this._underWater.v))){
                        this.waterProcess();
                    };
                    if ((((_local_2 == 3) && (this._grimpe.v)) && (this._accroche.v))){
                        this.grimpeProcess();
                    };
                    this.checkEnvironmentColor();
                    _local_1++;
                };
                if ((((((((this._onFloor.v) && (this.walking == 0)) && (((!(this.floorAccel)) && (!(this.floorDecel))) || (this.speed.x == 0))) && (this.floorSlide == 0)) && (!(this.jump))) || ((((this._grimpe.v) && (this._accroche.v)) && (this.jumping == 0)) && (this.walking == 0))) && (!(this._underWater.v)))){
                    this.activity = false;
                };
                this.checkLimit();
            };
        }

        public function checkEnvironmentColor():*{
            var _local_1:Object;
            var _local_2:WalkerPhysicEvent;
            if (((this.physic) && (this.physic.environmentBodyList.length))){
                if (((((this.position.x >= 0) && (this.position.y >= 0)) && (this.position.x < this.physic.environmentBodyList[0].map.width)) && (this.position.y < this.physic.environmentBodyList[0].map.height))){
                    _local_1 = this.physic.getEnvironmentPixelData(this.position.x, this.position.y);
                    if (_local_1.pxl != this._lastEnvironmentColor.v){
                        _local_2 = WalkerPhysicEvent.getDefaultEvent(this, "environmentEvent");
                        _local_2.lastColor = this._lastEnvironmentColor.v;
                        _local_2.newColor = _local_1.pxl;
                        this._lastEnvironmentColor = {"v":_local_1.pxl};
                        this.dispatchEvent(_local_2);
                    };
                };
            };
        }

        public function checkLimit():*{
            if (((!(this.physic)) || (!(this.physic.environmentBodyList.length)))){
                return;
            };
            var _local_1:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this, "overLimit");
            if (((this.position.y < 0) || (this.position.y >= this.physic.environmentBodyList[0].map.height))){
                _local_1.eventType = 102;
            };
            if (((this.position.x < 0) || (this.position.x >= this.physic.environmentBodyList[0].map.width))){
                _local_1.eventType = 100;
            };
            if (_local_1.eventType){
                if (((!(this.onFloor)) && (!(this.accroche)))){
                    this.surfaceBody = null;
                };
                this.dispatchEvent(_local_1);
            };
        }

        internal function onGrimpeTimeOut(_arg_1:Event=null):*{
            this.accroche = false;
            this.speed.x = 0;
            this.speed.y = 0;
            dispatchEvent(new Event("onGrimpeTimeOut"));
        }

        internal function grimpeProcess():*{
            var _local_3:*;
            var _local_4:CollisionObject;
            var _local_5:CollisionObject;
            var _local_6:CollisionObject;
            var _local_7:Boolean;
            var _local_8:*;
            var _local_1:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
            var _local_2:Object = this._physic.getCollisionPixelData(Math.floor(this.position.x), Math.floor((this.position.y - this.skinPhysicHeight)));
            if (((_local_2.pxl) && (!(this.physic.cloudTile[_local_2.pxl])))){
                this.accroche = false;
                this.speed.x = 0;
                this.speed.y = 0;
                this._nextJump = (this._stepCount + (200 / this.stepRate));
            }
            else {
                _local_3 = 2;
                this.speed.x = ((this.walking * this.walkSpeed) / _local_3);
                this.speed.y = ((this.jumping * this.walkSpeed) / -(_local_3));
                _local_4 = this.calculateColliWith(this.position, this.speed, 0, ((this.speed.y <= 0) ? this.physic.cloudTile : null));
                _local_5 = this.calculateColliWith(this.position, this.speed, this.skinPhysicHeight, this.physic.cloudTile);
                _local_6 = this.getFirstCol([_local_4, _local_5]);
                if (_local_6){
                    this.position.x = (_local_6.lastPixel.x + 0.5);
                    this.position.y = ((_local_6.lastPixel.y + 0.5) + (this.position.y - _local_6.originalSegment.ptA.y));
                    _local_7 = true;
                    if (_local_6 == _local_4){
                        _local_4.calculateNormal();
                        _local_8 = Math.abs(((Math.atan2(_local_4.normal.x, _local_4.normal.y) * 180) / Math.PI));
                        if (((_local_8 >= 120) && (this.jumping < 1))){
                            this.speed.x = 0;
                            this.speed.y = 0;
                            this._floorColor = {"v":_local_6.color};
                            this.onFloorEngine = true;
                            this.surfaceBody = _local_4.collisionBody;
                            _local_7 = false;
                            _local_1.lastColor = 0;
                            _local_1.eventType = 10;
                            _local_1.colData = _local_6;
                            _local_1.newColor = _local_6.color;
                            this.dispatchEvent(_local_1);
                        };
                    };
                    if (_local_7){
                        this.walking = 0;
                        this.jumping = 0;
                    };
                }
                else {
                    this.position.x = (this.position.x + (this.speed.x * this.stepRate));
                    this.position.y = (this.position.y + (this.speed.y * this.stepRate));
                };
                if ((((this.walking == 0) && (!(this.walkTemp == 0))) || ((this.jumping == 0) && (!(this.jumpTemp == 0))))){
                    this.stopGrimpe();
                };
            };
        }

        internal function flyProcess(_arg_1:PhysicBody=null):*{
            var _local_2:WalkerPhysicEvent;
            var _local_3:CollisionObject;
            var _local_4:CollisionObject;
            var _local_5:CollisionObject;
            var _local_6:Number;
            var _local_7:Object;
            var _local_8:DDpoint;
            var _local_9:DDpoint;
            var _local_10:int;
            if (((((this._grimpe.v) && (this.jumping == 1)) && (this.canAccroche)) && (this._nextJump <= this._stepCount))){
                this.accroche = true;
                this.processList.push(3);
            }
            else {
                _local_2 = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
                if (this.speed.y < 0){
                    _local_7 = this._physic.getCollisionPixelData(Math.floor(this.position.x), Math.floor((this.position.y - this.skinPhysicHeight)));
                    if (_local_7.pxl){
                        if (!this.physic.cloudTile[_local_7.pxl]){
                            this.speed.y = 0;
                            this.jumping = 0;
                        };
                    };
                };
                if (_arg_1){
                    _local_8 = new DDpoint();
                    _local_8.init();
                    _local_8.x = (_arg_1.position.x - _arg_1.lastPosition.x);
                    _local_8.y = (_arg_1.position.y - _arg_1.lastPosition.y);
                    _local_9 = this.position.duplicate();
                    _local_9.x = (_local_9.x + _local_8.x);
                    _local_9.y = (_local_9.y + _local_8.y);
                    _local_8.x = (_local_8.x / -(this.stepRate));
                    _local_8.y = (_local_8.y / -(this.stepRate));
                    _local_3 = this.calculateColliWith(_local_9, _local_8, 0, ((_local_8.y < 0) ? this.physic.cloudTile : null), _arg_1);
                    _local_4 = this.calculateColliWith(_local_9, _local_8, this.skinPhysicHeight, ((_local_8.y < 0) ? this.physic.cloudTile : null), _arg_1);
                }
                else {
                    _local_10 = this.walking;
                    if (this._nextWalk > this._stepCount){
                        _local_10 = 0;
                    };
                    if ((((_local_10 == 1) && (this.speed.x <= this.walkSpeed)) || ((_local_10 == -1) && (this.speed.x >= -(this.walkSpeed))))){
                        if (this.flyAccel){
                            this.speed.x = (this.speed.x + ((_local_10 * this.flyAccelFactor) * this.stepRate));
                        }
                        else {
                            this.speed.x = (this.walkSpeed * _local_10);
                        };
                        if ((((_local_10 == 1) && (this.speed.x >= this.walkSpeed)) || ((_local_10 == -1) && (this.speed.x <= -(this.walkSpeed))))){
                            this.speed.x = (_local_10 * this.walkSpeed);
                        };
                    }
                    else {
                        if (this.flyDecel){
                            this.speed.x = (this.speed.x / (1 + (this.flyDecelFactor * this.stepRate)));
                        }
                        else {
                            this.speed.x = 0;
                        };
                    };
                    this.speed.y = (this.speed.y + (this.gravity * this.stepRate));
                    _local_3 = this.calculateColliWith(this.position, this.speed, 0, ((this.speed.y < 0) ? this.physic.cloudTile : null));
                    _local_4 = this.calculateColliWith(this.position, this.speed, this.skinPhysicHeight, this.physic.cloudTile);
                    this.position.x = (this.position.x + (this.speed.x * this.stepRate));
                    this.position.y = (this.position.y + (this.speed.y * this.stepRate));
                };
                _local_5 = this.getFirstCol([_local_3, _local_4]);
                if (((_local_5) && (_local_5 == _local_4))){
                    _local_2.lastColor = 0;
                    _local_2.newColor = _local_5.color;
                    _local_2.eventType = 20;
                    _local_2.colData = _local_5;
                    _local_5.calculateNormal();
                    _local_6 = Math.abs(((Math.atan2(_local_5.normal.x, _local_5.normal.y) * 180) / Math.PI));
                    if (_local_6 <= 90){
                        this.position.x = (_local_5.lastPixel.x + 0.5);
                        this.position.y = ((_local_5.lastPixel.y + 0.5) + this.skinPhysicHeight);
                        this.speed.x = (_local_5.normal.x * this.walkSpeed);
                        this.speed.y = (_local_5.normal.y * this.walkSpeed);
                        this._nextJump = (this._stepCount + (200 / this.stepRate));
                        this._nextWalk = (this._stepCount + (100 / this.stepRate));
                        if (_arg_1){
                            this.speed.x = (this.speed.x + _arg_1.speed.x);
                            this.speed.y = (this.speed.y + _arg_1.speed.y);
                        };
                        _local_2.newSpeed = this.speed.duplicate();
                        this.dispatchEvent(_local_2);
                    }
                    else {
                        if (_local_3){
                            _local_5 = _local_3;
                        };
                    };
                };
                if (((_local_5) && (_local_5 == _local_3))){
                    _local_2.lastColor = 0;
                    _local_2.newColor = _local_3.color;
                    _local_2.colData = _local_5;
                    _local_2.eventType = 21;
                    _local_3.calculateNormal();
                    _local_6 = Math.abs(((Math.atan2(_local_3.normal.x, _local_3.normal.y) * 180) / Math.PI));
                    this.position.x = (_local_3.lastPixel.x + 0.5);
                    this.position.y = (_local_3.lastPixel.y + 0.5);
                    if (((_local_6 >= 120) && (!(this._floorProcess)))){
                        _local_2.eventType = 10;
                        this.onFloorEngine = true;
                        this.surfaceBody = _local_5.collisionBody;
                        this._floorColor = {"v":_local_3.color};
                        this.processList.push(1);
                        this.speed.y = 0;
                    }
                    else {
                        if (((_local_6 >= 120) && (this._floorProcess))){
                            this.speed.x = 0;
                            this._nextWalk = (this._stepCount + (100 / this.stepRate));
                        }
                        else {
                            this._nextWalk = (this._stepCount + (100 / this.stepRate));
                            this.speed.x = ((_local_3.normal.x * this.walkSpeed) / 2);
                            this.speed.y = ((this.speed.y > 0) ? (_local_3.normal.y * this.walkSpeed) : 0);
                        };
                    };
                    _local_2.newSpeed = this.speed.duplicate();
                    this.dispatchEvent(_local_2);
                };
            };
        }

        internal function waterProcess():*{
            var _local_6:Object;
            var _local_1:* = 1.7;
            var _local_2:int = this.jumping;
            if (this._nextJump > this._stepCount){
                _local_2 = 0;
            };
            if (_local_2 == 1){
                _local_6 = this._physic.getCollisionPixelData(Math.floor(this.position.x), Math.floor((this.position.y - this.skinPhysicHeight)));
                if (((_local_6.pxl) && (!(this.physic.cloudTile[_local_6.pxl])))){
                    _local_2 = 0;
                    if (this.speed.y < 0){
                        this.speed.y = (0.01 * this.stepRate);
                    };
                };
            };
            if ((((this.walking == 1) && (this.speed.x < (this.swimSpeed / _local_1))) || ((this.walking == -1) && (this.speed.x > (-(this.swimSpeed) / _local_1))))){
                this.speed.x = (this.speed.x + (((this.stepRate * this.walking) * this.swimSpeed) / 820));
            };
            if ((((_local_2 == 1) && (this.speed.y < (this.swimSpeed / _local_1))) || ((_local_2 == -1) && (this.speed.y > (-(this.swimSpeed) / _local_1))))){
                this.speed.y = (this.speed.y - (((this.stepRate * _local_2) * this.swimSpeed) / 820));
            };
            this.speed.y = (this.speed.y + ((this.gravity / 30) * this.stepRate));
            this.speed.x = (this.speed.x / (1 + (0.003 * this.stepRate)));
            this.speed.y = (this.speed.y / (1 + (0.003 * this.stepRate)));
            var _local_3:CollisionObject = this.calculateColliWith(this.position, this.speed, 0, ((this.speed.y < 0) ? this.physic.cloudTile : null));
            var _local_4:CollisionObject = this.calculateColliWith(this.position, this.speed, Math.round(this.skinPhysicHeight), this.physic.cloudTile);
            var _local_5:CollisionObject = this.getFirstCol([_local_3, _local_4]);
            if (_local_5){
                this.position.x = (_local_5.lastPixel.x + 0.5);
                this.position.y = ((_local_5.lastPixel.y + 0.5) + ((_local_5 == _local_4) ? Math.round(this.skinPhysicHeight) : 0));
                if (((!(this.walking == 0)) || (!(_local_2 == 0)))){
                    _local_5.calculateNormal();
                    this.speed.x = (this.speed.x + (_local_5.normal.x / 12));
                    this.speed.y = (_local_5.normal.y / 12);
                }
                else {
                    this.speed.x = 0;
                    this.speed.y = -0.0001;
                };
            }
            else {
                this.position.x = (this.position.x + (this.speed.x * this.stepRate));
                this.position.y = (this.position.y + (this.speed.y * this.stepRate));
            };
        }

        internal function floorProcess():*{
            var _local_1:WalkerPhysicEvent;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:DDpoint;
            var _local_7:*;
            var _local_8:*;
            var _local_9:CollisionObject;
            var _local_10:DDpoint;
            var _local_11:Object;
            var _local_12:Object;
            var _local_13:int;
            var _local_14:Object;
            var _local_2:Boolean = true;
            if (((((this.jumping == 1) && (this._grimpe.v)) && (this.canAccroche)) && (this._nextJump <= this._stepCount))){
                _local_1 = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
                _local_1.newColor = 0;
                _local_1.eventType = 0;
                _local_1.lastColor = this._floorColor.v;
                this.accroche = true;
                _local_2 = false;
                this.processList.push(3);
            }
            else {
                if (((this.jumping == 1) && (this._nextJump <= this._stepCount))){
                    this._nextJump = (this._stepCount + (200 / this.stepRate));
                    _local_1 = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
                    _local_1.newColor = 0;
                    _local_1.eventType = 0;
                    _local_1.lastColor = this._floorColor.v;
                    this.speed.y = -(this.jumpStrength);
                    if (this.surfaceBody){
                        this.speed.x = (this.speed.x + this.surfaceBody.speed.x);
                        this.speed.y = (this.speed.y + this.surfaceBody.speed.y);
                    };
                    this.processList.push(0);
                    _local_2 = false;
                }
                else {
                    if ((((!(this.floorSlide == 0)) || (!((this.walkSpeed * this.walking) == 0))) || ((!(this.speed.x == 0)) && ((this.floorAccel) || (this.floorDecel))))){
                        _local_1 = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
                        _local_1.newColor = 0;
                        _local_1.eventType = 0;
                        _local_1.lastColor = this._floorColor.v;
                        _local_3 = (this.walkSpeed + 0.044);
                        if ((((this.walking == 1) && (this.speed.x <= _local_3)) || ((this.walking == -1) && (this.speed.x >= -(_local_3))))){
                            if (this.floorAccel){
                                this.speed.x = (this.speed.x + ((this.walking * this.floorAccelFactor) * this.stepRate));
                            }
                            else {
                                this.speed.x = (_local_3 * this.walking);
                            };
                            if ((((this.walking == 1) && (this.speed.x >= _local_3)) || ((this.walking == -1) && (this.speed.x <= -(_local_3))))){
                                this.speed.x = (this.walking * _local_3);
                            };
                        }
                        else {
                            if (this.floorDecel){
                                this.speed.x = (this.speed.x / (1 + (this.floorDecelFactor * this.stepRate)));
                                if (Math.abs(this.speed.x) < 0.001){
                                    this.speed.x = 0;
                                    this.speed.y = 0;
                                };
                            }
                            else {
                                this.speed.x = 0;
                            };
                        };
                        if ((((this.floorNormalAccel) && (this.floorAccel)) && (this.floorDecel))){
                            _local_10 = new DDpoint();
                            _local_10.y = this.position.y;
                            _local_10.x = (this.position.x - 3);
                            _local_11 = this.getVpixel(_local_10, 4, 4);
                            _local_10.x = (this.position.x + 3);
                            _local_12 = this.getVpixel(_local_10, 4, 4);
                            _local_13 = (_local_12.ypos - _local_11.ypos);
                            this.speed.x = (this.speed.x + ((((this.floorNormalAccel * this.gravity) * this.stepRate) * _local_13) / 10));
                        };
                        _local_4 = Math.abs(((this.speed.x + this.floorSlide) * this.stepRate));
                        _local_4 = (_local_4 + -(this._walkSubStep));
                        _local_5 = 0;
                        _local_6 = new DDpoint();
                        _local_7 = this._floorColor.v;
                        _local_6.init();
                        _local_6.x = this.position.x;
                        _local_6.y = this.position.y;
                        while (_local_4 > _local_5) {
                            _local_6.x = (_local_6.x + ((((this.speed.x + this.floorSlide) * this.stepRate) > 0) ? 1 : -1));
                            if (((_local_6.x < 0) || (_local_6.x >= this.physic.environmentBodyList[0].map.width))){
                                this.speed.y = ((_local_6.y - this.position.y) / this.stepRate);
                                break;
                            };
                            _local_14 = this.getVpixel(_local_6, 4, (((this.gravity * this.stepRate) * 2) + 2));
                            if (_local_14.pxl == null){
                                if (_local_14.dir == 1){
                                    if (this.surfaceBody){
                                        this.speed.x = (this.speed.x + this.surfaceBody.speed.x);
                                        this.speed.y = (this.speed.y + this.surfaceBody.speed.y);
                                    };
                                    _local_2 = false;
                                    this.processList.push(0);
                                }
                                else {
                                    _local_6.x = this.position.x;
                                    _local_6.y = this.position.y;
                                    this.speed.x = 0;
                                    this.speed.y = 0;
                                    this.walking = 0;
                                };
                                _local_5 = _local_4;
                            }
                            else {
                                _local_7 = _local_14.pxl;
                                _local_6.y = (Math.floor(_local_14.ypos) + 0.5);
                                this.surfaceBody = _local_14.body;
                                _local_5 = _local_6.getPointDistance(this.position);
                            };
                        };
                        this._walkSubStep = (_local_5 - _local_4);
                        if (_local_2){
                            this.speed.y = ((_local_6.y - this.position.y) / this.stepRate);
                            if (_local_7 != this._floorColor.v){
                                this._floorColor = {"v":_local_7};
                                _local_1.eventType = 30;
                                _local_1.newColor = _local_7;
                            }
                            else {
                                _local_1 = null;
                            };
                        };
                        _local_8 = new Segment();
                        _local_8.init();
                        _local_8.ptA.x = this.position.x;
                        _local_8.ptA.y = (this.position.y - this.skinPhysicHeight);
                        _local_8.ptB.x = _local_6.x;
                        _local_8.ptB.y = (_local_6.y - this.skinPhysicHeight);
                        _local_8.lineCoef();
                        _local_9 = this.physic.getSurfaceCollision(_local_8, this.physic.cloudTile);
                        if (_local_9){
                            this.speed.x = 0;
                            this.speed.y = 0;
                            this.walking = 0;
                        }
                        else {
                            this.position.x = _local_6.x;
                            this.position.y = _local_6.y;
                        };
                        if (((this.walking == 0) && (!(this.walkTemp == 0)))){
                            this.stopWalk();
                        };
                    }
                    else {
                        this.speed.x = 0;
                    };
                };
            };
            this.onFloorEngine = _local_2;
            if (!_local_2){
                this._walkSubStep = 0;
            };
            if (_local_1){
                _local_1.newSpeed = this.speed.duplicate();
                this.dispatchEvent(_local_1);
            };
        }

        public function onCollisionBodyMove(_arg_1:PhysicBodyEvent):*{
            if (((this.surfaceBody == _arg_1.body) && (this.onFloor))){
                this.position.x = (this.position.x + (_arg_1.body.position.x - _arg_1.body.lastPosition.x));
                this.position.y = (this.position.y + (_arg_1.body.position.y - _arg_1.body.lastPosition.y));
                this.speed.y = _arg_1.body.speed.y;
                this.activity = true;
            }
            else {
                if (!this.onFloor){
                    this.flyProcess(_arg_1.body);
                };
            };
        }

        public function onCollisionBodyChange(_arg_1:Event):*{
            if (((this.onFloor) && (!(_arg_1.currentTarget.solid)))){
                this.speed.x = _arg_1.currentTarget.speed.x;
                this.speed.y = _arg_1.currentTarget.speed.y;
                this.onFloorEngine = false;
            };
        }

        private function emitSTDEvent(_arg_1:int):*{
            var _local_2:WalkerPhysicEvent = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
            _local_2.eventType = _arg_1;
            _local_2.lastColor = this._floorColor.v;
            this.dispatchEvent(_local_2);
        }

        public function stopGrimpe():*{
            this.emitSTDEvent(51);
        }

        public function startGrimpe():*{
            this.emitSTDEvent(50);
        }

        public function stopSwim():*{
            this.emitSTDEvent(61);
        }

        public function startSwim():*{
            this.emitSTDEvent(60);
        }

        public function stopWalk():*{
            this.emitSTDEvent(41);
        }

        public function startWalk():*{
            this.emitSTDEvent(40);
        }

        private function getVpixel(_arg_1:DDpoint, _arg_2:Number, _arg_3:Number):Object{
            var _local_6:uint;
            var _local_7:Object;
            var _local_4:DDpoint = new DDpoint();
            _local_4.x = _arg_1.x;
            _local_4.y = _arg_1.y;
            var _local_5:Object = this.physic.getCollisionPixelData(_local_4.x, _local_4.y);
            if (_local_5.pxl != 0){
                _local_6 = 0;
                while (_local_6 < _arg_2) {
                    _local_4.y--;
                    _local_7 = _local_5;
                    _local_5 = this.physic.getCollisionPixelData(_local_4.x, _local_4.y);
                    if (_local_5.pxl == 0){
                        return ({
                            "pxl":_local_7.pxl,
                            "body":_local_7.body,
                            "ypos":_local_4.y,
                            "dir":-1
                        });
                    };
                    _local_6++;
                };
                return ({
                    "pxl":null,
                    "body":null,
                    "ypos":_local_4.y,
                    "dir":-1
                });
            };
            _local_6 = 0;
            while (_local_6 < _arg_3) {
                _local_4.y++;
                _local_5 = this.physic.getCollisionPixelData(_local_4.x, _local_4.y);
                if (_local_5.pxl != 0){
                    return ({
                        "pxl":_local_5.pxl,
                        "body":_local_5.body,
                        "ypos":(_local_4.y - 1),
                        "dir":1
                    });
                };
                _local_6++;
            };
            return ({
                "pxl":null,
                "body":null,
                "ypos":_local_4.y,
                "dir":1
            });
        }

        internal function getFirstCol(_arg_1:Array):CollisionObject{
            var _local_5:*;
            var _local_6:*;
            var _local_2:CollisionObject;
            var _local_3:Number = -1;
            var _local_4:* = 0;
            while (_local_4 < _arg_1.length) {
                if (_arg_1[_local_4]){
                    _local_5 = _arg_1[_local_4].lastPixel.duplicate();
                    _local_5.x = (_local_5.x + 0.5);
                    _local_5.y = (_local_5.y + 0.5);
                    _local_6 = _local_5.getPointDistance(_arg_1[_local_4].originalSegment.ptA);
                    if (((_local_6 < _local_3) || (_local_3 < 0))){
                        _local_3 = _local_6;
                        _local_2 = _arg_1[_local_4];
                    };
                };
                _local_4++;
            };
            return (_local_2);
        }

        private function setBounce(_arg_1:DDpoint, _arg_2:DDpoint, _arg_3:Number, _arg_4:Number):void{
            var _local_5:Number = ((_arg_1.x * _arg_2.y) + (_arg_1.y * -(_arg_2.x)));
            var _local_6:Number = ((_arg_1.x * _arg_2.x) + (_arg_1.y * _arg_2.y));
            _arg_1.x = (((_local_5 * _arg_2.y) * _arg_3) - ((_local_6 * _arg_2.x) * _arg_4));
            _arg_1.y = (((_local_5 * -(_arg_2.x)) * _arg_3) - ((_local_6 * _arg_2.y) * _arg_4));
        }

        internal function calculateColliWith(_arg_1:DDpoint, _arg_2:DDpoint, _arg_3:Number=0, _arg_4:Object=null, _arg_5:PhysicBody=null):CollisionObject{
            var _local_6:* = new Segment();
            _local_6.init();
            _local_6.ptA.x = _arg_1.x;
            _local_6.ptA.y = (_arg_1.y - _arg_3);
            _local_6.ptB.x = (_arg_1.x + (_arg_2.x * this.stepRate));
            _local_6.ptB.y = ((_arg_1.y + (_arg_2.y * this.stepRate)) - _arg_3);
            _local_6.lineCoef();
            if (_arg_5){
                return (this.physic.getSingleSurfaceCollision(_arg_5, _local_6, _arg_4));
            };
            return (this.physic.getSurfaceCollision(_local_6, _arg_4));
        }

        public function get surfaceBody():PhysicBody{
            return (this._surfaceBody);
        }

        public function set surfaceBody(_arg_1:PhysicBody):*{
            if (_arg_1 != this._surfaceBody){
                if (_arg_1){
                    _arg_1.addEventListener("onChangedState", this.onCollisionBodyChange, false, 0, true);
                }
                else {
                    this._surfaceBody.removeEventListener("onChangedState", this.onCollisionBodyChange, false);
                };
                this._surfaceBody = _arg_1;
            };
        }

        public function set underWater(_arg_1:Boolean):void{
            var _local_2:Boolean;
            var _local_3:Number;
            var _local_4:DDpoint;
            var _local_5:Number;
            if (_arg_1 != this._underWater.v){
                this._underWater = {"v":_arg_1};
                this.activity = true;
                _local_2 = this.onFloor;
                if (_arg_1){
                    this.accroche = false;
                    this.onFloorEngine = false;
                };
                if (_arg_1){
                    this.speed.x = (this.speed.x / 4);
                    this.speed.y = (this.speed.y / 4);
                    this._nextJump = (this._stepCount + (200 / this.stepRate));
                    if (_local_2){
                        this.speed.y = 0;
                    };
                }
                else {
                    _local_3 = (this.jumpStrength / 1.5);
                    _local_4 = this.speed.duplicate();
                    _local_4.normalize();
                    _local_5 = Math.min((1 - Math.cos(Math.atan2(this.speed.x, this.speed.y))), 1);
                    _local_5 = (((!(this.walking == 0)) || (!(this.jumping == 0))) ? _local_5 : 0);
                    this.speed.x = (((_local_4.x * _local_5) * _local_3) + ((1 - _local_5) * this.speed.x));
                    this.speed.y = (((_local_4.y * _local_5) * _local_3) + ((1 - _local_5) * this.speed.y));
                };
                if (((!(_arg_1)) && ((!(this.walking == 0)) || (!(this.jumping == 0))))){
                    this.stopSwim();
                }
                else {
                    if (((_arg_1) && ((!(this.walking == 0)) || (!(this.jumping == 0))))){
                        this.startSwim();
                    };
                };
            };
        }

        public function get underWater():Boolean{
            return (this._underWater.v);
        }

        private function set onFloorEngine(_arg_1:Boolean):void{
            this._processing = true;
            this.onFloor = _arg_1;
            this._processing = false;
        }

        public function set onFloor(_arg_1:Boolean):void{
            var _local_2:WalkerPhysicEvent;
            if (_arg_1 != this._onFloor.v){
                this._onFloor = {"v":_arg_1};
                this.activity = true;
                if (_arg_1){
                    this.accroche = false;
                    this.underWater = false;
                }
                else {
                    this.surfaceBody = null;
                };
                if (((!(_arg_1)) && ((!(this.walking == 0)) || (!(this.jumping == 0))))){
                    this.stopWalk();
                }
                else {
                    if (((_arg_1) && (!(this.walking == 0)))){
                        this.startWalk();
                    };
                };
                if (!this._processing){
                    _local_2 = WalkerPhysicEvent.getDefaultEvent(this, "floorEvent");
                    _local_2.newColor = 0;
                    _local_2.eventType = ((_arg_1) ? 10 : 0);
                    _local_2.lastColor = this._floorColor.v;
                    this._floorColor = {"v":0};
                    _local_2.newSpeed = this.speed.duplicate();
                    this.dispatchEvent(_local_2);
                };
            };
        }

        public function get onFloor():Boolean{
            return (this._onFloor.v);
        }

        public function set accroche(_arg_1:Boolean):void{
            if (_arg_1 != this._accroche.v){
                if (!_arg_1){
                    this._nextJump = (this._stepCount + (200 / this.stepRate));
                };
                this._accroche = {"v":_arg_1};
                this.activity = true;
                if (_arg_1){
                    this.onFloorEngine = false;
                    this.underWater = false;
                };
                if (((_arg_1) && (this.clientControled))){
                    this._grimpeTimeOut.reset();
                    this._grimpeTimeOut.start();
                };
                if (((!(_arg_1)) && (this.clientControled))){
                    this._grimpeTimeOut.reset();
                    this._grimpeTimeOut.stop();
                };
                if (((!(_arg_1)) && ((!(this.walking == 0)) || (!(this.jumping == 0))))){
                    this.stopGrimpe();
                }
                else {
                    if (((_arg_1) && ((!(this.walking == 0)) || (!(this.jumping == 0))))){
                        this.startGrimpe();
                    };
                };
            };
        }

        public function get accroche():Boolean{
            return (this._accroche.v);
        }

        public function set jump(_arg_1:int):void{
            var _local_2:uint;
            if (_arg_1 != this.jumpTemp){
                if (((this._accroche.v) && (this.walking == 0))){
                    if (((!(_arg_1 == 0)) && (this.jumpTemp == 0))){
                        this.startGrimpe();
                    }
                    else {
                        if (_arg_1 == 0){
                            this.stopGrimpe();
                        };
                    };
                };
                this.jumpTemp = _arg_1;
                this.walking = this.walkTemp;
                this.jumping = _arg_1;
                this.activity = true;
                if (this.walking != this.walkTemp){
                    _local_2 = this.walkTemp;
                    this.walkTemp = 2;
                    this.walk = _local_2;
                };
                if (((this._underWater.v) && (this.walking == 0))){
                    if (_arg_1 != 0){
                        this.startSwim();
                    }
                    else {
                        this.stopSwim();
                    };
                };
                if (((this.clientControled) && (this.accroche))){
                    this._grimpeTimeOut.reset();
                    this._grimpeTimeOut.start();
                };
            };
        }

        public function get jump():int{
            return (this.jumpTemp);
        }

        public function get shiftKey():Boolean{
            return (this._shiftKey.v);
        }

        public function set shiftKey(_arg_1:Boolean):void{
            this._shiftKey = {"v":_arg_1};
        }

        public function set grimpe(_arg_1:Boolean):void{
            if (_arg_1 != this._grimpe.v){
                this._grimpe = {"v":_arg_1};
                if (((!(_arg_1)) && (this._accroche.v))){
                    if (this.speed.x > 0){
                        this.speed.x = (this.walkSpeed / 1.5);
                    };
                    if (this.speed.x < 0){
                        this.speed.x = (-(this.walkSpeed) / 1.5);
                    };
                    if (this.speed.y > 0){
                        this.speed.y = (this.jumpStrength / 1.5);
                    };
                    if (this.speed.y < 0){
                        this.speed.y = (-(this.jumpStrength) / 1.5);
                    };
                    this.onFloorEngine = false;
                    if (Math.abs(((Math.atan2(this.speed.x, this.speed.y) * 180) / Math.PI)) < 60){
                        this.speed.y = (this.speed.y / 5);
                    };
                };
                this.accroche = false;
                this.activity = true;
            };
        }

        public function get grimpe():Boolean{
            return (this._grimpe.v);
        }

        public function set walk(_arg_1:Number):void{
            var _local_2:int;
            var _local_3:uint;
            if (_arg_1 != this.walkTemp){
                _local_2 = this.walkTemp;
                this.walkTemp = _arg_1;
                this.walking = _arg_1;
                this.activity = true;
                if (this.jumping != this.jumpTemp){
                    _local_3 = this.jumpTemp;
                    this.jumpTemp = 2;
                    this.jump = _local_3;
                };
                if (this._onFloor.v){
                    if (((!(_arg_1 == 0)) && (_local_2 == 0))){
                        this.startWalk();
                    }
                    else {
                        if (_arg_1 == 0){
                            this.stopWalk();
                        };
                    };
                };
                if (((this._accroche.v) && (this.jumping == 0))){
                    if (_arg_1 != 0){
                        this.startGrimpe();
                    }
                    else {
                        this.stopGrimpe();
                    };
                };
                if (((this._underWater.v) && (this.jumping == 0))){
                    if (_arg_1 != 0){
                        this.startSwim();
                    }
                    else {
                        this.stopSwim();
                    };
                };
                if (((this.clientControled) && (this.accroche))){
                    this._grimpeTimeOut.reset();
                    this._grimpeTimeOut.start();
                };
            };
        }

        public function get walk():Number{
            return (this.walkTemp);
        }

        public function set walking(_arg_1:Number):*{
            if (((_arg_1 == 0) && (this.walking))){
                if (this._onFloor.v){
                    this.stopWalk();
                };
                if (((this._accroche.v) && (!(this.jumping)))){
                    this.stopGrimpe();
                };
                if (((this._underWater.v) && (!(this.jumping)))){
                    this.stopSwim();
                };
            };
            this._walking = {"v":_arg_1};
        }

        public function get walking():Number{
            return (this._walking.v);
        }

        public function get physic():Physic{
            return (this._physic);
        }

        public function set physic(_arg_1:Physic):void{
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:Object;
            var _local_5:Boolean;
            this._physic = _arg_1;
            _arg_1.addEventListener("onCollisionBodyMove", this.onCollisionBodyMove, false, 0, true);
            if (this._physic){
                _local_2 = 50;
                _local_3 = 0;
                _local_4 = this._physic.getCollisionPixelData(Math.floor(this.position.x), Math.floor(this.position.y));
                this.checkEnvironmentColor();
                _local_3 = 1;
                while ((((_local_3 < _local_2) && (_local_4.pxl)) && (Math.round((this.position.y - _local_3)) >= 0))) {
                    _local_4 = this._physic.getCollisionPixelData(Math.floor(this.position.x), Math.floor((this.position.y - _local_3)));
                    if (!_local_4.pxl){
                        this.position.y = (Math.floor((this.position.y - _local_3)) + 0.5);
                    };
                    _local_3++;
                };
                _local_3 = 1;
                while ((((_local_3 < _local_2) && (_local_4.pxl)) && (Math.floor((this.position.x + _local_3)) < this.physic.environmentBodyList[0].map.width))) {
                    _local_4 = this._physic.getCollisionPixelData(Math.floor((this.position.x + _local_3)), Math.floor(this.position.y));
                    if (!_local_4.pxl){
                        this.position.x = (Math.floor((this.position.x + _local_3)) + 0.5);
                    };
                    _local_3++;
                };
                _local_3 = 1;
                while ((((_local_3 < _local_2) && (_local_4.pxl)) && (Math.floor((this.position.x - _local_3)) >= 0))) {
                    _local_4 = this._physic.getCollisionPixelData(Math.floor((this.position.x - _local_3)), Math.floor(this.position.y));
                    if (!_local_4.pxl){
                        this.position.x = (Math.floor((this.position.x - _local_3)) + 0.5);
                    };
                    _local_3++;
                };
                if (this.onFloor){
                    _local_5 = false;
                    _local_3 = 0;
                    while (_local_3 < 5) {
                        _local_4 = this._physic.getCollisionPixelData(Math.round(this.position.x), Math.round(((this.position.y + _local_3) + 1)));
                        if (_local_4.pxl){
                            this._floorColor = {"v":_local_4.pxl};
                            _local_5 = true;
                            break;
                        };
                        _local_3++;
                    };
                    if (!_local_5){
                        this.onFloor = false;
                    };
                };
            };
        }

        public function get position():DDpoint{
            return (this._position);
        }

        public function set position(_arg_1:DDpoint):void{
            this.position.x = _arg_1.x;
            this.position.y = _arg_1.y;
        }

        public function set stepRate(_arg_1:Number):*{
            this._stepRate = {"v":_arg_1};
        }

        public function get stepRate():Number{
            return (this._stepRate.v);
        }

        public function set activity(_arg_1:Boolean):*{
            this._activity = {"v":_arg_1};
        }

        public function get activity():Boolean{
            return (this._activity.v);
        }

        public function set floorNormalAccel(_arg_1:Number):*{
            this._floorNormalAccel = {"v":_arg_1};
        }

        public function get floorNormalAccel():Number{
            return (this._floorNormalAccel.v);
        }

        public function set floorSlide(_arg_1:Number):*{
            this._floorSlide = {"v":_arg_1};
        }

        public function get floorSlide():Number{
            return (this._floorSlide.v);
        }

        public function set jumping(_arg_1:int):*{
            this._jumping = {"v":_arg_1};
        }

        public function get jumping():int{
            return (this._jumping.v);
        }

        public function set jumpTemp(_arg_1:int):*{
            this._jumpTemp = {"v":_arg_1};
        }

        public function get jumpTemp():int{
            return (this._jumpTemp.v);
        }

        public function set dodo(_arg_1:Boolean):*{
            this._dodo = {"v":_arg_1};
        }

        public function get dodo():Boolean{
            return (this._dodo.v);
        }

        public function set paused(_arg_1:Boolean):*{
            if (((!(_arg_1)) && (this._paused.v))){
                this.activity = true;
            };
            this._paused = {"v":_arg_1};
        }

        public function get paused():Boolean{
            return (this._paused.v);
        }

        public function get floorColor():uint{
            return (this._floorColor.v);
        }

        public function set skinAction(_arg_1:uint):*{
            this._skinAction = {"v":_arg_1};
        }

        public function get skinAction():uint{
            return (this._skinAction.v);
        }

        public function set skinActionPriority(_arg_1:uint):*{
            this._skinActionPriority = {"v":_arg_1};
        }

        public function get skinActionPriority():uint{
            return (this._skinActionPriority.v);
        }

        public function set canAccroche(_arg_1:Boolean):*{
            if (!_arg_1){
                this.accroche = false;
            };
            this._canAccroche = {"v":_arg_1};
        }

        public function get canAccroche():Boolean{
            return (this._canAccroche.v);
        }

        public function set lastEnvironmentColor(_arg_1:Number):*{
            this._lastEnvironmentColor = {"v":_arg_1};
        }

        public function get lastEnvironmentColor():Number{
            return (this._lastEnvironmentColor.v);
        }

        public function set flyDecel(_arg_1:Boolean):*{
            this._flyDecel = {"v":_arg_1};
        }

        public function get flyDecel():Boolean{
            return (this._flyDecel.v);
        }

        public function set flyDecelFactor(_arg_1:Number):*{
            this._flyDecelFactor = {"v":_arg_1};
        }

        public function get flyDecelFactor():Number{
            return (this._flyDecelFactor.v);
        }

        public function set flyAccel(_arg_1:Boolean):*{
            this._flyAccel = {"v":_arg_1};
        }

        public function get flyAccel():Boolean{
            return (this._flyAccel.v);
        }

        public function set flyAccelFactor(_arg_1:Number):*{
            this._flyAccelFactor = {"v":_arg_1};
        }

        public function get flyAccelFactor():Number{
            return (this._flyAccelFactor.v);
        }

        public function set floorDecel(_arg_1:Boolean):*{
            this._floorDecel = {"v":_arg_1};
        }

        public function get floorDecel():Boolean{
            return (this._floorDecel.v);
        }

        public function set floorDecelFactor(_arg_1:Number):*{
            this._floorDecelFactor = {"v":_arg_1};
        }

        public function get floorDecelFactor():Number{
            return (this._floorDecelFactor.v);
        }

        public function set floorAccel(_arg_1:Boolean):*{
            this._floorAccel = {"v":_arg_1};
        }

        public function get floorAccel():Boolean{
            return (this._floorAccel.v);
        }

        public function set floorAccelFactor(_arg_1:Number):*{
            this._floorAccelFactor = {"v":_arg_1};
        }

        public function get floorAccelFactor():Number{
            return (this._floorAccelFactor.v);
        }

        public function get skinPhysicHeight():Number{
            var _local_1:Number = 25;
            if (this._physic){
                _local_1 = ((this.underWater) ? this._physic.skinWaterPhysicHeight : this._physic.skinPhysicHeight);
            };
            if (skin){
                _local_1 = ((this.underWater) ? skin.skinWaterPhysicHeight : skin.skinPhysicHeight);
            };
            return (_local_1 * skinScale);
        }

        public function get skinGraphicHeight():Number{
            var _local_1:Number = 32;
            if (this._physic){
                _local_1 = ((this.underWater) ? this._physic.skinWaterGraphicHeight : this._physic.skinGraphicHeight);
            };
            if (skin){
                _local_1 = ((this.underWater) ? skin.skinWaterGraphicHeight : skin.skinGraphicHeight);
            };
            return (_local_1 * skinScale);
        }

        public function get gravity():Number{
            var _local_1:Number = 0;
            if (this._physic){
                _local_1 = this._physic.gravity;
            };
            if (skin){
                _local_1 = (_local_1 * skin.gravity);
            };
            return (_local_1 * this._gravity);
        }

        public function get walkSpeed():Number{
            var _local_1:Number = 0;
            if (this._physic){
                _local_1 = this._physic.walkSpeed;
            };
            _local_1 = (_local_1 * this._walkSpeed.v);
            if (this.shiftKey){
                _local_1 = (_local_1 * 0.5);
            }
            else {
                if (skin){
                    _local_1 = (_local_1 * skin.walkSpeed);
                };
            };
            return (_local_1);
        }

        public function get swimSpeed():Number{
            var _local_1:Number = 0;
            if (this._physic){
                _local_1 = this._physic.swimSpeed;
            };
            _local_1 = (_local_1 * this._swimSpeed.v);
            if (this.shiftKey){
                _local_1 = (_local_1 * 0.5);
            }
            else {
                if (skin){
                    _local_1 = (_local_1 * skin.swimSpeed);
                };
            };
            return (_local_1);
        }

        public function get jumpStrength():Number{
            var _local_1:Number = 0;
            if (this._physic){
                _local_1 = this._physic.jumpStrength;
            };
            _local_1 = (_local_1 * this._jumpStrength.v);
            if (this.shiftKey){
                _local_1 = (_local_1 * 0.8);
            }
            else {
                if (skin){
                    _local_1 = (_local_1 * skin.jumpStrength);
                };
            };
            return (_local_1);
        }


    }
}//package perso

