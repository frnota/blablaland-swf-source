// version 467 by nota

//perso.UserIcon

package perso{
    import fx.UserFx;
    import flash.display.Sprite;

    public class UserIcon extends UserFx {

        public var iconList:Array;
        public var iconContent:Sprite;
        private var _mute:Boolean;

        public function UserIcon(){
            this.iconContent = new Sprite();
            addChild(this.iconContent);
            this.iconList = new Array();
            this.updateIconPlace();
            this._mute = false;
        }

        override public function updateGraphicHeight():*{
            super.updateGraphicHeight();
            this.updateIconPlace();
        }

        public function updateIconPlace():*{
            var _local_1:int;
            var _local_2:uint;
            if (this.iconContent){
                _local_1 = 0;
                _local_2 = 0;
                while (_local_2 < this.iconList.length) {
                    _local_1 = Math.max(_local_1, (this.iconList[_local_2].height + 5));
                    _local_2++;
                };
                this.iconContent.y = ((-(skinGraphicHeight) - _local_1) - headOffset);
            };
        }

        public function getIconByIdSid(_arg_1:uint, _arg_2:uint):UserIconItem{
            var _local_3:* = 0;
            while (_local_3 < this.iconList.length) {
                if (((this.iconList[_local_3].id == _arg_1) && (this.iconList[_local_3].sid == _arg_2))){
                    return (this.iconList[_local_3]);
                };
                _local_3++;
            };
            return (null);
        }

        public function removeIcon(_arg_1:uint, _arg_2:uint):*{
            var _local_3:* = 0;
            while (_local_3 < this.iconList.length) {
                if (((this.iconList[_local_3].id == _arg_1) && (this.iconList[_local_3].sid == _arg_2))){
                    this.iconList.splice(_local_3, 1);
                    return;
                };
                _local_3++;
            };
        }

        public function addIcon():UserIconItem{
            var _local_1:UserIconItem = new UserIconItem();
            this.iconList.push(_local_1);
            return (_local_1);
        }

        public function redrawIcon():*{
            var _local_1:uint;
            var _local_2:uint;
            var _local_3:*;
            if (this.iconContent){
                _local_1 = 2;
                while (this.iconContent.numChildren) {
                    this.iconContent.removeChildAt(0);
                };
                _local_2 = 0;
                _local_3 = 0;
                while (_local_3 < this.iconList.length) {
                    if (this.iconList[_local_3].icon){
                        this.iconContent.addChild(this.iconList[_local_3].icon);
                        this.iconList[_local_3].icon.x = _local_2;
                        _local_2 = (_local_2 + (this.iconList[_local_3].width + _local_1));
                    };
                    _local_3++;
                };
                this.iconContent.x = -(Math.round(((_local_2 - _local_1) / 2)));
                this.updateIconPlace();
            };
        }

        override public function dispose():*{
            if (this.iconContent){
                removeChild(this.iconContent);
            };
            this.iconContent = null;
            super.dispose();
        }

        public function get mute():Boolean{
            return (this._mute);
        }

        public function set mute(_arg_1:Boolean):void{
            var _local_2:UserIconItem;
            var _local_3:Object;
            if (_arg_1 != this._mute){
                if (_arg_1){
                    _local_2 = this.addIcon();
                    _local_2.id = 1;
                    _local_2.sid = 0;
                    _local_3 = externalLoader.getClass("MuteIcon");
                    _local_2.icon = new (_local_3)();
                    _local_2.width = 15;
                    _local_2.height = 15;
                }
                else {
                    this.removeIcon(1, 0);
                };
                this.redrawIcon();
                this._mute = _arg_1;
            };
        }


    }
}//package perso

