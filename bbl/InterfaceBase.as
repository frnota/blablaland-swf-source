// version 467 by nota

//bbl.InterfaceBase

package bbl{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import ui.Scroll;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.events.Event;
    import flash.text.TextFieldType;

    public class InterfaceBase extends MovieClip {

        public var ecran:TextField;
        public var input:TextField;
        public var btSend:SimpleButton;
        public var btDerouleText:SimpleButton;
        public var scroll:Scroll;
        public var thermo:MovieClip;
        public var mapNameTxt:TextField;
        public var uniNameTxt:TextField;
        public var nbCoMap:TextField;
        public var nbCoMonde:TextField;
        public var nbCoUnivers:TextField;
        public var nbCoMondeUnivers:TextField;
        public var nbAmis:TextField;
        public var nbXP:TextField;
        public var nbBBL:TextField;
        public var thermoTxt:TextField;
        public var ecranBackground:Sprite;
        public var lastMpPseudo:String;
        public var _worldCount:Number;
        public var _universCount:Number;
        private var _textDeroule:Boolean;
        private var _ecranFirstPos:Number;
        private var _ecranFirstHeight:Number;
        private var _ecranBackgroundHeight:Number;
        private var _interfaceMoveLiberty:Boolean;
        private var msgList:Array;
        private var lastMsgList:Array;
        private var lastMsgPos:uint;
        private var _floodPunished:Object;
        private var _scriptingLock:Boolean;
        private var _autoFocus:Boolean;

        public function InterfaceBase(){
            this._worldCount = 0;
            this._universCount = 0;
            this._floodPunished = {"v":false};
            this._scriptingLock = false;
            if (stage){
                GlobalProperties.stage = stage;
            };
            this._interfaceMoveLiberty = true;
            this.autoFocus = true;
            GlobalProperties.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.KeyDown, false, 0, true);
            this.lastMsgList = new Array();
            this.lastMsgPos = 0;
            this.msgList = new Array();
            this.lastMpPseudo = "";
            this.scroll.addEventListener("onChanged", this.updateTextByScroll, false, 0, true);
            this.scroll.value = 1;
            this._textDeroule = true;
            if (this.btDerouleText){
                this.btDerouleText.addEventListener("click", this.derouleText, false, 0, true);
                this._ecranFirstPos = this.ecran.y;
                this._ecranFirstHeight = this.ecran.height;
                this._ecranBackgroundHeight = this.ecranBackground.height;
            };
            this.btSend.addEventListener("click", this.sendMessage, false, 0, true);
            if (this.nbXP){
                this.nbXP.text = "-";
                this.nbXP.mouseEnabled = false;
            };
            if (this.nbBBL){
                this.nbBBL.text = "-";
                this.nbBBL.mouseEnabled = false;
            };
            if (this.nbCoMap){
                this.nbCoMap.text = "-";
                this.nbCoMap.mouseEnabled = false;
            };
            if (this.nbCoMonde){
                this.nbCoMonde.text = "-";
                this.nbCoMonde.mouseEnabled = false;
            };
            if (this.nbCoUnivers){
                this.nbCoUnivers.text = "-";
                this.nbCoUnivers.mouseEnabled = false;
            };
            if (this.nbCoMondeUnivers){
                this.nbCoMondeUnivers.text = "-";
                this.nbCoMondeUnivers.mouseEnabled = false;
            };
            if (this.nbAmis){
                this.nbAmis.text = "-";
                this.nbAmis.mouseEnabled = false;
            };
            if (this.mapNameTxt){
                this.mapNameTxt.text = "-";
                this.mapNameTxt.mouseEnabled = false;
            };
            if (this.uniNameTxt){
                this.uniNameTxt.text = "-";
                this.uniNameTxt.mouseEnabled = false;
            };
            if (this.thermoTxt){
                this.thermoTxt.text = "";
                this.thermoTxt.mouseEnabled = false;
            };
            this.ecran.htmlText = "";
            this.input.text = "";
            this.input.addEventListener("change", this.inputChanged, false, 0, true);
            this.input.addEventListener("click", this.inputChanged, false, 0, true);
            GlobalProperties.stage.addEventListener("focusOut", this.checkFocus, false, 0, true);
            GlobalProperties.stage.addEventListener("focusIn", this.checkFocus, false, 0, true);
            this.ecran.styleSheet = GlobalProperties.chatStyleSheet;
            this.ecran.addEventListener(TextEvent.LINK, this.linkEvent, false, 0, true);
            if (this.btDerouleText){
                this.derouleText();
            };
            this.mapName = null;
            this.uniName = null;
            this.temperature = 0.6;
        }

        private function updateCount():*{
            if (this.nbCoMonde){
                this.nbCoMonde.text = this._worldCount.toString();
            };
            if (this.nbCoUnivers){
                this.nbCoUnivers.text = this._universCount.toString();
            };
            if (this.nbCoMondeUnivers){
                this.nbCoMondeUnivers.text = (((this._worldCount.toString() + " [") + this._universCount.toString()) + "]");
            };
        }

        public function set temperature(_arg_1:Number):*{
            var _local_2:uint;
            var _local_3:String;
            if (this.thermo){
                _local_2 = Math.round((((this.thermo.totalFrames - 1) * _arg_1) + 1));
                if (_local_2 != this.thermo.currentFrame){
                    this.thermo.gotoAndStop(_local_2);
                };
            };
            if (this.thermoTxt){
                _local_3 = (Math.round(((_arg_1 * 80) - 40)) + "°");
                if (this.thermoTxt.text != _local_3){
                    this.thermoTxt.text = _local_3;
                };
            };
        }

        public function set mapCount(_arg_1:uint):*{
            if (this.nbCoMap){
                this.nbCoMap.text = _arg_1.toString();
            };
        }

        public function set xp(_arg_1:uint):*{
            if (this.nbXP){
                this.nbXP.text = _arg_1.toString();
            };
        }

        public function set bbl(_arg_1:uint):*{
            if (this.nbBBL){
                this.nbBBL.text = _arg_1.toString();
            };
        }

        public function set worldCount(_arg_1:uint):*{
            this._worldCount = _arg_1;
            this.updateCount();
        }

        public function set universCount(_arg_1:uint):*{
            this._universCount = _arg_1;
            this.updateCount();
        }

        public function set friendCount(_arg_1:uint):*{
            if (this.nbAmis){
                this.nbAmis.text = _arg_1.toString();
            };
        }

        public function get friendCount():uint{
            if (this.nbAmis){
                return (Number(this.nbAmis.text));
            };
            return (0);
        }

        public function set uniName(_arg_1:String):*{
            if (this.uniNameTxt){
                if (_arg_1){
                    this.uniNameTxt.text = _arg_1;
                }
                else {
                    this.uniNameTxt.text = "--";
                };
            };
        }

        public function set mapName(_arg_1:String):*{
            if (this.mapNameTxt){
                if (_arg_1){
                    this.mapNameTxt.text = _arg_1;
                }
                else {
                    this.mapNameTxt.text = "--";
                };
            };
        }

        public function derouleText(_arg_1:Event=null):*{
            var _local_2:uint = 200;
            this.ecran.y = ((this._textDeroule) ? this._ecranFirstPos : (this._ecranFirstPos - _local_2));
            this.btDerouleText.y = this.ecran.y;
            this.scroll.y = (this.ecran.y + 3);
            this.ecran.height = ((this._textDeroule) ? this._ecranFirstHeight : (this._ecranFirstHeight + _local_2));
            this.scroll.size = (this.ecran.height - 10);
            this.ecranBackground.y = ((this._textDeroule) ? this._ecranFirstPos : (this._ecranFirstPos - _local_2));
            this.ecranBackground.height = ((this._textDeroule) ? this._ecranBackgroundHeight : (this._ecranBackgroundHeight + _local_2));
            this.ecranBackground.alpha = ((this._textDeroule) ? 1 : 0.75);
            this.ecran.y = (this.ecran.y - 2);
            this._textDeroule = (!(this._textDeroule));
            this.updateTextByScroll();
        }

        public function linkEvent(_arg_1:TextEvent):*{
            var _local_3:InterfaceEvent;
            var _local_4:TextEvent;
            var _local_2:* = _arg_1.text.split("=");
            if (_local_2[0] == "0"){
                _local_3 = new InterfaceEvent("onSelectUser");
                _local_3.pseudo = unescape(_local_2[1]);
                _local_3.pid = _local_2[2];
                _local_3.uid = _local_2[3];
                _local_3.serverId = _local_2[4];
                dispatchEvent(_local_3);
            }
            else {
                if (_local_2[0] == "1"){
                    _local_2.shift();
                    _local_4 = new TextEvent("onOpenAlert");
                    _local_4.text = _local_2.join("=");
                    dispatchEvent(_local_4);
                };
            };
        }

        public function get interfaceMoveLiberty():Boolean{
            if (((!(GlobalProperties.stage.focus == this.input)) || (!(this.input.text.length)))){
                return (true);
            };
            return (this._interfaceMoveLiberty);
        }

        public function inputChanged(_arg_1:Event):*{
            this._interfaceMoveLiberty = false;
            if (((this.input.text == "/r ") && (this.lastMpPseudo.length))){
                this.input.text = (("/mp " + this.lastMpPseudo) + " ");
                this.input.setSelection(this.input.text.length, this.input.text.length);
            };
        }

        public function KeyDown(_arg_1:KeyboardEvent):*{
            if ((((_arg_1.keyCode == 38) || (_arg_1.keyCode == 40)) && (!(_arg_1.ctrlKey)))){
                this._interfaceMoveLiberty = true;
            };
            if (GlobalProperties.stage.focus == this.input){
                if (_arg_1.keyCode == 13){
                    this.sendMessage();
                }
                else {
                    if ((((_arg_1.keyCode == 38) && (_arg_1.ctrlKey)) && (this.lastMsgList.length))){
                        if (this.lastMsgPos > 0){
                            this.lastMsgPos--;
                        };
                        this.input.text = this.lastMsgList[this.lastMsgPos];
                    }
                    else {
                        if ((((_arg_1.keyCode == 40) && (_arg_1.ctrlKey)) && (this.lastMsgList.length))){
                            this.lastMsgPos++;
                            if (this.lastMsgPos > (this.lastMsgList.length - 1)){
                                this.lastMsgPos = (this.lastMsgList.length - 1);
                            };
                            this.input.text = this.lastMsgList[this.lastMsgPos];
                        };
                    };
                };
            };
        }

        public function checkFocus(_arg_1:Event=null):*{
            var _local_2:Boolean;
            var _local_3:Boolean;
            if (this._autoFocus){
                _local_2 = (GlobalProperties.stage.focus is TextField);
                _local_3 = false;
                if (_local_2){
                    if (TextField(GlobalProperties.stage.focus).type == "input"){
                        _local_3 = true;
                    };
                };
                if (!_local_3){
                    this.setFocus();
                };
            };
        }

        public function setFocus():*{
            GlobalProperties.stage.focus = this.input;
        }

        public function setMP(_arg_1:String):*{
            _arg_1 = _arg_1.split("\n")[0];
            this.input.text = this.input.text.replace(/^\/mp +[^ ]* */, "");
            this.input.text = ((("/mp " + _arg_1) + " ") + this.input.text);
            this.setFocus();
            this.input.setSelection(this.input.text.length, this.input.text.length);
        }

        public function sendMessage(_arg_1:Event=null):*{
            this.computeMessage(this.input.text);
        }

        public function computeMessage(_arg_1:String):*{
            var _local_2:String;
            var _local_3:Boolean;
            var _local_4:InterfaceEvent;
            var _local_5:Array;
            var _local_6:Array;
            var _local_7:TextEvent;
            if ((((_arg_1.length) && (!(this.floodPunished))) && (!(this.scriptingLock)))){
                _arg_1 = _arg_1.replace(/\x09/gi, " ");
                _arg_1 = _arg_1.replace(/(.)\1{10,}/gi, "$1$1$1$1$1");
                _arg_1 = _arg_1.replace(/(.)(.)(\1\2){10,}/gi, "$1$2$1$2$1$2$1$2$1$2");
                _local_2 = _arg_1;
                _local_3 = false;
                _local_2 = _local_2.replace(/^(\/[^\s]*)\s+/, "$1 ");
                _local_2 = _local_2.replace(/^\.\.\.+ +(.*)/, "/pense $1");
                _local_2 = _local_2.replace(/^([^\/]+!!!+)$/, "/cri $1");
                _local_5 = _local_2.split(" ");
                _local_5[0] = _local_5[0].toLowerCase();
                _local_6 = _local_5.slice();
                if (((_local_5[0] == "/mp") || (_local_5[0] == "/w"))){
                    if (_local_5.length > 2){
                        if (((_local_5[1].length > 2) && ((_local_5[2].length > 0) || (_local_5.length > 3)))){
                            _local_4 = new InterfaceEvent("onSendPrivateMessage");
                            _local_4.pseudo = _local_5[1];
                            _local_6.shift();
                            _local_6.shift();
                            _local_4.text = _local_6.join(" ");
                            dispatchEvent(_local_4);
                            _local_3 = true;
                        };
                    };
                }
                else {
                    if (_local_5[0] == "/debug"){
                        dispatchEvent(new Event("onOpenDebug"));
                        _local_3 = true;
                    }
                    else {
                        if (_local_5[0] == "/dodo"){
                            dispatchEvent(new Event("onDodo"));
                            _local_3 = true;
                        }
                        else {
                            if (_local_5[0] == "/prison"){
                                dispatchEvent(new Event("onPrison"));
                                _local_3 = true;
                            }
                            else {
                                if (_local_5[0] == "/paradis"){
                                    _local_4 = new InterfaceEvent("onCreve");
                                    _local_6.shift();
                                    _local_4.text = _local_6.join(" ");
                                    dispatchEvent(_local_4);
                                    _local_3 = true;
                                }
                                else {
                                    if (_local_5[0] == "/poisson"){
                                        _local_4 = new InterfaceEvent("onPoissonAvril");
                                        dispatchEvent(_local_4);
                                        _local_3 = true;
                                    }
                                    else {
                                        if (_local_5[0] == "/reload"){
                                            _local_4 = new InterfaceEvent("onReload");
                                            dispatchEvent(_local_4);
                                        }
                                        else {
                                            if (_local_5[0] == "/guerreouverte"){
                                                _local_4 = new InterfaceEvent("onWarEvent");
                                                _local_4.text = "1";
                                                dispatchEvent(_local_4);
                                                _local_3 = true;
                                            }
                                            else {
                                                if (_local_5[0] == "/guerrefermee"){
                                                    _local_4 = new InterfaceEvent("onWarEvent");
                                                    _local_4.text = "0";
                                                    dispatchEvent(_local_4);
                                                    _local_3 = true;
                                                }
                                                else {
                                                    if (_local_5[0] == "/profil"){
                                                        _local_4 = new InterfaceEvent("onOpenProfil");
                                                        dispatchEvent(_local_4);
                                                        _local_3 = true;
                                                    }
                                                    else {
                                                        if (((_local_5[0].charAt(0) == "/") && (_local_5[0].length > 2))){
                                                            _local_4 = new InterfaceEvent("onAction");
                                                            _local_6 = _local_5.slice();
                                                            _local_4.action = _local_6[0];
                                                            _local_6.shift();
                                                            _local_4.text = _local_6.join(" ");
                                                            _local_4.actionList = _local_6;
                                                            dispatchEvent(_local_4);
                                                            _local_3 = _local_4.valide;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                if (_local_5[0].charAt(0) != "/"){
                    _local_7 = new TextEvent("onSendMessage");
                    _local_7.text = _arg_1;
                    dispatchEvent(_local_7);
                    _local_3 = true;
                }
                else {
                    if (!_local_3){
                        this.addLocalMessage((('<span class="info">Commande "' + this.htmlEncode(_arg_1)) + '" invalide !</span>'));
                    };
                };
                if (_local_3){
                    this.lastMsgList.push(_arg_1);
                    if (this.lastMsgList.length > 30){
                        this.lastMsgList.shift();
                    };
                    this.lastMsgPos = this.lastMsgList.length;
                    this.input.text = "";
                };
            };
        }

        public function addUserMessage(_arg_1:String, _arg_2:String, _arg_3:Object=null):*{
            if (!_arg_3){
                _arg_3 = new Object();
            };
            if (!_arg_3.PID){
                _arg_3.PID = 0;
            };
            if (!_arg_3.UID){
                _arg_3.UID = 0;
            };
            if (!_arg_3.SERVERID){
                _arg_3.SERVERID = 0;
            };
            if (!_arg_3.TYPE){
                _arg_3.TYPE = 0;
            };
            _arg_1 = this.htmlEncode(_arg_1);
            if (!_arg_3.ISHTML){
                _arg_2 = this.htmlEncode(_arg_2);
            };
            var _local_4:Array = new Array("", _arg_1, "</span>");
            if (_arg_3.TYPE == 3){
                _local_4[0] = '<span class="me">';
            }
            else {
                if (((_arg_3.ISMODO) && (_arg_3.ISPRIVATE))){
                    _local_4[0] = '<span class="user_modo_mp"> MODO ';
                }
                else {
                    if (_arg_3.ISMODO){
                        _local_4[0] = '<span class="user_modo"> MODO ';
                    }
                    else {
                        _local_4[0] = '<span class="user">';
                    };
                };
            };
            var _local_5:String = ((_arg_3.SEX == 0) ? "_U" : ((_arg_3.SEX == 1) ? "_M" : "_F"));
            var _local_6:Array = new Array("", _arg_2, "</span>");
            if (_arg_3.TYPE == 3){
                _local_6[0] = '<span class="me">';
            }
            else {
                if (((_arg_3.ISMODO) && (_arg_3.ISPRIVATE))){
                    _local_6[0] = '<span class="message_modo_mp">';
                }
                else {
                    if (_arg_3.ISMODO){
                        _local_6[0] = '<span class="message_modo">';
                    }
                    else {
                        if (_arg_3.ISPRIVATE){
                            _local_6[0] = '<span class="message_mp">';
                        }
                        else {
                            _local_6[0] = (('<span class="message' + _local_5) + '">');
                        };
                    };
                };
            };
            if (((_arg_3.ISPRIVATE) && (!(_arg_3.ISMODO)))){
                _local_4[0] = ('<span class="message_mp">mp de </span>' + _local_4[0]);
            };
            if (_arg_3.TYPE == 1){
                _local_4[2] = (" pense : " + _local_4[2]);
            }
            else {
                if (_arg_3.TYPE == 2){
                    _local_4[2] = (" crie : " + _local_4[2]);
                }
                else {
                    if (_arg_3.TYPE == 3){
                        _local_4[2] = (" " + _local_4[2]);
                    }
                    else {
                        _local_4[2] = (" : " + _local_4[2]);
                    };
                };
            };
            if (((_arg_3.PID) && (!(_arg_3.ISMODO)))){
                _local_4[0] = (_local_4[0] + (((((((("<U><A HREF='event:0=" + escape(_arg_1)) + "=") + _arg_3.PID) + "=") + _arg_3.UID) + "=") + _arg_3.SERVERID) + "'>"));
                _local_4[2] = ("</a></u>" + _local_4[2]);
            };
            var _local_7:String = (_local_4.join("") + _local_6.join(""));
            if (_arg_3.ISPRIVATE){
                dispatchEvent(new Event("onShowMP"));
            };
            if (_arg_3.ISMODO){
                dispatchEvent(new Event("onModoMessage"));
            };
            this.addLocalMessage(_local_7);
        }

        public function htmlEncode(_arg_1:String):String{
            return (GlobalProperties.htmlEncode(_arg_1));
        }

        public function addLocalMessage(_arg_1:String):*{
            if (_arg_1){
                this.msgList.push(_arg_1);
            };
            if (this.msgList.length > 80){
                this.msgList.shift();
            };
            this.ecran.htmlText = this.msgList.join("<br>");
            this.updateTextByScroll();
        }

        private function updateTextByScroll(_arg_1:Event=null):*{
            this.scroll.visible = (this.ecran.maxScrollV > 1);
            this.ecran.scrollV = (((this.ecran.maxScrollV - 1) * this.scroll.value) + 1);
        }

        public function get scriptingLock():Boolean{
            return (this._scriptingLock);
        }

        public function set scriptingLock(_arg_1:Boolean):*{
            this._scriptingLock = _arg_1;
            this.updateLock();
        }

        public function get floodPunished():Boolean{
            return (this._floodPunished.v);
        }

        public function set floodPunished(_arg_1:Boolean):*{
            this._floodPunished = {"v":_arg_1};
            this.updateLock();
        }

        public function get autoFocus():Boolean{
            return (this._autoFocus);
        }

        public function set autoFocus(_arg_1:Boolean):*{
            this._autoFocus = _arg_1;
            if (_arg_1){
                this.checkFocus();
            };
        }

        public function updateLock():*{
            var _local_1:Boolean = ((this._scriptingLock) || (this.floodPunished));
            this.input.backgroundColor = ((_local_1) ? 0xBBBBBB : 0xFFFFFF);
            this.input.type = ((_local_1) ? TextFieldType.DYNAMIC : TextFieldType.INPUT);
        }


    }
}//package bbl

