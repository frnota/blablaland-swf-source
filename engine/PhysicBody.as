// version 467 by nota

//engine.PhysicBody

package engine{
    import flash.events.EventDispatcher;
    import bbl.GlobalProperties;
    import flash.events.Event;

    public class PhysicBody extends EventDispatcher {

        public var position:DDpoint;
        public var lastPosition:DDpoint;
        public var speed:DDpoint;
        public var map:Object;
        public var id:uint;
        private var _solid:Boolean;
        private var lastTime:uint;

        public function PhysicBody(){
            this.position = new DDpoint();
            this.position.init();
            this.lastPosition = new DDpoint();
            this.lastPosition.init();
            this.speed = new DDpoint();
            this.speed.init();
            this.lastTime = GlobalProperties.getTimer();
            this._solid = true;
            this.id = 0;
        }

        public function dispose():*{
            if (this.map){
                this.map.dispose();
            };
        }

        public function placeTo(_arg_1:Number, _arg_2:Number):*{
            this.position.x = _arg_1;
            this.position.y = _arg_2;
            this.lastPosition.x = _arg_1;
            this.lastPosition.y = _arg_2;
            this.speed.x = 0;
            this.speed.y = 0;
            this.lastTime = GlobalProperties.getTimer();
            if (this.solid){
                dispatchEvent(new Event("onMove"));
            };
        }

        public function moveTo(_arg_1:Number, _arg_2:Number):*{
            this.lastPosition.x = this.position.x;
            this.lastPosition.y = this.position.y;
            this.speed.x = ((_arg_1 - this.lastPosition.x) / (GlobalProperties.getTimer() - this.lastTime));
            this.speed.y = ((_arg_2 - this.lastPosition.y) / (GlobalProperties.getTimer() - this.lastTime));
            this.lastTime = GlobalProperties.getTimer();
            this.position.x = _arg_1;
            this.position.y = _arg_2;
            if (this.solid){
                dispatchEvent(new Event("onMove"));
            };
        }

        public function get solid():Boolean{
            return (this._solid);
        }

        public function set solid(_arg_1:Boolean):*{
            if (this._solid != _arg_1){
                this._solid = _arg_1;
                dispatchEvent(new Event("onChangedState"));
            };
        }


    }
}//package engine

