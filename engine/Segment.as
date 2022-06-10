// version 467 by nota

//engine.Segment

package engine{
    public class Segment {

        public var ptA:DDpoint;
        public var ptB:DDpoint;
        public var a:Number;
        public var b:Number;


        public function duplicate():Segment{
            var _local_1:Segment = new Segment();
            _local_1.init();
            _local_1.ptA.x = this.ptA.x;
            _local_1.ptA.y = this.ptA.y;
            _local_1.ptB.x = this.ptB.x;
            _local_1.ptB.y = this.ptB.y;
            return (_local_1);
        }

        public function getVector():DDpoint{
            var _local_1:DDpoint;
            _local_1 = new DDpoint();
            _local_1.x = (this.ptB.x - this.ptA.x);
            _local_1.y = (this.ptB.y - this.ptA.y);
            return (_local_1);
        }

        public function lineCoef():void{
            this.a = ((this.ptB.y - this.ptA.y) / (this.ptB.x - this.ptA.x));
            this.b = (this.ptA.y - (this.a * this.ptA.x));
        }

        public function vectorIsDirect(_arg_1:Number, _arg_2:Number):Boolean{
            return (((_arg_1 * (this.ptB.y - this.ptA.y)) - (_arg_2 * (this.ptB.x - this.ptA.x))) >= 0);
        }

        public function segmentIsDirect(_arg_1:Segment):Boolean{
            return ((((_arg_1.ptB.x - _arg_1.ptA.x) * (this.ptB.y - this.ptA.y)) - ((_arg_1.ptB.y - _arg_1.ptA.y) * (this.ptB.x - this.ptA.x))) >= 0);
        }

        public function init():void{
            this.ptA = new DDpoint();
            this.ptB = new DDpoint();
            this.ptA.init();
            this.ptB.init();
        }

        public function pointIsInSegment(_arg_1:Number, _arg_2:Number):Boolean{
            var _local_3:uint;
            if (this.ptA.x <= this.ptB.x){
                if (((_arg_1 >= this.ptA.x) && (_arg_1 <= this.ptB.x))){
                    _local_3++;
                };
            }
            else {
                if (this.ptA.x > this.ptB.x){
                    if (((_arg_1 <= this.ptA.x) && (_arg_1 >= this.ptB.x))){
                        _local_3++;
                    };
                }
                else {
                    if (_arg_1 == this.ptA.x){
                        _local_3++;
                    };
                };
            };
            if (this.ptA.y <= this.ptB.y){
                if (((_arg_2 >= this.ptA.y) && (_arg_2 <= this.ptB.y))){
                    _local_3++;
                };
            }
            else {
                if (this.ptA.y > this.ptB.y){
                    if (((_arg_2 <= this.ptA.y) && (_arg_2 >= this.ptB.y))){
                        _local_3++;
                    };
                }
                else {
                    if (_arg_2 == this.ptA.y){
                        _local_3++;
                    };
                };
            };
            return (_local_3 == 2);
        }

        public function orthoProjection(_arg_1:Number, _arg_2:Number):DDpoint{
            var _local_3:DDpoint = new DDpoint();
            _local_3.init();
            if (this.ptA.x == this.ptB.x){
                _local_3.x = this.ptA.x;
                _local_3.y = _arg_2;
            }
            else {
                if (this.ptA.y == this.ptB.y){
                    _local_3.x = _arg_1;
                    _local_3.y = this.ptA.y;
                }
                else {
                    _local_3.x = (((_arg_1 - (this.a * this.b)) + (this.a * _arg_2)) / (1 + (this.a * this.a)));
                    _local_3.y = (this.b + (this.a * _local_3.x));
                };
            };
            return (_local_3);
        }


    }
}//package engine

