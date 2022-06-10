// version 467 by nota

//bbl.ClickOptionPopup

package bbl{
    import ui.PopupItemBase;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class ClickOptionPopup extends PopupItemBase {

        private var screenXmarge:int;
        private var screenYmarge:int;
        private var spaceXmarge:int;
        private var spaceYmarge:int;
        private var subMenuList:Array;
        private var optionItem:ClickOptionItem;
        private var xSens:Boolean;

        public function ClickOptionPopup(){
            addEventListener("onClose", this.onClose, false, 0, true);
            this.screenXmarge = 10;
            this.screenYmarge = 0;
            this.spaceXmarge = 5;
            this.spaceYmarge = 2;
            this.subMenuList = new Array();
            this.xSens = true;
            this.addEventListener(Event.ADDED, this.init, false);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.removeEventListener(Event.ADDED, this.init, false);
                this.optionItem = data["OPTIONLIST"];
                this.insertMenu(this, this.optionItem);
                this.setClipEvent(true, this.optionItem);
            };
        }

        public function onClose(_arg_1:Event):*{
            removeEventListener("enterFrame", this.enterFrame, false);
            this.setClipEvent(false, this.optionItem);
        }

        public function setClipEvent(_arg_1:Boolean, _arg_2:ClickOptionItem):*{
            var _local_3:uint;
            if (((_arg_2.clip) && (_arg_1))){
                _arg_2.clip.addEventListener("click", this.onClipClick, false);
            }
            else {
                if (((_arg_2.clip) && (!(_arg_1)))){
                    _arg_2.clip.removeEventListener("click", this.onClipClick, false);
                };
            };
            while (_local_3 < _arg_2.childList.length) {
                this.setClipEvent(_arg_1, _arg_2.childList[_local_3]);
                _local_3++;
            };
        }

        public function onClipClick(_arg_1:Event):*{
            var _local_3:Event;
            var _local_2:ClickOptionItem = this.getOptionByClip(DisplayObject(_arg_1.currentTarget), this.optionItem);
            if (_local_2){
                _local_3 = new Event("click");
                _local_2.dispatchEvent(_local_3);
                if (_local_2.childList.length){
                    this.addSubMenu(_local_2);
                }
                else {
                    close();
                };
            };
        }

        public function getOptionByClip(_arg_1:DisplayObject, _arg_2:ClickOptionItem):ClickOptionItem{
            var _local_3:uint;
            var _local_4:ClickOptionItem;
            if (_arg_2.clip == _arg_1){
                return (_arg_2);
            };
            while (_local_3 < _arg_2.childList.length) {
                _local_4 = this.getOptionByClip(_arg_1, _arg_2.childList[_local_3]);
                if (_local_4){
                    return (_local_4);
                };
                _local_3++;
            };
            return (null);
        }

        public function insertMenu(_arg_1:Sprite, _arg_2:ClickOptionItem):*{
            var _local_3:int;
            var _local_4:uint;
            var _local_5:Event;
            var _local_6:DisplayObject;
            _local_3 = 0;
            while (_local_4 < _arg_2.childList.length) {
                _local_5 = new Event("onPrepare");
                _arg_2.childList[_local_4].dispatchEvent(_local_5);
                if (((_arg_2.childList[_local_4].visible) && (!(_arg_2.childList[_local_4].data.hideForSelf)))){
                    _local_6 = _arg_2.childList[_local_4].clip;
                    _local_6.y = _local_3;
                    _arg_1.addChild(_local_6);
                    _local_3 = (_local_3 + (_arg_2.childList[_local_4].clipHeight + this.spaceYmarge));
                };
                _local_4++;
            };
        }

        public function enterFrame(_arg_1:Event):*{
            var _local_2:Rectangle = getBounds(this);
            var _local_3:int = 20;
            if (((((mouseX < (_local_2.left - _local_3)) || (mouseX > (_local_2.right + _local_3))) || (mouseY < (_local_2.top - _local_3))) || (mouseY > (_local_2.bottom + _local_3)))){
                close();
            };
        }

        override public function redraw():*{
            var _local_1:Rectangle = getBounds(this);
            x = ((x + mouseX) - 25);
            y = ((y + mouseY) - 8);
            if (x < this.screenXmarge){
                x = this.screenXmarge;
            };
            if (y < this.screenYmarge){
                y = this.screenYmarge;
            };
            if ((x + _local_1.right) > (stage.stageWidth - this.screenXmarge)){
                x = ((stage.stageWidth - this.screenXmarge) - _local_1.right);
            };
            if ((y + _local_1.bottom) > (stage.stageHeight - this.screenYmarge)){
                y = ((stage.stageHeight - this.screenYmarge) - _local_1.bottom);
            };
            addEventListener("enterFrame", this.enterFrame, false);
        }

        public function getMaxChildOptionSize(_arg_1:ClickOptionItem):Point{
            var _local_3:uint;
            var _local_2:Point = new Point(0, 0);
            while (_local_3 < _arg_1.childList.length) {
                if (((_arg_1.childList[_local_3].visible) && (!(_arg_1.childList[_local_3].data.hideForSelf)))){
                    if (_local_2.x < _arg_1.childList[_local_3].clipWidth){
                        _local_2.x = _arg_1.childList[_local_3].clipWidth;
                    };
                    _local_2.y = (_local_2.y + (_arg_1.childList[_local_3].clipHeight + this.spaceYmarge));
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function addSubMenu(_arg_1:ClickOptionItem):*{
            var _local_3:Point;
            var _local_4:Point;
            this.closeSubMenuTo(_arg_1);
            var _local_2:Sprite = new Sprite();
            addChild(_local_2);
            this.insertMenu(_local_2, _arg_1);
            this.subMenuList.push({
                "CLIP":_local_2,
                "OPTION":_arg_1
            });
            _local_3 = this.getMaxChildOptionSize(_arg_1);
            var _local_5:Point = new Point(_arg_1.clip.x, _arg_1.clip.y);
            _local_5 = _arg_1.clip.parent.localToGlobal(_local_5);
            _local_5 = this.globalToLocal(_local_5);
            if (this.xSens){
                _local_4 = new Point((((_local_5.x + _arg_1.clipWidth) + this.spaceXmarge) + _local_3.x), 0);
                _local_4 = this.localToGlobal(_local_4);
                if (_local_4.x > (stage.stageWidth - this.screenXmarge)){
                    this.xSens = false;
                };
            };
            if (this.xSens){
                _local_2.x = ((_local_5.x + _arg_1.clipWidth) + this.spaceXmarge);
            }
            else {
                _local_2.x = ((_local_5.x - this.spaceXmarge) - _local_3.x);
            };
            _local_2.y = _local_5.y;
            _local_4 = new Point(0, (_local_2.y + _local_3.y));
            _local_4 = this.localToGlobal(_local_4);
            if (_local_4.y > (stage.stageHeight - this.screenYmarge)){
                _local_2.y = (_local_2.y - (_local_4.y - (stage.stageHeight - this.screenYmarge)));
            };
        }

        public function closeSubMenuTo(_arg_1:ClickOptionItem):*{
            var _local_2:Object;
            while (this.subMenuList.length) {
                _local_2 = this.subMenuList[(this.subMenuList.length - 1)];
                if (_local_2["OPTION"] != _arg_1.parent){
                    _local_2["CLIP"].parent.removeChild(_local_2["CLIP"]);
                    this.subMenuList.pop();
                }
                else {
                    return;
                };
            };
        }


    }
}//package bbl

