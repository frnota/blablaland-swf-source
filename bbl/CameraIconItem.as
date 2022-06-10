// version 467 by nota

//bbl.CameraIconItem

package bbl{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class CameraIconItem extends Sprite {

        public var backContent:Sprite;
        public var frontContent:Sprite;
        public var iconContent:Sprite;
        public var camera:CameraInterface;
        public var warning:uint;
        private var chronoClip:MovieClip;
        private var externalLoader:ExternalLoader;
        private var chronoFrom:Number;
        private var chronoTo:Number;
        private var _overBulle:String;
        private var isOver:Boolean;
        private var haveBulled:Boolean;
        private var haveChrono:Boolean;

        public function CameraIconItem(){
            var _local_1:Object;
            var _local_2:MovieClip;
            super();
            this.frontContent = new Sprite();
            this.backContent = new Sprite();
            this.iconContent = new Sprite();
            this.iconContent.x = (this.iconContent.x + 3);
            this.iconContent.y = (this.iconContent.y + 3);
            addChild(this.backContent);
            addChild(this.iconContent);
            addChild(this.frontContent);
            this.externalLoader = new ExternalLoader();
            this.isOver = false;
            this.haveBulled = false;
            this.haveChrono = false;
            this.warning = 0;
            this._overBulle = null;
            _local_1 = this.externalLoader.getClass("CameraIconFront");
            _local_2 = new (_local_1)();
            this.frontContent.addChild(_local_2);
            _local_1 = this.externalLoader.getClass("CameraIconBack");
            _local_2 = new (_local_1)();
            this.backContent.addChild(_local_2);
            this.clickable = false;
            this.frontContent.mouseChildren = (this.frontContent.mouseEnabled = false);
            this.backContent.mouseChildren = (this.backContent.mouseEnabled = false);
        }

        public function updateBulle():*{
            var _local_1:String;
            var _local_2:Array;
            if (((this.haveBulled) && ((!(this.isOver)) || (!(this._overBulle))))){
                this.camera.showIconBulle(null);
                this.haveBulled = false;
            }
            else {
                if (((this.isOver) && (this._overBulle))){
                    this.haveChrono = false;
                    _local_1 = this._overBulle;
                    _local_2 = _local_1.split("$chrono");
                    if (_local_2.length > 1){
                        this.haveChrono = true;
                        _local_1 = _local_2.join(this.getChronoString());
                    };
                    this.camera.showIconBulle(_local_1, 5000);
                    this.haveBulled = true;
                };
            };
        }

        public function onMouseOver(_arg_1:MouseEvent):*{
            this.isOver = true;
            this.updateBulle();
        }

        public function onMouseOut(_arg_1:MouseEvent):*{
            this.isOver = false;
            this.updateBulle();
        }

        public function set overBulle(_arg_1:String):*{
            this._overBulle = _arg_1;
            if (_arg_1){
                addEventListener("mouseOver", this.onMouseOver);
                addEventListener("mouseOut", this.onMouseOut);
            }
            else {
                removeEventListener("mouseOver", this.onMouseOver);
                removeEventListener("mouseOut", this.onMouseOut);
                this.isOver = false;
            };
            this.updateBulle();
        }

        public function removeIcon():*{
            this.camera.removeIcon(this);
        }

        public function getChronoString():String{
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_1:* = "";
            if (this.chronoClip){
                _local_2 = int(Math.max(Math.round(((this.chronoTo - GlobalProperties.serverTime) / 1000)), 0));
                if (_local_2 > 59){
                    _local_3 = int(Math.floor((_local_2 / 60)));
                    _local_4 = (_local_2 - (_local_3 * 60));
                    _local_1 = (_local_1 + (_local_3.toString() + " min et "));
                    _local_1 = (_local_1 + (_local_4.toString() + " sec"));
                }
                else {
                    if (_local_2 > 1){
                        _local_1 = (_local_1 + (_local_2.toString() + " secondes"));
                    }
                    else {
                        _local_1 = (_local_1 + (_local_2.toString() + " seconde"));
                    };
                };
            };
            return (_local_1);
        }

        public function setChrono(_arg_1:Boolean, _arg_2:Number, _arg_3:Number):*{
            var _local_4:Object;
            this.chronoFrom = _arg_2;
            this.chronoTo = _arg_3;
            if (((_arg_1) && (!(this.chronoClip)))){
                _local_4 = this.externalLoader.getClass("CameraIconChrono");
                this.chronoClip = new (_local_4)();
                this.frontContent.addChildAt(this.chronoClip, 0);
            }
            else {
                if (((!(_arg_1)) && (this.chronoClip))){
                    if (this.chronoClip.parent){
                        this.chronoClip.parent.removeChild(this.chronoClip);
                    };
                    this.chronoClip = null;
                };
            };
        }

        public function frameStep(_arg_1:uint):*{
            var _local_2:Number;
            var _local_3:Number;
            if (this.warning){
                this.warning++;
                if (this.warning > 100){
                    this.unWarn();
                };
            };
            if (this.chronoClip){
                _local_2 = GlobalProperties.serverTime;
                _local_3 = Math.max(Math.min(((_local_2 - this.chronoFrom) / (this.chronoTo - this.chronoFrom)), 1), 0);
                this.chronoClip.gotoAndStop((Math.round(((this.chronoClip.totalFrames - 1) * _local_3)) + 1));
                if (((_local_3 < 1) && (_local_2 > (this.chronoTo - 3000)))){
                    this.warn();
                };
            };
            if (((((this.haveChrono) && (this.isOver)) && (this._overBulle)) && ((_arg_1 % 30) == 0))){
                this.updateBulle();
            };
        }

        public function dispose():*{
            if (parent){
                parent.removeChild(this);
            };
            this.overBulle = null;
            this.unWarn();
        }

        public function unWarn():*{
            if (this.warning){
                this.camera.iconWarning--;
            };
            this.warning = 0;
            alpha = 1;
        }

        public function set clickable(_arg_1:Boolean):*{
            var _local_3:MovieClip;
            var _local_2:int;
            while (_local_2 < this.frontContent.numChildren) {
                _local_3 = MovieClip(this.frontContent.getChildAt(_local_2));
                if (((_local_3.totalFrames == 2) && (!(_local_3 == this.chronoClip)))){
                    _local_3.gotoAndStop(((_arg_1) ? "CLICKABLE" : "UNCLICKABLE"));
                    break;
                };
                _local_2++;
            };
            this.iconContent.buttonMode = _arg_1;
        }

        public function warn():*{
            if (!this.warning){
                this.camera.iconWarning++;
            };
            this.warning = 1;
        }


    }
}//package bbl

