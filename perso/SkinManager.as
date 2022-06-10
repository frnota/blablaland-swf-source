// source 467 by nota
//perso.SkinManager

package perso{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.utils.getDefinitionByName;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.display.DisplayObjectContainer;

    public class SkinManager extends Sprite {

        public static var colorList:* = [[987679, 2074], [1973820, 1315890], [3289670, 2631750], [4605530, 3289680], [5921390, 4605540], [7237250, 5921410], [8553120, 7237280], [9868980, 8553150], [11184850, 9211080], [12500720, 9869010], [0, 0], [0x1E1E1E, 0x141414], [0x505050, 0x282828], [5063995, 3945010], [8157566, 4012082], [6051663, 5391682], [10461090, 7829369], [0xDEDEDE, 10986668], [0xF0F0F0, 0xC8C8C8], [0xFAFAFA, 0xE1E1E1], [2834954, 1517066], [4016650, 2700810], [6056202, 4015370], [7968010, 5329740], [12764527, 8814979], [12244559, 7968010], [10074634, 7243530], [12244490, 9876746], [13757706, 10930442], [15597386, 12112138], [0x5E00, 0x4000], [0x7C00, 0x5200], [0xB300, 0x6B00], [0xE300, 0x7C00], [0xFF00, 0xBA00], [0x80FF00, 0xE000], [0xB8FF00, 0x63F700], [14942039, 0xB3F000], [14745530, 10939768], [9615045, 5143698], [194, 115], [0xFF, 169], [24319, 0xFF], [44031, 24319], [50687, 30686], [0xFFFF, 48594], [11141119, 60927], [11330047, 8632050], [7988180, 7972782], [8490495, 5137088], [0x5C00D1, 0x360099], [0x8800FF, 0x4700CF], [0xC400FF, 0x7D00DE], [12872191, 0xAB00FF], [14585343, 10310098], [13602303, 11885012], [0xFFFFFF, 11246847], [0xFFFFFF, 12105983], [0xFFFFFF, 14280959], [0xFFFFFF, 0xFFFFFF], [0xFF0047, 0xB50033], [0xFF0075, 0xBD0036], [0xFF00B0, 0xD90063], [0xFF00FF, 0xD400AB], [16730879, 0xFF00FF], [16748543, 16734719], [16759021, 16745408], [16772572, 16766131], [0xFFFFFF, 15589837], [16777182, 14931906], [0xA60000, 0x7D0000], [0xD70000, 0x8B2300], [0xFF0000, 0xB10000], [0xFF4D00, 0xFF1700], [0xFF9D00, 0xFF5B00], [0xFFD200, 0xFF9200], [0xFFFF00, 0xFFBD00], [16777039, 0xFFD400], [16777123, 16771113], [16777175, 16769938], [0x5C2600, 0x401400], [0x744400, 4467991], [0xA32E00, 0x821700], [0xA95100, 0x793D00], [16742240, 12281967], [14585219, 11300205], [14789816, 11437707], [15777436, 11959647], [16766399, 14463373], [15589837, 13087150]];

        public var skin:Object;
        public var skinLoader:SkinLoader;
        public var skinByte:uint;
        private var _skinColorRefList:Array;
        private var _skinColor:SkinColor;
        private var popiereTimer:Timer;
        private var _direction:Object;
        private var _skinId:Object;
        private var _skinScale:Number;
        private var _action:Object;
        private var _useCache:Boolean;
        private var _cacheControl:SkinCacheControl;
        private var _frameControl:SkinFrameControl;
        public var content:Sprite;

        public function SkinManager(){
            this._skinColorRefList = new Array();
            this._skinId = {"v":-1};
            this._action = {"v":0};
            this.skin = null;
            this._skinColor = new SkinColor();
            this.skinLoader = new SkinLoader();
            this._direction = {"v":true};
            this._useCache = true;
            this._skinScale = 1;
            this.skinLoader.addEventListener("onSkinLoaded", this.onSkinReady, false, 0, true);
            this.content = new Sprite();
            this.clickable = true;
            addChild(this.content);
            this._cacheControl = new SkinCacheControl();
            this._frameControl = new SkinFrameControl();
            this.popiereTimer = new Timer(4000);
            this.popiereTimer.addEventListener("timer", this.popiereTimerEvent, false, 0, true);
        }

        public function getClassByName(_arg_1:String):Object{
            return (getDefinitionByName(_arg_1));
        }

        public function updateSkinContentColor():*{
            if (this._skinColorRefList.length){
                this.content.transform.colorTransform = this._skinColorRefList[(this._skinColorRefList.length - 1)][1];
            }
            else {
                this.content.transform.colorTransform = new ColorTransform();
            };
        }

        public function addSkinColor(_arg_1:Object, _arg_2:ColorTransform):*{
            this._skinColorRefList.push([_arg_1, _arg_2]);
            this.updateSkinContentColor();
        }

        public function removeSkinColor(_arg_1:Object):*{
            var _local_2:uint;
            while (_local_2 < this._skinColorRefList.length) {
                if (this._skinColorRefList[_local_2][0] == _arg_1){
                    this._skinColorRefList.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
            this.updateSkinContentColor();
        }

        public function popiereTimerEvent(_arg_1:Event):*{
            var _local_2:Array;
            var _local_3:*;
            var _local_4:DisplayObject;
            if (((((Math.random() < 0.4) && (!(this._action.v == 50))) && (!(this._action.v == 51))) && (!(this._action.v == 2)))){
                _local_2 = this.getChildList(this.skin.body);
                _local_3 = 0;
                while (_local_3 < _local_2.length) {
                    _local_4 = _local_2[_local_3];
                    if (((_local_4.name == "popiere") && (_local_4 is MovieClip))){
                        MovieClip(_local_4).play();
                    };
                    _local_3++;
                };
            };
        }

        public function getChildList(_arg_1:DisplayObjectContainer, _arg_2:Array=null):Array{
            var _local_4:DisplayObject;
            if (!_arg_2){
                _arg_2 = new Array();
            };
            var _local_3:* = 0;
            while (_local_3 < _arg_1.numChildren) {
                _local_4 = _arg_1.getChildAt(_local_3);
                if ((_local_4 is DisplayObjectContainer)){
                    _arg_2.push(_local_4);
                    this.getChildList(DisplayObjectContainer(_local_4), _arg_2);
                };
                _local_3++;
            };
            return (_arg_2);
        }

        public function onSkinReady(_arg_1:Event):*{
            var _local_2:SkinLoaderItem = this.skinLoader.getSkinById(this._skinId.v);
            var _local_3:* = _local_2.classRef;
            this.skinByte = _local_2.skinByte;
            this.skin = new (_local_3)();
            this.content.addChild(DisplayObject(this.skin));
            this.skin.cacheAsBitmap = (!(this._useCache));
            this.updateAll();
            this.popiereTimer.start();
            dispatchEvent(new Event("onSkinReady"));
        }

        public function onClickUser(_arg_1:Event):*{
            dispatchEvent(new Event("onClickUser"));
        }

        public function onOverUser(_arg_1:Event):*{
            dispatchEvent(new Event("onOverUser"));
        }

        public function onOutUser(_arg_1:Event):*{
            dispatchEvent(new Event("onOutUser"));
        }

        public function dispose():*{
            this.unloadSkin();
            this.skinLoader.removeEventListener("onSkinLoaded", this.onSkinReady, false);
            this.popiereTimer.removeEventListener("timer", this.popiereTimerEvent, false);
            if (this.parent){
                this.parent.removeChild(this);
            };
        }

        public function getSkinColorSlot():Array{
            var _local_1:uint;
            var _local_3:*;
            var _local_4:DisplayObject;
            var _local_5:Array;
            var _local_6:*;
            var _local_2:* = new Array();
            _local_1 = 0;
            while (_local_1 < this.skinColor.nbSlot) {
                _local_2.push(false);
                _local_1++;
            };
            if (this.skin){
                _local_3 = this.getChildList(this.skin.body);
                _local_1 = 0;
                while (_local_1 < _local_3.length) {
                    _local_4 = _local_3[_local_1];
                    _local_5 = _local_4.name.split("_");
                    _local_6 = _local_5[0].charCodeAt();
                    if ((((_local_5.length == 2) && (_local_6 >= 65)) && (_local_6 <= 82))){
                        _local_2[(_local_6 - 65)] = true;
                    };
                    _local_1++;
                };
            };
            return (_local_2);
        }

        public function unloadSkin():*{
            this.popiereTimer.stop();
            if (this.skin){
                this.skin.dispose();
                this.content.removeChild(DisplayObject(this.skin));
            };
            this.skin = null;
        }

        public function updateAll():*{
            this.updateColor();
            this.updateSkinScale();
            this.updateCache();
            this.updateState();
            this.updateDirection();
        }

        public function forceReload():*{
            this.unloadSkin();
            this.skinLoader.loadSkin(this._skinId.v);
        }

        public function step():*{
            this._frameControl.nextFrame();
            this._cacheControl.nextFrame();
        }

        public function updateState():*{
            if (this.skin){
                this._frameControl.action = this._action.v;
                this._cacheControl.action = this._action.v;
            };
        }

        public function updateCache():*{
            var _local_1:*;
            var _local_2:DisplayObject;
            var _local_3:*;
            var _local_4:*;
            if (this.skin){
                this._frameControl.removeAllItem();
                this._cacheControl.removeAllItem();
                _local_1 = 0;
                while (_local_1 < this.skin.body.numChildren) {
                    _local_2 = this.skin.body.getChildAt(_local_1);
                    if (((_local_2.name.split("_")[0] == "cached") && (this._useCache))){
                        _local_2.visible = false;
                        _local_3 = this._cacheControl.addItem();
                        _local_3.scale = Math.max(this.skinScale, 0.1);
                        _local_3.target = _local_2;
                        this.skin.body.addChildAt(_local_3, _local_1);
                        _local_1++;
                    }
                    else {
                        if (_local_2.name.split("_")[0] != "nobody"){
                            _local_2.visible = true;
                            _local_4 = this._frameControl.addItem();
                            _local_4.target = _local_2;
                        };
                    };
                    _local_1++;
                };
            };
        }

        public function updateDirection():*{
            if (this.skin){
                this.content.scaleX = ((Number(this._direction.v) * 2) - 1);
            };
        }

        public function updateSkinScale():*{
            if (this.skin){
                this.skin.scaleX = (this.skin.scaleY = Math.max(this._skinScale, 0.1));
            };
        }

        public function updateSkinColor():*{
            this.updateColor();
            this._cacheControl.updateCache();
        }

        public function updateColor():*{
            var _local_1:*;
            var _local_2:*;
            var _local_3:DisplayObject;
            var _local_4:Array;
            var _local_5:*;
            var _local_6:*;
            if (this.skin){
                _local_1 = this.getChildList(this.skin.body);
                _local_2 = 0;
                while (_local_2 < _local_1.length) {
                    _local_3 = _local_1[_local_2];
                    _local_4 = _local_3.name.split("_");
                    _local_5 = _local_4[0].charCodeAt();
                    if ((((_local_4.length == 2) && (_local_5 >= 65)) && (_local_5 <= 82))){
                        _local_6 = _local_3.transform.colorTransform;
                        if (colorList.length > this.skinColor.color[(_local_5 - 65)]){
                            _local_6.color = colorList[this.skinColor.color[(_local_5 - 65)]][Number(_local_4[1])];
                            _local_3.transform.colorTransform = _local_6;
                        };
                    };
                    _local_2++;
                };
            };
        }

        public function get clickable():Boolean{
            return (this.content.buttonMode);
        }

        public function set clickable(_arg_1:Boolean):*{
            if (_arg_1){
                this.content.addEventListener("click", this.onClickUser, false);
                this.content.addEventListener("mouseOver", this.onOverUser, false);
                this.content.addEventListener("mouseOut", this.onOutUser, false);
                this.content.buttonMode = true;
                this.content.mouseChildren = false;
            }
            else {
                this.content.removeEventListener("click", this.onClickUser, false);
                this.content.removeEventListener("mouseOver", this.onOverUser, false);
                this.content.removeEventListener("mouseOut", this.onOutUser, false);
                this.content.buttonMode = false;
                this.content.mouseChildren = true;
            };
        }

        public function set skinColor(_arg_1:SkinColor):*{
            this._skinColor = _arg_1;
            this.updateSkinColor();
        }

        public function get skinColor():SkinColor{
            return (this._skinColor);
        }

        public function set skinId(_arg_1:int):*{
            if (this._skinId.v != _arg_1){
                this._skinId = {"v":_arg_1};
                this.unloadSkin();
                this.skinLoader.loadSkin(this._skinId.v);
            };
        }

        public function get skinId():int{
            return (this._skinId.v);
        }

        public function set action(_arg_1:int):*{
            if (this._action.v != _arg_1){
                this._action = {"v":_arg_1};
                this.updateState();
            };
        }

        public function get action():int{
            return (this._action.v);
        }

        public function set direction(_arg_1:Boolean):*{
            if (this._direction.v != _arg_1){
                this._direction = {"v":_arg_1};
                this.updateDirection();
            };
        }

        public function get direction():Boolean{
            return (this._direction.v);
        }

        public function set skinScale(_arg_1:Number):*{
            if (this._skinScale != _arg_1){
                this._skinScale = _arg_1;
                this.updateSkinScale();
                this._cacheControl.scale = _arg_1;
                this._cacheControl.updateCache();
            };
        }

        public function get skinScale():Number{
            return (this._skinScale);
        }

        public function get useCache():Boolean{
            return (this._useCache);
        }

        public function set useCache(_arg_1:Boolean):*{
            if (this._useCache != _arg_1){
                this._useCache = _arg_1;
                this.updateCache();
                this.updateState();
                this.content.cacheAsBitmap = (!(this._useCache));
                if (this.skin){
                    this.skin.cacheAsBitmap = (!(this._useCache));
                };
            };
        }


    }
}//package perso

