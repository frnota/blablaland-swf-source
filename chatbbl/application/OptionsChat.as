// version 467 by nota

//chatbbl.application.OptionsChat

package chatbbl.application{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import ui.ValueSelector;
    import flash.text.TextField;
    import ui.CheckBox;
    import flash.events.Event;
    import chatbbl.Chat;
    import chatbbl.GlobalChatProperties;
    import bbl.CameraMapControl;

    public class OptionsChat extends MovieClip {

        public var bt_autodetect:SimpleButton;
        public var vs_qgraph:ValueSelector;
        public var vs_rain:ValueSelector;
        public var vs_move:ValueSelector;
        public var vs_volume:ValueSelector;
        public var vs_volume_amb:ValueSelector;
        public var vs_volume_action:ValueSelector;
        public var vs_volume_interface:ValueSelector;
        public var txt_power:TextField;
        public var ch_scroll:CheckBox;

        public function OptionsChat(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.removeEventListener(Event.ADDED, this.init, false);
                parent.width = 240;
                parent.height = 285;
                Object(parent).redraw();
                this.bt_autodetect.addEventListener("click", this.onUserAutoDetect, false, 0, true);
                this.ch_scroll.addEventListener("onChanged", this.onUserChange, false, 0, true);
                this.vs_rain.addEventListener("onFixed", this.onUserChange, false, 0, true);
                this.vs_move.addEventListener("onFixed", this.onUserChange, false, 0, true);
                this.vs_qgraph.addEventListener("onFixed", this.onUserChange, false, 0, true);
                this.vs_volume.addEventListener("onChanged", this.onUserChange, false, 0, true);
                this.vs_volume_amb.addEventListener("onChanged", this.onUserChange, false, 0, true);
                this.vs_volume_action.addEventListener("onChanged", this.onUserChange, false, 0, true);
                this.vs_volume_interface.addEventListener("onChanged", this.onUserChange, false, 0, true);
                this.vs_qgraph.maxValue = 3;
                this.vs_qgraph.minValue = 1;
                this.vs_move.maxValue = 5;
                this.vs_move.minValue = 1;
                this.vs_rain.maxValue = 5;
                this.vs_rain.minValue = 1;
                this.vs_volume.maxValue = 100;
                this.vs_volume.minValue = 0;
                this.vs_volume_amb.maxValue = 100;
                this.vs_volume_amb.minValue = 0;
                this.vs_volume_action.maxValue = 100;
                this.vs_volume_action.minValue = 0;
                this.vs_volume_interface.maxValue = 100;
                this.vs_volume_interface.minValue = 0;
                this.readQuality();
            };
        }

        public function onUserAutoDetect(_arg_1:Event):*{
            var _local_2:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
            _local_2.quality.autoDetect();
            Chat(GlobalChatProperties.chat).addDebug(("AutoDetectQuality Value : " + _local_2.quality.lastPowerTest));
            Chat(GlobalChatProperties.chat).addStats(0, _local_2.quality.lastPowerTest.toString());
            this.txt_power.text = _local_2.quality.lastPowerTest.toString();
            this.readQuality();
        }

        public function onUserChange(_arg_1:Event):*{
            var _local_2:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
            if (_arg_1.currentTarget == this.ch_scroll){
                _local_2.quality.scrollMode = Number(this.ch_scroll.value);
            };
            if (_arg_1.currentTarget == this.vs_rain){
                _local_2.quality.rainRateQuality = this.vs_rain.value;
            };
            if (_arg_1.currentTarget == this.vs_qgraph){
                _local_2.quality.graphicQuality = this.vs_qgraph.value;
            };
            if (_arg_1.currentTarget == this.vs_move){
                _local_2.quality.persoMoveQuality = this.vs_move.value;
            };
            if (_arg_1.currentTarget == this.vs_volume){
                _local_2.quality.generalVolume = (this.vs_volume.value / 100);
            };
            if (_arg_1.currentTarget == this.vs_volume_amb){
                _local_2.quality.ambiantVolume = (this.vs_volume_amb.value / 100);
            };
            if (_arg_1.currentTarget == this.vs_volume_interface){
                _local_2.quality.interfaceVolume = (this.vs_volume_interface.value / 100);
            };
            if (_arg_1.currentTarget == this.vs_volume_action){
                _local_2.quality.actionVolume = (this.vs_volume_action.value / 100);
            };
        }

        internal function readQuality():*{
            var _local_1:CameraMapControl = Chat(GlobalChatProperties.chat).camera;
            this.ch_scroll.value = (_local_1.quality.scrollMode == 1);
            this.vs_qgraph.value = _local_1.quality.graphicQuality;
            this.vs_rain.value = _local_1.quality.rainRateQuality;
            this.vs_move.value = _local_1.quality.persoMoveQuality;
            this.vs_volume.value = (_local_1.quality.generalVolume * 100);
            this.vs_volume_amb.value = (_local_1.quality.ambiantVolume * 100);
            this.vs_volume_interface.value = (_local_1.quality.interfaceVolume * 100);
            this.vs_volume_action.value = (_local_1.quality.actionVolume * 100);
        }


    }
}//package chatbbl.application

