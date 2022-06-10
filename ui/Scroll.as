// version 467 by nota

//ui.Scroll

package ui{
    import flash.display.Sprite;
    import flash.display.SimpleButton;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;

    public class Scroll extends Sprite {

        public var bt_left:SimpleButton;
        public var bt_right:SimpleButton;
        public var chariot:SimpleButton;
        public var fondscroll:Sprite;
        public var updateAfterEvent:Boolean;
        public var changeStep:Number;
        public var firstDelay:Number;
        public var secondDelay:Number;
        private var _timer:Timer;
        private var _value:Number;
        private var _ratio:Number;
        private var _size:Number;
        private var _sens:Number;
        private var _lastX:Number;
        private var _resizeChariot:Boolean;

        public function Scroll(){
            this.updateAfterEvent = true;
            this.firstDelay = 200;
            this.secondDelay = 50;
            this._value = 0;
            this._ratio = 0.2;
            this._size = 100;
            this._sens = 0;
            this.changeStep = 0.1;
            this._resizeChariot = true;
            addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
        }

        private function init(_arg_1:Event):*{
            removeEventListener(Event.ADDED_TO_STAGE, this.init, false);
            this.bt_right.addEventListener(MouseEvent.MOUSE_DOWN, this.pressEvent, false, 0, true);
            this.bt_left.addEventListener(MouseEvent.MOUSE_DOWN, this.pressEvent, false, 0, true);
            this.chariot.addEventListener(MouseEvent.MOUSE_DOWN, this.pressEvent, false, 0, true);
            this._timer = new Timer(this.firstDelay);
            this._timer.addEventListener("timer", this.timerEvent, false, 0, true);
            this.size = this._size;
        }

        private function timerEvent(_arg_1:TimerEvent):*{
            this._timer.delay = this.secondDelay;
            this.step((this.changeStep * this._sens));
        }

        private function pressEvent(_arg_1:MouseEvent):*{
            if (((_arg_1.currentTarget == this.bt_right) || (_arg_1.currentTarget == this.bt_left))){
                this._timer.delay = this.firstDelay;
                this._sens = ((_arg_1.currentTarget == this.bt_right) ? 1 : -1);
                this._timer.start();
                this.step((this.changeStep * this._sens));
            }
            else {
                if (_arg_1.currentTarget == this.chariot){
                    this._lastX = (mouseX - this.chariot.x);
                    this._sens = 0;
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, this.chariotMove, false, 0, true);
                };
            };
            stage.addEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, true, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, false, 0, true);
        }

        private function chariotMove(_arg_1:MouseEvent):*{
            var _local_2:Number = this._value;
            var _local_3:Number = (mouseX - this._lastX);
            if (_local_3 < this.bt_left.x){
                _local_3 = this.bt_left.x;
            };
            var _local_4:* = ((this.bt_right.x - this.bt_left.x) * (1 - this.ratio));
            if (_local_3 > (this.bt_left.x + _local_4)){
                _local_3 = (this.bt_left.x + _local_4);
            };
            this._value = ((this.bt_left.x - _local_3) / -(_local_4));
            if (isNaN(this._value)){
                this._value = 0;
            };
            if (this.value != _local_2){
                dispatchEvent(new Event("onChanged"));
            };
            this.chariot.x = _local_3;
            if (this.updateAfterEvent){
                _arg_1.updateAfterEvent();
            };
        }

        private function releaseEvent(_arg_1:MouseEvent):*{
            this._timer.stop();
            dispatchEvent(new Event("onFixed"));
            if (stage){
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.chariotMove);
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, true);
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, false);
            };
        }

        private function step(_arg_1:Number):*{
            var _local_2:* = this.value;
            this.value = (this.value + _arg_1);
            if (this.value != _local_2){
                dispatchEvent(new Event("onChanged"));
            };
        }

        public function get resizeChariot():*{
            return (this._resizeChariot);
        }

        public function set resizeChariot(_arg_1:Boolean):*{
            this._resizeChariot = _arg_1;
            this.update();
        }

        public function get size():*{
            return (this._size);
        }

        public function set size(_arg_1:Number):*{
            if (_arg_1 < 10){
                _arg_1 = 10;
            };
            this.bt_right.x = (_arg_1 - this.bt_right.width);
            this.fondscroll.width = (this.bt_right.x - this.bt_left.width);
            this._size = _arg_1;
            this.update();
        }

        public function get ratio():*{
            return (this._ratio);
        }

        public function set ratio(_arg_1:Number):*{
            if (_arg_1 > 1){
                _arg_1 = 1;
            }
            else {
                if (_arg_1 < 0.01){
                    _arg_1 = 0.01;
                };
            };
            this._ratio = _arg_1;
            this.update();
        }

        public function get value():*{
            return (this._value);
        }

        public function set value(_arg_1:Number):*{
            if (_arg_1 > 1){
                _arg_1 = 1;
            }
            else {
                if (_arg_1 < 0){
                    _arg_1 = 0;
                };
            };
            this._value = _arg_1;
            this.update();
        }

        public function update():*{
            var _local_1:* = ((this.bt_right.x - this.bt_left.x) * (1 - this.ratio));
            this.chariot.x = (this.bt_left.x + (_local_1 * this.value));
            if (this._resizeChariot){
                this.chariot.width = ((this.bt_right.x - this.bt_left.x) * this.ratio);
            }
            else {
                this._ratio = (this.chariot.width / (this.bt_right.x - this.bt_left.x));
            };
        }


    }
}//package ui

