// version 467 by nota

//ui.ListGraphicEvent

package ui{
    import flash.events.Event;

    public class ListGraphicEvent extends Event {

        public var graphic:ListGraphic;
        public var text:String;

        public function ListGraphicEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package ui

