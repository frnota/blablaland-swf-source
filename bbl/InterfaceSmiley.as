// version 467 by nota

//bbl.InterfaceSmiley

package bbl{
    import flash.display.SimpleButton;
    import perso.smiley.SmileyLoader;
    import ui.RectArea;
    import perso.smiley.SmileyPack;
    import flash.display.Sprite;
    import perso.smiley.SmileyEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.MovieClip;

    public class InterfaceSmiley extends InterfaceBase {

        public var btDerouleSmile:SimpleButton;
        private var smileyLoader:SmileyLoader;
        private var packList:Array;
        private var smileyContent:RectArea;
        private var _selectedPack:SmileyPack;
        private var packListContent:Sprite;

        public function InterfaceSmiley(){
            this._selectedPack = null;
            this.smileyLoader = new SmileyLoader();
            this.packList = new Array();
            if (this.btDerouleSmile){
                this.smileyContent = new RectArea();
                this.smileyContent.areaWidth = 146;
                this.smileyContent.areaHeight = 115;
                this.smileyContent.x = this.btDerouleSmile.x;
                this.smileyContent.y = (this.btDerouleSmile.y + 12);
                addChildAt(this.smileyContent, getChildIndex(this.btDerouleSmile));
                this.btDerouleSmile.addEventListener("click", this.openPackList, false, 0, true);
            };
        }

        public function closeInterface():*{
            this.removeAllAllowedPack();
        }

        public function removeAllAllowedPack():*{
            this.packList.splice(0, this.packList.length);
            if (this.selectedPack){
                this.selectedPack = null;
            };
            this.closePackList();
            if (this.smileyContent){
                this.smileyContent.clearContent();
            };
        }

        public function addAllowedPack(_arg_1:uint):*{
            var _local_2:SmileyPack = this.smileyLoader.loadPack(_arg_1);
            if (((!(this.selectedPack)) && ((_arg_1 == GlobalProperties.sharedObject.data.SELECTED_SMILEY) || (!(GlobalProperties.sharedObject.data.SELECTED_SMILEY))))){
                this.selectedPack = _local_2;
            };
            this.packList.push(_local_2);
        }

        public function onSmile(_arg_1:Object):*{
            var _local_2:SmileyEvent;
            GlobalProperties.stage.focus = input;
            if (!floodPunished){
                _local_2 = new SmileyEvent("onSmile");
                _local_2.smileyId = _arg_1.smileyId;
                _local_2.playLocal = _arg_1.playLocal;
                _local_2.playCallBack = _arg_1.playCallBack;
                _local_2.data.bitCopyObject(_arg_1.data);
                _local_2.packId = this.selectedPack.loaderItem.id;
                this.dispatchEvent(_local_2);
            };
        }

        public function closePackList(_arg_1:Event=null):*{
            GlobalProperties.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.closePackList, false);
            if (this.packListContent){
                removeChild(this.packListContent);
                this.packListContent = null;
            };
        }

        public function openPackList(_arg_1:Event):*{
            var _local_2:uint;
            var _local_3:Array;
            var _local_4:RectArea;
            var _local_5:uint;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:MovieClip;
            var _local_9:RectArea;
            if (this.packList.length){
                _local_2 = 1;
                _local_3 = new Array();
                this.closePackList();
                GlobalProperties.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.closePackList, false, 0, true);
                this.packListContent = new Sprite();
                addChild(this.packListContent);
                _local_4 = new RectArea();
                _local_4.addEventListener(MouseEvent.MOUSE_DOWN, this.downInPackList, true, 0, true);
                this.packListContent.addChild(_local_4);
                _local_6 = 2;
                _local_7 = 2;
                _local_5 = 0;
                while (_local_5 < this.packList.length) {
                    _local_8 = new this.packList[_local_5].loaderItem.packSelectClass();
                    _local_9 = new RectArea();
                    _local_9.areaWidth = this.smileyContent.areaWidth;
                    _local_9.areaHeight = Math.min(_local_8.areaHeight, this.smileyContent.areaHeight);
                    _local_9.contentWidth = _local_8.areaWidth;
                    _local_9.contentHeight = _local_8.areaHeight;
                    _local_9.y = _local_6;
                    _local_9.name = ("pack_" + this.packList[_local_5].loaderItem.id);
                    _local_9.content.addChild(_local_8);
                    _local_4.content.addChild(_local_9);
                    _local_9.buttonMode = true;
                    _local_9.addEventListener(MouseEvent.CLICK, this.clickInPackList, false, 0, true);
                    _local_6 = (_local_6 + (_local_9.areaHeight + _local_2));
                    _local_3.push(_local_6);
                    _local_5++;
                };
                _local_7 = Math.min(300, _local_6);
                this.packListContent.x = this.btDerouleSmile.x;
                this.packListContent.y = (this.btDerouleSmile.y - _local_7);
                _local_4.contentWidth = this.smileyContent.areaWidth;
                _local_4.contentHeight = _local_6;
                _local_4.areaWidth = _local_4.contentWidth;
                _local_4.areaHeight = _local_7;
            };
        }

        public function clickInPackList(_arg_1:MouseEvent):*{
            var _local_3:uint;
            var _local_2:uint = Number(_arg_1.currentTarget.name.split("_")[1]);
            _local_3 = 0;
            while (_local_3 < this.packList.length) {
                if (this.packList[_local_3].loaderItem.id == _local_2){
                    this.selectedPack = this.packList[_local_3];
                    break;
                };
                _local_3++;
            };
            this.closePackList();
        }

        public function downInPackList(_arg_1:MouseEvent):*{
            _arg_1.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, this.downInPackList, true);
            _arg_1.stopPropagation();
        }

        public function set selectedPack(_arg_1:SmileyPack):*{
            if (this._selectedPack){
                this._selectedPack.removeEventListener("onPackLoaded", this.onSelectedPackLoaded, false);
                this._selectedPack.removeEventListener("onSmile", this.onSmile, false);
            };
            if (((_arg_1) && (this.smileyContent))){
                this.smileyContent.clearContent();
                _arg_1.addEventListener("onPackLoaded", this.onSelectedPackLoaded, false, 0, true);
                GlobalProperties.sharedObject.data.SELECTED_SMILEY = _arg_1.loaderItem.id;
            };
            this._selectedPack = _arg_1;
        }

        public function get selectedPack():SmileyPack{
            return (this._selectedPack);
        }

        public function onSelectedPackLoaded(_arg_1:Event):*{
            _arg_1.currentTarget.removeEventListener("onPackLoaded", this.onSelectedPackLoaded, false);
            var _local_2:MovieClip = new _arg_1.currentTarget.loaderItem.iconClass();
            _local_2.addEventListener("onSmile", this.onSmile, false, 0, true);
            this.smileyContent.contentWidth = _local_2.areaWidth;
            this.smileyContent.contentHeight = _local_2.areaHeight;
            this.smileyContent.resetPosition();
            this.smileyContent.content.addChild(_local_2);
        }


    }
}//package bbl

