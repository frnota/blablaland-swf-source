// version 467 by nota

//engine.Tween

package engine{
    public class Tween {

        public var mode:uint;
        public var factor:Number;
        public var offset:Number;

        public function Tween(){
            this.mode = 0;
            this.factor = 1;
            this.offset = 0;
        }

        public function generate(_arg_1:Number):Number{
            if (this.mode == 0){
                return (this.generateLinear(_arg_1));
            };
            if (this.mode == 1){
                return (this.generateExponential(_arg_1));
            };
            if (this.mode == 2){
                return (this.generateInvertExponential(_arg_1));
            };
            if (this.mode == 5){
                return (this.generateDualExponential(_arg_1));
            };
            if (this.mode == 6){
                return (this.generateInvertDualExponential(_arg_1));
            };
            return (_arg_1);
        }

        public function generateLinear(_arg_1:Number):Number{
            return ((_arg_1 + this.offset) * this.factor);
        }

        public function generateExponential(_arg_1:Number):Number{
            return (Math.pow(_arg_1, this.factor));
        }

        public function generateInvertExponential(_arg_1:Number):Number{
            return (1 - Math.pow((1 - _arg_1), this.factor));
        }

        public function generateDualExponential(_arg_1:Number):Number{
            if (_arg_1 < 0.5){
                return (this.generateExponential((_arg_1 * 2)) / 2);
            };
            return ((this.generateInvertExponential(((_arg_1 - 0.5) * 2)) / 2) + 0.5);
        }

        public function generateInvertDualExponential(_arg_1:Number):Number{
            if (_arg_1 < 0.5){
                return (this.generateInvertExponential((_arg_1 * 2)) / 2);
            };
            return ((this.generateExponential(((_arg_1 - 0.5) * 2)) / 2) + 0.5);
        }


    }
}//package engine

