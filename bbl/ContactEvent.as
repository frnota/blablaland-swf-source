// version 467 by nota

//bbl.ContactEvent

package bbl{
    import flash.events.Event;

    public class ContactEvent extends Event {

        public var contact:Contact;

        public function ContactEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package bbl

