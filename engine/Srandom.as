// version 467 by nota

//engine.Srandom

package engine{
    public class Srandom {

        private static var exp:Number = (Math.pow(2, 48) - 1);

        public var seed:Number;

        public function Srandom(){
            this.seed = ((new Date().getTime() * Math.PI) % 1);
        }

        public function generate(_arg_1:Number=1):Number{
            var _local_2:uint;
            var _local_3:String;
            _local_2 = 0;
            while (_local_2 < _arg_1) {
                while (((Math.round((this.seed * 100)).toString().length < 2) && (!(this.seed == 0)))) {
                    this.seed = (this.seed * 10);
                };
                _local_3 = Math.round(Math.pow((this.seed * 100000), 2)).toString();
                this.seed = (Number(_local_3.substr(1, (_local_3.length - 1))) % exp);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < _arg_1) {
                this.seed = (((31167285 * this.seed) + 1) % exp);
                _local_2++;
            };
            this.seed = (this.seed / exp);
            return (this.seed);
        }


    }
}//package engine

