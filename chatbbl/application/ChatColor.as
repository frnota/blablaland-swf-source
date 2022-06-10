// version 467 by nota

//chatbbl.application.ChatColor

package chatbbl.application{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.display.DisplayObject;
    import bbl.GlobalProperties;
    import flash.filters.DropShadowFilter;
    import flash.events.TextEvent;
    import net.SocketMessage;
    import perso.SkinManager;
    import flash.geom.ColorTransform;

    public class ChatColor extends MovieClip {

        public var colorSel:Sprite;
        public var curColor:String;
        public var bt_defaut:SimpleButton;
        public var bt_apply:SimpleButton;
        public var simu:TextField;
        public var styleData:Array;
        public var case_0:Sprite;
        public var case_1:Sprite;
        public var case_2:Sprite;
        public var case_3:Sprite;
        public var case_4:Sprite;
        public var case_5:Sprite;
        public var case_6:Sprite;
        public var case_7:Sprite;
        public var curSel:int;
        public var changed:Boolean;

        public function ChatColor(){
            this.curSel = -1;
            this.changed = true;
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            var _local_2:StyleSheet;
            var _local_3:int;
            var _local_4:DisplayObject;
            var _local_5:Array;
            if (stage){
                this.bt_defaut.addEventListener("click", this.btDefautEvt);
                this.bt_apply.addEventListener("click", this.btApplyEvt);
                this.removeEventListener(Event.ADDED, this.init, false);
                parent.width = 343;
                parent.height = 185;
                Object(parent).redraw();
                this.styleData = GlobalProperties.chatStyleSheetData[(GlobalProperties.chatStyleSheetData.length - 1)];
                parent.addEventListener("onKill", this.onKill, false);
                this.buildColorSel();
                _local_2 = new StyleSheet();
                this.copyStyle(GlobalProperties.chatStyleSheet, _local_2);
                this.simu.styleSheet = _local_2;
                _local_3 = 0;
                while (_local_3 < this.numChildren) {
                    _local_4 = this.getChildAt(_local_3);
                    if ((_local_4 is Sprite)){
                        _local_5 = _local_4.name.split("case_");
                        if (_local_5.length == 2){
                            Sprite(_local_4).filters = [new DropShadowFilter(5, 45, 0, 1, 20, 20, 0.5, 2)];
                            Sprite(_local_4).addEventListener("click", this.caseClickEvt);
                            Sprite(_local_4).buttonMode = true;
                        };
                    };
                    _local_3++;
                };
                this.updateCaseColor();
                this.simu.text = "";
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:0"><span class="user"><u>&lt;pseudo&gt;</u></span></a> : <a href="event:2"><span class="message_M">Texte des garçons.</span></a>' + "\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:0"><span class="user"><u>&lt;pseudo&gt;</u></span></a> : <a href="event:1"><span class="message_F">Texte des filles.</span></a>' + "\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:0"><span class="user"><u>&lt;pseudo&gt;</u></span></a> : <a href="event:3"><span class="message_U">Texte des neutres.</span></a>' + "\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:7"><span class="info">Tu viens de trouver XXX blabillons.' + "</span></a>\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:4"><span class="me">&lt;pseudo&gt; fait une émote.' + "</span></a>\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:5"><span class="message_mp_to">mp à </span></a><a href="event:0"><span class="user"><a href="event:0">&lt;pseudo&gt;</a></span><a href="event:5"><span class="message_mp_to"> : Message envoyé</span></a>' + "\n"));
                this.simu.htmlText = (this.simu.htmlText + ('<a href="event:6"><span class="message_mp">mp de </span></a><a href="event:0"><span class="user"><a href="event:0"><U>&lt;pseudo&gt;</U></a></span><a href="event:6"><span class="message_mp"> : Message reçu.</span></a>' + "\n"));
                this.simu.addEventListener(TextEvent.LINK, this.linkEvent, false, 0, true);
            };
        }

        public function linkEvent(_arg_1:TextEvent):*{
            Sprite(this[("case_" + _arg_1.text)]).dispatchEvent(new Event("click"));
        }

        public function btDefautEvt(_arg_1:Event):*{
            var _local_2:StyleSheet = new StyleSheet();
            this.copyStyle(GlobalProperties.chatStyleSheet, _local_2);
            GlobalProperties.resetChatStyleSheet();
            this.copyStyle(GlobalProperties.chatStyleSheet, this.simu.styleSheet);
            this.copyStyle(_local_2, GlobalProperties.chatStyleSheet);
            this.updateCaseColor();
            this.changed = true;
        }

        public function btApplyEvt(_arg_1:Event):*{
            var _local_2:int;
            var _local_3:Array;
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            var _local_7:SocketMessage;
            var _local_8:Number;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:Number;
            var _local_13:int;
            var _local_14:Number;
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_18:Number;
            var _local_19:String;
            this.copyStyle(this.simu.styleSheet, GlobalProperties.chatStyleSheet);
            if (this.changed){
                this.changed = false;
                if (((GlobalProperties.mainApplication.camera) && (GlobalProperties.mainApplication.camera.mainUser))){
                    _local_2 = (GlobalProperties.chatStyleSheetData.length - 1);
                    _local_3 = new Array();
                    _local_4 = 0;
                    while (_local_4 < this.styleData.length) {
                        _local_8 = Number(this.simu.styleSheet.getStyle(this.styleData[_local_4]).color.split("#").join("0x"));
                        _local_9 = ((_local_8 >> 16) & 0xFF);
                        _local_10 = ((_local_8 >> 8) & 0xFF);
                        _local_11 = (_local_8 & 0xFF);
                        _local_3.push(0);
                        _local_12 = 0xFFFFFFFF;
                        _local_13 = 0;
                        while (_local_13 < SkinManager.colorList.length) {
                            _local_14 = SkinManager.colorList[_local_13][0];
                            _local_15 = ((_local_14 >> 16) & 0xFF);
                            _local_16 = ((_local_14 >> 8) & 0xFF);
                            _local_17 = (_local_14 & 0xFF);
                            _local_18 = (((Math.abs((_local_9 - _local_15)) + Math.abs((_local_10 - _local_16))) + Math.abs((_local_11 - _local_17))) / 3);
                            if (_local_18 < _local_12){
                                _local_12 = _local_18;
                                _local_3[_local_4] = _local_13;
                            };
                            _local_13++;
                        };
                        _local_4++;
                    };
                    _local_5 = _local_2.toString(16);
                    if (_local_5.length == 1){
                        _local_5 = ("0" + _local_5);
                    };
                    _local_6 = 0;
                    while (_local_6 < _local_3.length) {
                        _local_19 = _local_3[_local_6].toString(16);
                        if (_local_19.length == 1){
                            _local_19 = ("0" + _local_19);
                        };
                        _local_5 = (_local_5 + _local_19);
                        _local_6++;
                    };
                    _local_7 = new SocketMessage();
                    _local_7.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 2);
                    _local_7.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 4);
                    _local_7.bitWriteUnsignedInt(5, 1);
                    _local_7.bitWriteString(_local_5);
                    GlobalProperties.mainApplication.blablaland.send(_local_7);
                };
            };
        }

        public function updateCaseColor():*{
            var _local_2:DisplayObject;
            var _local_3:Array;
            var _local_4:int;
            var _local_5:Object;
            var _local_6:ColorTransform;
            var _local_1:int;
            while (_local_1 < this.numChildren) {
                _local_2 = this.getChildAt(_local_1);
                if ((_local_2 is Sprite)){
                    _local_3 = _local_2.name.split("case_");
                    if (_local_3.length == 2){
                        _local_4 = Number(_local_3[1]);
                        _local_5 = this.simu.styleSheet.getStyle(this.styleData[_local_4]);
                        _local_6 = _local_2.transform.colorTransform;
                        _local_6.color = Number(_local_5.color.split("#").join("0x"));
                        _local_2.transform.colorTransform = _local_6;
                    };
                };
                _local_1++;
            };
        }

        public function caseClickEvt(_arg_1:Event):*{
            var _local_2:int = Number(Sprite(_arg_1.currentTarget).name.split("case_")[1]);
            this.curSel = _local_2;
            this.curColor = this.simu.styleSheet.getStyle(this.styleData[_local_2]).color;
            this.showColorSel();
        }

        public function hideColorSel():*{
            var _local_1:Object;
            if (this.colorSel.parent){
                this.colorSel.parent.removeChild(this.colorSel);
            };
            stage.removeEventListener("mouseMove", this.colorSelMoveEvt);
            if (this.curSel >= 0){
                _local_1 = this.simu.styleSheet.getStyle(this.styleData[this.curSel]);
                _local_1.color = this.curColor;
                this.simu.styleSheet.setStyle(this.styleData[this.curSel], _local_1);
                this.updateCaseColor();
            };
            this.curSel = -1;
        }

        public function colorSelMoveEvt(_arg_1:Event):*{
            var _local_2:int = 50;
            if (((((stage.mouseX < (this.colorSel.x - _local_2)) || (stage.mouseX > ((this.colorSel.x + this.colorSel.width) + _local_2))) || (stage.mouseY < (this.colorSel.y - _local_2))) || (stage.mouseY > ((this.colorSel.y + this.colorSel.height) + _local_2)))){
                this.hideColorSel();
            };
        }

        public function showColorSel():*{
            stage.addChild(this.colorSel);
            this.colorSel.x = (stage.mouseX - (this.colorSel.width / 2));
            this.colorSel.y = (stage.mouseY - (this.colorSel.height / 2));
            var _local_1:int = 5;
            if (this.colorSel.x < _local_1){
                this.colorSel.x = _local_1;
            };
            if ((this.colorSel.width + this.colorSel.x) > (stage.stageWidth - _local_1)){
                this.colorSel.x = ((stage.stageWidth - _local_1) - this.colorSel.width);
            };
            if (this.colorSel.y < _local_1){
                this.colorSel.y = _local_1;
            };
            if ((this.colorSel.height + this.colorSel.y) > (stage.stageHeight - _local_1)){
                this.colorSel.y = ((stage.stageHeight - _local_1) - this.colorSel.height);
            };
            stage.addEventListener("mouseMove", this.colorSelMoveEvt);
        }

        public function onKill(_arg_1:Event):*{
            parent.removeEventListener("onKill", this.onKill, false);
            this.hideColorSel();
        }

        public function buildColorSel():*{
            var _local_9:uint;
            var _local_1:int = 15;
            var _local_2:int = 15;
            var _local_3:int = 10;
            var _local_4:int = 9;
            var _local_5:int = 1;
            var _local_6:int = 1;
            this.colorSel = new Sprite();
            this.colorSel.graphics.lineStyle(0, 0xCCCCCC, 1);
            this.colorSel.graphics.beginFill(0xCCCCCC, 1);
            this.colorSel.graphics.moveTo(0, 0);
            this.colorSel.graphics.lineTo(((_local_1 * _local_3) + ((_local_3 - 1) * _local_5)), 0);
            this.colorSel.graphics.lineTo(((_local_1 * _local_3) + ((_local_3 - 1) * _local_5)), ((_local_2 * _local_4) + ((_local_4 - 1) * _local_6)));
            this.colorSel.graphics.lineTo(0, ((_local_2 * _local_4) + ((_local_4 - 1) * _local_6)));
            this.colorSel.graphics.lineTo(0, 0);
            this.colorSel.graphics.endFill();
            this.colorSel.filters = [new DropShadowFilter(5, 45, 0, 1, 20, 20, 0.5, 2)];
            var _local_7:int;
            var _local_8:uint;
            while (_local_8 < _local_4) {
                _local_9 = 0;
                while (_local_9 < _local_3) {
                    this.buildCase(_local_7, _local_9, _local_8, this.colorSel, _local_1, _local_2, _local_5, _local_6);
                    _local_7++;
                    _local_9++;
                };
                _local_8++;
            };
        }

        public function buildCase(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Sprite, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int):*{
            if (((((((((_arg_1 == 56) || (_arg_1 == 57)) || (_arg_1 == 58)) || (_arg_1 == 59)) || (_arg_1 == 19)) || (_arg_1 == 68)) || (_arg_1 == 69)) || (_arg_1 == 79))){
                return;
            };
            var _local_9:Sprite = new Sprite();
            _local_9.x = ((_arg_2 * _arg_5) + (_arg_7 * _arg_2));
            _local_9.y = ((_arg_3 * _arg_6) + (_arg_8 * _arg_3));
            _arg_4.addChild(_local_9);
            _local_9.graphics.lineStyle(0, 0, 0);
            _local_9.graphics.beginFill(SkinManager.colorList[_arg_1][0], 1);
            _local_9.graphics.moveTo(0, 0);
            _local_9.graphics.lineTo(_arg_5, 0);
            _local_9.graphics.lineTo(_arg_5, _arg_6);
            _local_9.graphics.lineTo(0, _arg_6);
            _local_9.graphics.lineTo(0, 0);
            _local_9.graphics.endFill();
            _local_9.name = ("case_" + _arg_1);
            _local_9.addEventListener("mouseOver", this.caseOver);
            _local_9.addEventListener("click", this.caseClick);
            _local_9.buttonMode = true;
        }

        public function caseOver(_arg_1:Event):*{
            var _local_2:int = Number(Sprite(_arg_1.currentTarget).name.split("case_")[1]);
            var _local_3:Object = this.simu.styleSheet.getStyle(this.styleData[this.curSel]);
            _local_3.color = ("#" + SkinManager.colorList[_local_2][0].toString(16));
            this.simu.styleSheet.setStyle(this.styleData[this.curSel], _local_3);
        }

        public function caseClick(_arg_1:Event):*{
            var _local_2:int = Number(Sprite(_arg_1.currentTarget).name.split("case_")[1]);
            this.curColor = ("#" + SkinManager.colorList[_local_2][0].toString(16));
            this.changed = true;
            this.hideColorSel();
        }

        public function copyStyle(_arg_1:StyleSheet, _arg_2:StyleSheet):*{
            var _local_4:String;
            var _local_3:int;
            while (_local_3 < _arg_1.styleNames.length) {
                _local_4 = _arg_1.styleNames[_local_3];
                _arg_2.setStyle(_local_4, _arg_1.getStyle(_local_4));
                _local_3++;
            };
        }


    }
}//package chatbbl.application

