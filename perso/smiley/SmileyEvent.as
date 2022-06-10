// version 467 by nota

//perso.smiley.SmileyEvent

package perso.smiley{
    import flash.events.Event;
    import net.Binary;

    public class SmileyEvent extends Event {

        public var packId:uint;
        public var smileyId:uint;
        public var data:Binary = new Binary();
        public var playLocal:Boolean = true;
        public var playCallBack:Boolean = false;

        public function SmileyEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package perso.smiley

