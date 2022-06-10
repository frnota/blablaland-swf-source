// version 467 by nota

//utils.FPS

package utils{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import flash.events.Event;

    public class FPS extends Sprite {

        public var addText:String;
        public var interval:uint;
        private var txt:TextField;
        private var count:uint;
        private var lastTime:uint;

        public function FPS(){
            this.count = 0;
            this.interval = 10;
            this.addText = "";
            this.txt = new TextField();
            this.txt.autoSize = "left";
            addChild(this.txt);
            addEventListener("enterFrame", this.enterF);
            this.lastTime = 0;
        }

        public function enterF(_arg_1:Event):*{
            var _local_2:Number;
            var _local_3:uint;
            if ((this.count % this.interval) == 0){
                _local_2 = getTimer();
                _local_3 = (_local_2 - this.lastTime);
                this.txt.background = true;
                this.txt.text = ((String((Math.round(((this.interval * 10000) / _local_3)) / 10)) + " ") + this.addText);
                this.lastTime = _local_2;
            };
            this.count++;
        }


    }
}//package utils

