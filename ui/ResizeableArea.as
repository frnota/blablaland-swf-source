// version 467 by nota

//ui.ResizeableArea

package ui{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;

    public class ResizeableArea extends Sprite {

        public var source:MovieClip;
        private var _width:Number;
        private var _height:Number;
        private var _map:Array;
        private var mainbtmd:BitmapData;
        private var P0:Bitmap;
        private var P1:Bitmap;
        private var P2:Bitmap;
        private var P3:Bitmap;
        private var P4:Bitmap;
        private var P5:Bitmap;
        private var P6:Bitmap;
        private var P7:Bitmap;
        private var P8:Bitmap;
        private var P9:Bitmap;

        public function ResizeableArea(){
            var _local_2:*;
            super();
            this.source.stop();
            this.source.scaleX = (this.source.scaleY = 0);
            this.source.visible = false;
            this._map = new Array();
            this._map.push({
                "_x":-1,
                "_y":-1
            });
            this._map.push({
                "_x":0,
                "_y":-1
            });
            this._map.push({
                "_x":1,
                "_y":-1
            });
            this._map.push({
                "_x":1,
                "_y":0
            });
            this._map.push({
                "_x":1,
                "_y":1
            });
            this._map.push({
                "_x":0,
                "_y":1
            });
            this._map.push({
                "_x":-1,
                "_y":1
            });
            this._map.push({
                "_x":-1,
                "_y":0
            });
            this._map.push({
                "_x":0,
                "_y":0
            });
            this._width = 100;
            this._height = 100;
            var _local_1:uint;
            while (_local_1 < 9) {
                _local_2 = new Bitmap();
                this[("P" + _local_1.toString())] = _local_2;
                addChild(_local_2);
                _local_1++;
            };
            this.redraw();
        }

        private function getMatrix(_arg_1:Number, _arg_2:Number, _arg_3:Rectangle):Matrix{
            var _local_4:Matrix = new Matrix();
            _local_4.translate(((_arg_1 < 0) ? _arg_3.left : ((_arg_1 > 0) ? -100 : 0)), ((_arg_2 < 0) ? _arg_3.top : ((_arg_2 > 0) ? -100 : 0)));
            var _local_5:Matrix = new Matrix();
            _local_5.scale(((_arg_1 == 0) ? (this._width / 100) : 1), ((_arg_2 == 0) ? (this._height / 100) : 1));
            _local_4.concat(_local_5);
            return (_local_4);
        }

        private function getScreen(_arg_1:Number, _arg_2:Number, _arg_3:Rectangle):BitmapData{
            var _local_4:Number = ((_arg_1 < 0) ? _arg_3.left : ((_arg_1 > 0) ? _arg_3.right : this._width));
            var _local_5:Number = ((_arg_2 < 0) ? _arg_3.top : ((_arg_2 > 0) ? _arg_3.bottom : this._height));
            var _local_6:* = new BitmapData(_local_4, _local_5, true, 0);
            var _local_7:* = this.getMatrix(_arg_1, _arg_2, _arg_3);
            _local_6.draw(this.source, _local_7, new ColorTransform(), null, null, true);
            return (_local_6);
        }

        public function redraw():*{
            var _local_4:*;
            this.source.scaleX = (this.source.scaleY = 100);
            var _local_1:* = 0;
            while (_local_1 < 9) {
                if (this[("P" + _local_1)].bitmapData){
                    this[("P" + _local_1)].bitmapData.dispose();
                };
                _local_1++;
            };
            var _local_2:* = this.source.getBounds(this.source);
            if (_local_2.left >= 0){
                _local_2.left = 0;
            }
            else {
                _local_2.left = -(_local_2.left);
            };
            if (_local_2.right <= 100){
                _local_2.right = 0;
            }
            else {
                _local_2.right = (_local_2.right - 100);
            };
            if (_local_2.top >= 0){
                _local_2.top = 0;
            }
            else {
                _local_2.top = -(_local_2.top);
            };
            if (_local_2.bottom <= 100){
                _local_2.bottom = 0;
            }
            else {
                _local_2.bottom = (_local_2.bottom - 100);
            };
            _local_2.left = (_local_2.left + 2);
            _local_2.right = (_local_2.right + 2);
            _local_2.top = (_local_2.top + 2);
            _local_2.bottom = (_local_2.bottom + 2);
            var _local_3:* = new Array();
            _local_1 = 0;
            while (_local_1 < 9) {
                _local_3.push(this.getScreen(this._map[_local_1]._x, this._map[_local_1]._y, _local_2));
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 9) {
                _local_4 = this[("P" + _local_1.toString())];
                _local_4.bitmapData = _local_3[_local_1];
                _local_4.smoothing = true;
                _local_1++;
            };
            this.P0.x = -(this.P0.width);
            this.P0.y = -(this.P0.height);
            this.P1.x = 0;
            this.P1.y = -(this.P1.height);
            this.P1.width = this._width;
            this.P2.x = this._width;
            this.P2.y = -(this.P2.height);
            this.P3.x = this._width;
            this.P3.y = 0;
            this.P3.height = this._height;
            this.P4.x = this._width;
            this.P4.y = this._height;
            this.P5.x = 0;
            this.P5.y = this._height;
            this.P5.width = this._width;
            this.P6.x = -(this.P6.width);
            this.P6.y = this._height;
            this.P7.x = -(this.P7.width);
            this.P7.y = 0;
            this.P7.height = this._height;
            this.P8.x = 0;
            this.P8.y = 0;
            this.P8.height = this._height;
            this.P8.width = this._width;
            this.source.scaleX = (this.source.scaleY = 0);
        }

        override public function get height():Number{
            return (this._height);
        }

        override public function set height(_arg_1:Number):void{
            this._height = Math.round(_arg_1);
        }

        override public function get width():Number{
            return (this._width);
        }

        override public function set width(_arg_1:Number):void{
            this._width = Math.round(_arg_1);
        }


    }
}//package ui

