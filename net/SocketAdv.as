// version 467 by nota

//net.SocketAdv

package net{
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.system.Security;

    public class SocketAdv extends Socket {

        private var inBuffer:ByteArray;
        private var inCmpt:uint;
        private var outCmpt:uint;
        private var flushTimer:Timer;
        private var keepAliveTimer:Timer;

        public function SocketAdv(){
            addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
            this.inBuffer = new ByteArray();
            this.flushTimer = new Timer(1);
            this.flushTimer.addEventListener("timer", this.flushEvent, false, 0, true);
            this.keepAliveTimer = new Timer(20000);
            this.keepAliveTimer.addEventListener("timer", this.keepAliveTimerEvt, false, 0, true);
        }

        public function keepAliveTimerEvt(_arg_1:Event):*{
            var _local_2:*;
            if (connected){
                _local_2 = new SocketMessage();
                this.send(_local_2);
            };
        }

        public function flushEvent(_arg_1:Event):*{
            if (connected){
                this.flush();
            };
            this.flushTimer.stop();
        }

        public function send(_arg_1:SocketMessage, _arg_2:Boolean=false):*{
            var _local_3:*;
            var _local_4:*;
            if (connected){
                this.keepAliveTimer.reset();
                this.keepAliveTimer.start();
                this.outCmpt++;
                if (this.outCmpt >= 65530){
                    this.outCmpt = 12;
                };
                _local_3 = new SocketMessage();
                _local_3.bitWriteUnsignedInt(16, this.outCmpt);
                _local_4 = _local_3.exportMessage();
                this.writeBytes(_local_4);
                _local_4 = _arg_1.exportMessage();
                this.writeBytes(_local_4);
                this.writeByte(0);
                if (_arg_2){
                    this.flush();
                }
                else {
                    this.flushTimer.start();
                };
            };
        }

        override public function close():void{
            if (connected){
                super.close();
            };
        }

        override public function connect(_arg_1:String, _arg_2:int):void{
            this.inCmpt = 12;
            this.outCmpt = 12;
            this.inBuffer = new ByteArray();
            Security.loadPolicyFile(((("xmlsocket://" + _arg_1) + ":") + _arg_2));
            super.connect(_arg_1, _arg_2);
        }

        public function eventMessage(_arg_1:SocketMessageEvent):*{
            dispatchEvent(_arg_1);
        }

        public function socketDataHandler(_arg_1:ProgressEvent):*{
            var _local_4:uint;
            var _local_5:*;
            var _local_6:*;
            var _local_2:* = this.bytesAvailable;
            var _local_3:* = 0;
            while (((_local_3 < _local_2) && (connected))) {
                _local_4 = this.readByte();
                if (_local_4 == 0){
                    this.inCmpt++;
                    if (this.inCmpt >= 65530){
                        this.inCmpt = 12;
                    };
                    _local_5 = new SocketMessage();
                    _local_5.readMessage(this.inBuffer);
                    _local_4 = _local_5.bitReadUnsignedInt(16);
                    if (!((_local_4 < this.inCmpt) || (_local_4 > (this.inCmpt + 20)))){
                        _local_6 = new SocketMessageEvent("onMessage", true, true);
                        _local_6.message.writeBytes(_local_5, 2, 0);
                        _local_6.message.bitLength = (_local_6.message.length * 8);
                        this.eventMessage(_local_6);
                        this.inBuffer = new ByteArray();
                    };
                }
                else {
                    this.inBuffer.writeByte(_local_4);
                };
                _local_3++;
            };
        }


    }
}//package net

