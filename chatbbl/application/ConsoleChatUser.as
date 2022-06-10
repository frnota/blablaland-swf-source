// version 467 by nota

//chatbbl.application.ConsoleChatUser

package chatbbl.application{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import ui.Scroll;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import bbl.GlobalProperties;
    import flash.events.KeyboardEvent;
    import net.SocketMessage;
    import flash.geom.ColorTransform;
    import flash.text.TextFieldType;

    public class ConsoleChatUser extends MovieClip {

        public var txtEcran:TextField;
        public var scroll:Scroll;
        public var msgList:Array;
        public var btSend:SimpleButton;
        public var txtInput:TextField;
        public var backgroundInput:Sprite;

        public function ConsoleChatUser(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
            this.txtEcran.text = "";
            this.scroll.value = 1;
            this.msgList = new Array();
        }

        public function onKillEvt(_arg_1:Event):*{
            delete GlobalProperties.data[("CONSOLEUSERCHAT_" + Object(parent).data.UID)];
        }

        public function init(_arg_1:Event):*{
            if (stage){
                GlobalProperties.data[("CONSOLEUSERCHAT_" + Object(parent).data.UID)] = this;
                this.scroll.size = this.txtEcran.height;
                this.txtEcran.addEventListener("change", this.updateScrollByText);
                this.txtEcran.addEventListener("scroll", this.updateScrollByText);
                this.scroll.addEventListener("onChanged", this.updateTextByScroll);
                this.removeEventListener(Event.ADDED, this.init, false);
                parent.width = 370;
                parent.height = 151;
                Object(parent).redraw();
                Object(parent).addEventListener("onKill", this.onKillEvt);
                this.btSend.addEventListener("click", this.sendEvt);
                this.txtInput.addEventListener(KeyboardEvent.KEY_UP, this.sendKeyEvt);
            };
        }

        public function sendKeyEvt(_arg_1:KeyboardEvent):*{
            if (_arg_1.keyCode == 13){
                this.sendEvt(null);
            };
        }

        public function sendEvt(_arg_1:Event):*{
            var _local_2:SocketMessage;
            if (this.txtInput.text.length){
                _local_2 = new SocketMessage();
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 10);
                _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID, Object(parent).data.UID);
                _local_2.bitWriteString(this.txtInput.text);
                GlobalProperties.mainApplication.blablaland.send(_local_2);
                this.addMessage(this.txtInput.text, false);
                this.txtInput.text = "";
            };
            stage.focus = this.txtInput;
        }

        public function updateScrollByText(_arg_1:Event):*{
            if (this.txtEcran.maxScrollV <= 2){
                this.scroll.value = 1;
            }
            else {
                this.scroll.value = ((this.txtEcran.scrollV - 1) / (this.txtEcran.maxScrollV - 2));
            };
        }

        public function updateTextByScroll(_arg_1:Event):*{
            this.txtEcran.scrollV = (((this.txtEcran.maxScrollV - 2) * this.scroll.value) + 1);
        }

        public function setAnswerState(_arg_1:Boolean):*{
            this.txtInput.selectable = _arg_1;
            this.btSend.enabled = _arg_1;
            if (_arg_1){
                this.btSend.transform.colorTransform = new ColorTransform();
                this.backgroundInput.transform.colorTransform = new ColorTransform();
                this.txtInput.type = TextFieldType.INPUT;
            }
            else {
                this.btSend.transform.colorTransform = new ColorTransform(0.7, 0.7, 0.7);
                this.backgroundInput.transform.colorTransform = new ColorTransform(0.7, 0.7, 0.7);
                this.txtInput.text = "";
                this.txtInput.type = TextFieldType.DYNAMIC;
            };
        }

        public function addMessage(_arg_1:String, _arg_2:Boolean):*{
            _arg_1 = GlobalProperties.htmlEncode(_arg_1);
            var _local_3:Object = Object(parent).data;
            var _local_4:Date = new Date();
            var _local_5:* = (((("<b>[" + _local_4.getHours()) + ":") + _local_4.getMinutes()) + "]");
            if (_arg_2){
                _local_5 = (_local_5 + (" " + _local_3.PSEUDO));
            }
            else {
                _local_5 = (_local_5 + (" " + GlobalProperties.mainApplication.blablaland.pseudo));
            };
            _local_5 = (_local_5 + (" :</b> " + _arg_1));
            if (_arg_2){
                _local_5 = (('<font color="#FF0000">' + _local_5) + "</font>");
            }
            else {
                _local_5 = (('<font color="#0000DD">' + _local_5) + "</font>");
            };
            this.subAddMessage(_local_5);
            if (_arg_2){
                this.setAnswerState((GlobalProperties.mainApplication.blablaland.uid > 0));
            };
        }

        public function subAddMessage(_arg_1:String):*{
            this.msgList.push(_arg_1);
            while (this.msgList.length > 100) {
                this.msgList.shift();
            };
            this.txtEcran.htmlText = this.msgList.join("\n");
            this.txtEcran.scrollV = this.txtEcran.maxScrollV;
            this.updateScrollByText(null);
        }


    }
}//package chatbbl.application

