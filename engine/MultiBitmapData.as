// version 467 by nota

//engine.MultiBitmapData

package engine{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.IBitmapDrawable;
    import flash.geom.ColorTransform;

    public class MultiBitmapData {

        public var matrix:Array;
        public var mapWidth:uint;
        public var mapHeight:uint;
        public var width:uint;
        public var height:uint;
        private var nbX:uint;
        private var nbY:uint;

        public function MultiBitmapData(_arg_1:int, _arg_2:int, _arg_3:Boolean=true, _arg_4:uint=0xFFFFFFFF){
            var _local_6:*;
            var _local_7:*;
            super();
            this.width = _arg_1;
            this.height = _arg_2;
            this.mapWidth = 2800;
            this.mapHeight = 2800;
            this.matrix = new Array();
            this.nbX = Math.ceil((this.width / this.mapWidth));
            this.nbY = Math.ceil((this.height / this.mapHeight));
            var _local_5:* = 0;
            while (_local_5 < this.nbX) {
                this.matrix.push(new Array());
                _local_6 = 0;
                while (_local_6 < this.nbY) {
                    _arg_1 = ((((_local_5 + 1) * this.mapWidth) <= this.width) ? this.mapWidth : (this.width - (_local_5 * this.mapWidth)));
                    _arg_2 = ((((_local_6 + 1) * this.mapHeight) <= this.height) ? this.mapHeight : (this.height - (_local_6 * this.mapHeight)));
                    _local_7 = new BitmapData(_arg_1, _arg_2, _arg_3, _arg_4);
                    this.matrix[_local_5].push(_local_7);
                    _local_6++;
                };
                _local_5++;
            };
        }

        public function getSprite():Sprite{
            var _local_3:*;
            var _local_4:*;
            var _local_1:Sprite = new Sprite();
            var _local_2:* = 0;
            while (_local_2 < this.nbX) {
                _local_3 = 0;
                while (_local_3 < this.nbY) {
                    _local_4 = new Bitmap(this.matrix[_local_2][_local_3], "auto", false);
                    _local_1.addChild(_local_4);
                    _local_4.x = (_local_2 * this.mapWidth);
                    _local_4.y = (_local_3 * this.mapHeight);
                    _local_3++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function getPixel(_arg_1:int, _arg_2:int):uint{
            var _local_8:*;
            var _local_3:* = Math.floor((_arg_1 / this.mapWidth));
            var _local_4:* = Math.floor((_arg_2 / this.mapHeight));
            if (_local_3 >= this.nbX){
                _local_3 = (this.nbX - 1);
            };
            if (_local_4 >= this.nbY){
                _local_4 = (this.nbY - 1);
            };
            var _local_5:* = (_arg_1 - (_local_3 * this.mapWidth));
            var _local_6:* = (_arg_2 - (_local_4 * this.mapHeight));
            var _local_7:* = this.matrix[_local_3];
            if (_local_7){
                _local_8 = _local_7[_local_4];
                if (_local_8){
                    return (_local_8.getPixel(_local_5, _local_6));
                };
            };
            return (0);
        }

        public function getPixel32(_arg_1:int, _arg_2:int):uint{
            var _local_8:*;
            var _local_3:* = Math.floor((_arg_1 / this.mapWidth));
            var _local_4:* = Math.floor((_arg_2 / this.mapHeight));
            if (_local_3 >= this.nbX){
                _local_3 = (this.nbX - 1);
            };
            if (_local_4 >= this.nbY){
                _local_4 = (this.nbY - 1);
            };
            var _local_5:* = (_arg_1 - (_local_3 * this.mapWidth));
            var _local_6:* = (_arg_2 - (_local_4 * this.mapHeight));
            var _local_7:* = this.matrix[_local_3];
            if (_local_7){
                _local_8 = _local_7[_local_4];
                if (_local_8){
                    return (_local_8.getPixel32(_local_5, _local_6));
                };
            };
            return (0);
        }

        public function dispose():void{
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < this.nbX) {
                _local_2 = 0;
                while (_local_2 < this.nbY) {
                    this.matrix[_local_1][_local_2].dispose();
                    _local_2++;
                };
                _local_1++;
            };
        }

        public function draw(_arg_1:IBitmapDrawable, _arg_2:Matrix=null, _arg_3:ColorTransform=null, _arg_4:String=null, _arg_5:Rectangle=null, _arg_6:Boolean=false):void{
            var _local_8:*;
            var _local_9:Matrix;
            var _local_10:*;
            var _local_11:Rectangle;
            var _local_7:* = 0;
            while (_local_7 < this.nbX) {
                _local_8 = 0;
                while (_local_8 < this.nbY) {
                    _local_10 = new Matrix();
                    _local_10.translate((-(_local_7) * this.mapWidth), (-(_local_8) * this.mapHeight));
                    if (_arg_2){
                        _local_9 = _arg_2.clone();
                        _local_9.concat(_local_10);
                    }
                    else {
                        _local_9 = _local_10;
                    };
                    _local_11 = null;
                    if (_arg_5){
                        _local_11 = _arg_5.clone();
                        _local_11.left = (_local_11.left - (_local_7 * this.mapWidth));
                        _local_11.top = (_local_11.top - (_local_8 * this.mapHeight));
                        _local_11.width = (_local_11.width - (_local_7 * this.mapWidth));
                        _local_11.height = (_local_11.height - (_local_8 * this.mapHeight));
                    };
                    this.matrix[_local_7][_local_8].draw(_arg_1, _local_9, _arg_3, _arg_4, _local_11, _arg_6);
                    _local_8++;
                };
                _local_7++;
            };
        }


    }
}//package engine

