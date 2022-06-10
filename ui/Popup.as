// version 467 by nota

//ui.Popup

package ui{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.events.Event;

    public class Popup extends Sprite {

        public var itemList:Array;
        public var itemClass:Object;
        public var areaLimit:Rectangle;
        public var appearLimit:Rectangle;
        private var counter:Number;

        public function Popup(){
            this.itemList = new Array();
            this.counter = 0;
            this.itemClass = PopupItem;
            this.areaLimit = new Rectangle(0, 0, 550, 400);
            this.appearLimit = new Rectangle(0, 0, 500, 350);
        }

        public function close(_arg_1:PopupItemBase):*{
            if (_arg_1){
                if (!_arg_1.closed){
                    _arg_1.toClose = true;
                    _arg_1.dispatchEvent(new Event("onClose"));
                    if (_arg_1.toClose){
                        _arg_1.kill();
                    };
                };
            };
        }

        public function killAll():*{
            while (this.itemList.length) {
                this.kill(this.itemList[0]);
            };
        }

        public function kill(_arg_1:PopupItemBase):*{
            var _local_2:*;
            if (_arg_1){
                if (!_arg_1.closed){
                    _arg_1.dispatchEvent(new Event("onKill"));
                    _local_2 = 0;
                    while (_local_2 < this.itemList.length) {
                        if (this.itemList[_local_2] == _arg_1){
                            this.itemList.splice(_local_2, 1);
                            break;
                        };
                        _local_2++;
                    };
                    _arg_1.closed = true;
                    this.removeChild(_arg_1);
                    this.checkForDepend();
                    dispatchEvent(new Event("checkForDepend"));
                };
            };
        }

        public function checkForDepend():*{
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < this.itemList.length) {
                _local_2 = this.itemList[_local_1];
                if (((!(_local_2.depend === null)) && (stage))){
                    if (!stage.contains(_local_2.depend)){
                        _local_2.close();
                        if (this.itemList[_local_1] == _local_2){
                            _local_1--;
                        };
                    };
                };
                _local_1++;
            };
        }

        public function popupLinkEvent(_arg_1:Event):*{
            this.checkForDepend();
        }

        public function linkPopup(_arg_1:Popup):*{
            _arg_1.addEventListener("checkForDepend", this.popupLinkEvent, false, 0, true);
        }

        public function getFocus():PopupItemBase{
            if (!this.itemList.length){
                return (null);
            };
            return (this.itemList[(this.itemList.length - 1)]);
        }

        public function setFocus(_arg_1:PopupItemBase):*{
            var _local_2:* = null;
            var _local_3:* = 0;
            while (_local_3 < this.itemList.length) {
                if (this.itemList[_local_3] == _arg_1){
                    _local_2 = this.itemList[_local_3];
                    this.itemList.splice(_local_3, 1);
                    this.itemList.push(_local_2);
                    break;
                };
                _local_3++;
            };
            this.updateFocus();
        }

        public function getPopupById(_arg_1:String):Object{
            var _local_2:Object;
            var _local_3:* = 0;
            while (_local_3 < this.itemList.length) {
                if (this.itemList[_local_3].id == _arg_1){
                    return (this.itemList[_local_3]);
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function open(_arg_1:Object=null, _arg_2:Object=null):Object{
            if (!_arg_1){
                _arg_1 = new Object();
            };
            if (!_arg_1.ID){
                _arg_1.ID = this.counter.toString();
            };
            if (!_arg_1.CLASS){
                _arg_1.CLASS = this.itemClass;
            };
            var _local_3:* = this.getPopupById(_arg_1.ID);
            if (_local_3){
                _local_3.setFocus();
            }
            else {
                _local_3 = new _arg_1.CLASS();
                _local_3.data = _arg_2;
                _local_3.params = _arg_1;
                _local_3.id = _arg_1.ID;
                _local_3.pid = this.counter;
                _local_3.system = this;
                _local_3.width = ((_arg_1.WIDTH) ? _arg_1.WIDTH : 200);
                _local_3.height = ((_arg_1.HEIGHT) ? _arg_1.HEIGHT : 150);
                _local_3.depend = ((_arg_1.DEPEND) ? _arg_1.DEPEND : null);
                this.itemList.push(_local_3);
                addChild(_local_3);
                _local_3.title = ((_arg_1.TITLE) ? _arg_1.TITLE : "Display Popup");
                _local_3.x = Math.round(((Math.random() * this.appearLimit.width) + this.appearLimit.left));
                _local_3.y = Math.round(((Math.random() * this.appearLimit.height) + this.appearLimit.top));
                this.counter++;
            };
            _local_3.redraw();
            return (_local_3);
        }

        public function verifiPosition():*{
            var _local_1:* = 0;
            while (_local_1 < this.itemList.length) {
                this.itemList[_local_1].verifiPosition();
                _local_1++;
            };
        }

        public function updateFocus():*{
            while (this.numChildren) {
                this.removeChildAt(0);
            };
            var _local_1:* = 0;
            while (_local_1 < this.itemList.length) {
                addChild(this.itemList[_local_1]);
                _local_1++;
            };
        }


    }
}//package ui

