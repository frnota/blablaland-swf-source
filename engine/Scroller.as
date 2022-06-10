// version 467 by nota

//engine.Scroller

package engine{
    import flash.display.Sprite;
    import flash.geom.Rectangle;

    public class Scroller {

        public var itemList:Array;
        public var screenWidth:Number;
        public var screenHeight:Number;
        public var mapWidth:Number;
        public var mapHeight:Number;
        public var depthScrollEffect:Boolean;
        public var relativeObject:Sprite;
        public var scrollMode:int;
        public var targetScroll:DDpoint;
        public var crantMarge:Number;
        public var curScrollX:Number;
        public var curScrollY:Number;
        public var activTarget:Boolean;
        private var curSpd:Number;

        public function Scroller(){
            this.screenWidth = 550;
            this.screenHeight = 400;
            this.mapWidth = this.screenWidth;
            this.mapHeight = this.screenHeight;
            this.depthScrollEffect = true;
            this.itemList = new Array();
            this.relativeObject = null;
            this.curScrollX = 0;
            this.curScrollY = 0;
            this.crantMarge = 0.35;
            this.scrollMode = 0;
            this.targetScroll = new DDpoint();
            this.targetScroll.init();
            this.activTarget = false;
            this.curSpd = 3;
        }

        public function clearAllItem():*{
            this.itemList.splice(0, this.itemList.length);
        }

        public function addItem():ScrollerItem{
            var _local_1:ScrollerItem = new ScrollerItem();
            this.itemList.push(_local_1);
            return (_local_1);
        }

        public function reset():*{
            this.curScrollX = 0;
            this.curScrollY = 0;
            this.targetScroll.x = 0;
            this.targetScroll.y = 0;
        }

        public function scrollX(_arg_1:Number):*{
            var _local_2:Rectangle;
            var _local_3:Number;
            var _local_4:uint;
            var _local_5:*;
            var _local_6:Number;
            var _local_7:*;
            this.curScrollX = _arg_1;
            if (this.relativeObject){
                _local_3 = (-(_arg_1) * (this.mapWidth - this.screenWidth));
                _local_4 = 0;
                while (_local_4 < this.itemList.length) {
                    _local_5 = this.itemList[_local_4];
                    _local_6 = ((this.depthScrollEffect) ? (1 / (((_local_5.plan / 5) / 10) + 0.9)) : 1);
                    _local_7 = 0;
                    if (_local_5.scrollModeX == 0){
                        _local_7 = (_local_3 * _local_6);
                    }
                    else {
                        if (_local_5.scrollModeX == 1){
                            _local_2 = _local_5.Opoint.getBounds(this.relativeObject);
                            _local_7 = (_local_5.target.x - _local_2.x);
                        }
                        else {
                            if (_local_5.scrollModeX == 2){
                                _local_7 = ((_local_3 * _local_6) % (this.screenWidth * _local_5.scrollRepeatX));
                            }
                            else {
                                if (_local_5.scrollModeX == 3){
                                    _local_2 = _local_5.Opoint.getBounds(this.relativeObject);
                                    _local_7 = ((_local_5.target.x - _local_2.x) + ((_local_3 * _local_6) % (this.screenWidth * _local_5.scrollRepeatX)));
                                }
                                else {
                                    if (_local_5.scrollModeX == 4){
                                        _local_7 = (-(_local_3) * _local_6);
                                    };
                                };
                            };
                        };
                    };
                    _local_5.target.x = ((_local_5.roundValue) ? Math.round(_local_7) : _local_7);
                    _local_4++;
                };
            };
        }

        public function scrollY(_arg_1:Number):*{
            var _local_2:Number;
            var _local_3:Rectangle;
            var _local_4:uint;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            this.curScrollY = _arg_1;
            if (this.relativeObject){
                _local_2 = (-(_arg_1) * (this.mapHeight - this.screenHeight));
                _local_4 = 0;
                while (_local_4 < this.itemList.length) {
                    _local_5 = this.itemList[_local_4];
                    _local_6 = ((this.depthScrollEffect) ? (1 / (((_local_5.plan / 5) / 10) + 0.9)) : 1);
                    _local_7 = 0;
                    if (_local_5.scrollModeY == 0){
                        _local_7 = (_local_2 * _local_6);
                    }
                    else {
                        if (_local_5.scrollModeY == 1){
                            _local_3 = _local_5.Opoint.getBounds(this.relativeObject);
                            _local_7 = (_local_5.target.y - _local_3.y);
                        }
                        else {
                            if (_local_5.scrollModeY == 2){
                                _local_7 = ((_local_2 * _local_6) % (this.screenHeight * _local_5.scrollRepeatY));
                            }
                            else {
                                if (_local_5.scrollModeY == 3){
                                    _local_3 = _local_5.Opoint.getBounds(this.relativeObject);
                                    _local_7 = ((_local_5.target.y - _local_3.y) + ((_local_2 * _local_6) % (this.screenHeight * _local_5.scrollRepeatY)));
                                };
                            };
                        };
                    };
                    _local_5.target.y = ((_local_5.roundValue) ? Math.round(_local_7) : _local_7);
                    _local_4++;
                };
            };
        }

        public function scrollToX(_arg_1:Number):*{
            var _local_2:Number;
            var _local_3:Number;
            if (this.relativeObject){
                _local_2 = (this.mapWidth - this.screenWidth);
                _local_3 = ((_arg_1 - (this.screenWidth / 2)) / _local_2);
                this.scrollX(Math.max(Math.min(_local_3, 1), 0));
            };
        }

        public function scrollToY(_arg_1:Number):*{
            var _local_2:Number;
            var _local_3:Number;
            if (this.relativeObject){
                _local_2 = (this.mapHeight - this.screenHeight);
                _local_3 = ((_arg_1 - (this.screenHeight / 2)) / _local_2);
                this.scrollY(Math.max(Math.min(_local_3, 1), 0));
            };
        }

        public function step():*{
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            if (((this.activTarget) && ((this.scrollMode == 0) || (this.scrollMode == 1)))){
                _local_1 = new DDpoint();
                _local_1.x = ((this.targetScroll.x - this.curScrollX) * this.mapWidth);
                _local_1.y = ((this.targetScroll.y - this.curScrollY) * this.mapHeight);
                _local_2 = _local_1.getLength();
                _local_1.normalize();
                if (_local_2 > 0){
                    this.curSpd = (this.curSpd + Math.max((_local_2 / 100), 0.9));
                };
                _local_3 = this.curSpd;
                if (_local_2 < 200){
                    _local_3 = (_local_3 * Math.min((0.1 + ((2 * (_local_2 - 10)) / (200 - 10))), 1));
                };
                _local_4 = Math.min(Math.max((this.curScrollX + ((((_local_1.x >= 0) ? 1 : -1) * (_local_3 / this.mapWidth)) * Math.abs(_local_1.x))), 0), 1);
                _local_5 = Math.min(Math.max((this.curScrollY + ((((_local_1.y >= 0) ? 1 : -1) * (_local_3 / this.mapHeight)) * Math.abs(_local_1.y))), 0), 1);
                if (_local_2 <= 10){
                    this.activTarget = false;
                    this.curSpd = 3;
                    _local_4 = this.targetScroll.x;
                    _local_5 = this.targetScroll.y;
                };
                this.scrollX(_local_4);
                this.scrollY(_local_5);
            };
        }

        public function stepScrollTo(_arg_1:Number, _arg_2:Number, _arg_3:Object=null):*{
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:*;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:*;
            var _local_10:Number;
            var _local_11:Number;
            if (!_arg_3){
                _arg_3 = new Object();
            };
            if (this.itemList.length){
                _local_4 = 0;
                _local_5 = (this.mapWidth - this.screenWidth);
                if (_local_5 > 0){
                    _local_10 = ((_arg_1 - (this.screenWidth / 2)) / _local_5);
                    _local_4 = Math.max(Math.min(_local_10, 1), 0);
                };
                _local_6 = (Math.abs(((this.itemList[0].target.x + _arg_1) - (this.screenWidth / 2))) >= (this.screenWidth * this.crantMarge));
                _local_6 = ((_local_6) && (!(_local_4 == (Math.round((this.curScrollX * 100)) / 100))));
                _local_7 = 0;
                _local_8 = (this.mapHeight - this.screenHeight);
                if (_local_8 > 0){
                    _local_11 = ((_arg_2 - (this.screenHeight / 2)) / _local_8);
                    _local_7 = Math.max(Math.min(_local_11, 1), 0);
                };
                _local_9 = (Math.abs(((this.itemList[0].target.y + _arg_2) - (this.screenHeight / 2))) >= (this.screenHeight * this.crantMarge));
                _local_9 = ((_local_9) && (!(_local_7 == (Math.round((this.curScrollY * 100)) / 100))));
                if (this.scrollMode == 2){
                    this.scrollX(_local_4);
                    this.scrollY(_local_7);
                }
                else {
                    if (((_local_6) || (_local_9))){
                        if (((this.scrollMode == 0) && (!(_arg_3.forceBinary)))){
                            this.targetScroll.x = _local_4;
                            this.targetScroll.y = _local_7;
                            this.activTarget = true;
                        }
                        else {
                            this.scrollX(_local_4);
                            this.scrollY(_local_7);
                        };
                    };
                };
            };
        }


    }
}//package engine

