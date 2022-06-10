// version 467 by nota

//ui.RectArea

package ui{
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    public class RectArea extends Sprite {

        public var masque:Shape;
        public var content:Sprite;
        public var mouseBorderMarge:Number;
        public var scrollSpeed:Number;
        private var _scrollControlH:uint;
        private var _scrollControlV:uint;
        private var _contentWidth:Number;
        private var _contentHeight:Number;
        private var _areaWidth:Number;
        private var _areaHeight:Number;

        public function RectArea(){
            this.scrollSpeed = 8;
            this.mouseBorderMarge = 20;
            this.scrollControlH = 1;
            this.scrollControlV = 1;
            this.masque = new Shape();
            addChild(this.masque);
            this.content = new Sprite();
            addChild(this.content);
            this.content.mask = this.masque;
            this.contentWidth = 200;
            this.contentHeight = 200;
            this._areaWidth = 100;
            this._areaHeight = 100;
            this.updateMasque();
            this.addEventListener(Event.ADDED_TO_STAGE, this.updateScrollMode, false, 0, true);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.updateScrollMode, false, 0, true);
        }

        public function updateScrollMode(_arg_1:Event=null):*{
            if (stage){
                if (!_arg_1){
                    _arg_1 = new Event("vide");
                };
                if (((this.scrollControlH == 0) || (_arg_1.type == Event.REMOVED_FROM_STAGE))){
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMove);
                    removeEventListener("enterFrame", this.enterFrameEvt, false);
                }
                else {
                    if (this.scrollControlH == 1){
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMove, false, 0, true);
                        removeEventListener("enterFrame", this.enterFrameEvt, false);
                    }
                    else {
                        if (this.scrollControlH == 2){
                            addEventListener("enterFrame", this.enterFrameEvt, false, 0, true);
                            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMove);
                        };
                    };
                };
                if (((this.scrollControlV == 0) || (_arg_1.type == Event.REMOVED_FROM_STAGE))){
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMove);
                    removeEventListener("enterFrame", this.enterFrameEvt, false);
                }
                else {
                    if (this.scrollControlV == 1){
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMove, false, 0, true);
                        removeEventListener("enterFrame", this.enterFrameEvt, false);
                    }
                    else {
                        if (this.scrollControlV == 2){
                            addEventListener("enterFrame", this.enterFrameEvt, false, 0, true);
                            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMove);
                        };
                    };
                };
            };
        }

        public function centerToPoint(_arg_1:Number, _arg_2:Number):*{
            this.contentX = -(_arg_1 - (this.areaWidth / 2));
            this.contentY = -(_arg_2 - (this.areaHeight / 2));
        }

        public function replaceInside():*{
            this.contentX = Math.min(Math.max(this.contentX, -(Math.max((this.contentWidth - this.areaWidth), 0))), 0);
            this.contentY = Math.min(Math.max(this.contentY, -(Math.max((this.contentHeight - this.areaHeight), 0))), 0);
        }

        public function showRectangle(_arg_1:Rectangle):*{
            if (-(this.contentX) > _arg_1.left){
                this.contentX = -(_arg_1.left);
            }
            else {
                if ((-(this.contentX) + this.areaWidth) < _arg_1.right){
                    this.contentX = -(_arg_1.right - this.areaWidth);
                };
            };
            if (-(this.contentY) > _arg_1.top){
                this.contentY = -(_arg_1.top);
            }
            else {
                if ((-(this.contentY) + this.areaHeight) < _arg_1.bottom){
                    this.contentY = (-(_arg_1.bottom) + this.areaHeight);
                };
            };
        }

        public function showPoint(_arg_1:Number, _arg_2:Number):*{
            if (-(this.contentX) > _arg_1){
                this.contentX = -(_arg_1);
            }
            else {
                if ((-(this.contentX) + this.areaWidth) < _arg_1){
                    this.contentX = -(_arg_1 - this.areaWidth);
                };
            };
            if (-(this.contentY) > _arg_2){
                this.contentY = -(_arg_2);
            }
            else {
                if ((-(this.contentY) + this.areaHeight) < _arg_2){
                    this.contentY = (-(_arg_2) + this.areaHeight);
                };
            };
        }

        public function scrollToX(_arg_1:Number):*{
            this.contentX = (-(Math.max((this.contentWidth - this.areaWidth), 0)) * _arg_1);
        }

        public function scrollToY(_arg_1:Number):*{
            this.contentY = (-(Math.max((this.contentHeight - this.areaHeight), 0)) * _arg_1);
        }

        public function onMove(_arg_1:MouseEvent):*{
            if (((((mouseX >= 0) && (mouseX <= this.areaWidth)) && (mouseY >= 0)) && (mouseY <= this.areaHeight))){
                this.updateSceneByMouse();
            };
        }

        public function updateSceneByMouse():*{
            if (this.scrollControlH){
                this.scrollToX(Math.max(Math.min(((mouseX - this.mouseBorderMarge) / (this.areaWidth - (2 * this.mouseBorderMarge))), 1), 0));
            };
            if (this.scrollControlV){
                this.scrollToY(Math.max(Math.min(((mouseY - this.mouseBorderMarge) / (this.areaHeight - (2 * this.mouseBorderMarge))), 1), 0));
            };
        }

        public function enterFrameEvt(_arg_1:Event):*{
            var _local_2:Boolean;
            var _local_3:Number;
            if (((((mouseX >= 0) && (mouseX <= this.areaWidth)) && (mouseY >= 0)) && (mouseY <= this.areaHeight))){
                _local_2 = false;
                if (((this.scrollControlH == 2) && ((mouseX <= this.mouseBorderMarge) || (mouseX >= (this.areaWidth - this.mouseBorderMarge))))){
                    _local_2 = true;
                    if ((mouseX > (this.areaWidth / 2))){
                        _local_3 = (this.contentX - (this.scrollSpeed * Math.pow((1 - ((this.areaWidth - mouseX) / this.mouseBorderMarge)), 0.5)));
                    }
                    else {
                        _local_3 = (this.contentX + (this.scrollSpeed * Math.pow((1 - (mouseX / this.mouseBorderMarge)), 0.5)));
                    };
                    this.contentX = Math.min(Math.max(_local_3, -(Math.max((this.contentWidth - this.areaWidth), 0))), 0);
                };
                if (((this.scrollControlV == 2) && ((mouseY <= this.mouseBorderMarge) || (mouseY >= (this.areaHeight - this.mouseBorderMarge))))){
                    _local_2 = true;
                    if ((mouseY > (this.areaHeight / 2))){
                        _local_3 = (this.contentY - (this.scrollSpeed * Math.pow((1 - ((this.areaHeight - mouseY) / this.mouseBorderMarge)), 0.5)));
                    }
                    else {
                        _local_3 = (this.contentY + (this.scrollSpeed * Math.pow((1 - (mouseY / this.mouseBorderMarge)), 0.5)));
                    };
                    this.contentY = Math.min(Math.max(_local_3, -(Math.max((this.contentHeight - this.areaHeight), 0))), 0);
                };
            };
        }

        public function resetPosition():*{
            this.contentX = 0;
            this.contentY = 0;
        }

        public function clearContent():*{
            while (this.content.numChildren) {
                this.content.removeChildAt(0);
            };
        }

        private function updateMasque():*{
            this.masque.graphics.clear();
            this.masque.graphics.lineStyle(1, 0, 1);
            this.masque.graphics.beginFill(0, 1);
            this.masque.graphics.lineTo(this._areaWidth, 0);
            this.masque.graphics.lineTo(this._areaWidth, this._areaHeight);
            this.masque.graphics.lineTo(0, this._areaHeight);
            this.masque.graphics.lineTo(0, 0);
            this.masque.graphics.endFill();
        }

        public function set scrollControl(_arg_1:uint):*{
            this.scrollControlH = _arg_1;
            this.scrollControlV = _arg_1;
        }

        private function set contentX(_arg_1:Number):*{
            _arg_1 = Math.round(_arg_1);
            if (this.content.x != _arg_1){
                this.content.x = _arg_1;
            };
        }

        private function get contentX():Number{
            return (this.content.x);
        }

        private function set contentY(_arg_1:Number):*{
            _arg_1 = Math.round(_arg_1);
            if (this.content.y != _arg_1){
                this.content.y = _arg_1;
            };
        }

        private function get contentY():Number{
            return (this.content.y);
        }

        public function set areaWidth(_arg_1:Number):*{
            this._areaWidth = _arg_1;
            this.updateMasque();
        }

        public function get areaWidth():Number{
            return (this._areaWidth);
        }

        public function set areaHeight(_arg_1:Number):*{
            this._areaHeight = _arg_1;
            this.updateMasque();
        }

        public function get areaHeight():Number{
            return (this._areaHeight);
        }

        public function set scrollControlH(_arg_1:Number):*{
            this._scrollControlH = _arg_1;
            this.updateScrollMode();
        }

        public function get scrollControlH():Number{
            return (this._scrollControlH);
        }

        public function set scrollControlV(_arg_1:Number):*{
            this._scrollControlV = _arg_1;
            this.updateScrollMode();
        }

        public function get scrollControlV():Number{
            return (this._scrollControlV);
        }

        public function set contentWidth(_arg_1:Number):*{
            this._contentWidth = _arg_1;
        }

        public function get contentWidth():Number{
            return (this._contentWidth);
        }

        public function set contentHeight(_arg_1:Number):*{
            this._contentHeight = _arg_1;
        }

        public function get contentHeight():Number{
            return (this._contentHeight);
        }


    }
}//package ui

