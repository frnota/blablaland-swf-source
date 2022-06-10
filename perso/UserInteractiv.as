// version 467 by nota

//perso.UserInteractiv

package perso{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilter;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import bbl.ExternalLoader;
    import flash.text.Font;
    import flash.text.TextFormat;
    import bbl.CameraMap;
    import fx.UserFxOverloadItem;
    import bbl.GlobalProperties;

    public class UserInteractiv extends UserIcon {

        private var _interactivIconClass:Object;
        private var _dodoIconClass:Object;
        private var _headIconClass:Object;
        private var _headLocation:MovieClip;

        public var interactivIcon:Object = null;
        private var _pseudo:String = "";
        private var _sex:uint = 0;
        public var userId:uint = 0;
        public var userPid:uint = 0;
        private var _interactiv:DisplayObject = null;
        private var _interactivId:Object = {"v":0};
        private var _dodoMc:MovieClip = null;
        private var _highLightRefList:Array = new Array();
        private var _highLightCurFilter:BitmapFilter = null;
        private var _headLocationRefList:Array = new Array();
        private var _filters:Array = new Array();
        private var _skinFiltersRefList:Array = new Array();
        private var _pseudoTextFieldContent:Sprite = new Sprite();
        public var pseudoTextField:TextField = new TextField();

        public function UserInteractiv(){
            addChild(this._pseudoTextFieldContent);
            this.pseudoTextField.selectable = false;
            var _local_1:GlowFilter = new GlowFilter(0, 1, 2.5, 2.5, 3, 1);
            this.pseudoTextField.filters = [_local_1];
            this._pseudoTextFieldContent.addChild(this.pseudoTextField);
            this._pseudoTextFieldContent.cacheAsBitmap = true;
            super();
            this.updateItemPosition();
        }

        override public function set filters(_arg_1:Array):void{
            this._filters = _arg_1;
            super.filters = _arg_1;
        }

        override public function get filters():Array{
            return (this._filters.slice());
        }

        private function removeFromArray(_arg_1:Array, _arg_2:Object):*{
            var _local_3:uint;
            while (_local_3 < _arg_1.length) {
                if (_arg_1[_local_3] == _arg_2){
                    _arg_1.splice(_local_3, 1);
                    _local_3--;
                };
                _local_3++;
            };
        }

        public function updateSkinFilter():*{
            if (this._skinFiltersRefList.length){
                content.filters = [this._skinFiltersRefList[(this._skinFiltersRefList.length - 1)][1]];
            }
            else {
                content.filters = [];
            };
        }

        public function addSkinFilter(_arg_1:Object, _arg_2:BitmapFilter):*{
            this._skinFiltersRefList.push([_arg_1, _arg_2]);
            this.updateSkinFilter();
        }

        public function removeSkinFilter(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this._skinFiltersRefList.length) {
                if (this._skinFiltersRefList[_local_2][0] == _arg_1){
                    this._skinFiltersRefList.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
            this.updateSkinFilter();
        }

        private function updateHighLight():*{
            var _local_1:uint;
            var _local_2:uint;
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:BitmapFilter;
            var _local_6:* = false;
            if (((this._highLightRefList.length) && (clickable))){
                _local_5 = this._highLightRefList[(this._highLightRefList.length - 1)][1];
                _local_6 = this._highLightRefList[(this._highLightRefList.length - 1)][2];
            };
            if (this._highLightCurFilter){
                _local_3 = this.filters;
                this.removeFromArray(_local_3, this._highLightCurFilter);
                this.filters = _local_3;
                _local_1 = 0;
                while (_local_1 < fxMemory.length) {
                    _local_4 = fxMemory[_local_1];
                    _local_2 = 0;
                    while (_local_2 < _local_4.skinGraphicLinkList.length) {
                        _local_4.skinGraphicLinkList[_local_2].filters = new Array();
                        _local_2++;
                    };
                    _local_1++;
                };
                _local_1 = 0;
                while (_local_1 < fxPersistent.length) {
                    _local_4 = fxPersistent[_local_1];
                    _local_2 = 0;
                    while (_local_2 < _local_4.skinGraphicLinkList.length) {
                        _local_4.skinGraphicLinkList[_local_2].filters = new Array();
                        _local_2++;
                    };
                    _local_1++;
                };
                this._highLightCurFilter = null;
            };
            if (_local_5){
                if (!_local_6){
                    _local_3 = this.filters;
                    _local_3.push(_local_5);
                    this.filters = _local_3;
                    _local_1 = 0;
                    while (_local_1 < fxMemory.length) {
                        _local_4 = fxMemory[_local_1];
                        _local_2 = 0;
                        while (_local_2 < _local_4.skinGraphicLinkList.length) {
                            _local_4.skinGraphicLinkList[_local_2].filters = _local_3;
                            _local_2++;
                        };
                        _local_1++;
                    };
                    _local_1 = 0;
                    while (_local_1 < fxPersistent.length) {
                        _local_4 = fxPersistent[_local_1];
                        _local_2 = 0;
                        while (_local_2 < _local_4.skinGraphicLinkList.length) {
                            _local_4.skinGraphicLinkList[_local_2].filters = _local_3;
                            _local_2++;
                        };
                        _local_1++;
                    };
                };
                this._highLightCurFilter = _local_5;
            };
        }

        override public function set clickable(_arg_1:Boolean):*{
            super.clickable = _arg_1;
            this.updateHighLight();
        }

        public function addHighLight(_arg_1:Object, _arg_2:BitmapFilter=null):*{
            if (!_arg_2){
                _arg_2 = new GlowFilter(0xFFFFFF, 2, 8, 8, 10, 1);
            };
            this._highLightRefList.push([_arg_1, _arg_2]);
            this.updateHighLight();
        }

        public function removeHighLight(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this._highLightRefList.length) {
                if (this._highLightRefList[_local_2][0] == _arg_1){
                    this._highLightRefList.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
            this.updateHighLight();
        }

        override public function set y(_arg_1:Number):void{
            super.y = _arg_1;
            this.updateHeadLocationPosition();
        }

        override public function set x(_arg_1:Number):void{
            super.x = _arg_1;
            this.updateHeadLocationPosition();
        }

        override public function set visible(_arg_1:Boolean):void{
            super.visible = _arg_1;
            this.updateHeadLocationPosition();
        }

        private function updateHeadLocationPosition():*{
            var _local_1:DisplayObject;
            if (((this._headLocation) && (camera))){
                this._headLocation.x = x;
                if (((this._interactiv) && (!(shiftKey)))){
                    _local_1 = Sprite(this._interactiv).getChildByName("fontSize");
                    this._headLocation.y = ((y + this._interactiv.y) - this._interactiv.height);
                    if (_local_1){
                        this._headLocation.y = ((y + this._interactiv.y) - _local_1.height);
                    };
                }
                else {
                    this._headLocation.y = (y + this.pseudoTextField.y);
                };
                if (this._headLocation.parent != camera.bulleContent){
                    camera.bulleContent.addChild(this._headLocation);
                };
                this._headLocation.visible = visible;
            };
        }

        private function updateHeadLocation():*{
            if (((!(this._headLocation)) && (this._headLocationRefList.length))){
                this._headLocation = new this._headIconClass();
                this.updateHeadLocationPosition();
            }
            else {
                if (((this._headLocation) && (!(this._headLocationRefList.length)))){
                    if (this._headLocation.parent){
                        this._headLocation.parent.removeChild(this._headLocation);
                    };
                    this._headLocation = null;
                };
            };
        }

        public function addHeadLocation(_arg_1:Object):*{
            this._headLocationRefList.push(_arg_1);
            this.updateHeadLocation();
            this.addHighLight(_arg_1, new GlowFilter(6937152, 2, 8, 8, 10, 1));
        }

        public function removeHeadLocation(_arg_1:Object):*{
            this.removeFromArray(this._headLocationRefList, _arg_1);
            this.updateHeadLocation();
            this.removeHighLight(_arg_1);
        }

        override public function onOverUser(_arg_1:Event):*{
            this.addHighLight(this);
            super.onOverUser(_arg_1);
        }

        override public function onOutUser(_arg_1:Event):*{
            this.removeHighLight(this);
            super.onOutUser(_arg_1);
        }

        override public function onExternalReady(_arg_1:Event):*{
            this._interactivIconClass = externalLoader.getClass("InteractivIcon");
            this._dodoIconClass = externalLoader.getClass("DodoIcon");
            this._headIconClass = externalLoader.getClass("HeadLocation");
            var _local_2:Object = Object(ExternalLoader.external.content).pseudoFont;
            var _local_3:Font = new (_local_2)();
            Font.registerFont(Class(_local_2));
            var _local_4:* = new TextFormat();
            _local_4.font = _local_3.fontName;
            _local_4.align = "center";
            _local_4.size = 10;
            this.pseudoTextField.height = 0;
            this.pseudoTextField.width = 0;
            this.pseudoTextField.defaultTextFormat = _local_4;
            this.pseudoTextField.autoSize = "right";
            this.pseudoTextField.antiAliasType = "advanced";
            this.pseudoTextField.embedFonts = true;
            this.pseudo = this.pseudo;
            super.onExternalReady(_arg_1);
        }

        override public function dispose():*{
            this.interactiv = 0;
            super.dispose();
        }

        override public function updateGraphicHeight():*{
            super.updateGraphicHeight();
            this.updateItemPosition();
        }

        override public function redrawIcon():*{
            super.redrawIcon();
            this.updateItemPosition();
        }

        private function updateItemPosition():*{
            var _local_1:int = (-(skinGraphicHeight) - headOffset);
            if (iconContent){
                _local_1 = iconContent.y;
            };
            _local_1 = (_local_1 - this.pseudoTextField.height);
            this.pseudoTextField.y = _local_1;
            if (this._interactiv){
                this._interactiv.y = _local_1;
            };
            if (this._dodoMc){
                this._dodoMc.y = _local_1;
            };
            this.updateHeadLocationPosition();
        }

        override public function set camera(_arg_1:CameraMap):*{
            if (_arg_1){
                this.interactiv = 0;
            };
            super.camera = _arg_1;
            this.updateHeadLocationPosition();
        }

        public function set interactiv(val:Number):*{
            var it:Object;
            if (val != this._interactivId.v){
                this._interactivId = {"v":val};
                if (this._interactiv){
                    this.removeChild(this._interactiv);
                    if (((camera) && (camera.lightEffect))){
                        camera.lightEffect.removeItemByTarget(this._interactiv);
                    };
                    this._interactiv = null;
                };
                if (((val >= 1000) && (clientControled))){
                    if (!this.interactivIcon){
                        this.interactivIcon = "DEFAULT";
                    };
                    if ((this.interactivIcon is DisplayObject)){
                        this._interactiv = DisplayObject(this.interactivIcon);
                    }
                    else {
                        this._interactiv = new this._interactivIconClass();
                    };
                    try {
                        if ((this.interactivIcon is String)){
                            MovieClip(this._interactiv).gotoAndStop(this.interactivIcon);
                        };
                    }
                    catch(err) {
                        MovieClip(_interactiv).gotoAndStop(1);
                    };
                    this._interactiv.visible = (!(shiftKey));
                    this.updateItemPosition();
                    this.addChildAt(this._interactiv, 1);
                    if (((camera) && (camera.lightEffect))){
                        it = camera.lightEffect.addItem(this._interactiv);
                        it.invertLight = true;
                        it.redraw();
                    };
                };
                this.interactivIcon = null;
            };
        }

        public function get interactiv():Number{
            return (this._interactivId.v);
        }

        public function get sex():uint{
            return (this._sex);
        }

        public function set sex(_arg_1:uint):*{
            this._sex = _arg_1;
            this.pseudo = this.pseudo;
            bulle.fontColor = ((_arg_1 == 0) ? 0xF5F5F5 : ((_arg_1 == 1) ? 13421823 : 16765183));
        }

        public function set pseudo(_arg_1:String):*{
            this._pseudo = _arg_1;
            if (overPseudo){
                if (overPseudo.type == 0){
                    _arg_1 = (_arg_1 + overPseudo.pseudoValue);
                }
                else {
                    if (overPseudo.type == 2){
                        _arg_1 = overPseudo.pseudoValue;
                    };
                };
            };
            var _local_2:Number = ((this.sex == 0) ? 0xEEEEEE : ((this.sex == 1) ? 12636415 : 16109813));
            if (((!(this.pseudoTextField.textColor == _local_2)) || (!(_arg_1 == this.pseudoTextField.text)))){
                this.pseudoTextField.text = _arg_1;
                this.pseudoTextField.textColor = _local_2;
                this.pseudoTextField.x = -(Math.round((this.pseudoTextField.width / 2)));
                this.updateItemPosition();
            };
        }

        public function get pseudo():String{
            return (this._pseudo);
        }

        override public function set overPseudo(_arg_1:UserFxOverloadItem):*{
            super.overPseudo = _arg_1;
            this.pseudo = this.pseudo;
        }

        override public function set dodo(_arg_1:Boolean):*{
            if (_arg_1 != dodo){
                if (((this._dodoMc) && (!(_arg_1)))){
                    this.removeChild(this._dodoMc);
                    this._dodoMc = null;
                }
                else {
                    if (((!(this._dodoMc)) && (_arg_1))){
                        this._dodoMc = new this._dodoIconClass();
                        this.updateItemPosition();
                        this.addChild(this._dodoMc);
                    };
                };
            };
            super.dodo = _arg_1;
        }

        override public function set shiftKey(_arg_1:Boolean):void{
            super.shiftKey = _arg_1;
            if (this._interactiv){
                this._interactiv.visible = (!(shiftKey));
                this.updateItemPosition();
            };
        }

        override public function set jump(_arg_1:int):void{
            var _local_3:WalkerPhysicEvent;
            var _local_2:* = (!(jump == _arg_1));
            super.jump = _arg_1;
            if (((((_local_2) && (_arg_1 == -1)) && (this._interactivId.v)) && (!(shiftKey)))){
                _local_3 = new WalkerPhysicEvent("interactivEvent");
                _local_3.walker = this;
                _local_3.lastColor = 0;
                _local_3.newColor = this._interactivId.v;
                _local_3.certified = true;
                this.dispatchEvent(_local_3);
            };
            if (((((((((_local_2) && (_arg_1 == -1)) && (onFloor)) && (walk == 0)) && (shiftKey)) && (clientControled)) && (camera)) && (GlobalProperties.mainApplication.userInterface))){
                GlobalProperties.mainApplication.userInterface.computeMessage("/assis");
            };
        }


    }
}//package perso

