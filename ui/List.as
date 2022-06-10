// version 467 by nota

//ui.List

package ui{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class List extends Sprite {

        public var size:Number;
        public var graphicHeight:Number;
        public var graphicWidth:Number;
        public var annonce:Sprite;
        public var node:ListTreeNode;
        public var scrollLink:Object;
        public var graphicLink:Object;
        private var startAt:Number;
        private var scroll:Object;
        private var content:Sprite;
        private var graphicList:Array;
        private var visibleList:Array;

        public function List(){
            this.node = new ListTreeNode();
            this.visibleList = new Array();
            this.size = 5;
            if (this.annonce){
                this.removeChild(this.annonce);
            };
            this.graphicHeight = 13;
            this.graphicWidth = 200;
            this.graphicList = new Array();
            this.startAt = 0;
            this.scrollLink = Scroll;
            this.graphicLink = ListGraphic;
            this.content = new Sprite();
            this.addChild(this.content);
        }

        public function redraw():*{
            var _local_1:Object;
            if (((!(this.scroll)) && (this.scrollLink))){
                this.scroll = new this.scrollLink();
                this.addChild(DisplayObject(this.scroll));
                this.scroll.rotation = 90;
                this.scroll.visible = false;
                this.scroll.x = (this.graphicWidth + 10);
                this.scroll.addEventListener("onChanged", this.updateSceneByScroll, false, 0, true);
            };
            while (this.graphicList.length > this.size) {
                _local_1 = this.graphicList.pop();
                this.content.removeChild(DisplayObject(_local_1));
            };
            while (this.graphicList.length < this.size) {
                _local_1 = new this.graphicLink();
                this.content.addChild(DisplayObject(_local_1));
                this.graphicList.push(_local_1);
                _local_1.system = this;
            };
            if (this.scroll){
                this.scroll.size = (this.size * this.graphicHeight);
            };
            this.visibleList = this.node.getVisibleList();
            this.startAt = Math.max(Math.min((this.visibleList.length - this.size), this.startAt), 0);
            this.updateScreen();
            this.updateScrollByScene();
        }

        public function scrollDragging():*{
            if (mouseX < 0){
                this.scroll.value = (this.scroll.value - (this.scroll.changeStep / 2));
            }
            else {
                if (mouseY > (this.size * this.graphicHeight)){
                    this.scroll.value = (this.scroll.value + (this.scroll.changeStep / 2));
                };
            };
            this.updateSceneByScroll();
        }

        public function updateScreen():*{
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < this.size) {
                _local_2 = this.graphicList[_local_1];
                _local_2.screenIndex = _local_1;
                _local_2.visibleIndex = (_local_1 + this.startAt);
                if ((_local_1 + this.startAt) < this.visibleList.length){
                    _local_2.node = this.visibleList[(_local_1 + this.startAt)];
                    _local_2.visible = true;
                    _local_2.y = (this.graphicHeight * _local_1);
                    _local_2.redraw();
                }
                else {
                    _local_2.visible = false;
                    _local_2.node = null;
                };
                _local_1++;
            };
        }

        public function updateSceneByScroll(_arg_1:Event=null):*{
            var _local_2:*;
            if (this.scroll){
                _local_2 = (this.visibleList.length - this.size);
                if (_local_2 < 0){
                    _local_2 = 0;
                };
                this.startAt = Math.round((_local_2 * this.scroll.value));
            };
            this.updateScreen();
        }

        public function updateScrollByScene():*{
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            if (((this.scroll) && (this.graphicList.length))){
                if (this.size < this.visibleList.length){
                    _local_1 = (this.visibleList.length - this.size);
                    _local_2 = 0;
                    _local_3 = 0;
                    while (_local_3 < this.visibleList.length) {
                        if (this.visibleList[_local_3] == this.graphicList[0].node){
                            _local_2 = _local_3;
                            break;
                        };
                        _local_3++;
                    };
                    this.scroll.visible = true;
                    this.scroll.value = (_local_2 / _local_1);
                }
                else {
                    this.scroll.visible = false;
                };
            };
        }


    }
}//package ui

