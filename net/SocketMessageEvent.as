// version 467 by nota

//net.SocketMessageEvent

package net{
    import flash.events.Event;

    public class SocketMessageEvent extends Event {

        public var message:SocketMessage;

        public function SocketMessageEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
            this.message = new SocketMessage();
        }

        public function duplicate():SocketMessageEvent{
            var _local_1:SocketMessageEvent = new SocketMessageEvent(type, bubbles, cancelable);
            _local_1.message = this.message.duplicate();
            return (_local_1);
        }


    }
}//package net

