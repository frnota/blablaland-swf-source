// version 467 by nota

//engine.PhysicBodyEvent

package engine{
    import flash.events.Event;

    public class PhysicBodyEvent extends Event {

        public var body:PhysicBody;

        public function PhysicBodyEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package engine

