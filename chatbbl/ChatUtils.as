// version 467 by nota

//chatbbl.ChatUtils

package chatbbl{
    import bbl.CameraIconItem;
    import flash.display.Bitmap;
    import bbl.GlobalProperties;
    import flash.events.Event;
    import com.facebook.graph.Facebook;
    import net.SocketMessage;
    import fx.SkinAction;
    import bbl.UserObject;

    public class ChatUtils extends ChatContact {

        public var utilList:Array = new Array();
        public var webRadioUtil:ChatUtilItem;


        override public function initBlablaland():*{
            super.initBlablaland();
            blablaland.addEventListener("onObjectListChange", this.onObjectListChange, false, 0, true);
            this.onWebRadioChanged(null);
        }

        override public function onGetCamera(_arg_1:Event):*{
            var _local_2:ChatUtilItem;
            var _local_3:CameraIconItem;
            var _local_4:Bitmap;
            super.onGetCamera(_arg_1);
            _local_2 = this.addUtil();
            _local_2.utilInterface.iconContent.addChild(new PhotoUtil(_local_2));
            if (GlobalProperties.FBFROMAPP){
                _local_3 = camera.addIcon();
                _local_4 = new Bitmap(new FaceBookEtatIcon());
                _local_3.iconContent.addChild(_local_4);
                _local_3.overBulle = "Clique ici pour inviter tes amis facebook à te rejoindre sur Blablaland.";
                _local_3.clickable = true;
                _local_3.iconContent.addEventListener("click", this.onFaceBookEvt);
            };
            blablaland.addEventListener("onWebRadioChanged", this.onWebRadioChanged, false, 0, true);
            this.onWebRadioChanged(null);
        }

        public function onFaceBookEvt(_arg_1:Event):*{
            var _local_2:Object = {};
            _local_2.message = "Viens nous rejoindre sur Blablaland ^^";
            _local_2.title = "Blablaland";
            Facebook.ui("apprequests", _local_2, null, "iframe");
        }

        public function onWebRadioChanged(_arg_1:Event):*{
            var _local_2:Boolean = blablaland.webRadioAllowed;
            if (((_local_2) && (!(this.webRadioUtil)))){
                this.webRadioUtil = this.addUtil();
                this.webRadioUtil.utilInterface.iconContent.addChild(new WebRadioUtil(this.webRadioUtil));
                this.webRadioUtil.utilInterface.warn();
            }
            else {
                if (((!(_local_2)) && (this.webRadioUtil))){
                    this.removeUtil(this.webRadioUtil);
                    this.webRadioUtil = null;
                };
            };
        }

        public function clearAllSkinAction():*{
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 10);
            blablaland.send(_local_1);
        }

        public function setSkinAction(_arg_1:SkinAction):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 6);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, ((_arg_1.activ) ? 6 : 7));
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_FX_SID, _arg_1.fxSid);
            _local_2.bitWriteUnsignedInt(32, camera.mainUser.skinByte);
            _local_2.bitWriteBoolean(_arg_1.delayed);
            _local_2.bitWriteBoolean(_arg_1.latence);
            _local_2.bitWriteBoolean(_arg_1.userActivity);
            _local_2.bitWriteBoolean(_arg_1.transmitSelfEvent);
            if (_arg_1.activ){
                _local_2.bitWriteBoolean(_arg_1.persistent);
            };
            if (_arg_1.activ){
                _local_2.bitWriteBoolean(_arg_1.uniq);
            };
            if (_arg_1.activ){
                _local_2.bitWriteUnsignedInt(2, _arg_1.durationBlend);
                if (_arg_1.duration){
                    _local_2.bitWriteBoolean(true);
                    _local_2.bitWriteUnsignedInt(16, _arg_1.duration);
                }
                else {
                    _local_2.bitWriteBoolean(false);
                };
            };
            if (_arg_1.data.bitLength){
                _local_2.bitWriteBoolean(true);
                _local_2.bitWriteBinaryData(_arg_1.data);
            }
            else {
                _local_2.bitWriteBoolean(false);
            };
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_SKIN_ACTION, _arg_1.serverSkinAction);
            blablaland.send(_local_2);
        }

        public function onObjectListChange(_arg_1:Event):*{
            var _local_3:UserObject;
            var _local_4:ChatUtilItem;
            var _local_2:uint;
            while (_local_2 < blablaland.objectList.length) {
                _local_3 = blablaland.objectList[_local_2];
                if (!this.getUtilByBddId(_local_3.id)){
                    if (_local_3.visibility == 2){
                        _local_4 = this.addGhostUtil();
                    }
                    else {
                        _local_4 = this.addUtil(_local_3.genre);
                    };
                    _local_4.data.OBJECT = _local_3;
                    _local_4.loadFx(_local_3.fxFileId, 4, _local_3.objectId);
                };
                _local_2++;
            };
        }

        override public function close():*{
            if (blablaland){
                blablaland.removeEventListener("onObjectListChange", this.onObjectListChange, false);
                blablaland.removeEventListener("onWebRadioChanged", this.onWebRadioChanged, false);
            };
            while (this.utilList.length) {
                this.removeUtil(this.utilList[0]);
            };
            super.close();
        }

        public function removeUtil(_arg_1:ChatUtilItem):*{
            var _local_2:* = 0;
            while (_local_2 < this.utilList.length) {
                if (this.utilList[_local_2] == _arg_1){
                    this.utilList[_local_2].dispatchEvent(new Event("onRemove"));
                    if (this.utilList[_local_2].utilInterface){
                        this.utilList[_local_2].utilInterface.removeUtil();
                    };
                    this.utilList[_local_2].dispose();
                    this.utilList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function getUtil(_arg_1:uint, _arg_2:uint):ChatUtilItem{
            var _local_3:* = 0;
            while (_local_3 < this.utilList.length) {
                if (((this.utilList[_local_3].id == _arg_1) && (this.utilList[_local_3].sid == _arg_2))){
                    return (this.utilList[_local_3]);
                };
                _local_3++;
            };
            return (null);
        }

        public function getUtilByBddId(_arg_1:uint):ChatUtilItem{
            var _local_2:* = 0;
            while (_local_2 < this.utilList.length) {
                if (((this.utilList[_local_2].data.OBJECT) && (this.utilList[_local_2].data.OBJECT.id == _arg_1))){
                    return (this.utilList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function addGhostUtil():ChatUtilItem{
            var _local_1:ChatUtilItem = new ChatUtilItem();
            _local_1.chat = this;
            this.utilList.push(_local_1);
            return (_local_1);
        }

        public function addUtil(_arg_1:uint=0):ChatUtilItem{
            var _local_2:ChatUtilItem = this.addGhostUtil();
            _local_2.utilInterface = userInterface.addUtil(_arg_1);
            return (_local_2);
        }


    }
}//package chatbbl

