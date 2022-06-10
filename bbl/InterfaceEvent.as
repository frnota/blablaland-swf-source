// version 467 by nota

//bbl.InterfaceEvent

package bbl{
    import flash.events.Event;

    public class InterfaceEvent extends Event {

        public var transmitTalk:Boolean = true;
        public var transmitInterface:Boolean = true;
        public var valide:Boolean = false;
        public var actionList:Array = null;
        public var text:String = "";
        public var pseudo:String = "";
        public var action:String = "";
        public var pid:uint = 0;
        public var uid:uint = 0;
        public var serverId:uint = 0;

        public function InterfaceEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
        }

        override public function stopImmediatePropagation():void{
            this.valide = true;
            super.stopImmediatePropagation();
        }


    }
}//package bbl

