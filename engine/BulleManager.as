// version 467 by nota

//engine.BulleManager

package engine{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class BulleManager extends Bulle {

        public var timer:Timer;

        public function BulleManager(){
            this.timer = new Timer(500);
            this.timer.addEventListener("timer", this.timerEvt, false, 0, true);
        }

        public function timerEvt(_arg_1:TimerEvent=null):*{
            this.clear();
        }

        override public function dispose():*{
            this.timer.removeEventListener("timer", this.timerEvt, false);
            super.dispose();
        }

        override public function clear():*{
            this.timer.stop();
            super.clear();
        }

        public function show(_arg_1:String):*{
            text = _arg_1;
            redraw();
            this.timer.delay = ((Math.min((_arg_1.length / 100), 1) * 3000) + 3000);
            this.timer.start();
        }


    }
}//package engine

