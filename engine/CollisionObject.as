// version 467 by nota

//engine.CollisionObject

package engine{
    public class CollisionObject {

        public static var _init:Boolean = init();
        public static var _pxArea:Object;

        public var colPoint:DDpoint;
        public var colPixel:DDpoint;
        public var lastPixel:DDpoint;
        public var surfaceSegment:Segment;
        public var normal:DDpoint;
        public var exclude:Object;
        public var collisionBody:PhysicBody;
        public var originalSegment:Segment;
        public var color:uint;
        public var faceNum:uint;


        public static function init():Boolean{
            var _local_1:Object;
            _pxArea = new Object();
            _local_1 = (_pxArea["0_0"] = {
                "x":-1,
                "y":-1
            });
            _local_1 = (_pxArea["1_0"] = {
                "x":0,
                "y":-1,
                "last":_local_1
            });
            _local_1 = (_pxArea["2_0"] = {
                "x":1,
                "y":-1,
                "last":_local_1
            });
            _local_1 = (_pxArea["2_1"] = {
                "x":1,
                "y":0,
                "last":_local_1
            });
            _local_1 = (_pxArea["2_2"] = {
                "x":1,
                "y":1,
                "last":_local_1
            });
            _local_1 = (_pxArea["1_2"] = {
                "x":0,
                "y":1,
                "last":_local_1
            });
            _local_1 = (_pxArea["0_2"] = {
                "x":-1,
                "y":1,
                "last":_local_1
            });
            _local_1 = (_pxArea["0_1"] = {
                "x":-1,
                "y":0,
                "last":_local_1
            });
            _pxArea["0_0"].last = _local_1;
            _pxArea["0_0"].next = _pxArea["1_0"];
            _pxArea["1_0"].next = _pxArea["2_0"];
            _pxArea["2_0"].next = _pxArea["2_1"];
            _pxArea["2_1"].next = _pxArea["2_2"];
            _pxArea["2_2"].next = _pxArea["1_2"];
            _pxArea["1_2"].next = _pxArea["0_2"];
            _pxArea["0_2"].next = _pxArea["0_1"];
            _pxArea["0_1"].next = _pxArea["0_0"];
            return (true);
        }


        public function calculateColor(_arg_1:Number):Number{
            return (((((_arg_1 >> 16) & 0xFF) * 0x10000) + (((_arg_1 >> 8) & 0xFF) * 0x0100)) + (_arg_1 & 0xFF));
        }

        public function calculateNormal():void{
            if (!this.normal){
                this._calculateNormal();
            };
        }

        private function _calculateNormal():void{
            var _local_1:Object;
            var _local_2:Object;
            var _local_6:uint;
            var _local_3:Object = _pxArea[((((1 + this.lastPixel.x) - this.colPixel.x) + "_") + ((1 + this.lastPixel.y) - this.colPixel.y))];
            var _local_4:Object = _local_3.next;
            var _local_5:Number = 0;
            while (((!(_local_4 == _local_3)) && (_local_5 < 5))) {
                _local_6 = this.collisionBody.map.getPixel(((this.colPixel.x + _local_4.x) - this.collisionBody.position.x), ((this.colPixel.y + _local_4.y) - this.collisionBody.position.y));
                if (((!(_local_6 == 0)) && (!(this.exclude[String(_local_6)])))){
                    _local_1 = _local_4;
                    break;
                };
                _local_4 = _local_4.next;
                _local_5++;
            };
            _local_4 = _local_3.last;
            var _local_7:Number = _local_5;
            _local_5 = 0;
            while ((((!(_local_4 == _local_3)) && (_local_5 < 5)) && (_local_7 < 5))) {
                _local_6 = this.collisionBody.map.getPixel(((this.colPixel.x + _local_4.x) - this.collisionBody.position.x), ((this.colPixel.y + _local_4.y) - this.collisionBody.position.y));
                if (((!(_local_6 == 0)) && (!(this.exclude[String(_local_6)])))){
                    _local_2 = _local_4;
                    break;
                };
                _local_4 = _local_4.last;
                _local_5++;
                _local_7++;
            };
            this.surfaceSegment = null;
            if ((((_local_1) && (_local_2)) && (!(_local_1 == _local_2)))){
                this.surfaceSegment = new Segment();
                this.surfaceSegment.init();
                this.surfaceSegment.ptA.x = (_local_1.x + this.colPixel.x);
                this.surfaceSegment.ptA.y = (_local_1.y + this.colPixel.y);
                this.surfaceSegment.ptB.x = (_local_2.x + this.colPixel.x);
                this.surfaceSegment.ptB.y = (_local_2.y + this.colPixel.y);
            };
            if (Math.round((this.colPixel.y + this.collisionBody.position.y)) == 0){
                this.surfaceSegment = null;
            };
            this.normal = new DDpoint();
            if (this.surfaceSegment){
                this.normal.x = -(this.surfaceSegment.ptB.y - this.surfaceSegment.ptA.y);
                this.normal.y = (this.surfaceSegment.ptB.x - this.surfaceSegment.ptA.x);
                this.normal.normalize();
            }
            else {
                this.normal.x = (this.lastPixel.x - this.colPixel.x);
                this.normal.y = (this.lastPixel.y - this.colPixel.y);
                this.normal.normalize();
            };
        }


    }
}//package engine

