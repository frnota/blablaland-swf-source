// version 467 by nota

//perso.Emotional

package perso{
    import bbl.ExternalLoader;
    import engine.BulleManager;
    import flash.display.Sprite;
    import perso.smiley.SmileyLoader;
    import bbl.CameraMap;
    import flash.text.Font;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.geom.Point;
    import flash.media.SoundTransform;
    import perso.smiley.SmileyPack;
    import net.Binary;
	import perso.Walker;
	
    public class Emotional extends Walker {

        public var externalLoader:ExternalLoader;
        public var bulle:BulleManager;
        public var smileyContent:Sprite;
        private var smileyLoader:SmileyLoader;
        private var smileyList:Array;
        private var smileyPlayList:Array;
        private var headOffsetList:Array;
        public var headOffset:int;
        private var _camera:CameraMap;

        public function Emotional(){
            this.headOffset = 0;
            this.headOffsetList = new Array();
            this.smileyLoader = new SmileyLoader();
            this.smileyList = new Array();
            this.smileyPlayList = new Array();
            this.smileyContent = new Sprite();
            addChild(this.smileyContent);
            this.bulle = new BulleManager();
            this.externalLoader = new ExternalLoader();
            this.externalLoader.addEventListener("onReady", this.onExternalReady, false, 0, true);
            this.externalLoader.load();
        }

        public function addHeadMinHeight(_arg_1:int):*{
            this.headOffsetList.push(_arg_1);
            this.updateGraphicHeight();
        }

        public function removeHeadMinHeight(_arg_1:int):*{
            var _local_2:* = 0;
            while (_local_2 < this.headOffsetList.length) {
                if (this.headOffsetList[_local_2] == _arg_1){
                    this.headOffsetList.splice(_local_2, 1);
                    this.updateGraphicHeight();
                    return;
                };
                _local_2++;
            };
        }

        override public function updateSkinScale():*{
            this.updateGraphicHeight();
            super.updateSkinScale();
        }

        public function updateGraphicHeight():*{
            this.headOffset = 0;
            var _local_1:int;
            var _local_2:* = 0;
            while (_local_2 < this.headOffsetList.length) {
                _local_1 = Math.max(_local_1, this.headOffsetList[_local_2]);
                _local_2++;
            };
            this.headOffset = (Math.max((_local_1 * skinScale), skinGraphicHeight) - skinGraphicHeight);
            this.updateBulleHeight();
            this.smileyContent.y = ((-(skinGraphicHeight) - 25) - this.headOffset);
        }

        public function onExternalReady(_arg_1:Event):*{
            var _local_2:Object;
            var _local_3:Font;
            _local_2 = Object(ExternalLoader.external.content).bulleFont;
            Font.registerFont(Class(_local_2));
            _local_3 = new (_local_2)();
            this.bulle.textFormat.font = _local_3.fontName;
        }

        override public function dispose():*{
            var _local_1:*;
            var _local_2:*;
            this.bulle.dispose();
            super.dispose();
            while (this.smileyPlayList.length) {
                _local_1 = this.smileyPlayList.shift();
                _local_1[0].removeEventListener("onPackLoaded", this.onPackLoaded, false);
            };
            while (this.smileyList.length) {
                _local_2 = this.smileyList.shift();
                _local_2.dispose();
            };
        }

        public function placeOnFront():*{
            var _local_1:uint;
            var _local_2:uint;
            if (parent){
                _local_1 = parent.getChildIndex(this);
                _local_2 = (parent.numChildren - 1);
                if (_local_1 != _local_2){
                    parent.setChildIndex(this, _local_2);
                };
            };
        }

        public function talk(_arg_1:String, _arg_2:uint=0):*{
            var _local_3:*;
            var _local_4:Object;
            var _local_5:Sound;
            if (this.camera){
                if (this.bulle.parent){
                    this.bulle.parent.setChildIndex(this.bulle, (this.bulle.parent.numChildren - 1));
                }
                else {
                    this.camera.bulleContent.addChild(this.bulle);
                    this.updateBulleHeight();
                    this.bulle.x = x;
                };
                _local_3 = new Point();
                _local_3 = this.localToGlobal(_local_3);
                _local_3 = this.camera.currentMap.globalToLocal(_local_3);
                this.bulle.direction = (((_local_3.x + this.bulle.maxWidth) + 30) < this.camera.screenWidth);
                this.bulle.type = _arg_2;
                this.bulle.show(_arg_1);
                this.placeOnFront();
                _local_4 = this.externalLoader.getClass("BubbleSound");
                _local_5 = new (_local_4)();
                _local_5.play(0, 0, new SoundTransform(this.camera.quality.actionVolume));
            };
        }

        public function updateBulleHeight():*{
            if (this.bulle.parent){
                this.bulle.y = (((y - skinGraphicHeight) - 25) - this.headOffset);
            };
        }

        public function smile(_arg_1:uint, _arg_2:uint, _arg_3:Binary):*{
            var _local_4:SmileyPack = this.smileyLoader.loadPack(_arg_1);
            this.smileyPlayList.push([_local_4, _arg_2, _arg_3]);
            _local_4.addEventListener("onPackLoaded", this.onPackLoaded, false, 0, true);
        }

        public function onPackLoaded(_arg_1:Event):*{
            var _local_2:*;
            var _local_3:Boolean;
            var _local_4:*;
            _arg_1.currentTarget.removeEventListener("onPackLoaded", this.onPackLoaded, false);
            if (this.camera){
                _local_2 = new _arg_1.currentTarget.loaderItem.managerClass();
                _local_2.camera = this.camera;
                _local_2.selfTarget = this.smileyContent;
                _local_2.emetteur = this;
                _local_3 = false;
                _local_4 = 0;
                while (_local_4 < this.smileyPlayList.length) {
                    if (this.smileyPlayList[_local_4][0] == _arg_1.currentTarget){
                        _local_2.playSmiley(this.smileyPlayList[_local_4][1], this.smileyPlayList[_local_4][2]);
                        this.smileyPlayList.splice(_local_4, 1);
                        _local_3 = true;
                        break;
                    };
                    _local_4++;
                };
                if (((parent) && (_local_3))){
                    parent.setChildIndex(this, (parent.numChildren - 1));
                };
            }
            else {
                this.smileyPlayList.splice(0, this.smileyPlayList.length);
            };
        }

        override public function set underWater(_arg_1:Boolean):void{
            var _local_2:Boolean = underWater;
            super.underWater = _arg_1;
            if (_local_2 != _arg_1){
                this.updateGraphicHeight();
            };
        }

        override public function set y(_arg_1:Number):void{
            super.y = _arg_1;
            this.updateBulleHeight();
        }

        override public function set x(_arg_1:Number):void{
            super.x = _arg_1;
            if (this.bulle.parent){
                this.bulle.x = _arg_1;
            };
        }

        override public function set visible(_arg_1:Boolean):void{
            super.visible = _arg_1;
            this.bulle.visible = _arg_1;
        }

        public function get camera():CameraMap{
            return (this._camera);
        }

        public function set camera(_arg_1:CameraMap):*{
            this._camera = _arg_1;
            if (this.bulle.parent){
                this.bulle.parent.removeChild(this.bulle);
            };
            if (skin){
                skin.camera = _arg_1;
            };
            if (_arg_1){
                skinOffset.x = 0;
                skinOffset.y = 0;
                physic = _arg_1.physic;
                walking = walkTemp;
                jumping = jumpTemp;
            };
        }

        override public function onSkinReady(_arg_1:Event):*{
            super.onSkinReady(_arg_1);
            skin.camera = this.camera;
        }

        override public function get gravity():Number{
            if (this._camera){
                if (this._camera.currentMap){
                    return (super.gravity * this._camera.currentMap.gravity);
                };
            };
            return (super.gravity);
        }

        override public function get walkSpeed():Number{
            var _local_1:Number = super.walkSpeed;
            if (this._camera){
                if (this._camera.currentMap){
                    _local_1 = (_local_1 * this._camera.currentMap.walkSpeed);
                };
            };
            return (_local_1);
        }

        override public function get swimSpeed():Number{
            if (this._camera){
                if (this.camera.currentMap){
                    return (super.swimSpeed * this.camera.currentMap.swimSpeed);
                };
            };
            return (super.swimSpeed);
        }

        override public function get jumpStrength():Number{
            if (this._camera){
                if (this.camera.currentMap){
                    return (super.jumpStrength * this.camera.currentMap.jumpStrength);
                };
            };
            return (super.jumpStrength);
        }


    }
}//package perso

