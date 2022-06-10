// version 467 by nota

//bbl.BblWebRadio

package bbl{
    import net.Client;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.Timer;
    import flash.events.Event;
    import net.SocketMessage;
    import flash.net.URLRequest;
    import flash.events.IOErrorEvent;
    import flash.media.SoundTransform;
    import net.SocketMessageEvent;

    public class BblWebRadio extends Client {

        private var _webRadioAllowed:Boolean;
        private var refList:Array;
        private var stream:Sound;
        private var streamChannel:SoundChannel;
        private var retryTimer:Timer;
        private var updateTimer:Timer;

        public function BblWebRadio(){
            this.stream = null;
            this.retryTimer = null;
            this.updateTimer = null;
            this.refList = new Array();
            this.webRadioAllowed = false;
            addEventListener("onGetPID", this.onWRGetPID);
            addEventListener("close", this.onWRCloseEvt);
        }

        public function setWRRefVolume(_arg_1:Object, _arg_2:Number):*{
            var _local_3:uint;
            while (_local_3 < this.refList.length) {
                if (this.refList[_local_3][0] == _arg_1){
                    this.refList[_local_3][1] = _arg_2;
                    this.updateVolume();
                    return;
                };
                _local_3++;
            };
        }

        public function haveWRRef(_arg_1:Object):Boolean{
            var _local_2:uint;
            while (_local_2 < this.refList.length) {
                if (this.refList[_local_2][0] == _arg_1){
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function removeWRRef(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this.refList.length) {
                if (this.refList[_local_2][0] == _arg_1){
                    this.refList[_local_2].splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
            this.updateVolume();
        }

        public function addWRRef(_arg_1:Object=null):Object{
            if (!_arg_1){
                _arg_1 = new Object();
            }
            else {
                if (this.haveWRRef(_arg_1)){
                    return (_arg_1);
                };
            };
            this.refList.push([_arg_1, 0]);
            return (_arg_1);
        }

        public function nextRetryTimerEvt(_arg_1:Event):*{
            this.retryTimer.stop();
            this.retryTimer = null;
            this.stopStream();
            this.updateVolume();
        }

        public function nextRetry(_arg_1:Event=null):*{
            if (!this.retryTimer){
                this.retryTimer = new Timer(2000);
                this.retryTimer.addEventListener("timer", this.nextRetryTimerEvt);
                this.retryTimer.start();
            };
        }

        private function stopStream():*{
            if (this.streamChannel){
                this.sendWRToServer(false);
                this.streamChannel.stop();
                this.streamChannel = null;
                try {
                    this.stream.close();
                }
                catch(err) {
                };
                this.stream = null;
            };
        }

        private function sendWRToServer(_arg_1:Boolean):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 17);
            _local_2.bitWriteUnsignedInt(8, 2);
            _local_2.bitWriteBoolean(_arg_1);
            send(_local_2);
        }

        private function updateVolume():*{
            if (!this.updateTimer){
                this.updateTimer = new Timer(200);
                this.updateTimer.addEventListener("timer", this.subUpdateVolume);
                this.updateTimer.start();
            };
        }

        private function subUpdateVolume(_arg_1:Event):*{
            if (this.updateTimer){
                this.updateTimer.stop();
                this.updateTimer = null;
            };
            var _local_2:Number = 0;
            var _local_3:uint;
            while (((_local_3 < this.refList.length) && (this.webRadioAllowed))) {
                if (_local_2 < this.refList[_local_3][1]){
                    _local_2 = this.refList[_local_3][1];
                };
                _local_3++;
            };
            if (((_local_2) && (!(this.stream)))){
                this.sendWRToServer(true);
                this.stream = new Sound(new URLRequest(("http://listen.radionomy.com/extradance?&lang=auto&codec=mp3&volume=100&introurl=&tracking=true&autoplay=true&jsevents=false&cache=" + new Date().getTime())));
                this.stream.addEventListener(IOErrorEvent.IO_ERROR, this.nextRetry);
                this.stream.addEventListener(Event.COMPLETE, this.nextRetry);
                this.streamChannel = this.stream.play();
                this.streamChannel.addEventListener(Event.SOUND_COMPLETE, this.nextRetry);
            }
            else {
                if (((_local_2 <= 0) && (this.stream))){
                    this.stopStream();
                };
            };
            if (((_local_2 > 0) && (this.stream))){
                this.streamChannel.soundTransform = new SoundTransform(_local_2);
            };
        }

        private function onWRGetPID(_arg_1:Event):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 17);
            _local_2.bitWriteUnsignedInt(8, 1);
            send(_local_2);
        }

        private function setWebRadioStatus(_arg_1:Boolean):*{
            if (((_arg_1) && (!(this.webRadioAllowed)))){
                this.webRadioAllowed = _arg_1;
                this.updateVolume();
                this.dispatchEvent(new Event("onWebRadioChanged"));
            }
            else {
                if (((!(_arg_1)) && (this.webRadioAllowed))){
                    this.webRadioAllowed = _arg_1;
                    this.updateVolume();
                    this.dispatchEvent(new Event("onWebRadioChanged"));
                };
            };
        }

        public function set webRadioAllowed(_arg_1:Boolean):*{
            this._webRadioAllowed = _arg_1;
        }

        public function get webRadioAllowed():Boolean{
            return (this._webRadioAllowed);
        }

        override public function parsedEventMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_4:int;
            if (_arg_1 == 1){
                if (_arg_2 == 17){
                    _local_4 = _arg_3.message.bitReadUnsignedInt(8);
                    if (_local_4 == 1){
                        this.setWebRadioStatus(_arg_3.message.bitReadBoolean());
                    };
                };
            };
            super.parsedEventMessage(_arg_1, _arg_2, _arg_3);
        }

        override public function close():void{
            this.onWRCloseEvt(null);
            super.close();
        }

        public function onWRCloseEvt(_arg_1:Event):*{
            this.setWebRadioStatus(false);
            if (this.retryTimer){
                this.retryTimer.stop();
                this.retryTimer = null;
            };
        }


    }
}//package bbl

