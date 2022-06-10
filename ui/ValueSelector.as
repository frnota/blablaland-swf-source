// version 467 by nota

//ui.ValueSelector

package ui{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.text.TextFieldType;

    public class ValueSelector extends Sprite {

        public var step:Number;
        public var repeatDelay:Number;
        public var repeatInterval:Number;
        private var _enabled:Boolean;
        private var _value:Number;
        private var _resolution:Number;
        private var _minValue:Number;
        private var _maxValue:Number;
        private var _dragging:Boolean;
        private var _sens:Number;
        private var _oldPos:Number;
        private var _oldValue:Number;
        private var _timer:Timer;
        public var bt_up:SimpleButton;
        public var bt_dn:SimpleButton;
        public var txt:TextField;

        public function ValueSelector(){
            this._value = 0;
            this._resolution = 1;
            this._enabled = true;
            this._minValue = 0;
            this._maxValue = 999;
            this.repeatDelay = 200;
            this.repeatInterval = 50;
            this.step = 1;
            this._timer = new Timer(this.repeatDelay);
            this._timer.addEventListener("timer", this.timerEvent, false, 0, true);
            addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            removeEventListener(Event.ADDED_TO_STAGE, this.init, false);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyEvent, false, 0, true);
            this.txt.addEventListener(FocusEvent.FOCUS_OUT, this.txtlostfocus, false, 0, true);
            this.txt.restrict = "0-9\\-\\.";
            this.bt_up.addEventListener(MouseEvent.MOUSE_DOWN, this.pressEvent, false, 0, true);
            this.bt_dn.addEventListener(MouseEvent.MOUSE_DOWN, this.pressEvent, false, 0, true);
        }

        public function keyEvent(_arg_1:KeyboardEvent):*{
            if (stage){
                if (((_arg_1.keyCode == 13) && (stage.focus == this.txt))){
                    this._value = this.verifi(this.txt.text);
                    this.txt.text = String(this._value);
                    dispatchEvent(new Event("onChanged"));
                    dispatchEvent(new Event("onFixed"));
                };
            };
        }

        public function txtlostfocus(_arg_1:FocusEvent):*{
            this._value = this.verifi(this.txt.text);
            this.txt.text = String(this._value);
            dispatchEvent(new Event("onChanged"));
            dispatchEvent(new Event("onFixed"));
        }

        public function timerEvent(_arg_1:Event):*{
            var _local_2:Number = this._value;
            this.stepValue(this._sens);
            this._timer.delay = this.repeatInterval;
            if (_local_2 != this._value){
                dispatchEvent(new Event("onChanged"));
            };
        }

        public function moveEvent(_arg_1:MouseEvent):*{
            if (this._dragging){
                this._value = this.verifi((((this._oldPos - mouseY) * (this.step / 2)) + this._oldValue));
                this.txt.text = String(this._value);
                dispatchEvent(new Event("onChanged"));
                this._timer.stop();
            }
            else {
                if (Math.abs((this._oldPos - mouseY)) > 5){
                    this._dragging = true;
                    this._oldPos = mouseY;
                };
            };
        }

        public function pressEvent(_arg_1:MouseEvent):*{
            if (this._enabled){
                this._sens = ((_arg_1.currentTarget == this.bt_up) ? 1 : -1);
                this._oldPos = mouseY;
                this._dragging = false;
                this._oldValue = this._value;
                this.stepValue(this._sens);
                dispatchEvent(new Event("onChanged"));
                this._timer.delay = this.repeatDelay;
                this._timer.start();
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent, false, 0, true);
                stage.addEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, true, 0, true);
                stage.addEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, false, 0, true);
            };
        }

        public function releaseEvent(_arg_1:MouseEvent):*{
            this._timer.stop();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, true);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.releaseEvent, false);
            this._value = this.verifi(this.txt.text);
            this.txt.text = String(this._value);
            dispatchEvent(new Event("onFixed"));
        }

        public function stepValue(_arg_1:Number):*{
            var _local_2:* = this.verifi((this._value + (this.step * _arg_1)));
            this._value = _local_2;
            this.txt.text = _local_2;
        }

        public function verifi(_arg_1:Object):Number{
            var _local_4:Number;
            var _local_2:Number = Number(_arg_1);
            if (isNaN(_local_2)){
                return (this._value);
            };
            _local_2 = (Math.round((_local_2 / this._resolution)) * this._resolution);
            var _local_3:Array = String(this._resolution).split(".");
            if (_local_3.length > 1){
                _local_4 = _local_3[1].length;
                _local_2 = (Math.round((_local_2 * Math.pow(10, _local_4))) / Math.pow(10, _local_4));
            }
            else {
                _local_2 = Math.round(_local_2);
            };
            if (_local_2 < this._minValue){
                _local_2 = this._minValue;
            };
            if (_local_2 > this._maxValue){
                _local_2 = this._maxValue;
            };
            return (_local_2);
        }

        public function get value():*{
            return (this._value);
        }

        public function set value(_arg_1:Number):*{
            _arg_1 = this.verifi(_arg_1);
            this._value = _arg_1;
            this.txt.text = String(_arg_1);
        }

        public function get resolution():*{
            return (this._resolution);
        }

        public function set resolution(_arg_1:Number):*{
            this._resolution = _arg_1;
            this._value = this.verifi(this._value);
            this.txt.text = String(this._value);
        }

        public function get minValue():*{
            return (this._minValue);
        }

        public function set minValue(_arg_1:Number):*{
            this._minValue = _arg_1;
            this._value = this.verifi(this._value);
            this.txt.text = String(this._value);
        }

        public function get maxValue():*{
            return (this._maxValue);
        }

        public function set maxValue(_arg_1:Number):*{
            this._maxValue = _arg_1;
            this._value = this.verifi(this._value);
            this.txt.text = String(this._value);
        }

        public function get enabled():*{
            return (this._enabled);
        }

        public function set enabled(_arg_1:Boolean):*{
            this._enabled = _arg_1;
            this.bt_up.enabled = _arg_1;
            this.bt_dn.enabled = _arg_1;
            this.txt.type = ((_arg_1) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            this.txt.backgroundColor = ((_arg_1) ? 0xFFFFFF : 0xDDDDDD);
        }


    }
}//package ui

