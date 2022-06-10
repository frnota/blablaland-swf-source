// version 467 by nota

//chatbbl.PhotoUtilPopup

package chatbbl{
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.Event;
    import engine.JPEGEncoder;
    import flash.utils.ByteArray;
    import flash.net.FileReference;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import bbl.GlobalProperties;
    import com.facebook.graph.Facebook;

    public class PhotoUtilPopup extends MovieClip {

        public var win:Object;
        public var image:BitmapData;
        public var outImage:BitmapData;
        public var viewImage:BitmapData;
        public var bt_save:SimpleButton;
        public var waiter:Sprite;
        public var backBitmap:Bitmap;
        public var masque_0:MovieClip;
        public var masque_1:MovieClip;
        public var masque_2:MovieClip;
        public var masqueEtat:Array = [false, false, false];

        public function PhotoUtilPopup(){
            this.bt_save.addEventListener("click", this.onBtSave);
        }

        public function init():void{
            this.backBitmap = new Bitmap(this.image);
            this.backBitmap.scaleX = 0.5;
            this.backBitmap.scaleY = 0.5;
            addChildAt(this.backBitmap, 0);
            parent.width = this.backBitmap.width;
            parent.height = (this.backBitmap.height + 40);
            Object(parent).redraw();
            Object(parent).addEventListener("onKill", this.onWinKill);
            var _local_1:int;
            while (_local_1 < 3) {
                this[("masque_" + _local_1)].buttonMode = true;
                this[("masque_" + _local_1)].alpha = 0;
                this[("masque_" + _local_1)].stop();
                this[("masque_" + _local_1)].addEventListener("mouseOver", this.onMasqueOver);
                this[("masque_" + _local_1)].addEventListener("mouseOut", this.onMasqueOut);
                this[("masque_" + _local_1)].addEventListener("click", this.onMasqueClick);
                _local_1++;
            };
            this.updatePrise();
        }

        public function onMasqueOver(_arg_1:Event):void{
            _arg_1.currentTarget.alpha = 1;
        }

        public function onMasqueOut(_arg_1:Event):void{
            _arg_1.currentTarget.alpha = 0;
        }

        public function onMasqueClick(_arg_1:Event):void{
            this.masqueEtat[Number(_arg_1.currentTarget.name.split("_")[1])] = (!(this.masqueEtat[Number(_arg_1.currentTarget.name.split("_")[1])]));
            this.updatePrise();
        }

        public function onWinKill(_arg_1:Event):*{
            this.setWaiter(false);
        }

        public function onBtSave(_arg_1:Event):*{
            var _local_2:JPEGEncoder = new JPEGEncoder(95);
            var _local_3:ByteArray = _local_2.encode(this.outImage);
            var _local_4:FileReference = new FileReference();
            _local_4.save(_local_3, (("photo_" + Math.floor((new Date().getTime() / 1000))) + ".jpg"));
        }

        public function updatePrise():*{
            var _local_3:Matrix;
            if (this.viewImage){
                this.viewImage.dispose();
            };
            this.viewImage = new BitmapData(this.image.width, this.image.height, false, 0);
            this.viewImage.draw(this.image);
            this.backBitmap.bitmapData = this.viewImage;
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < 3) {
                if (this.masqueEtat[_local_2]){
                    this[("masque_" + _local_2)].gotoAndStop(2);
                    _local_3 = new Matrix();
                    _local_3.scale((this[("masque_" + _local_2)].scaleX * 2), (this[("masque_" + _local_2)].scaleY * 2));
                    _local_3.translate((this[("masque_" + _local_2)].x * 2), (this[("masque_" + _local_2)].y * 2));
                    this.viewImage.draw(this[("masque_" + _local_2)], _local_3);
                    this[("masque_" + _local_2)].gotoAndStop(1);
                }
                else {
                    _local_1 = false;
                };
                _local_2++;
            };
            this.outImage = this.viewImage;
            if (_local_1){
                this.outImage = new BitmapData(this.viewImage.width, (this.viewImage.height - 136));
                this.outImage.copyPixels(this.viewImage, this.viewImage.rect, new Point());
            };
        }

        public function onBtFb(_arg_1:Event):*{
            this.setWaiter(true);
            if (GlobalProperties.FBPERMLIST["publish_actions"]){
                this.sendToFb();
            }
            else {
                GlobalProperties.fbRequestPermissions(["publish_actions"], this.onFbRequest);
            };
        }

        public function onFbRequest():*{
            var _local_1:Object;
            if (GlobalProperties.FBPERMLIST["publish_actions"]){
                _local_1 = GlobalProperties.mainApplication.msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"FaceBook",
                    "DEPEND":this
                }, {
                    "MSG":"Veux tu enregistrer cette photo dans ton album FaceBook ?",
                    "ACTION":"YESNO"
                });
                _local_1.addEventListener("onKill", this.confirmEvent, false);
            }
            else {
                GlobalProperties.mainApplication.msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Partage FaceBook",
                    "DEPEND":this
                }, {
                    "MSG":"Impossible d'envoyer la photo dans ton album FaceBook, réessaie plus tard !",
                    "ACTION":"OK"
                });
                this.setWaiter(false);
            };
        }

        public function confirmEvent(_arg_1:Event):*{
            if (Object(_arg_1.currentTarget).data.RES){
                this.sendToFb();
            }
            else {
                this.setWaiter(false);
            };
        }

        public function sendToFb():*{
            var _local_1:Object = {
                "image":this.outImage,
                "message":"Photo prise sur Blablaland",
                "fileName":"Blablaland"
            };
            Facebook.api("v2.0/me/photos", this.sendHandle, _local_1);
        }

        public function sendHandle(_arg_1:Object, _arg_2:Object):*{
            this.setWaiter(false);
            if (!_arg_1){
                GlobalProperties.mainApplication.msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Partage FaceBook",
                    "DEPEND":this
                }, {
                    "MSG":"Impossible d'envoyer la photo dans ton album FaceBook, réessaie plus tard !",
                    "ACTION":"OK"
                });
            };
        }

        public function setWaiter(_arg_1:Boolean):*{
            var _local_2:MovieClip;
            if (((_arg_1) && (!(this.waiter)))){
                this.waiter = new Sprite();
                addChild(this.waiter);
                this.waiter.graphics.beginFill(0, 0.7);
                this.waiter.graphics.lineTo(parent.width, 0);
                this.waiter.graphics.lineTo(parent.width, parent.height);
                this.waiter.graphics.lineTo(0, parent.height);
                this.waiter.graphics.lineTo(0, 0);
                this.waiter.graphics.endFill();
                _local_2 = new photoWaiter();
                _local_2.x = (parent.width / 2);
                _local_2.y = (parent.height / 2);
                this.waiter.addChild(_local_2);
            }
            else {
                if (((!(_arg_1)) && (this.waiter))){
                    this.waiter.parent.removeChild(this.waiter);
                    this.waiter = null;
                };
            };
        }


    }
}//package chatbbl

