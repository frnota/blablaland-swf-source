// version 467 by nota

//ui.ListGraphic

package ui{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.events.TextEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class ListGraphic extends Sprite {

        public var node:ListTreeNode;
        public var fond:MovieClip;
        public var content:Object;
        public var system:List;
        public var screenIndex:Number;
        public var visibleIndex:Number;
        private var pX:Number;
        private var pY:Number;
        private var dragging:Boolean;
        private var iconMouse:Boolean;
        private var _stage:Stage;

        public function ListGraphic(){
            this.node = null;
            this.iconMouse = false;
            this.content.icon.stop();
            this.content.text.addEventListener(TextEvent.LINK, this._linkEvent, false, 0, true);
            this.content.text.mouseEnabled = false;
            this.buttonMode = true;
            this.addEventListener(MouseEvent.ROLL_OVER, this._onRollOver, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, this._onRollOut, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_DOWN, this._onPress, false, 0, true);
            this.content.icon.addEventListener(MouseEvent.MOUSE_DOWN, this._iconEvt, false, 0, true);
            this.content.icon.addEventListener("click", this._onClickIcon, false, 0, true);
        }

        public function _linkEvent(_arg_1:TextEvent):*{
            var _local_2:* = new ListGraphicEvent("onTextClick");
            _local_2.graphic = this;
            _local_2.text = _arg_1.text;
            this.system.dispatchEvent(_local_2);
        }

        public function _iconEvt(_arg_1:Event):*{
            if (!this._stage){
                this._stage = stage;
            };
            this.iconMouse = (!(this.iconMouse));
            if (this.iconMouse){
                this._stage.addEventListener(MouseEvent.MOUSE_UP, this._iconEvt, false, 0, true);
            }
            else {
                this._stage.removeEventListener(MouseEvent.MOUSE_UP, this._iconEvt);
            };
        }

        public function _onClickIcon(_arg_1:Event):*{
            var _local_2:* = new ListGraphicEvent("onIconClick");
            _local_2.graphic = this;
            this.system.dispatchEvent(_local_2);
        }

        public function _onRollOver(_arg_1:Event=null):*{
            this.fond.gotoAndStop("OVER");
        }

        public function _onRollOut(_arg_1:Event=null):*{
            if (!this.node){
                this.fond.gotoAndStop("UP");
            }
            else {
                this.fond.gotoAndStop(((this.node.selected) ? "SELECTED" : "UP"));
            };
        }

        public function _onRelease(_arg_1:Event=null):*{
            if (!this._stage){
                this._stage = stage;
            };
            this._stage.removeEventListener(MouseEvent.MOUSE_UP, this._onReleaseOutside, false);
            this.removeEventListener(MouseEvent.MOUSE_UP, this._onRelease, false);
            var _local_2:* = new ListGraphicEvent("onClick");
            _local_2.graphic = this;
            this.system.dispatchEvent(_local_2);
        }

        public function _onPress(_arg_1:Event=null):*{
            if (!this._stage){
                this._stage = stage;
            };
            if (!this.iconMouse){
                this.pX = this.system.mouseX;
                this.pY = this.system.mouseY;
                this._stage.addEventListener(MouseEvent.MOUSE_UP, this._onReleaseOutside, false, 0, true);
                this.addEventListener(MouseEvent.MOUSE_UP, this._onRelease, false, 0, true);
            };
        }

        public function _onReleaseOutside(_arg_1:Event=null):*{
            if (!this._stage){
                this._stage = stage;
            };
            this._stage.removeEventListener(MouseEvent.MOUSE_UP, this._onReleaseOutside, false);
            this.fond.removeEventListener(MouseEvent.MOUSE_UP, this._onRelease, false);
            this._onRollOut();
        }

        public function redraw():*{
            var _local_1:* = this.node.getLevel();
            this.content.text.styleSheet = this.node.styleSheet;
            this.content.text.htmlText = this.node.text;
            this.content.icon.gotoAndStop(((this.node.icon) ? this.node.icon : 1));
            this._onRollOut();
            this.content.x = (_local_1 * 10);
        }


    }
}//package ui

