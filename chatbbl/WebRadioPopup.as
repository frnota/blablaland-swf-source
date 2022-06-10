// version 467 by nota

//chatbbl.WebRadioPopup

package chatbbl{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class WebRadioPopup extends MovieClip {

        public var win:Object;
        public var util:Object;
        public var btn_power:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_vol:SimpleButton;
        public var btn_vol_back:SimpleButton;
        public var power_led:MovieClip;

        public function WebRadioPopup(){
            addEventListener(MouseEvent.MOUSE_DOWN, this.startDragEvt, false);
            this.btn_power.addEventListener("click", this.onPowerEvt);
            this.btn_close.addEventListener("click", this.onBtnCloseCLick);
            this.btn_vol.addEventListener(MouseEvent.MOUSE_DOWN, this.onBtnVolDown);
            this.btn_vol_back.addEventListener(MouseEvent.MOUSE_DOWN, this.onBtnVolDown);
        }

        public function onBtnVolDown(_arg_1:Event):*{
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onBtnVolMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onBtnVolUp);
            _arg_1.stopImmediatePropagation();
        }

        public function onBtnVolMove(_arg_1:Event):*{
            var _local_2:Number = this.pxToVol(mouseX);
            this.btn_vol.x = this.volToPx(_local_2);
            this.setVolume(_local_2);
        }

        public function onBtnVolUp(_arg_1:Event):*{
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onBtnVolMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onBtnVolUp);
        }

        public function pxToVol(_arg_1:Number):*{
            return (Math.min(Math.max(((_arg_1 - 120) / (190 - 120)), 0.1), 1));
        }

        public function volToPx(_arg_1:Number):*{
            _arg_1 = Math.max(Math.min(_arg_1, 1), 0);
            return (((190 - 120) * _arg_1) + 120);
        }

        public function onPowerEvt(_arg_1:Event):*{
            this.util.webRRef.power = (!(this.util.webRRef.power));
            this.util.update();
            this.updateUI();
        }

        public function updateUI():*{
            this.power_led.gotoAndStop(((this.util.webRRef.power) ? 2 : 1));
            this.btn_vol.x = this.volToPx(this.util.webRRef.volume);
        }

        public function init():void{
            this.win.addEventListener("onKill", this.onKill);
            this.updateUI();
        }

        public function onBtnCloseCLick(_arg_1:Event):void{
            this.win.close();
        }

        public function onKill(_arg_1:Event):*{
            this.onBtnVolUp(null);
        }

        public function stopDragEvt(_arg_1:MouseEvent):*{
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopDragEvt, false);
            this.win.stopDrag();
        }

        public function startDragEvt(_arg_1:MouseEvent):*{
            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragEvt, false, 0, true);
            this.win.startDrag();
        }

        private function setVolume(_arg_1:Number):*{
            _arg_1 = Math.min(Math.max(_arg_1, 0), 1);
            this.util.webRRef.volume = _arg_1;
            this.util.update();
            this.updateUI();
        }


    }
}//package chatbbl

