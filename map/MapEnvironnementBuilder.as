// version 467 by nota

//map.MapEnvironnementBuilder

package map{
    import bbl.ExternalLoader;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import engine.ScrollerItem;
    import flash.geom.Rectangle;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.InteractiveObject;

    public class MapEnvironnementBuilder extends MapManager {

        public var earthQuake:EarthQuake = new EarthQuake();
        public var snowEffect:SnowEffect = new SnowEffect();
        public var daytimeEffect:DaytimeEffect = new DaytimeEffect();
        public var seasonEffect:SeasonEffect = new SeasonEffect();
        public var rainEffect:RainEffect = new RainEffect();
        public var fogEffect:FogEffect = new FogEffect();
        public var sky:Object = null;
        public var lightEffect:LightEffect = null;
        public var externalLoader:ExternalLoader = new ExternalLoader();

        public function MapEnvironnementBuilder(){
            this.rainEffect.syncSteper.clock = GlobalProperties.screenSteper;
            this.externalLoader.addEventListener("onReady", this.onExternalReady, false, 0, true);
            this.externalLoader.load();
            super();
        }

        override public function unloadMap():*{
            super.unloadMap();
            this.clear();
        }

        override public function dispose():*{
            super.dispose();
            this.clear();
            this.rainEffect.dispose();
        }

        public function clear():*{
            this.earthQuake.stop();
            this.daytimeEffect.clearAllItem();
            this.seasonEffect.clearAllItem();
            this.snowEffect.clearAllItem();
            this.rainEffect.clearAllItem();
            this.earthQuake.target = null;
            this.fogEffect.clearAllItem();
            if (this.lightEffect){
                this.lightEffect.dispose();
                this.lightEffect = null;
            };
            if (this.sky){
                this.sky.dispose();
                this.sky = null;
            };
        }

        override public function init():*{
            super.init();
            this.rainEffect.screenWidth = screenWidth;
            this.rainEffect.screenHeight = screenHeight;
            this.rainEffect.redraw();
        }

        public function onExternalReady(_arg_1:Event):*{
            var _local_2:* = this.externalLoader.getClass("EarthQuakeSnd");
            this.earthQuake.soundClass = _local_2;
            _local_2 = this.externalLoader.getClass("RainSnd");
            this.rainEffect.rainSndClass = _local_2;
        }

        override public function onQualityChange(_arg_1:Event):*{
            super.onQualityChange(_arg_1);
            this.mapEnvironnementBuilderUpdateQuality();
        }

        public function mapEnvironnementBuilderUpdateQuality():*{
            this.rainEffect.rainRateQuality = quality.rainRateQuality;
        }

        public function setUnRainMask(_arg_1:DisplayObject, _arg_2:Boolean):*{
            var _local_3:Array;
            var _local_4:*;
            var _local_5:*;
            var _local_6:RainEffectItem;
            var _local_7:*;
            if (((!(_arg_2)) && (_arg_1.parent))){
                _arg_1.parent.removeChild(_arg_1);
            }
            else {
                if (((_arg_2) && (userContent))){
                    _local_3 = this.rainEffect.itemList;
                    _local_4 = userContent.parent.getChildIndex(userContent);
                    _local_5 = (_local_3.length - 1);
                    while (_local_5 >= 0) {
                        _local_6 = _local_3[_local_5];
                        if (((_local_6.parent == userContent.parent) || (_local_6.parent == currentMap.graphic))){
                            _local_7 = _local_6.parent.getChildIndex(_local_6);
                            if (((_local_7 > _local_4) || (_local_6.parent == currentMap.graphic))){
                                _local_6.rainUnMask.addChild(_arg_1);
                                return;
                            };
                        };
                        _local_5--;
                    };
                };
            };
        }

        override public function onMapLoaded(_arg_1:Event):*{
            var _local_2:Array;
            var _local_3:DisplayObject;
            var _local_4:Sprite;
            var _local_5:int;
            var _local_6:RainEffectItem;
            var _local_7:ScrollerItem;
            var _local_8:*;
            var _local_10:DisplayObject;
            var _local_11:Boolean;
            var _local_12:Rectangle;
            var _local_13:*;
            var _local_14:*;
            var _local_15:int;
            var _local_16:*;
            var _local_17:String;
            var _local_18:*;
            var _local_19:Object;
            super.onMapLoaded(_arg_1);
            this.earthQuake.target = currentMap.graphic;
            if (currentMap.rainEffect){
                this.rainEffect.sndVolume = 1;
                if (("rainEffectVolume" in currentMap)){
                    this.rainEffect.sndVolume = currentMap.rainEffectVolume;
                };
                _local_11 = false;
                _local_2 = getChildList(currentMap.graphic, 10, DisplayObjectContainer);
                _local_5 = 0;
                while (_local_5 < _local_2.length) {
                    if (_local_2[_local_5].target.name.split("_")[0] == "rainMask"){
                        _local_6 = this.rainEffect.addItem();
                        _local_11 = true;
                        _local_12 = _local_2[_local_5].target.getBounds(_local_2[_local_5].target.parent);
                        if (((_local_12.width > screenWidth) || (_local_12.height > screenHeight))){
                            _local_7 = scroller.addItem();
                            _local_7.scrollModeX = 4;
                            _local_7.scrollModeY = 4;
                            _local_7.plan = _local_2[_local_5].plan;
                            _local_7.target = _local_6.content;
                            _local_7.roundValue = true;
                        }
                        else {
                            _local_6.x = _local_12.left;
                            _local_6.y = _local_12.top;
                            _local_6.surfaceWidth = _local_12.width;
                            _local_6.surfaceHeight = _local_12.height;
                        };
                        _local_13 = _local_2[_local_5].target.parent;
                        _local_14 = _local_13.getChildIndex(_local_2[_local_5].target);
                        _local_13.removeChildAt(_local_14);
                        _local_6.rainMask.addChild(_local_2[_local_5].target);
                        _local_2[_local_5].target.x = (_local_2[_local_5].target.x - _local_6.x);
                        _local_2[_local_5].target.y = (_local_2[_local_5].target.y - _local_6.y);
                        _local_2[_local_5].target.cacheAsBitmap = true;
                        _local_13.addChildAt(_local_6, _local_14);
                        _local_6.init();
                    };
                    _local_5++;
                };
                if (!_local_11){
                    _local_6 = this.rainEffect.addItem();
                    currentMap.graphic.addChild(_local_6);
                    if (((currentMap.mapWidth > screenWidth) || (currentMap.mapHeight > screenHeight))){
                        _local_7 = scroller.addItem();
                        _local_7.scrollModeX = 4;
                        _local_7.scrollModeY = 4;
                        _local_7.plan = 5;
                        _local_7.target = _local_6.content;
                        _local_7.roundValue = true;
                    };
                    _local_6.init();
                };
            };
            if (currentMap.fogEffect){
                this.fogEffect.screenWidth = screenWidth;
                this.fogEffect.screenHeight = screenHeight;
                _local_15 = 0;
                _local_5 = (currentMap.graphic.numChildren - 1);
                while (_local_5 >= 0) {
                    _local_3 = currentMap.graphic.getChildAt(_local_5);
                    _local_16 = _local_3.name.split("plan_");
                    if (((_local_16.length == 2) && (_local_15 < _local_16[1]))){
                        _local_15 = Number(_local_16[1]);
                        _local_4 = new Sprite();
                        _local_4.cacheAsBitmap = true;
                        currentMap.graphic.addChildAt(_local_4, (_local_5 + 1));
                        this.fogEffect.addItem(_local_4, Number(_local_16[1]));
                    };
                    _local_5--;
                };
            };
            _local_4 = new Sprite();
            currentMap.graphic.addChildAt(_local_4, 0);
            this.fogEffect.addItem(_local_4, (Math.max(_local_15, 5000) + 1000));
            if (currentMap.lightEffect){
                this.lightEffect = new LightEffect();
                _local_5 = 0;
                while (_local_5 < currentMap.graphic.numChildren) {
                    _local_3 = currentMap.graphic.getChildAt(_local_5);
                    if (_local_3.name.split("_")[0] != "unlight"){
                        this.lightEffect.addItem(_local_3);
                    };
                    _local_5++;
                };
                _local_2 = getChildList(currentMap.graphic, 10, MovieClip);
                _local_5 = 0;
                while (_local_5 < _local_2.length) {
                    if (((_local_2[_local_5].target.name.split("_")[0] == "unlight") && (!(_local_2[_local_5].target.parent == currentMap.graphic)))){
                        _local_8 = this.lightEffect.addItem(_local_2[_local_5].target);
                        _local_8.invertLight = true;
                    };
                    _local_5++;
                };
                _local_8 = this.lightEffect.addItem(lightContent);
                _local_8.invertLight = true;
            };
            _local_2 = getChildList(currentMap.graphic, 10, MovieClip);
            _local_5 = 0;
            while (_local_5 < _local_2.length) {
                _local_17 = _local_2[_local_5].target.name.split("_")[0];
                if (_local_17 == "temperature"){
                    this.snowEffect.addItem(_local_2[_local_5].target);
                };
                if (_local_17 == "daytime"){
                    this.daytimeEffect.addItem(_local_2[_local_5].target);
                };
                if (_local_17 == "season"){
                    this.seasonEffect.addItem(_local_2[_local_5].target);
                };
                _local_5++;
            };
            if (currentMap.skyLayer){
                _local_18 = this.externalLoader.getClass("map.Sky");
                _local_19 = new (_local_18)();
                currentMap.graphic.addChildAt(_local_19, 0);
                _local_19.serverId = serverId;
                _local_19.mapWidth = defaultScreenWidth;
                _local_19.mapHeight = Math.min(currentMap.horizonHeight, screenHeight);
                _local_19.reset();
                this.sky = _local_19;
            };
            var _local_9:DisplayObjectContainer = userContent;
            while (_local_9.parent != currentMap) {
                _local_5 = (_local_9.parent.numChildren - 1);
                while (_local_5 >= 0) {
                    _local_10 = _local_9.parent.getChildAt(_local_5);
                    if (_local_10 != _local_9){
                        if ((_local_10 is InteractiveObject)){
                            InteractiveObject(_local_10).mouseEnabled = false;
                        };
                        if ((_local_10 is DisplayObjectContainer)){
                            DisplayObjectContainer(_local_10).mouseChildren = false;
                        };
                    }
                    else {
                        break;
                    };
                    _local_5--;
                };
                _local_9 = _local_9.parent;
            };
            this.mapEnvironnementBuilderUpdateQuality();
        }


    }
}//package map

