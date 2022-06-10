// version 467 by nota

//ui.CheckBox

package ui{
    import flash.display.MovieClip;
    import flash.events.Event;

    public class CheckBox extends MovieClip {

        private var _value:Boolean;
        private var _enable:Boolean;
        public var zone_chaude:MovieClip;
        public var onChanged:Function;

        public function CheckBox(){
            this._value = false;
            this._enable = true;
            stop();
            addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
        }

        public function update():*{
            gotoAndStop(((("etat_" + this._value) + "_enable_") + this._enable));
        }

        public function click(_arg_1:Event):*{
            this._value = (!(this._value));
            dispatchEvent(new Event("onChanged"));
            this.update();
        }

        public function init(_arg_1:Event):*{
            removeEventListener(Event.ADDED_TO_STAGE, this.init, false);
            this.update();
            this.zone_chaude.addEventListener("click", this.click, false, 0, true);
            this.zone_chaude.buttonMode = true;
        }

        public function get value():Boolean{
            return (this._value);
        }

        public function set value(_arg_1:Boolean):*{
            if ((_arg_1 == _arg_1)){
            };
            this._value = _arg_1;
            this.update();
        }

        public function get enable():Boolean{
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):*{
            if ((_arg_1 == _arg_1)){
            };
            this._enable = _arg_1;
            this.update();
        }


    }
}//package ui

