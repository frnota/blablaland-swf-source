// version 467 by nota

//ui.ScrollRectArea

package ui{
    import flash.events.Event;
    import flash.display.DisplayObject;

    public class ScrollRectArea extends RectArea {

        public var scrollV:Object;
        public var scrollH:Object;

        public function ScrollRectArea(){
            this.scrollLink = Scroll;
            scrollControl = 0;
        }

        public function updateScrollByScene():*{
            this.scrollH.value = (-(content.x) / Math.max((contentWidth - areaWidth), 0));
            this.scrollV.value = (-(content.y) / Math.max((contentHeight - areaHeight), 0));
            this.scrollH.visible = (contentWidth > areaWidth);
            this.scrollV.visible = (contentHeight > areaHeight);
        }

        public function updateSceneByScroll(_arg_1:Event=null):*{
            super.scrollToX(this.scrollH.value);
            super.scrollToY(this.scrollV.value);
        }

        public function updateScrollPosition():*{
            this.scrollV.rotation = 90;
            this.scrollV.x = (areaWidth + 6);
            this.scrollV.size = areaHeight;
            this.scrollH.y = (areaHeight + 6);
            this.scrollH.size = areaWidth;
        }

        override public function scrollToX(_arg_1:Number):*{
            super.scrollToX(_arg_1);
            this.updateScrollByScene();
        }

        override public function scrollToY(_arg_1:Number):*{
            super.scrollToY(_arg_1);
            this.updateScrollByScene();
        }

        override public function set areaWidth(_arg_1:Number):*{
            super.areaWidth = _arg_1;
            if (this.scrollV){
                this.updateScrollPosition();
                this.updateScrollByScene();
            };
        }

        override public function set areaHeight(_arg_1:Number):*{
            super.areaHeight = _arg_1;
            if (this.scrollV){
                this.updateScrollPosition();
                this.updateScrollByScene();
            };
        }

        override public function set contentWidth(_arg_1:Number):*{
            super.contentWidth = _arg_1;
            if (this.scrollV){
                this.updateScrollByScene();
            };
        }

        override public function set contentHeight(_arg_1:Number):*{
            super.contentHeight = _arg_1;
            if (this.scrollV){
                this.updateScrollByScene();
            };
        }

        public function set scrollLink(_arg_1:Class):*{
            var _local_2:Boolean = true;
            if (((_arg_1) && (this.scrollV))){
                _local_2 = (!(this.scrollV is _arg_1));
            };
            if (_local_2){
                if (this.scrollV){
                    removeChild(DisplayObject(this.scrollV));
                    this.scrollV.removeEventListener("onChanged", this.updateSceneByScroll, false);
                    this.scrollV = null;
                    removeChild(DisplayObject(this.scrollH));
                    this.scrollH.removeEventListener("onChanged", this.updateSceneByScroll, false);
                    this.scrollH = null;
                };
                if (_arg_1){
                    this.scrollV = new (_arg_1)();
                    this.scrollV.addEventListener("onChanged", this.updateSceneByScroll, false, 0, true);
                    addChild(DisplayObject(this.scrollV));
                    this.scrollH = new (_arg_1)();
                    this.scrollH.addEventListener("onChanged", this.updateSceneByScroll, false, 0, true);
                    addChild(DisplayObject(this.scrollH));
                    this.updateScrollByScene();
                };
            };
        }


    }
}//package ui

