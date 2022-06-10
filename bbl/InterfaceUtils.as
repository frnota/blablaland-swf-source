// version 467 by nota

//bbl.InterfaceUtils

package bbl{
    import ui.RectArea;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.Event;

    public class InterfaceUtils extends InterfaceSmiley {

        public var utilsRectAreaA:RectArea;
        public var utilsRectAreaB:RectArea;
        public var utilsList:Array;
        public var onglet_0:Sprite;
        public var onglet_1:Sprite;
        public var onglet_2:Sprite;
        public var onglet_3:Sprite;
        public var noMouse:Sprite;
        public var maskUtilA:Sprite;
        public var maskUtilB:Sprite;
        public var infoBulle:Function;
        private var gridContentA:Sprite;
        private var utilsContentA:Sprite;
        private var gridContentB:Sprite;
        private var utilsContentB:Sprite;
        private var gridWidth:uint;
        private var gridHeight:uint;
        private var curGenre:uint;
        private var genrePosMemory:Array;

        public function InterfaceUtils(){
            var _local_2:Sprite;
            var _local_3:String;
            var _local_4:Array;
            super();
            this.utilsList = new Array();
            this.curGenre = 0;
            this.genrePosMemory = [0, 0, 0, 0, 0, 0];
            this.gridWidth = 30;
            this.gridHeight = 31;
            this.utilsRectAreaA = new RectArea();
            this.utilsRectAreaA.contentWidth = this.gridWidth;
            this.utilsRectAreaA.areaWidth = (this.gridWidth * 5);
            this.utilsRectAreaA.areaHeight = (this.gridHeight * 4);
            this.utilsRectAreaA.x = (this.maskUtilA.x + 1);
            this.utilsRectAreaA.y = 0;
            this.utilsRectAreaA.mouseBorderMarge = 40;
            this.utilsRectAreaA.scrollControl = 2;
            addChildAt(this.utilsRectAreaA, getChildIndex(this.maskUtilA));
            this.maskUtilA.visible = false;
            this.utilsRectAreaB = new RectArea();
            this.utilsRectAreaB.contentWidth = this.gridWidth;
            this.utilsRectAreaB.areaWidth = (this.gridWidth * 2);
            this.utilsRectAreaB.areaHeight = (this.gridHeight * 4);
            this.utilsRectAreaB.x = (this.maskUtilB.x + 1);
            this.utilsRectAreaB.y = 0;
            this.utilsRectAreaB.mouseBorderMarge = 40;
            this.utilsRectAreaB.scrollControl = 2;
            addChildAt(this.utilsRectAreaB, getChildIndex(this.maskUtilB));
            this.maskUtilB.visible = false;
            this.gridContentA = new Sprite();
            this.utilsRectAreaA.content.addChild(this.gridContentA);
            this.utilsContentA = new Sprite();
            this.utilsRectAreaA.content.addChild(this.utilsContentA);
            this.gridContentB = new Sprite();
            this.utilsRectAreaB.content.addChild(this.gridContentB);
            this.utilsContentB = new Sprite();
            this.utilsRectAreaB.content.addChild(this.utilsContentB);
            var _local_1:uint;
            while (_local_1 < this.numChildren) {
                if ((getChildAt(_local_1) is Sprite)){
                    _local_2 = Sprite(getChildAt(_local_1));
                    _local_3 = _local_2.name;
                    _local_4 = _local_3.split("_");
                    if (_local_3 == "noMouse"){
                        _local_2.mouseChildren = false;
                        _local_2.mouseEnabled = false;
                    }
                    else {
                        if ((((_local_4.length == 2) && (_local_4[0] == "onglet")) && (_local_4[1].length == 1))){
                            MovieClip(_local_2).gotoAndStop(((Number(_local_4[1]) == this.curGenre) ? 2 : 1));
                            _local_2.addEventListener("mouseOver", this.ongletOverEvt);
                            _local_2.addEventListener("mouseOut", this.ongletOutEvt);
                            _local_2.addEventListener("click", this.ongletClickEvt);
                        };
                    };
                };
                _local_1++;
            };
            this.redrawGrid();
        }

        private function getGenreList(_arg_1:uint):*{
            var _local_2:Array;
            if (_arg_1 == 0){
                _local_2 = [3, 5, 7];
            };
            if (_arg_1 == 1){
                _local_2 = [1, 8];
            };
            if (_arg_1 == 2){
                _local_2 = [2, 9];
            };
            if (_arg_1 == 3){
                _local_2 = [4, 6];
            };
            return (_local_2);
        }

        private function isInGenre(_arg_1:uint, _arg_2:Array):Boolean{
            var _local_3:* = 0;
            while (_local_3 < _arg_2.length) {
                if (_arg_2[_local_3] == _arg_1){
                    return (true);
                };
                _local_3++;
            };
            return (false);
        }

        public function ongletClickEvt(_arg_1:Event):*{
            var _local_3:Array;
            var _local_4:*;
            var _local_5:InterfaceUtilsItem;
            var _local_6:Boolean;
            var _local_2:uint = Number(_arg_1.currentTarget.name.split("_")[1]);
            if (_local_2 != this.curGenre){
                this.genrePosMemory[this.curGenre] = this.utilsRectAreaA.content.y;
                _local_3 = this.getGenreList(_local_2);
                this[("onglet_" + this.curGenre)].gotoAndStop(1);
                this[("onglet_" + _local_2)].gotoAndStop(2);
                _local_4 = 0;
                while (_local_4 < this.utilsList.length) {
                    _local_5 = this.utilsList[_local_4];
                    _local_6 = this.isInGenre(_local_5.genre, _local_3);
                    if (((_local_6) && (!(_local_5.iconContent.parent)))){
                        this.utilsContentA.addChild(_local_5.iconContent);
                    }
                    else {
                        if (((!(_local_6)) && (_local_5.iconContent.parent == this.utilsContentA))){
                            this.utilsContentA.removeChild(_local_5.iconContent);
                        };
                    };
                    _local_4++;
                };
                this.utilsRectAreaA.content.y = this.genrePosMemory[_local_2];
                this.curGenre = _local_2;
                this.redrawGrid();
                this.utilsRectAreaA.replaceInside();
            };
        }

        public function ongletOverEvt(_arg_1:Event):*{
            var _local_2:uint;
            if (this.infoBulle){
                _local_2 = Number(_arg_1.currentTarget.name.split("_")[1]);
                if (_local_2 == 0){
                    this.infoBulle("Objets & Pouvoirs");
                };
                if (_local_2 == 1){
                    this.infoBulle("Montures");
                };
                if (_local_2 == 2){
                    this.infoBulle("Bliblis");
                };
                if (_local_2 == 3){
                    this.infoBulle("Maisons");
                };
            };
        }

        public function ongletOutEvt(_arg_1:Event):*{
            if (this.infoBulle){
                this.infoBulle(null);
            };
        }

        override public function closeInterface():*{
            this.removeAllUtil();
            super.closeInterface();
        }

        public function removeAllUtil():*{
            while (this.utilsList.length) {
                this.removeUtil(this.utilsList[0]);
            };
        }

        public function warnUtil(_arg_1:InterfaceUtilsItem):*{
            var _local_2:uint;
            var _local_3:uint;
            var _local_4:MovieClip;
            if (_arg_1.iconContent.parent){
                _local_2 = 0;
                _local_3 = 0;
                while (_local_3 < this.utilsList.length) {
                    if (this.utilsList[_local_3] == _arg_1){
                        _local_4 = MovieClip(Sprite(_arg_1.iconContent.parent.parent.getChildAt(0)).getChildAt(_local_2));
                        _local_4.gotoAndPlay(2);
                        RectArea(_arg_1.iconContent.parent.parent.parent).showRectangle(_local_4.getBounds(_local_4.parent));
                        break;
                    };
                    if (this.utilsList[_local_3].iconContent.parent == _arg_1.iconContent.parent){
                        _local_2++;
                    };
                    _local_3++;
                };
                this.utilsRectAreaA.replaceInside();
                this.utilsRectAreaB.replaceInside();
            };
        }

        public function removeUtil(_arg_1:InterfaceUtilsItem):*{
            if (_arg_1.iconContent.parent){
                _arg_1.iconContent.parent.removeChild(_arg_1.iconContent);
            };
            var _local_2:* = 0;
            while (_local_2 < this.utilsList.length) {
                if (this.utilsList[_local_2] == _arg_1){
                    this.utilsList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this.utilsRectAreaA.replaceInside();
            this.utilsRectAreaB.replaceInside();
            this.redrawGrid();
        }

        public function addUtil(_arg_1:uint=0):InterfaceUtilsItem{
            var _local_2:InterfaceUtilsItem = new InterfaceUtilsItem();
            _local_2.genre = _arg_1;
            _local_2.userInterface = this;
            var _local_3:Array = this.getGenreList(this.curGenre);
            if (_arg_1 == 0){
                this.utilsContentB.addChild(_local_2.iconContent);
            }
            else {
                if (this.isInGenre(_arg_1, _local_3)){
                    this.utilsContentA.addChild(_local_2.iconContent);
                };
            };
            this.utilsList.push(_local_2);
            this.redrawGrid();
            return (_local_2);
        }

        private function redrawGrid():*{
            var _local_1:uint;
            var _local_7:uint;
            var _local_8:MovieClip;
            var _local_2:uint = 4;
            var _local_3:uint = 5;
            var _local_4:* = 0;
            var _local_5:* = 0;
            var _local_6:Array = this.getGenreList(this.curGenre);
            _local_1 = 0;
            while (_local_1 < this.utilsList.length) {
                if (this.isInGenre(this.utilsList[_local_1].genre, _local_6)){
                    _local_4++;
                }
                else {
                    if (this.utilsList[_local_1].genre == 0){
                        _local_5++;
                    };
                };
                _local_1++;
            };
            _local_7 = Math.max((Math.ceil((this.utilsRectAreaA.areaHeight / this.gridHeight)) * _local_3), (Math.ceil((_local_4 / _local_3)) * _local_3));
            this.utilsRectAreaA.contentHeight = ((this.gridHeight * _local_7) / _local_3);
            while (_local_7 < this.gridContentA.numChildren) {
                this.gridContentA.removeChildAt(0);
            };
            while (_local_7 > this.gridContentA.numChildren) {
                _local_8 = new utilsGridSprite();
                this.gridContentA.addChild(_local_8);
            };
            _local_1 = 0;
            while (_local_1 < this.gridContentA.numChildren) {
                this.gridContentA.getChildAt(_local_1).x = ((_local_1 % _local_3) * this.gridWidth);
                this.gridContentA.getChildAt(_local_1).y = (Math.floor((_local_1 / _local_3)) * this.gridHeight);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.utilsContentA.numChildren) {
                this.utilsContentA.getChildAt(_local_1).x = (((_local_1 % _local_3) * this.gridWidth) + _local_2);
                this.utilsContentA.getChildAt(_local_1).y = ((Math.floor((_local_1 / _local_3)) * this.gridHeight) + _local_2);
                _local_1++;
            };
            _local_3 = 2;
            _local_7 = Math.max((Math.ceil((this.utilsRectAreaB.areaHeight / this.gridHeight)) * _local_3), (Math.ceil((_local_5 / _local_3)) * _local_3));
            this.utilsRectAreaB.contentHeight = ((this.gridHeight * _local_7) / _local_3);
            while (_local_7 < this.gridContentB.numChildren) {
                this.gridContentB.removeChildAt(0);
            };
            while (_local_7 > this.gridContentB.numChildren) {
                _local_8 = new utilsGridSprite();
                this.gridContentB.addChild(_local_8);
            };
            _local_1 = 0;
            while (_local_1 < this.gridContentB.numChildren) {
                this.gridContentB.getChildAt(_local_1).x = ((_local_1 % _local_3) * this.gridWidth);
                this.gridContentB.getChildAt(_local_1).y = (Math.floor((_local_1 / _local_3)) * this.gridHeight);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.utilsContentB.numChildren) {
                this.utilsContentB.getChildAt(_local_1).x = (((_local_1 % _local_3) * this.gridWidth) + _local_2);
                this.utilsContentB.getChildAt(_local_1).y = ((Math.floor((_local_1 / _local_3)) * this.gridHeight) + _local_2);
                _local_1++;
            };
        }


    }
}//package bbl

