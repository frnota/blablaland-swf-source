// version 467 by nota

//utils.AntiFlood

package utils{
    import flash.utils.getTimer;

    public class AntiFlood {

        public var maxValue:Number;
        public var lostValue:Number;
        private var curValue:Number;
        private var lastTime:int;

        public function AntiFlood(){
            this.maxValue = 1000;
            this.lostValue = 0.001;
            this.curValue = 0;
            this.lastTime = getTimer();
        }

        public function hit(_arg_1:Number=1):*{
            this.curValue = (this.curValue + _arg_1);
            if (this.curValue > this.maxValue){
                this.curValue = this.maxValue;
            };
        }

        public function getValue():Number{
            var _local_1:int = getTimer();
            var _local_2:int = (_local_1 - this.lastTime);
            this.lastTime = _local_1;
            this.curValue = (this.curValue - (_local_2 * this.lostValue));
            if (this.curValue < 0){
                this.curValue = 0;
            };
            return (this.curValue);
        }


    }
}//package utils

