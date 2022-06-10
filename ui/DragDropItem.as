// version 467 by nota

//ui.DragDropItem

package ui{
    import flash.events.EventDispatcher;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    public class DragDropItem extends EventDispatcher {

        public var system:DragDrop;
        public var data:Object;
        public var overTarget:Boolean;
        public var isTarget:Boolean;
        private var _targetSprite:DisplayObject;

        public function DragDropItem(){
            this.data = new Object();
            this.isTarget = false;
            this.overTarget = false;
        }

        public function testDrag():Array{
            return (this.system.testDrag(this));
        }

        public function dispose():*{
            this.system.removeItem(this);
        }

        public function onTargetOver(_arg_1:MouseEvent):*{
            this.overTarget = true;
        }

        public function onTargetOut(_arg_1:MouseEvent):*{
            this.overTarget = false;
        }

        public function get targetSprite():DisplayObject{
            return (this._targetSprite);
        }

        public function set targetSprite(_arg_1:DisplayObject):*{
            if (((this._targetSprite) && (!(_arg_1 == this._targetSprite)))){
                _arg_1.removeEventListener(MouseEvent.MOUSE_OVER, this.onTargetOver, false);
                _arg_1.removeEventListener(MouseEvent.MOUSE_OUT, this.onTargetOut, false);
                this.overTarget = false;
            };
            if (((!(this._targetSprite)) && (_arg_1))){
                _arg_1.addEventListener(MouseEvent.MOUSE_OVER, this.onTargetOver, false, 0, true);
                _arg_1.addEventListener(MouseEvent.MOUSE_OUT, this.onTargetOut, false, 0, true);
            };
            this._targetSprite = _arg_1;
        }


    }
}//package ui

