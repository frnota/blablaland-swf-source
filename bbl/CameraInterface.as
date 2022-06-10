// version 467 by nota

//bbl.CameraInterface

package bbl{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.Font;
    import flash.text.TextFormat;
    import flash.events.Event;
    import flash.utils.getTimer;

    public class CameraInterface extends CameraMap {

        private var _userInterface:InterfaceSmiley = null;
        private var iconList:Array = new Array();
        private var iconContent:Sprite = new Sprite();
        public var iconWarning:int = 0;
        private var frameCount:int = 0;
        private var lastIconOpenAt:uint = 0;
        private var txtIconBulle:TextField = new TextField();

        public function CameraInterface(){
            var _local_2:Font;
            var _local_3:TextFormat;
            var _local_1:Object = Object(ExternalLoader.external.content).bulleFont;
            if (_local_1){
                _local_2 = new (_local_1)();
                Font.registerFont(Class(_local_1));
                _local_3 = new TextFormat();
                _local_3.font = _local_2.fontName;
                _local_3.align = "right";
                _local_3.size = 10;
                _local_3.color = 0;
                this.txtIconBulle.defaultTextFormat = _local_3;
                this.txtIconBulle.antiAliasType = "advanced";
                this.txtIconBulle.embedFonts = true;
                this.txtIconBulle.mouseEnabled = false;
                this.txtIconBulle.multiline = true;
                this.txtIconBulle.wordWrap = true;
                this.txtIconBulle.alpha = 0.7;
                this.iconContent.addChild(this.txtIconBulle);
                this.txtIconBulle.y = 40;
            };
            super();
        }

        override public function get floodPunished():Boolean{
            return (super.floodPunished);
        }

        override public function set floodPunished(_arg_1:Boolean):*{
            super.floodPunished = _arg_1;
            if (this.userInterface){
                this.userInterface.floodPunished = _arg_1;
            };
        }

        public function get userInterface():InterfaceSmiley{
            return (this._userInterface);
        }

        public function set userInterface(_arg_1:InterfaceSmiley):*{
            this._userInterface = _arg_1;
        }

        override public function dispose():*{
            this.removeIcon(null);
            this.userInterface = null;
            super.dispose();
        }

        override public function snowEffectSteperEvent(_arg_1:Event=null):*{
            if (this.userInterface){
                this.userInterface.temperature = Math.min(Math.max(temperature.getValue(GlobalProperties.serverTime), 0), 1);
            };
            super.snowEffectSteperEvent(_arg_1);
        }

        override public function get interfaceMoveLiberty():Boolean{
            if (!this.userInterface){
                return (true);
            };
            return (this.userInterface.interfaceMoveLiberty);
        }

        public function showIconBulle(_arg_1:String, _arg_2:uint=0):*{
            this.iconContent.graphics.clear();
            if (_arg_1){
                this.txtIconBulle.autoSize = "right";
                this.txtIconBulle.wordWrap = false;
                this.txtIconBulle.multiline = false;
                this.txtIconBulle.htmlText = _arg_1;
                if (this.txtIconBulle.width > 300){
                    this.txtIconBulle.wordWrap = true;
                    this.txtIconBulle.multiline = true;
                    this.txtIconBulle.width = 300;
                };
                this.txtIconBulle.x = (-(this.txtIconBulle.width) - 2);
                this.iconContent.graphics.lineStyle(1, 0xFFFFFF, 1, true);
                this.iconContent.graphics.beginFill(0xFFFFFF, 0.8);
                this.iconContent.graphics.drawRoundRect((this.txtIconBulle.x - 2), this.txtIconBulle.y, (this.txtIconBulle.width + 4), this.txtIconBulle.height, 15, 15);
                this.iconContent.graphics.endFill();
            }
            else {
                this.txtIconBulle.text = "";
            };
        }

        override public function enterFrame(_arg_1:Event):*{
            var _local_4:CameraIconItem;
            var _local_2:uint = getTimer();
            var _local_3:uint;
            while (_local_3 < this.iconList.length) {
                _local_4 = this.iconList[_local_3];
                _local_4.frameStep(this.frameCount);
                _local_3++;
            };
            this.frameCount++;
            super.enterFrame(_arg_1);
        }

        override public function onMapLoaded(_arg_1:Event):*{
            super.onMapLoaded(_arg_1);
            addChild(this.iconContent);
        }

        override public function onChangeScreenSize():*{
            super.onChangeScreenSize();
            this.iconContent.x = screenWidth;
        }

        public function updateIconList():*{
            var _local_2:CameraIconItem;
            var _local_1:uint;
            while (_local_1 < this.iconList.length) {
                _local_2 = this.iconList[_local_1];
                _local_2.x = (-(_local_1 + 1) * 38);
                _local_2.y = 3;
                _local_1++;
            };
        }

        public function removeIcon(_arg_1:CameraIconItem):*{
            var _local_2:uint;
            var _local_3:CameraIconItem;
            if (!_arg_1){
                while (this.iconList.length) {
                    this.removeIcon(this.iconList[_local_2]);
                };
            };
            _local_2 = 0;
            while (_local_2 < this.iconList.length) {
                if (this.iconList[_local_2] == _arg_1){
                    _local_3 = this.iconList[_local_2];
                    _local_3.dispose();
                    this.iconList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this.updateIconList();
        }

        public function addIcon():CameraIconItem{
            var _local_1:CameraIconItem = new CameraIconItem();
            _local_1.camera = this;
            _local_1.warn();
            this.iconContent.addChild(_local_1);
            this.iconList.push(_local_1);
            this.updateIconList();
            return (_local_1);
        }


    }
}//package bbl

