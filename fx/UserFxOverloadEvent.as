// version 467 by nota

//fx.UserFxOverloadEvent

package fx{
    import flash.events.Event;
    import net.Binary;

    public class UserFxOverloadEvent extends Event {

        public var data:Binary = new Binary();
        public var uol:UserFxOverloadItem = null;
        public var walker:UserFx = null;

        public function UserFxOverloadEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package fx

