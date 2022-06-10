// version 467 by nota

//perso.WalkerPhysicEvent

package perso{
    import flash.events.Event;
    import engine.DDpoint;
    import engine.CollisionObject;
    import net.Binary;
	import perso.Walker;

    public class WalkerPhysicEvent extends Event {

        public var walker:*;
        public var lastColor:Number;
        public var newColor:Number;
        public var certified:Boolean;
        public var eventType:Number;
        public var lastSpeed:DDpoint;
        public var lastPosition:DDpoint;
        public var newSpeed:DDpoint;
        public var colData:CollisionObject;

        public function WalkerPhysicEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false){
            super(_arg_1, _arg_2, _arg_3);
            this.walker = null;
            this.lastColor = 0;
            this.newColor = 0;
            this.certified = false;
            this.eventType = 0;
            this.lastPosition = null;
            this.lastSpeed = null;
            this.newSpeed = null;
            this.colData = null;
        }

        public static function getEventFromMessage(_arg_1:Binary):WalkerPhysicEvent{
            var _local_2:* = "overLimit";
            var _local_3:uint = _arg_1.bitReadUnsignedInt(2);
            if (_local_3 == 1){
                _local_2 = "floorEvent";
            };
            if (_local_3 == 2){
                _local_2 = "environmentEvent";
            };
            if (_local_3 == 3){
                _local_2 = "interactivEvent";
            };
            var _local_4:* = new WalkerPhysicEvent(_local_2);
            _local_4.lastColor = _arg_1.bitReadUnsignedInt(24);
            _local_4.newColor = _arg_1.bitReadUnsignedInt(24);
            _local_4.eventType = _arg_1.bitReadUnsignedInt(8);
            _local_4.lastSpeed = new DDpoint();
            _local_4.lastSpeed.x = (_arg_1.bitReadSignedInt(18) / 10000);
            _local_4.lastSpeed.y = (_arg_1.bitReadSignedInt(18) / 10000);
            return (_local_4);
        }

        public static function getDefaultEvent(_arg_1:*, _arg_2:String):WalkerPhysicEvent{
            var _local_3:* = new WalkerPhysicEvent(_arg_2);
            _local_3.lastPosition = _arg_1.position.duplicate();
            _local_3.lastSpeed = _arg_1.speed.duplicate();
            _local_3.certified = ((_arg_1.clientControled) || (_arg_1.isCertified));
            _local_3.walker = _arg_1;
            return (_local_3);
        }


        public function exportEvent(_arg_1:Binary):*{
            var _local_2:uint;
            if (type == "floorEvent"){
                _local_2 = 1;
            };
            if (type == "environmentEvent"){
                _local_2 = 2;
            };
            if (type == "interactivEvent"){
                _local_2 = 3;
            };
            _arg_1.bitWriteUnsignedInt(2, _local_2);
            _arg_1.bitWriteUnsignedInt(24, this.lastColor);
            _arg_1.bitWriteUnsignedInt(24, this.newColor);
            _arg_1.bitWriteUnsignedInt(8, this.eventType);
            if (!this.lastSpeed){
                this.lastSpeed = new DDpoint();
            };
            _arg_1.bitWriteSignedInt(18, Math.round((this.lastSpeed.x * 10000)));
            _arg_1.bitWriteSignedInt(18, Math.round((this.lastSpeed.y * 10000)));
        }


    }
}//package perso

