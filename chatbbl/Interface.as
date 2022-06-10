// version 467 by nota

//chatbbl.Interface

package chatbbl{
    import bbl.InterfaceUtils;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import flash.events.TextEvent;

    public class Interface extends InterfaceUtils {

        public var alertClip:MovieClip;
        public var alertTxt:TextField;
        public var timeTxt:TextField;
        public var alertBt:SimpleButton;
        public var amisBt:SimpleButton;
        public var btBBPOD:SimpleButton;
        public var btProfil:SimpleButton;
        public var btCarte:SimpleButton;
        public var btUnivers:SimpleButton;
        public var btNbCo:SimpleButton;
        public var amisPicto:Sprite;
        public var mapPicto:Sprite;
        private var _warnCount:uint;

        public function Interface(){
            this._warnCount = 0;
            this.alertBt.addEventListener("click", this.alertBtEvt, false, 0, true);
            this.alertBt.addEventListener("mouseOver", this.alertBtOverEvt, false, 0, true);
            this.alertBt.addEventListener("mouseOut", this.alertBtOutEvt, false, 0, true);
            this.amisBt.addEventListener("click", this.amisBtEvt, false, 0, true);
            this.amisBt.addEventListener("mouseOver", this.amisBtOverEvt, false, 0, true);
            this.amisBt.addEventListener("mouseOut", this.amisBtOutEvt, false, 0, true);
            this.btNbCo.addEventListener("click", this.btCarteEvt, false, 0, true);
            this.btNbCo.addEventListener("mouseOver", this.btNbCoOverEvt, false, 0, true);
            this.btNbCo.addEventListener("mouseOut", this.btNbCoOutEvt, false, 0, true);
            this.btBBPOD.addEventListener("click", this.btBBPODEvt, false, 0, true);
            this.btProfil.addEventListener("click", this.btProfilEvt, false, 0, true);
            this.btProfil.addEventListener("mouseOver", this.btProfilOverEvt, false, 0, true);
            this.btProfil.addEventListener("mouseOut", this.btProfilOutEvt, false, 0, true);
            this.btCarte.addEventListener("click", this.btCarteEvt, false, 0, true);
            this.btCarte.addEventListener("mouseOver", this.btCarteOverEvt, false, 0, true);
            this.btCarte.addEventListener("mouseOut", this.btCarteOutEvt, false, 0, true);
            this.btUnivers.addEventListener("click", this.btUniversEvt, false, 0, true);
            this.btUnivers.addEventListener("mouseOver", this.btUniversOverEvt, false, 0, true);
            this.btUnivers.addEventListener("mouseOut", this.btUniversOutEvt, false, 0, true);
            this.alertTxt.mouseEnabled = false;
            this.alertClip.mouseEnabled = false;
            this.alertClip.mouseChildren = false;
            this.amisPicto.mouseEnabled = false;
            this.amisPicto.mouseChildren = false;
            this.mapPicto.mouseEnabled = false;
            this.mapPicto.mouseChildren = false;
            this.timeTxt.text = "";
            addEventListener("enterFrame", this.enterFrame, false, 0, true);
            this.warnCount = 0;
        }

        public function enterFrame(_arg_1:Event):*{
            var _local_2:Date = new Date();
            _local_2.setTime(GlobalProperties.serverTime);
            var _local_3:String = ((((((_local_2.getUTCHours() + ":") + ((_local_2.getUTCMinutes().toString().length > 1) ? "" : "0")) + _local_2.getUTCMinutes()) + ":") + ((_local_2.getUTCSeconds().toString().length > 1) ? "" : "0")) + _local_2.getUTCSeconds());
            if (_local_3 != this.timeTxt.text){
                this.timeTxt.text = _local_3;
            };
        }

        public function btBBPODEvt(_arg_1:Event):*{
            this.dispatchEvent(new Event("onOpenBBPOD"));
        }

        public function btCarteEvt(_arg_1:Event):*{
            this.dispatchEvent(new Event("onOpenCarte"));
        }

        public function btCarteOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle("Carte de blablaland.");
        }

        public function btCarteOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function btUniversEvt(_arg_1:Event):*{
            this.dispatchEvent(new Event("onOpenChangeUnivers"));
        }

        public function btUniversOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle("Changer d'univers.");
        }

        public function btUniversOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function btProfilEvt(_arg_1:Event):*{
            this.dispatchEvent(new Event("onOpenProfil"));
        }

        public function btProfilOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle("Clique ici pour accéder à ton profil.");
        }

        public function btProfilOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function alertBtOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle((("Tu as reçu " + this._warnCount) + " événements."));
        }

        public function alertBtOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function alertBtEvt(_arg_1:Event):*{
            this.dispatchEvent(new TextEvent("onOpenAlert"));
        }

        public function btNbCoOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle((((_worldCount + " connectés dans cet univers.\n") + _universCount) + " dans tout blablaland."));
        }

        public function btNbCoOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function amisBtOverEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle((("Tu as " + friendCount) + " amis connectés."));
        }

        public function amisBtOutEvt(_arg_1:Event):*{
            GlobalProperties.mainApplication.infoBulle(null);
        }

        public function amisBtEvt(_arg_1:Event):*{
            this.dispatchEvent(new Event("onOpenFriend"));
        }

        public function set warnCount(_arg_1:uint):*{
            this.alertClip.visible = (_arg_1 > 0);
            this.alertClip.y = ((_arg_1 > 0) ? 70.8 : 500);
            this._warnCount = _arg_1;
            this.alertTxt.text = _arg_1.toString();
        }


    }
}//package chatbbl

