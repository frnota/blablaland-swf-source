// version 467 by nota

//engine.DDpoint

package engine{
    public class DDpoint {

        private var _x:Object;
        private var _y:Object;


        public function getPointDistance(_arg_1:DDpoint):Number{
            var _local_2:Segment = new Segment();
            var _local_3:Number = (_arg_1.x - this.x);
            var _local_4:Number = (_arg_1.y - this.y);
            return (Math.sqrt(((_local_3 * _local_3) + (_local_4 * _local_4))));
        }

        public function normalize():void{
            var _local_1:Number = Math.sqrt(((this.x * this.x) + (this.y * this.y)));
            if (!_local_1){
                this.x = 0;
                this.y = 0;
            }
            else {
                this.x = (this.x / _local_1);
                this.y = (this.y / _local_1);
            };
        }

        public function getLength():Number{
            return (Math.sqrt(((this.x * this.x) + (this.y * this.y))));
        }

        public function duplicate():DDpoint{
            var _local_1:DDpoint = new DDpoint();
            _local_1.x = this.x;
            _local_1.y = this.y;
            return (_local_1);
        }

        public function init():void{
            this.x = 0;
            this.y = 0;
        }

        public function set x(_arg_1:Number):*{
            this._x = {"v":_arg_1};
        }

        public function get x():Number{
            return (this._x.v);
        }

        public function set y(_arg_1:Number):*{
            this._y = {"v":_arg_1};
        }

        public function get y():Number{
            return (this._y.v);
        }


    }
}//package engine

