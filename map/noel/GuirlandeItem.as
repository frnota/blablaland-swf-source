// version 467 by nota

//map.noel.GuirlandeItem

package map.noel{
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.filters.GlowFilter;

    public class GuirlandeItem {

        private static var spotColorList:Array;

        public var source:MovieClip;
        public var GB:Object;
        public var camera:Object;
        public var spotSize:Number;
        private var spotPositionList:Array;
        private var ecran:BitmapData;
        private var lastStep:int;
        private var lastStepA:int;

        public function GuirlandeItem(){
            this.spotSize = 10;
        }

        public function init():*{
            var _local_4:DisplayObject;
            var _local_5:Object;
            this.lastStep = -1;
            this.spotPositionList = new Array();
            this.source.visible = true;
            var _local_1:Rectangle = this.source.getBounds(this.source);
            _local_1.left = (_local_1.left - 10);
            _local_1.right = (_local_1.right + 10);
            _local_1.top = (_local_1.top - 10);
            _local_1.bottom = (_local_1.bottom + 10);
            this.ecran = new BitmapData(Math.ceil(_local_1.width), Math.ceil(_local_1.height), true, 0);
            if (!spotColorList){
                spotColorList = new Array();
                this.addSpotColor(new ColorTransform(0, 1, 1));
                this.addSpotColor(new ColorTransform(1, 1, 0));
                this.addSpotColor(new ColorTransform(1, 0, 0));
                this.addSpotColor(new ColorTransform(1, 0, 1));
                this.addSpotColor(new ColorTransform(1, 1, 1));
                this.addSpotColor(new ColorTransform(0.2, 0.2, 1));
                this.addSpotColor(new ColorTransform(0, 1, 0));
            };
            var _local_2:* = 0;
            while (_local_2 < this.source.numChildren) {
                _local_4 = this.source.getChildAt(_local_2);
                if (((_local_4 is MovieClip) && (!(_local_4.name == "nospot")))){
                    this.spotPositionList.push(new Point((_local_4.x - _local_1.left), (_local_4.y - _local_1.top)));
                    this.source.removeChildAt(_local_2);
                    _local_2--;
                };
                _local_2++;
            };
            var _local_3:* = new Bitmap(this.ecran);
            _local_3.x = (_local_1.left - (this.spotSize / 2));
            _local_3.y = (_local_1.top - (this.spotSize / 2));
            _local_3.blendMode = "hardlight";
            this.source.addChild(_local_3);
            if (this.camera.lightEffect){
                _local_5 = this.camera.lightEffect.addItem(this.source);
                _local_5.invertLight = true;
                _local_5.redraw();
            };
            this.source.addEventListener("enterFrame", this.enterF, false);
        }

        public function enterF(_arg_1:Event):*{
            var _local_2:Array;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:uint;
            var _local_6:uint;
            if (this.GB.noelFx.noelLight){
                _local_2 = this.source.name.split("_");
                _local_3 = 0;
                if (_local_2.length >= 2){
                    _local_3 = Math.round(Number(_local_2[1]));
                };
                _local_4 = this.GB.serverTime;
                _local_5 = (_local_4 % 60000);
                if (_local_5 < 20000){
                    _local_6 = 0;
                }
                else {
                    if (_local_5 < 40000){
                        _local_6 = 1;
                    }
                    else {
                        if (_local_5 < 60000){
                            _local_6 = 2;
                        };
                    };
                };
                _local_6 = (_local_6 + _local_3);
                _local_6 = (_local_6 % 3);
                if (_local_6 == 0){
                    this.doStepA(_local_4, (!(this.lastStep == _local_6)));
                }
                else {
                    if (_local_6 == 1){
                        this.doStepB(_local_4, (!(this.lastStep == _local_6)));
                    }
                    else {
                        if (_local_6 == 2){
                            this.doStepC(_local_4, (!(this.lastStep == _local_6)));
                        };
                    };
                };
                this.lastStep = _local_6;
            };
        }

        public function addSpotColor(_arg_1:ColorTransform):*{
            var _local_2:Number = (((0xFF000000 + Math.round((_arg_1.redMultiplier * 0xFF0000))) + Math.round((_arg_1.greenMultiplier * 0xFF00))) + Math.round((_arg_1.blueMultiplier * 0xFF)));
            var _local_3:BitmapData = new BitmapData(this.spotSize, this.spotSize, true, 0);
            var _local_4:Rectangle = _local_3.rect;
            _local_4.left = (_local_4.left + 4);
            _local_4.right = (_local_4.right - 4);
            _local_4.top = (_local_4.top + 4);
            _local_4.bottom = (_local_4.bottom - 4);
            _local_3.fillRect(_local_4, _local_2);
            _local_3.applyFilter(_local_3, _local_3.rect, new Point(), new GlowFilter(_local_2, 1, 5, 5, 10, 3));
            spotColorList.push(_local_3);
        }

        public function dispose():*{
            if (this.camera.lightEffect){
                this.camera.lightEffect.removeItemByTarget(this.source);
            };
            this.source.removeEventListener("enterFrame", this.enterF, false);
        }

        public function doStepA(_arg_1:Number, _arg_2:Boolean):*{
            var _local_4:uint;
            var _local_5:Array;
            var _local_6:*;
            var _local_3:uint = uint(Math.floor((_arg_1 / 2000)));
            if (((!(_local_3 == this.lastStepA)) || (_arg_2))){
                _local_4 = (_local_3 % spotColorList.length);
                _local_5 = new Array();
                _local_6 = 0;
                while (_local_6 < this.spotPositionList.length) {
                    _local_5.push(new Point(_local_6, _local_4));
                    _local_6++;
                };
                this.redraw(_local_5);
                this.lastStepA = _local_3;
            };
        }

        public function doStepB(_arg_1:Number, _arg_2:Boolean):*{
            var _local_4:uint;
            var _local_5:Array;
            var _local_6:*;
            var _local_3:uint = uint(Math.floor((_arg_1 / 1000)));
            if (((!(_local_3 == this.lastStepA)) || (_arg_2))){
                _local_4 = uint((Math.floor((_arg_1 / 5000)) % spotColorList.length));
                _local_5 = new Array();
                _local_6 = 0;
                while (_local_6 < this.spotPositionList.length) {
                    if (((_local_3 + _local_6) % 3) == 0){
                        _local_5.push(new Point(_local_6, _local_4));
                    };
                    _local_6++;
                };
                this.redraw(_local_5);
                this.lastStepA = _local_3;
            };
        }

        public function doStepC(_arg_1:Number, _arg_2:Boolean):*{
            var _local_4:Array;
            var _local_5:*;
            var _local_3:uint = uint(Math.floor((_arg_1 / 2000)));
            if (((!(_local_3 == this.lastStepA)) || (_arg_2))){
                _local_4 = new Array();
                _local_5 = 0;
                while (_local_5 < this.spotPositionList.length) {
                    _local_4.push(new Point(_local_5, ((_local_3 + (_local_5 % 2)) % spotColorList.length)));
                    _local_5++;
                };
                this.redraw(_local_4);
                this.lastStepA = _local_3;
            };
        }

        public function redraw(_arg_1:Array):*{
            var _local_3:BitmapData;
            this.ecran.lock();
            this.ecran.colorTransform(this.ecran.rect, new ColorTransform(0, 0, 0, 0));
            var _local_2:* = 0;
            while (_local_2 < _arg_1.length) {
                _local_3 = spotColorList[_arg_1[_local_2].y];
                this.ecran.copyPixels(_local_3, _local_3.rect, this.spotPositionList[_arg_1[_local_2].x], null, null, true);
                _local_2++;
            };
            this.ecran.unlock();
        }


    }
}//package map.noel

