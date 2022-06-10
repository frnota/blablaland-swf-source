// version 467 by nota

//map.MapManager

package map{
    import flash.display.Sprite;
    import engine.Scroller;
    import engine.Physic;
    import bbl.Quality;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import engine.MultiBitmapData;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.DisplayObjectContainer;
    import engine.ScrollerItem;

    public class MapManager extends Sprite {

        public var data:Object;
        public var persistentData:Object;
        public var currentMap:Object;
        public var serverId:int;
        public var mapReady:Boolean;
        public var mapLoader:MapLoader;
        public var mapPreloader:MapLoader;
        public var screenWidth:Number;
        public var screenHeight:Number;
        public var defaultScreenWidth:Number;
        public var defaultScreenHeight:Number;
        public var scroller:Scroller;
        public var physic:Physic;
        public var userContent:Sprite;
        public var userContentList:Array;
        public var bulleContent:Sprite;
        public var lightContent:Sprite;
        public var preloadList:Array;
        private var _quality:Quality;
        private var _mapFileId:Object;

        public function MapManager(){
            this.defaultScreenWidth = 950;
            this.defaultScreenHeight = 425;
            this.mapFileId = 0;
            this.preloadList = new Array();
            this.data = new Object();
            this.persistentData = new Object();
            this.mapReady = false;
            this.mapLoader = new MapLoader();
            this.mapLoader.addEventListener("onMapLoaded", this.onMapLoaded, false, 0, true);
            this.mapPreloader = new MapLoader();
            this.mapPreloader.addEventListener("onMapLoaded", this.onMapPreloaded, false, 0, true);
            this.scroller = new Scroller();
            this.setDefaultScreenSize();
            this.userContent = null;
            this.bulleContent = null;
            this.quality = new Quality();
            this.userContentList = new Array();
        }

        public function init():*{
            this.onChangeScreenSize();
        }

        public function onQualitySoundChange(_arg_1:Event):*{
        }

        public function onQualityChange(_arg_1:Event):*{
            this.mapManagerUpdateQuality();
        }

        public function mapManagerUpdateQuality():*{
            this.scroller.scrollMode = ((this._quality.scrollMode == 1) ? 0 : 1);
        }

        public function onMapReady(_arg_1:Event=null):*{
            this.currentMap.removeEventListener("onMapReady", this.onMapReady, false);
            this.mapReady = true;
            var _local_2:Sprite = new Sprite();
            _local_2.graphics.beginFill(0, 100);
            _local_2.graphics.lineTo(this.screenWidth, 0);
            _local_2.graphics.lineTo(this.screenWidth, this.screenHeight);
            _local_2.graphics.lineTo(0, this.screenHeight);
            _local_2.graphics.lineTo(0, 0);
            _local_2.graphics.endFill();
            this.currentMap.addChildAt(_local_2, 0);
            this.currentMap.graphic.mask = _local_2;
        }

        public function rebuildMapCollision():*{
            if (this.physic){
                this.physic.dispose();
                this.physic = null;
            };
            this.physic = new Physic();
            this.physic.readMap(this.currentMap.physic.surfaceMap, this.currentMap.physic.environmentMap, this.currentMap.mapWidth, this.currentMap.mapHeight);
        }

        public function updateMapCollision():*{
            this.physic.updateCollisionMap(this.currentMap.physic.surfaceMap, this.currentMap.mapWidth, this.currentMap.mapHeight);
        }

        public function getUserContentByName(_arg_1:String):Sprite{
            var _local_2:uint;
            while (_local_2 < this.userContentList.length) {
                if (this.userContentList[_local_2].name == ("userContent_" + _arg_1)){
                    return (this.userContentList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function onChangeScreenSize():*{
            this.scroller.screenWidth = this.screenWidth;
            this.scroller.screenHeight = this.screenHeight;
        }

        public function setDefaultScreenSize():*{
            this.screenWidth = this.defaultScreenWidth;
            this.screenHeight = this.defaultScreenHeight;
            if (this.currentMap){
                if (this.currentMap.mapWidth < this.defaultScreenWidth){
                    this.screenWidth = this.currentMap.mapWidth;
                };
                if (this.currentMap.mapHeight < this.defaultScreenHeight){
                    this.screenHeight = this.currentMap.mapHeight;
                };
            };
            this.onChangeScreenSize();
        }

        public function setScreenSize(_arg_1:Number, _arg_2:Number):*{
            this.screenWidth = _arg_1;
            this.screenHeight = _arg_2;
            this.onChangeScreenSize();
        }

        public function abortPreload(_arg_1:int=-1):*{
            if (this.mapPreloader){
                if (this.mapPreloader.currentLoad){
                    if (this.mapPreloader.currentLoad.id != _arg_1){
                        this.mapPreloader.abortLoad();
                    };
                };
            };
            this.preloadList.splice(0, this.preloadList.length);
        }

        public function onMapPreloaded(_arg_1:Event=null):*{
            var _local_2:uint;
            if (((this.preloadList.length) && (!(this.mapPreloader.currentLoad)))){
                _local_2 = this.preloadList.shift();
                this.mapPreloader.loadMap(_local_2);
            };
        }

        public function addPreloadList(_arg_1:uint):*{
            if (!this.mapPreloader.getMapById(_arg_1)){
                this.preloadList.push(_arg_1);
                this.onMapPreloaded();
            };
        }

        public function optimizeClipCreateBitmap(_arg_1:Array):*{
            var _local_3:uint;
            var _local_6:Matrix;
            var _local_7:Matrix;
            var _local_2:Rectangle;
            _local_3 = 0;
            while (_local_3 < _arg_1.length) {
                if (_local_2){
                    _local_2 = _local_2.union(_arg_1[_local_3].getBounds(_arg_1[_local_3].parent));
                }
                else {
                    _local_2 = _arg_1[_local_3].getBounds(_arg_1[_local_3].parent);
                };
                _local_3++;
            };
            var _local_4:MultiBitmapData = new MultiBitmapData(Math.ceil(_local_2.width), Math.ceil(_local_2.height), true, 0);
            _local_3 = 0;
            while (_local_3 < _arg_1.length) {
                _local_6 = new Matrix();
                _local_6.translate((_arg_1[_local_3].x - _local_2.x), (_arg_1[_local_3].y - _local_2.y));
                _local_7 = new Matrix();
                _local_7.scale(_arg_1[_local_3].scaleX, _arg_1[_local_3].scaleY);
                _local_6.concat(_local_7);
                _local_4.draw(_arg_1[_local_3], _local_6);
                _local_3++;
            };
            var _local_5:Sprite = _local_4.getSprite();
            _local_5.x = _local_2.x;
            _local_5.y = _local_2.y;
            _local_5.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
            _arg_1[0].parent.addChildAt(_local_5, _arg_1[0].parent.getChildIndex(_arg_1[0]));
            _local_3 = 0;
            while (_local_3 < _arg_1.length) {
                _arg_1[_local_3].parent.removeChild(_arg_1[_local_3]);
                _local_3++;
            };
            _arg_1.splice(0, _arg_1.length);
        }

        public function optimizeClip(_arg_1:DisplayObjectContainer, _arg_2:Boolean=false, _arg_3:uint=0):Boolean{
            var _local_7:DisplayObject;
            var _local_8:Boolean;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:Boolean;
            var _local_4:Array = new Array();
            var _local_5:Boolean = true;
            var _local_6:int = (_arg_1.numChildren - 1);
            while (_local_6 >= 0) {
                _local_7 = _arg_1.getChildAt(_local_6);
                _local_8 = false;
                _local_9 = false;
                _local_10 = true;
                _local_11 = false;
                if ((_local_7 is MovieClip)){
                    if (MovieClip(_local_7).totalFrames > 1){
                        _local_8 = true;
                        _local_5 = false;
                    };
                };
                if (_local_7.name.split("rainMask").length == 2){
                    _local_5 = false;
                    _local_11 = true;
                };
                if (_local_7.name.split("instance").length != 2){
                    _local_5 = false;
                    _local_9 = true;
                };
                if (((!(_local_8)) && (!(_local_11)))){
                    if ((_local_7 is DisplayObjectContainer)){
                        _local_10 = this.optimizeClip(DisplayObjectContainer(_local_7), false, (_arg_3 + 1));
                    };
                    if (!_local_10){
                        _local_5 = false;
                    };
                    if (((_local_10) && (!(_local_9)))){
                        _local_4.push(_local_7);
                    };
                };
                if (((_local_4.length) && ((((_local_9) || (_local_8)) || (!(_local_10))) || (_local_11)))){
                    this.optimizeClipCreateBitmap(_local_4);
                };
                _local_6--;
            };
            if ((((_arg_2) || (!(_arg_1.name.split("instance").length == 2))) && (_local_4.length))){
                this.optimizeClipCreateBitmap(_local_4);
            };
            return (_local_5);
        }

        public function onMapLoaded(_arg_1:Event):*{
            var _local_2:*;
            var _local_3:Number;
            var _local_4:DisplayObjectContainer;
            var _local_5:Array;
            var _local_9:*;
            var _local_10:*;
            var _local_11:ScrollerItem;
            this.data = new Object();
            this.currentMap = new this.mapLoader.lastLoad.classRef();
            this.setDefaultScreenSize();
            addChild(DisplayObject(this.currentMap));
            this.currentMap.addEventListener("onMapReady", this.onMapReady, false, 0, true);
            this.scroller.mapWidth = this.currentMap.mapWidth;
            this.scroller.mapHeight = this.currentMap.mapHeight;
            this.scroller.depthScrollEffect = ((this.currentMap.depthScrollEffect) ? true : false);
            this.scroller.relativeObject = this.currentMap.graphic;
            this.rebuildMapCollision();
            _local_2 = (this.currentMap.graphic.numChildren - 1);
            while (_local_2 >= 0) {
                _local_4 = this.currentMap.graphic.getChildAt(_local_2);
                _local_2--;
            };
            var _local_6:DisplayObjectContainer;
            var _local_7:DisplayObjectContainer;
            _local_2 = (this.currentMap.graphic.numChildren - 1);
            while (_local_2 >= 0) {
                _local_4 = this.currentMap.graphic.getChildAt(_local_2);
                _local_5 = _local_4.name.split("plan_");
                if (_local_5.length == 2){
                    if (((_local_5[1] == 5) && (!(_local_6)))){
                        _local_6 = _local_4;
                        _local_9 = this.getChildList(_local_4, 10);
                        _local_3 = 0;
                        while (_local_3 < _local_9.length) {
                            if (_local_9[_local_3].target.name.split("_")[0] == "userContent"){
                                this.userContentList.push(_local_9[_local_3].target);
                            };
                            _local_3++;
                        };
                    };
                    if (((_local_5[1] > 5) && (!(_local_7)))){
                        _local_7 = _local_4;
                    };
                };
                _local_2--;
            };
            if (((!(_local_6)) && (!(this.userContentList.length)))){
                _local_6 = new Sprite();
                _local_6.name = "plan_5";
                if (!_local_7){
                    this.currentMap.graphic.addChild(_local_6);
                }
                else {
                    _local_10 = this.currentMap.graphic.getChildIndex(_local_7);
                    this.currentMap.graphic.addChildAt(_local_6, (_local_10 + 1));
                };
            };
            if (((_local_6) && (!(this.userContentList.length)))){
                this.userContent = new Sprite();
                _local_6.addChild(this.userContent);
                this.userContentList.push(this.userContent);
            };
            this.userContentList.sortOn("name", Array.CASEINSENSITIVE);
            this.userContent = this.userContentList[0];
            this.lightContent = new Sprite();
            _local_2 = this.userContent.parent.getChildIndex(this.userContent);
            this.userContent.parent.addChildAt(this.lightContent, (_local_2 + 1));
            this.bulleContent = new Sprite();
            this.userContent.parent.addChild(this.bulleContent);
            var _local_8:Number = 5;
            _local_2 = (this.currentMap.graphic.numChildren - 1);
            while (_local_2 >= 0) {
                _local_4 = this.currentMap.graphic.getChildAt(_local_2);
                _local_5 = _local_4.name.split("plan_");
                if (_local_5.length == 2){
                    _local_8 = _local_5[1];
                };
                _local_11 = this.scroller.addItem();
                _local_11.plan = _local_8;
                _local_11.target = _local_4;
                _local_2--;
            };
            this.mapManagerUpdateQuality();
            this.dispatchEvent(new Event("onMapLoaded"));
        }

        public function getChildList(_arg_1:DisplayObjectContainer, _arg_2:Number=0, _arg_3:Class=null, _arg_4:Array=null, _arg_5:Number=0, _arg_6:Number=0):Array{
            var _local_8:DisplayObject;
            var _local_9:*;
            var _local_10:ScrollerItem;
            if (!_arg_4){
                _arg_4 = new Array();
            };
            if (!_arg_3){
                _arg_3 = DisplayObjectContainer;
            };
            _arg_2--;
            _arg_6++;
            var _local_7:* = 0;
            while (((_local_7 < _arg_1.numChildren) && (_arg_2 >= -1))) {
                _local_8 = _arg_1.getChildAt(_local_7);
                if (_arg_6 == 1){
                    _local_9 = _local_8.name.split("plan_");
                    if (_local_9.length == 2){
                        _arg_5 = _local_9[1];
                    };
                };
                if ((_local_8 is _arg_3)){
                    _local_10 = new ScrollerItem();
                    _local_10.plan = _arg_5;
                    _local_10.target = _local_8;
                    _arg_4.push(_local_10);
                };
                if ((_local_8 is DisplayObjectContainer)){
                    this.getChildList(DisplayObjectContainer(_local_8), _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
                };
                _local_7++;
            };
            return (_arg_4);
        }

        public function dispose():*{
            if (this.parent){
                this.parent.removeChild(this);
            };
            this.abortPreload();
            this.unloadMap();
            this.mapLoader.removeEventListener("onMapLoaded", this.onMapLoaded, false);
            this.mapPreloader.removeEventListener("onMapLoaded", this.onMapPreloaded, false);
            this._quality.removeEventListener("onChanged", this.onQualityChange, false);
            this._quality.removeEventListener("onSoundChanged", this.onQualitySoundChange, false);
            this.dispatchEvent(new Event("onDisposed"));
        }

        public function unloadMap():*{
            this.scroller.clearAllItem();
            this.scroller.relativeObject = null;
            this.mapReady = false;
            if (this.currentMap){
                removeChild(DisplayObject(this.currentMap));
                this.currentMap.removeEventListener("onMapReady", this.onMapReady, false);
                this.currentMap.dispose();
            };
            this.currentMap = null;
            this.userContent = null;
            this.userContentList = new Array();
            this.bulleContent = null;
            if (this.physic){
                this.physic.dispose();
                this.physic = null;
            };
            this.dispatchEvent(new Event("onUnloadMap"));
        }

        public function loadMap(_arg_1:int):*{
            this.abortPreload(_arg_1);
            this.unloadMap();
            this.mapFileId = _arg_1;
            this.mapLoader.loadMap(_arg_1);
        }

        public function set mapFileId(_arg_1:int):*{
            this._mapFileId = {"val":_arg_1};
        }

        public function get mapFileId():int{
            return (this._mapFileId.val);
        }

        public function get quality():Quality{
            return (this._quality);
        }

        public function set quality(_arg_1:Quality):*{
            if (_arg_1 != this._quality){
                if (this._quality){
                    this._quality.removeEventListener("onChanged", this.onQualityChange, false);
                    this._quality.removeEventListener("onSoundChanged", this.onQualitySoundChange, false);
                };
                this._quality = _arg_1;
                this._quality.addEventListener("onChanged", this.onQualityChange, false, 0, true);
                this._quality.addEventListener("onSoundChanged", this.onQualitySoundChange, false, 0, true);
                this.onQualityChange(null);
                this.onQualitySoundChange(null);
            };
        }


    }
}//package map

