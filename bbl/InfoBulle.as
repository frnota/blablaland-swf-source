// version 467 by nota

//bbl.InfoBulle

package bbl{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.text.Font;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.events.Event;

    public class InfoBulle extends MovieClip {

        public var txt_bulle:TextField;
        public var align:String;
        public var durationFactor:Number;
        private var _texte:String;
        private var _startTime:Number;

        public function InfoBulle(){
            var _local_2:Font;
            var _local_3:TextFormat;
            super();
            this.durationFactor = 1;
            this.align = "right";
            this._texte = null;
            this._startTime = getTimer();
            addEventListener("enterFrame", this.enterFrameEvt, false, 0, true);
            this.mouseEnabled = false;
            this.mouseChildren = false;
            filters = [new DropShadowFilter(4, 45, 0, 1, 4, 4, 0.5)];
            GlobalProperties.mainApplication.addChild(this);
            this.txt_bulle = new TextField();
            var _local_1:Object = Object(ExternalLoader.external.content).bulleFont;
            if (_local_1){
                _local_2 = new (_local_1)();
                Font.registerFont(Class(_local_1));
                _local_3 = new TextFormat();
                _local_3.font = _local_2.fontName;
                _local_3.align = this.align;
                _local_3.size = 10;
                _local_3.color = 0;
                this.txt_bulle.defaultTextFormat = _local_3;
                this.txt_bulle.antiAliasType = "advanced";
                this.txt_bulle.embedFonts = true;
                this.txt_bulle.mouseEnabled = false;
                this.txt_bulle.multiline = true;
                this.txt_bulle.wordWrap = true;
                this.txt_bulle.alpha = 0.7;
                addChild(this.txt_bulle);
            };
        }

        public function redraw():*{
            graphics.clear();
            this.txt_bulle.autoSize = "left";
            this.txt_bulle.wordWrap = false;
            this.txt_bulle.multiline = false;
            this.txt_bulle.text = this.text;
            this.txt_bulle.y = (-(this.txt_bulle.height) - 10);
            graphics.lineStyle(1, 0xFFFFFF, 1, true);
            graphics.beginFill(0xFFFFFF, 0.8);
            graphics.drawRoundRect((this.txt_bulle.x - 2), this.txt_bulle.y, (this.txt_bulle.width + 4), this.txt_bulle.height, 15, 15);
            graphics.endFill();
            x = parent.mouseX;
            y = parent.mouseY;
            var _local_1:Rectangle = this.getBounds(parent);
            var _local_2:uint = 5;
            if (_local_1.left < _local_2){
                x = (x + (_local_2 - _local_1.left));
            };
            if (_local_1.top < _local_2){
                y = (y + (_local_2 - _local_1.top));
            };
            if (_local_1.right > (stage.stageWidth - _local_2)){
                x = (x - (_local_1.right - (stage.stageWidth - _local_2)));
            };
            if (_local_1.bottom > (stage.stageHeight - _local_2)){
                y = (y - (_local_1.bottom - (stage.stageHeight - _local_2)));
            };
            x = Math.round(x);
            y = Math.round(y);
        }

        public function enterFrameEvt(_arg_1:Event):*{
            var _local_2:uint = (((this._texte) ? (this._texte.length * 100) : 10000) * this.durationFactor);
            if (getTimer() > (this._startTime + _local_2)){
                alpha = Math.max((alpha - 0.03), 0);
                if (alpha == 0){
                    this.dispose();
                };
            };
        }

        public function dispose():*{
            if (parent){
                parent.removeChild(this);
            };
            removeEventListener("enterFrame", this.enterFrameEvt, false);
        }

        public function get text():String{
            return (this._texte);
        }

        public function set text(_arg_1:String):*{
            this._startTime = getTimer();
            this._texte = _arg_1;
            this.redraw();
        }


    }
}//package bbl

