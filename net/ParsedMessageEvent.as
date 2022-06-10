// version 467 by nota

//net.ParsedMessageEvent

package net{
    import flash.events.Event;
    import bbl.GlobalProperties;

    public class ParsedMessageEvent extends Event {

        public var _message:SocketMessage;
        public var evtType:uint;
        public var evtStype:uint;

        public function ParsedMessageEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

        public function getMessage():SocketMessage{
            this._message.bitPosition = (GlobalProperties.BIT_TYPE + GlobalProperties.BIT_STYPE);
            return (this._message);
        }


    }
}//package net

