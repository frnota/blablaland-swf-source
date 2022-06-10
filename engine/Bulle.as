// version 467 by nota

//engine.Bulle

package engine{
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.TextEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Bulle extends Sprite {

        public var fontColor:uint;
        public var maxWidth:uint;
        public var text:String;
        public var isHtml:Boolean;
        public var textFormat:TextFormat;
        public var direction:Boolean;
        public var type:uint;
        private var textField:TextField;
        private var shape:Shape;
        private var frameCount:uint;
        private var content:Sprite;

        public function Bulle(){
            this.content = new Sprite();
            addChild(this.content);
            this.frameCount = 0;
            this.type = 0;
            this.fontColor = 0xFFFFFF;
            this.maxWidth = 150;
            this.isHtml = false;
            this.direction = true;
            cacheAsBitmap = true;
            this.textFormat = new TextFormat();
            this.textFormat.font = "Arial";
            this.textFormat.size = 10;
        }

        public function shakeEvt(_arg_1:Event):*{
            var _local_2:uint;
            var _local_4:Number;
            _local_2 = 10;
            var _local_3:Number = 12;
            _local_4 = (_local_3 - (_local_3 / 2));
            var _local_5:Number = (1 - (this.frameCount / _local_2));
            this.content.x = Math.round(((Math.random() * _local_4) * _local_5));
            this.content.y = Math.round(((Math.random() * _local_4) * _local_5));
            this.frameCount++;
            if (this.frameCount > _local_2){
                removeEventListener("enterFrame", this.shakeEvt);
                this.content.x = (this.content.y = 0);
            };
        }

        public function fadeEvt(_arg_1:Event):*{
            var _local_2:uint = 5;
            this.content.alpha = (this.frameCount / _local_2);
            this.frameCount++;
            if (this.frameCount > _local_2){
                removeEventListener("enterFrame", this.fadeEvt);
                this.content.alpha = 1;
            };
        }

        public function clear():*{
            this.frameCount = 0;
            removeEventListener("enterFrame", this.shakeEvt);
            removeEventListener("enterFrame", this.fadeEvt);
            while (this.content.numChildren) {
                this.content.removeChildAt(0);
            };
        }

        public function dispose():*{
            this.clear();
            if (this.parent){
                this.parent.removeChild(this);
            };
        }

        public function onLinkEvt(_arg_1:TextEvent):*{
            var _local_2:TextEvent = new TextEvent("onLink");
            _local_2.text = _arg_1.text;
            dispatchEvent(_local_2);
        }

        public function redraw():*{
            this.clear();
            this.shape = new Shape();
            this.textField = new TextField();
            this.textField.addEventListener("link", this.onLinkEvt, false);
            this.content.addChild(this.shape);
            this.content.addChild(this.textField);
            if (this.type == 0){
                this.textFormat.bold = (this.textFormat.italic = false);
            };
            if (this.type == 1){
                this.textFormat.bold = false;
                this.textFormat.italic = true;
            };
            if (this.type == 2){
                this.textFormat.bold = (this.textFormat.italic = false);
            };
            this.textField.selectable = false;
            this.textField.autoSize = "left";
            this.textField.wordWrap = false;
            this.textField.multiline = false;
            this.textField.defaultTextFormat = this.textFormat;
            this.textField.antiAliasType = "advanced";
            this.textField.embedFonts = true;
            if (this.isHtml){
                this.textField.htmlText = this.text;
            }
            else {
                this.textField.text = this.text;
            };
            if (this.textField.width > this.maxWidth){
                this.textField.wordWrap = true;
                this.textField.multiline = true;
                this.textField.width = this.maxWidth;
            };
            this.textField.y = -(this.textField.height + 11);
            this.textField.x = ((this.direction) ? 2 : -(this.textField.textWidth + 2));
            if (this.type == 0){
                this.drawTalk();
            };
            if (this.type == 1){
                this.drawThink();
            };
            if (this.type == 2){
                this.drawScream();
            };
            var _local_1:DropShadowFilter = new DropShadowFilter(2, 45, 0, 1, 4, 4, 0.5, 1);
            this.shape.filters = [_local_1];
        }

        private function drawScream():*{
            var _local_1:int;
            var _local_10:Point;
            var _local_11:Point;
            var _local_12:Point;
            var _local_13:Number;
            var _local_14:Point;
            var _local_15:Rectangle;
            var _local_16:Number;
            var _local_17:Number;
            var _local_18:Point;
            addEventListener("enterFrame", this.shakeEvt);
            this.textField.y = (this.textField.y - 17);
            this.textField.x = (this.textField.x + 10);
            var _local_2:Rectangle = new Rectangle(7, 5, 9, 5);
            this.shape.graphics.lineStyle(0, 0, 0.5, true);
            this.shape.graphics.beginFill(this.fontColor, 0.85);
            var _local_3:Array = new Array();
            _local_3.push(new Point((this.textField.x - _local_2.x), (this.textField.y - _local_2.y)));
            _local_3.push(new Point(((this.textField.x + this.textField.textWidth) + _local_2.width), (this.textField.y - _local_2.y)));
            _local_3.push(new Point(((this.textField.x + this.textField.textWidth) + _local_2.width), ((this.textField.y + this.textField.height) + _local_2.height)));
            _local_3.push(new Point((this.textField.x - _local_2.x), ((this.textField.y + this.textField.height) + _local_2.height)));
            var _local_4:Number = 10;
            var _local_5:Number = 8;
            var _local_6:Number = 10;
            var _local_7:Number = 10;
            var _local_8:Point;
            var _local_9:Array = new Array();
            _local_1 = 0;
            while (_local_1 < _local_3.length) {
                _local_10 = _local_3[_local_1];
                _local_11 = _local_3[((_local_1 + 1) % _local_3.length)];
                _local_12 = new Point((_local_11.x - _local_10.x), (_local_11.y - _local_10.y));
                _local_13 = _local_12.length;
                _local_12.normalize(1);
                _local_14 = new Point(-(_local_12.y), _local_12.x);
                _local_15 = new Rectangle(_local_4, _local_6, _local_5, _local_7);
                _local_16 = (2 * (_local_15.width + (_local_15.height / 2)));
                _local_17 = (_local_13 / _local_16);
                if (_local_17 < 1){
                    _local_15.width = (_local_15.width * _local_17);
                    _local_15.height = (_local_15.height * _local_17);
                    _local_16 = (2 * (_local_15.width + (_local_15.height / 2)));
                };
                _local_9.push(new Point((_local_10.x - ((_local_14.x + _local_12.x) * _local_15.y)), (_local_10.y - ((_local_14.y + _local_12.y) * _local_15.y))));
                _local_9.push(new Point((_local_10.x + (_local_12.x * (_local_15.height / 2))), (_local_10.y + (_local_12.y * (_local_15.height / 2)))));
                _local_9.push(new Point(((_local_10.x + (_local_12.x * ((_local_15.width / 2) + (_local_15.height / 2)))) - (_local_14.x * _local_15.x)), ((_local_10.y + (_local_12.y * ((_local_15.width / 2) + (_local_15.height / 2)))) - (_local_14.y * _local_15.x))));
                if ((((!(this.direction)) && (Math.round(_local_12.x) == -1)) && (Math.round(_local_12.y) == 0))){
                    _local_8 = _local_9[(_local_9.length - 1)];
                };
                _local_9.push(new Point((_local_10.x + (_local_12.x * (_local_15.width + (_local_15.height / 2)))), (_local_10.y + (_local_12.y * (_local_15.width + (_local_15.height / 2))))));
                _local_9.push(new Point((_local_11.x - (_local_12.x * (_local_15.width + (_local_15.height / 2)))), (_local_11.y - (_local_12.y * (_local_15.width + (_local_15.height / 2))))));
                _local_9.push(new Point(((_local_11.x - (_local_12.x * ((_local_15.width / 2) + (_local_15.height / 2)))) - (_local_14.x * _local_15.x)), ((_local_11.y - (_local_12.y * ((_local_15.width / 2) + (_local_15.height / 2)))) - (_local_14.y * _local_15.x))));
                if ((((this.direction) && (Math.round(_local_12.x) == -1)) && (Math.round(_local_12.y) == 0))){
                    _local_8 = _local_9[(_local_9.length - 1)];
                };
                _local_9.push(new Point((_local_11.x - (_local_12.x * (_local_15.height / 2))), (_local_11.y - (_local_12.y * (_local_15.height / 2)))));
                _local_1++;
            };
            _local_8.x = 0;
            _local_8.y = 0;
            this.shape.graphics.moveTo(_local_9[0].x, _local_9[0].y);
            _local_1 = 0;
            while (_local_1 < _local_9.length) {
                _local_18 = _local_9[_local_1];
                this.shape.graphics.lineTo(_local_18.x, _local_18.y);
                _local_1++;
            };
        }

        private function drawThink():*{
            var _local_1:int;
            var _local_9:Number;
            var _local_10:Point;
            var _local_11:Point;
            var _local_12:Point;
            var _local_13:Point;
            var _local_14:Number;
            var _local_15:Point;
            var _local_16:Point;
            var _local_17:Point;
            var _local_18:Number;
            var _local_19:Point;
            var _local_20:Point;
            addEventListener("enterFrame", this.fadeEvt);
            this.textField.y = (this.textField.y - 12);
            var _local_2:Rectangle = new Rectangle(7, 5, 12, 5);
            this.shape.graphics.lineStyle(0, 0, 0.5, true);
            this.shape.graphics.beginFill(this.fontColor, 0.85);
            var _local_3:Array = new Array();
            _local_3.push(new Point((this.textField.x - _local_2.x), (this.textField.y - _local_2.y)));
            _local_3.push(new Point(((this.textField.x + this.textField.textWidth) + _local_2.width), (this.textField.y - _local_2.y)));
            _local_3.push(new Point(((this.textField.x + this.textField.textWidth) + _local_2.width), ((this.textField.y + this.textField.height) + _local_2.height)));
            _local_3.push(new Point((this.textField.x - _local_2.x), ((this.textField.y + this.textField.height) + _local_2.height)));
            var _local_4:Array = new Array();
            var _local_5:Number = ((this.getDistance(_local_3[0], _local_3[1]) * 2) + (this.getDistance(_local_3[1], _local_3[2]) * 2));
            var _local_6:Number = 0;
            _local_4.push(0);
            while (true) {
                _local_9 = ((Math.random() * 20) + 10);
                _local_4.push((_local_9 + _local_6));
                _local_6 = (_local_6 + _local_9);
                if ((_local_9 + _local_6) > (_local_5 - 10)) break;
            };
            var _local_7:Array = new Array();
            _local_6 = 0;
            var _local_8:Number = 0;
            _local_1 = 0;
            while (_local_1 < _local_3.length) {
                _local_10 = _local_3[_local_1];
                _local_11 = _local_3[((_local_1 + 1) % _local_3.length)];
                _local_12 = new Point((_local_11.x - _local_10.x), (_local_11.y - _local_10.y));
                _local_8 = (_local_8 + _local_12.length);
                _local_13 = _local_12.clone();
                _local_13.normalize(1);
                while (((_local_6 < _local_4.length) && (_local_4[_local_6] <= _local_8))) {
                    _local_14 = (_local_12.length - (_local_8 - _local_4[_local_6]));
                    _local_7.push(new Point((_local_10.x + (_local_13.x * _local_14)), (_local_10.y + (_local_13.y * _local_14))));
                    _local_6++;
                };
                _local_1++;
            };
            this.shape.graphics.moveTo(_local_7[0].x, _local_7[0].y);
            _local_1 = 0;
            while (_local_1 < _local_7.length) {
                _local_15 = _local_7[_local_1];
                _local_16 = _local_7[((_local_1 + 1) % _local_7.length)];
                _local_17 = new Point((_local_16.x - _local_15.x), (_local_16.y - _local_15.y));
                _local_18 = (_local_17.length / 2);
                _local_18 = (_local_18 * ((Math.random() * 0.5) + 0.5));
                if (((_local_15.x == _local_16.x) || (_local_15.y == _local_16.y))){
                };
                _local_17.normalize(1);
                _local_19 = new Point(_local_17.y, -(_local_17.x));
                _local_20 = new Point(((_local_16.x + _local_15.x) / 2), ((_local_16.y + _local_15.y) / 2));
                this.shape.graphics.curveTo((_local_20.x + (_local_18 * _local_19.x)), (_local_20.y + (_local_18 * _local_19.y)), _local_16.x, _local_16.y);
                _local_1++;
            };
            this.shape.graphics.drawCircle(0, 0, 3);
            if (this.direction){
                this.shape.graphics.drawCircle(8, -8, 5);
            }
            else {
                this.shape.graphics.drawCircle(-8, -8, 5);
            };
        }

        private function getDistance(_arg_1:Point, _arg_2:Point):Number{
            return (Math.sqrt((Math.pow((_arg_2.x - _arg_1.x), 2) + Math.pow((_arg_2.y - _arg_1.y), 2))));
        }

        private function drawTalk(_arg_1:int=15):*{
            var _local_2:Rectangle = new Rectangle(2, 0, 8, 0);
            var _local_3:* = _arg_1;
            if (((this.textField.height + _local_2.height) - _local_2.y) < (_local_3 * 2)){
                _local_3 = (((this.textField.height + _local_2.height) - _local_2.y) / 2);
            };
            if (((this.textField.textWidth + _local_2.width) - _local_2.x) < (_local_3 * 2)){
                _local_3 = (((this.textField.textWidth + _local_2.width) - _local_2.x) / 2);
            };
            _local_2.x = (_local_2.x + (_local_3 / 10));
            _local_2.y = (_local_2.y + (_local_3 / 10));
            _local_2.width = (_local_2.width + (_local_3 / 10));
            _local_2.height = (_local_2.height + (_local_3 / 10));
            this.shape.graphics.lineStyle(0, 0, 0.5, true);
            this.shape.graphics.beginFill(this.fontColor, 0.85);
            this.shape.graphics.moveTo(((this.textField.x - _local_2.x) + _local_3), (this.textField.y - _local_2.y));
            this.shape.graphics.lineTo((((this.textField.x + this.textField.textWidth) + _local_2.width) - _local_3), (this.textField.y - _local_2.y));
            this.shape.graphics.curveTo(((this.textField.x + this.textField.textWidth) + _local_2.width), (this.textField.y - _local_2.y), ((this.textField.x + this.textField.textWidth) + _local_2.width), ((this.textField.y - _local_2.y) + _local_3));
            this.shape.graphics.lineTo(((this.textField.x + this.textField.textWidth) + _local_2.width), (((this.textField.y + this.textField.height) + _local_2.height) - _local_3));
            this.shape.graphics.curveTo(((this.textField.x + this.textField.textWidth) + _local_2.width), ((this.textField.y + this.textField.height) + _local_2.height), (((this.textField.x + this.textField.textWidth) + _local_2.width) - _local_3), ((this.textField.y + this.textField.height) + _local_2.height));
            var _local_4:* = 10;
            if (_local_4 > (this.textField.textWidth - (_local_3 * 2))){
                _local_4 = Math.max((this.textField.textWidth - (_local_3 * 2)), 1);
            };
            if (this.direction){
                this.shape.graphics.lineTo((((this.textField.x - _local_2.x) + _local_4) + _local_3), ((this.textField.y + this.textField.height) + _local_2.height));
                this.shape.graphics.lineTo(0, 0);
                this.shape.graphics.lineTo(((this.textField.x - _local_2.x) + _local_3), ((this.textField.y + this.textField.height) + _local_2.height));
                this.shape.graphics.curveTo((this.textField.x - _local_2.x), ((this.textField.y + this.textField.height) + _local_2.height), (this.textField.x - _local_2.x), (((this.textField.y + this.textField.height) + _local_2.height) - _local_3));
            }
            else {
                this.shape.graphics.lineTo(0, 0);
                this.shape.graphics.lineTo(((((this.textField.x + this.textField.textWidth) + _local_2.width) - _local_4) - _local_3), ((this.textField.y + this.textField.height) + _local_2.height));
                this.shape.graphics.lineTo(((this.textField.x - _local_2.x) + _local_3), ((this.textField.y + this.textField.height) + _local_2.height));
                this.shape.graphics.curveTo((this.textField.x - _local_2.x), ((this.textField.y + this.textField.height) + _local_2.height), (this.textField.x - _local_2.x), (((this.textField.y + this.textField.height) + _local_2.height) - _local_3));
            };
            this.shape.graphics.lineTo((this.textField.x - _local_2.x), ((this.textField.y - _local_2.y) + _local_3));
            this.shape.graphics.curveTo((this.textField.x - _local_2.x), (this.textField.y - _local_2.y), ((this.textField.x - _local_2.x) + _local_3), (this.textField.y - _local_2.y));
            this.shape.graphics.endFill();
        }


    }
}//package engine

