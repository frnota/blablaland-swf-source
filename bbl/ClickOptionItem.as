// version 467 by nota

//bbl.ClickOptionItem

package bbl{
    import flash.events.EventDispatcher;
    import flash.display.DisplayObject;

    public class ClickOptionItem extends EventDispatcher {

        public var visible:Boolean;
        public var clip:DisplayObject;
        public var clipWidth:uint;
        public var clipHeight:uint;
        public var parent:ClickOptionItem;
        public var root:ClickOptionItem;
        public var data:Object;
        public var childList:Array;

        public function ClickOptionItem(){
            this.data = new Object();
            this.root = this;
            this.parent = null;
            this.visible = true;
            this.childList = new Array();
            this.clipWidth = 53;
            this.clipHeight = 21;
        }

        public function removeChild(_arg_1:ClickOptionItem):*{
            var _local_2:uint;
            while (_local_2 < this.childList.length) {
                if (this.childList[_local_2] == _arg_1){
                    _arg_1.parent = null;
                    _arg_1.root = null;
                    this.childList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function addChild(_arg_1:ClickOptionItem=null):*{
            if (!_arg_1){
                _arg_1 = new ClickOptionItem();
            };
            _arg_1.parent = this;
            _arg_1.root = this.root;
            this.childList.push(_arg_1);
            return (_arg_1);
        }


    }
}//package bbl

