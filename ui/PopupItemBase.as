// version 467 by nota

//ui.PopupItemBase

package ui{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class PopupItemBase extends Sprite {

        public var depend:Object;
        public var title:String;
        public var id:String;
        public var pid:uint;
        public var data:Object;
        public var params:Object;
        public var closed:Boolean;
        public var system:Popup;
        public var toClose:Boolean;
        private var _width:Number;
        private var _height:Number;
        public var _lastX:Number;
        public var _lastY:Number;
        public var dragLimitMarge:uint;

        public function PopupItemBase(){
            this.closed = false;
            this.dragLimitMarge = 20;
            this.depend = null;
            this.toClose = false;
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent, false, 0, true);
        }

        public function mouseDownEvent(_arg_1:MouseEvent):*{
            this.setFocus();
        }

        public function cancelClose():*{
            this.toClose = false;
        }

        public function redraw():*{
            this.verifiPosition();
        }

        override public function startDrag(_arg_1:Boolean=false, _arg_2:Rectangle=null):void{
            this._lastX = (x - parent.mouseX);
            this._lastY = (y - parent.mouseY);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent, false, 0, true);
            this.dispatchEvent(new Event("onStartDrag"));
        }

        override public function stopDrag():void{
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent, false);
            this.dispatchEvent(new Event("onStopDrag"));
        }

        public function verifiPosition():*{
            var _local_1:* = new Rectangle(x, y, this.width, this.height);
            if (_local_1.right < (this.system.areaLimit.left + this.dragLimitMarge)){
                x = Math.round(((x + (this.system.areaLimit.left + this.dragLimitMarge)) - _local_1.right));
            };
            if (_local_1.left > (this.system.areaLimit.right - this.dragLimitMarge)){
                x = Math.round((x - (_local_1.left - (this.system.areaLimit.right - this.dragLimitMarge))));
            };
            if (_local_1.bottom < (this.system.areaLimit.top + this.dragLimitMarge)){
                y = Math.round(((y + (this.system.areaLimit.top + this.dragLimitMarge)) - _local_1.bottom));
            };
            if (_local_1.top > (this.system.areaLimit.bottom - this.dragLimitMarge)){
                y = Math.round((y - (_local_1.top - (this.system.areaLimit.bottom - this.dragLimitMarge))));
            };
        }

        public function moveEvent(_arg_1:MouseEvent):*{
            var _local_2:* = new Point();
            x = Math.round((parent.mouseX + this._lastX));
            y = Math.round((parent.mouseY + this._lastY));
            this.verifiPosition();
            _arg_1.updateAfterEvent();
        }

        public function setFocus():*{
            this.system.setFocus(this);
        }

        public function close():*{
            this.system.close(this);
        }

        public function kill():*{
            this.system.kill(this);
        }

        public function get focus():Boolean{
            return (this.system.getFocus() == this);
        }

        override public function get width():Number{
            return (this._width);
        }

        override public function set width(_arg_1:Number):void{
            this._width = _arg_1;
        }

        override public function get height():Number{
            return (this._height);
        }

        override public function set height(_arg_1:Number):void{
            this._height = _arg_1;
        }


    }
}//package ui

