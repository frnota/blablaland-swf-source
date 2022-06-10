// version 467 by nota

//ui.Cursor

package ui{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.ui.Mouse;
    import flash.events.MouseEvent;

    public class Cursor extends Sprite {

        public var source:Class;
        public var cursor:MovieClip;
        public var referer:Object;
        public var cursorRefList:Array;

        public function Cursor(){
            this.cursorRefList = new Array();
            this.cursor = null;
            this.referer = null;
            this.mouseEnabled = false;
            this.mouseChildren = false;
        }

        public function removeCursor(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this.cursorRefList.length) {
                if (this.cursorRefList[_local_2][0] == _arg_1){
                    this.cursorRefList.splice(_local_2, 1);
                    this.updateCursor();
                    return;
                };
                _local_2++;
            };
        }

        public function updateCursor():*{
            var _local_1:MovieClip;
            var _local_2:Object;
            var _local_3:int = this.cursorRefList.length;
            if (_local_3){
                _local_2 = this.cursorRefList[(_local_3 - 1)][0];
                _local_1 = this.cursorRefList[(_local_3 - 1)][1];
            };
            if (((this.cursor) && (!(this.cursor == _local_1)))){
                Mouse.show();
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent, false);
                this.removeChild(this.cursor);
                this.cursor = null;
                this.referer = null;
            };
            if (((_local_1) && (!(this.cursor == _local_1)))){
                this.cursor = _local_1;
                this.referer = _local_2;
                addChild(this.cursor);
                Mouse.hide();
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveEvent, false, 0, true);
                this.moveEvent();
            };
        }

        public function addCursor(_arg_1:Object, _arg_2:MovieClip=null, _arg_3:uint=0):MovieClip{
            if (!_arg_2){
                _arg_2 = new this.source();
            };
            this.removeCursor(_arg_1);
            this.cursorRefList.push([_arg_1, _arg_2, _arg_3]);
            this.updateCursor();
            return (_arg_2);
        }

        public function moveEvent(_arg_1:MouseEvent=null):*{
            this.cursor.x = mouseX;
            this.cursor.y = mouseY;
            if (_arg_1){
                _arg_1.updateAfterEvent();
            };
        }


    }
}//package ui

