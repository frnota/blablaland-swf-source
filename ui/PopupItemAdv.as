// version 467 by nota

//ui.PopupItemAdv

package ui{
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.events.Event;

    public class PopupItemAdv extends PopupItem {

        public var titlePanel:ResizeableArea;
        public var titleText:TextField;
        public var btClose:SimpleButton;
        public var resizer:SimpleButton;

        public function PopupItemAdv(){
            this.titlePanel.source.gotoAndStop("titlePanel");
            if (this.btClose){
                this.btClose.addEventListener(MouseEvent.CLICK, this.btCloseEvent, false, 0, true);
            };
            if (this.resizer){
                this.resizer.visible = false;
                this.resizer.addEventListener(MouseEvent.MOUSE_DOWN, this.startResizeEvent, false, 0, true);
            };
            this.titlePanel.addEventListener(MouseEvent.MOUSE_DOWN, this.startDragEvt, false, 0, true);
            this.titlePanel.buttonMode = true;
        }

        public function btCloseEvent(_arg_1:MouseEvent):*{
            close();
        }

        override public function redraw():*{
            this.titlePanel.x = 0;
            this.titlePanel.y = 3;
            this.titlePanel.width = width;
            this.titlePanel.height = 11;
            this.titlePanel.redraw();
            this.titleText.text = title;
            this.titleText.mouseEnabled = false;
            this.titleText.width = (width - 17);
            if (this.resizer){
                this.resizer.x = (width - 10);
                this.resizer.y = (height + 10);
            };
            if (this.btClose){
                this.btClose.x = (width - 15);
                this.btClose.y = 1.5;
            }
            else {
                width--;
            };
            fontPanel.width = width;
            fontPanel.height = (height + 20);
            fontPanel.filters = [new DropShadowFilter(5, 45, 0, 1, 20, 20, 0.5, 2)];
            fontPanel.redraw();
            this.verifiPosition();
        }

        public function startResizeEvent(_arg_1:MouseEvent):*{
            _lastX = (width - parent.mouseX);
            _lastY = (height - parent.mouseY);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.resizeMoveEvent, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopResizeEvent, false, 0, true);
        }

        public function stopResizeEvent(_arg_1:MouseEvent):*{
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopResizeEvent, false);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.resizeMoveEvent, false);
        }

        public function resizeMoveEvent(_arg_1:MouseEvent):*{
            var _local_2:Number = (parent.mouseX + _lastX);
            var _local_3:Number = (parent.mouseY + _lastY);
            if (_local_2 < 30){
                _local_2 = 30;
            };
            if (_local_3 < 30){
                _local_3 = 30;
            };
            width = _local_2;
            height = _local_3;
            this.dispatchEvent(new Event("onResized"));
            this.redraw();
            _arg_1.updateAfterEvent();
        }

        public function stopDragEvt(_arg_1:MouseEvent):*{
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopDragEvt, false);
            stopDrag();
        }

        public function startDragEvt(_arg_1:MouseEvent):*{
            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopDragEvt, false, 0, true);
            startDrag();
        }

        override public function verifiPosition():*{
            var _local_1:* = this.titlePanel.getBounds(parent);
            if (this.btClose){
                _local_1.right = (_local_1.right - 10);
            };
            if (_local_1.right < (system.areaLimit.left + dragLimitMarge)){
                x = Math.round(((x + (system.areaLimit.left + dragLimitMarge)) - _local_1.right));
            };
            if (_local_1.left > (system.areaLimit.right - dragLimitMarge)){
                x = Math.round((x - (_local_1.left - (system.areaLimit.right - dragLimitMarge))));
            };
            if (_local_1.bottom < (system.areaLimit.top + dragLimitMarge)){
                y = Math.round(((y + (system.areaLimit.top + dragLimitMarge)) - _local_1.bottom));
            };
            if (_local_1.top > (system.areaLimit.bottom - dragLimitMarge)){
                y = Math.round((y - (_local_1.top - (system.areaLimit.bottom - dragLimitMarge))));
            };
        }


    }
}//package ui

