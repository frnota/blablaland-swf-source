// version 467 by nota

//engine.CollisionMap

package engine{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import bbl.GlobalProperties;
    import flash.display.DisplayObject;

    public class CollisionMap extends EventDispatcher {

        public var collisionBodyList:Array;
        public var environmentBodyList:Array;
        private var cbCount:uint;
        private var ebCount:uint;

        public function CollisionMap(){
            this.collisionBodyList = new Array();
            this.environmentBodyList = new Array();
            this.clearAllSurfaceBody();
        }

        public function clearAllSurfaceBody():*{
            var _local_1:uint;
            _local_1 = 0;
            while (_local_1 < this.collisionBodyList.length) {
                this.collisionBodyList[_local_1].dispose();
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.environmentBodyList.length) {
                this.environmentBodyList[_local_1].dispose();
                _local_1++;
            };
            this.collisionBodyList.splice(0, this.collisionBodyList.length);
            this.environmentBodyList.splice(0, this.environmentBodyList.length);
            this.cbCount = 0;
            this.ebCount = 0;
        }

        public function dispose():*{
            this.clearAllSurfaceBody();
        }

        public function getCollisionBodyById(_arg_1:uint):PhysicBody{
            var _local_2:* = 0;
            while (_local_2 < this.collisionBodyList.length) {
                if (this.collisionBodyList[_local_2].id == _arg_1){
                    return (this.collisionBodyList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function addCollisionBody():PhysicBody{
            var _local_1:* = new PhysicBody();
            _local_1.id = this.cbCount;
            this.collisionBodyList.push(_local_1);
            _local_1.addEventListener("onMove", this.onCollisionBodyMove, false, 0, true);
            this.cbCount++;
            return (_local_1);
        }

        public function onCollisionBodyMove(_arg_1:Event):*{
            var _local_2:PhysicBodyEvent = new PhysicBodyEvent("onCollisionBodyMove");
            _local_2.body = PhysicBody(_arg_1.currentTarget);
            dispatchEvent(_local_2);
        }

        public function removeCollisionBody(_arg_1:PhysicBody):*{
            var _local_2:* = 0;
            while (_local_2 < this.collisionBodyList.length) {
                if (this.collisionBodyList[_local_2] == _arg_1){
                    this.collisionBodyList[_local_2].removeEventListener("onMove", this.onCollisionBodyMove, false);
                    this.collisionBodyList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function getEnvironmentBodyById(_arg_1:uint):PhysicBody{
            var _local_2:* = 0;
            while (_local_2 < this.environmentBodyList.length) {
                if (this.environmentBodyList[_local_2].id == _arg_1){
                    return (this.environmentBodyList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function addEnvironmentBody():PhysicBody{
            var _local_1:* = new PhysicBody();
            _local_1.id = this.ebCount;
            this.environmentBodyList.push(_local_1);
            _local_1.addEventListener("onMove", this.onEnvironmentBodyMove, false, 0, true);
            this.ebCount++;
            return (_local_1);
        }

        public function onEnvironmentBodyMove(_arg_1:Event):*{
            var _local_2:PhysicBodyEvent = new PhysicBodyEvent("onEnvironmentBodyMove");
            _local_2.body = PhysicBody(_arg_1.currentTarget);
            dispatchEvent(_local_2);
        }

        public function removeEnvironmentBody(_arg_1:PhysicBody):*{
            var _local_2:* = 0;
            while (_local_2 < this.environmentBodyList.length) {
                if (this.environmentBodyList[_local_2] == _arg_1){
                    this.environmentBodyList[_local_2].removeEventListener("onMove", this.onEnvironmentBodyMove, false);
                    this.environmentBodyList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function updateCollisionMap(_arg_1:DisplayObject, _arg_2:Number, _arg_3:Number):*{
            var _local_5:String;
            var _local_4:PhysicBody = this.getCollisionBodyById(0);
            if (_local_4){
                _local_4.map.dispose();
                _local_4.map = new MultiBitmapData(_arg_2, _arg_3, true, 0);
                _local_5 = GlobalProperties.stage.quality;
                GlobalProperties.stage.quality = "low";
                _local_4.map.draw(_arg_1);
                GlobalProperties.stage.quality = _local_5;
            };
        }

        public function readMap(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Number, _arg_4:Number):*{
            var _local_5:String = GlobalProperties.stage.quality;
            GlobalProperties.stage.quality = "low";
            this.dispose();
            var _local_6:PhysicBody = this.addCollisionBody();
            _local_6.map = new MultiBitmapData(_arg_3, _arg_4, true, 0);
            _local_6.map.draw(_arg_1);
            _local_6 = this.addEnvironmentBody();
            _local_6.map = new MultiBitmapData(_arg_3, _arg_4, true, 0);
            _local_6.map.draw(_arg_2);
            GlobalProperties.stage.quality = _local_5;
        }

        public function getEnvironmentPixelData(_arg_1:Number, _arg_2:Number):Object{
            var _local_3:uint;
            var _local_4:Object = new Object();
            _local_4.pxl = 0;
            var _local_5:uint;
            while (_local_5 < this.environmentBodyList.length) {
                if (((this.environmentBodyList[_local_5].map) && (this.environmentBodyList[_local_5].solid))){
                    _local_3 = this.environmentBodyList[_local_5].map.getPixel((_arg_1 - Math.floor(this.environmentBodyList[_local_5].position.x)), (_arg_2 - Math.floor(this.environmentBodyList[_local_5].position.y)));
                    if (_local_3){
                        _local_4.pxl = _local_3;
                        _local_4.body = this.environmentBodyList[_local_5];
                        return (_local_4);
                    };
                };
                _local_5++;
            };
            return (_local_4);
        }

        public function getCollisionPixelData(_arg_1:Number, _arg_2:Number):Object{
            var _local_3:uint;
            var _local_4:Object = new Object();
            _local_4.pxl = 0;
            var _local_5:uint;
            while (_local_5 < this.collisionBodyList.length) {
                if (((this.collisionBodyList[_local_5].map) && (this.collisionBodyList[_local_5].solid))){
                    _local_3 = this.collisionBodyList[_local_5].map.getPixel((_arg_1 - Math.floor(this.collisionBodyList[_local_5].position.x)), (_arg_2 - Math.floor(this.collisionBodyList[_local_5].position.y)));
                    if (_local_3){
                        _local_4.pxl = _local_3;
                        _local_4.body = this.collisionBodyList[_local_5];
                        return (_local_4);
                    };
                };
                _local_5++;
            };
            return (_local_4);
        }

        public function getSurfaceCollision(_arg_1:Segment, _arg_2:Object=null):CollisionObject{
            var _local_3:CollisionObject;
            var _local_4:uint;
            while (_local_4 < this.collisionBodyList.length) {
                if (((this.collisionBodyList[_local_4].map) && (this.collisionBodyList[_local_4].solid))){
                    _local_3 = this.getSingleSurfaceCollision(this.collisionBodyList[_local_4], _arg_1, _arg_2);
                    if (_local_3){
                        return (_local_3);
                    };
                };
                _local_4++;
            };
            return (null);
        }

        public function getSingleSurfaceCollision(_arg_1:PhysicBody, _arg_2:Segment, _arg_3:*):CollisionObject{
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Number;
            var _local_19:Number;
            if (!_arg_3){
                _arg_3 = new Object();
            };
            var _local_4:DDpoint = _arg_1.position.duplicate();
            _local_4.x = Math.floor(_local_4.x);
            _local_4.y = Math.floor(_local_4.y);
            var _local_5:CollisionObject;
            var _local_6:DDpoint = new DDpoint();
            _local_6.x = Math.floor(_arg_2.ptA.x);
            _local_6.y = Math.floor(_arg_2.ptA.y);
            var _local_7:Number = Math.floor(_arg_2.ptA.x);
            var _local_8:Number = Math.floor(_arg_2.ptA.y);
            var _local_9:Number = Math.floor(_arg_2.ptB.x);
            var _local_10:Number = Math.floor(_arg_2.ptB.y);
            if (((_local_7 < _local_4.x) && (_local_9 < _local_4.x))){
                return (null);
            };
            if (((_local_8 < _local_4.y) && (_local_10 < _local_4.y))){
                return (null);
            };
            if (((_local_7 > (_arg_1.map.width + _local_4.x)) && (_local_9 > (_arg_1.map.width + _local_4.x)))){
                return (null);
            };
            if (((_local_8 > (_arg_1.map.height + _local_4.y)) && (_local_10 > (_arg_1.map.height + _local_4.y)))){
                return (null);
            };
            if (((_local_7 == _local_9) && (_local_8 == _local_10))){
                return (null);
            };
            var _local_11:Number = _arg_1.map.getPixel((_local_7 - _local_4.x), (_local_8 - _local_4.y));
            var _local_12:Number = 0;
            if (_local_11){
                _local_12 = _local_11;
            };
            if (_arg_2.ptA.x == _arg_2.ptB.x){
                if (_local_8 < _local_10){
                    _local_13 = _local_8;
                    while (_local_13 <= _local_10) {
                        _local_11 = _arg_1.map.getPixel((_local_7 - _local_4.x), (_local_13 - _local_4.y));
                        if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                            _local_5 = new CollisionObject();
                            _local_5.colPoint = new DDpoint();
                            _local_5.colPixel = new DDpoint();
                            _local_5.lastPixel = _local_6;
                            _local_5.collisionBody = _arg_1;
                            _local_5.originalSegment = _arg_2;
                            _local_5.color = _local_11;
                            _local_5.faceNum = 0;
                            _local_5.exclude = _arg_3;
                            _local_5.colPixel.x = _local_7;
                            _local_5.colPixel.y = _local_13;
                            _local_5.colPoint.x = _arg_2.ptA.x;
                            _local_5.colPoint.y = _local_13;
                            break;
                        };
                        _local_6.x = _local_7;
                        _local_6.y = _local_13;
                        _local_13++;
                    };
                }
                else {
                    _local_13 = _local_8;
                    while (_local_13 >= _local_10) {
                        _local_11 = _arg_1.map.getPixel((_local_7 - _local_4.x), (_local_13 - _local_4.y));
                        if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                            _local_5 = new CollisionObject();
                            _local_5.colPoint = new DDpoint();
                            _local_5.colPixel = new DDpoint();
                            _local_5.lastPixel = _local_6;
                            _local_5.collisionBody = _arg_1;
                            _local_5.originalSegment = _arg_2;
                            _local_5.color = _local_11;
                            _local_5.faceNum = 2;
                            _local_5.exclude = _arg_3;
                            _local_5.colPixel.x = _local_7;
                            _local_5.colPixel.y = _local_13;
                            _local_5.colPoint.x = _arg_2.ptA.x;
                            _local_5.colPoint.y = (_local_13 + 1);
                            break;
                        };
                        _local_6.x = _local_7;
                        _local_6.y = _local_13;
                        _local_13--;
                    };
                };
            }
            else {
                if (_arg_2.ptA.y == _arg_2.ptB.y){
                    if (_local_7 < _local_9){
                        _local_13 = _local_7;
                        while (_local_13 <= _local_9) {
                            _local_11 = _arg_1.map.getPixel((_local_13 - _local_4.x), (_local_8 - _local_4.y));
                            if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                _local_5 = new CollisionObject();
                                _local_5.colPoint = new DDpoint();
                                _local_5.colPixel = new DDpoint();
                                _local_5.lastPixel = _local_6;
                                _local_5.collisionBody = _arg_1;
                                _local_5.originalSegment = _arg_2;
                                _local_5.color = _local_11;
                                _local_5.faceNum = 3;
                                _local_5.exclude = _arg_3;
                                _local_5.colPixel.x = _local_13;
                                _local_5.colPixel.y = _local_8;
                                _local_5.colPoint.x = _local_13;
                                _local_5.colPoint.y = _arg_2.ptA.y;
                                break;
                            };
                            _local_6.x = _local_13;
                            _local_6.y = _local_8;
                            _local_13++;
                        };
                    }
                    else {
                        _local_13 = _local_7;
                        while (_local_13 >= _local_9) {
                            _local_11 = _arg_1.map.getPixel((_local_13 - _local_4.x), (_local_8 - _local_4.y));
                            if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                _local_5 = new CollisionObject();
                                _local_5.colPoint = new DDpoint();
                                _local_5.colPixel = new DDpoint();
                                _local_5.lastPixel = _local_6;
                                _local_5.collisionBody = _arg_1;
                                _local_5.originalSegment = _arg_2;
                                _local_5.color = _local_11;
                                _local_5.faceNum = 1;
                                _local_5.exclude = _arg_3;
                                _local_5.colPixel.x = _local_13;
                                _local_5.colPixel.y = _local_8;
                                _local_5.colPoint.x = (_local_13 + 1);
                                _local_5.colPoint.y = _arg_2.ptA.y;
                                break;
                            };
                            _local_6.x = _local_13;
                            _local_6.y = _local_8;
                            _local_13--;
                        };
                    };
                }
                else {
                    _local_14 = _arg_2.a;
                    _local_15 = _arg_2.b;
                    _local_16 = 0;
                    _local_17 = _local_7;
                    _local_18 = _local_8;
                    if (((_arg_2.ptB.x > _arg_2.ptA.x) && (_arg_2.ptB.y > _arg_2.ptA.y))){
                        while (((_local_17 <= _local_9) && (_local_18 <= _local_10))) {
                            _local_6.x = _local_17;
                            _local_6.y = _local_18;
                            _local_19 = ((_local_14 * (_local_17 + 1)) + _local_15);
                            if (_local_19 > (_local_18 + 1)){
                                _local_18++;
                                _local_16 = 0;
                            }
                            else {
                                _local_17++;
                                _local_16 = 3;
                            };
                            _local_11 = _arg_1.map.getPixel((_local_17 - _local_4.x), (_local_18 - _local_4.y));
                            if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                _local_5 = new CollisionObject();
                                _local_5.colPoint = new DDpoint();
                                _local_5.colPixel = new DDpoint();
                                _local_5.lastPixel = _local_6;
                                _local_5.collisionBody = _arg_1;
                                _local_5.originalSegment = _arg_2;
                                _local_5.color = _local_11;
                                _local_5.faceNum = _local_16;
                                _local_5.exclude = _arg_3;
                                _local_5.colPixel.x = _local_17;
                                _local_5.colPixel.y = _local_18;
                                if (_local_16 == 0){
                                    _local_5.colPoint.x = ((_local_18 - _local_15) / _local_14);
                                    _local_5.colPoint.y = _local_18;
                                }
                                else {
                                    _local_5.colPoint.x = _local_17;
                                    _local_5.colPoint.y = _local_19;
                                };
                                break;
                            };
                        };
                    }
                    else {
                        if (((_arg_2.ptB.x < _arg_2.ptA.x) && (_arg_2.ptB.y > _arg_2.ptA.y))){
                            while (((_local_17 >= _local_9) && (_local_18 <= _local_10))) {
                                _local_6.x = _local_17;
                                _local_6.y = _local_18;
                                _local_19 = ((_local_14 * _local_17) + _local_15);
                                if (_local_19 >= (_local_18 + 1)){
                                    _local_18++;
                                    _local_16 = 0;
                                }
                                else {
                                    _local_17--;
                                    _local_16 = 1;
                                };
                                _local_11 = _arg_1.map.getPixel((_local_17 - _local_4.x), (_local_18 - _local_4.y));
                                if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                    _local_5 = new CollisionObject();
                                    _local_5.colPoint = new DDpoint();
                                    _local_5.colPixel = new DDpoint();
                                    _local_5.lastPixel = _local_6;
                                    _local_5.collisionBody = _arg_1;
                                    _local_5.originalSegment = _arg_2;
                                    _local_5.color = _local_11;
                                    _local_5.faceNum = _local_16;
                                    _local_5.exclude = _arg_3;
                                    _local_5.colPixel.x = _local_17;
                                    _local_5.colPixel.y = _local_18;
                                    if (_local_16 == 0){
                                        _local_5.colPoint.x = ((_local_18 - _local_15) / _local_14);
                                        _local_5.colPoint.y = _local_18;
                                    }
                                    else {
                                        _local_5.colPoint.x = (_local_17 + 1);
                                        _local_5.colPoint.y = _local_19;
                                    };
                                    break;
                                };
                            };
                        }
                        else {
                            if (((_arg_2.ptB.x < _arg_2.ptA.x) && (_arg_2.ptB.y < _arg_2.ptA.y))){
                                while (((_local_17 >= _local_9) && (_local_18 >= _local_10))) {
                                    _local_6.x = _local_17;
                                    _local_6.y = _local_18;
                                    _local_19 = ((_local_14 * _local_17) + _local_15);
                                    if (_local_19 > _local_18){
                                        _local_17--;
                                        _local_16 = 1;
                                    }
                                    else {
                                        _local_18--;
                                        _local_16 = 2;
                                    };
                                    _local_11 = _arg_1.map.getPixel((_local_17 - _local_4.x), (_local_18 - _local_4.y));
                                    if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                        _local_5 = new CollisionObject();
                                        _local_5.colPoint = new DDpoint();
                                        _local_5.colPixel = new DDpoint();
                                        _local_5.lastPixel = _local_6;
                                        _local_5.collisionBody = _arg_1;
                                        _local_5.originalSegment = _arg_2;
                                        _local_5.color = _local_11;
                                        _local_5.faceNum = _local_16;
                                        _local_5.exclude = _arg_3;
                                        _local_5.colPixel.x = _local_17;
                                        _local_5.colPixel.y = _local_18;
                                        if (_local_16 == 1){
                                            _local_5.colPoint.x = (_local_17 + 1);
                                            _local_5.colPoint.y = _local_19;
                                        }
                                        else {
                                            _local_5.colPoint.x = (((_local_18 + 1) - _local_15) / _local_14);
                                            _local_5.colPoint.y = (_local_18 + 1);
                                        };
                                        break;
                                    };
                                };
                            }
                            else {
                                if (((_arg_2.ptB.x > _arg_2.ptA.x) && (_arg_2.ptB.y < _arg_2.ptA.y))){
                                    while (((_local_17 <= _local_9) && (_local_18 >= _local_10))) {
                                        _local_6.x = _local_17;
                                        _local_6.y = _local_18;
                                        _local_19 = ((_local_14 * (_local_17 + 1)) + _local_15);
                                        if (_local_19 >= _local_18){
                                            _local_17++;
                                            _local_16 = 3;
                                        }
                                        else {
                                            _local_18--;
                                            _local_16 = 2;
                                        };
                                        _local_11 = _arg_1.map.getPixel((_local_17 - _local_4.x), (_local_18 - _local_4.y));
                                        if ((((!(_local_11 == 0)) && (!(_local_11 == _local_12))) && (!(_arg_3[String(_local_11)])))){
                                            _local_5 = new CollisionObject();
                                            _local_5.colPoint = new DDpoint();
                                            _local_5.colPixel = new DDpoint();
                                            _local_5.lastPixel = _local_6;
                                            _local_5.collisionBody = _arg_1;
                                            _local_5.originalSegment = _arg_2;
                                            _local_5.color = _local_11;
                                            _local_5.faceNum = _local_16;
                                            _local_5.exclude = _arg_3;
                                            _local_5.colPixel.x = _local_17;
                                            _local_5.colPixel.y = _local_18;
                                            if (_local_16 == 3){
                                                _local_5.colPoint.x = _local_17;
                                                _local_5.colPoint.y = _local_19;
                                            }
                                            else {
                                                _local_5.colPoint.x = (((_local_18 + 1) - _local_15) / _local_14);
                                                _local_5.colPoint.y = (_local_18 + 1);
                                            };
                                            break;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (_local_5){
                if (((_local_5.lastPixel.x < 0) || (_local_5.lastPixel.y < 0))){
                    _local_5 = null;
                };
            };
            return (_local_5);
        }


    }
}//package engine

