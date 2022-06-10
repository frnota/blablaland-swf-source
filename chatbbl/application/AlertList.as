// version 467 by nota

//chatbbl.application.AlertList

package chatbbl.application{
    import flash.display.MovieClip;
    import ui.List;
    import flash.display.Sprite;
    import flash.events.Event;
    import ui.ListGraphicTxtClick;
    import chatbbl.Chat;
    import chatbbl.GlobalChatProperties;
    import flash.text.StyleSheet;
    import fx.FxLoader;
    import bbl.GlobalProperties;
    import ui.ListGraphicEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class AlertList extends MovieClip {

        public var liste:List;
        public var bt_clear:Sprite;

        public function AlertList(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
            this.addEventListener("onKill", this.onKill, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.removeEventListener(Event.ADDED, this.init, false);
                this.liste.size = 10;
                this.liste.graphicLink = ListGraphicTxtClick;
                this.liste.graphicWidth = 350;
                this.liste.addEventListener("onTextClick", this.onTextClick, false, 0, true);
                this.liste.addEventListener("onClick", this.onLineClick, false, 0, true);
                this.bt_clear.getChildByName("bt").addEventListener("click", this.onClear, false, 0, true);
                parent.width = ((this.liste.graphicWidth + 15) + (this.liste.x * 2));
                parent.height = (((this.liste.graphicHeight * this.liste.size) + (this.liste.y * 2)) + 20);
                Object(parent).redraw();
                this.bt_clear.x = ((parent.width / 2) - (this.bt_clear.width / 2));
                this.bt_clear.y = (parent.height - 18);
                Chat(GlobalChatProperties.chat).addEventListener("onAlertChange", this.updateList, false, 0, true);
                this.updateList();
            };
        }

        public function onClear(_arg_1:Event):*{
            Chat(GlobalChatProperties.chat).clearAllAlert();
        }

        public function onKill(_arg_1:Event):*{
            this.removeEventListener("onKill", this.onKill, false);
            Chat(GlobalChatProperties.chat).removeEventListener("onAlertChange", this.updateList, false);
        }

        public function updateList(_arg_1:Event=null):*{
            var _local_5:*;
            var _local_6:*;
            var _local_2:StyleSheet = new StyleSheet();
            _local_2.setStyle(".click_pseudo", {
                "color":"#0000FF",
                "textDecoration":"underline"
            });
            _local_2.setStyle(".accept", {
                "color":"#0000FF",
                "textDecoration":"underline"
            });
            _local_2.setStyle(".cancel", {
                "color":"#0000FF",
                "textDecoration":"underline"
            });
            _local_2.setStyle(".info", {"color":"#0000FF"});
            this.liste.node.removeAllChild();
            var _local_3:* = Chat(GlobalChatProperties.chat).alertList;
            var _local_4:uint;
            while (_local_4 < _local_3.length) {
                _local_5 = this.liste.node.addChild();
                _local_6 = new Date();
                _local_6.setTime(_local_3[_local_4].date);
                _local_5.data.ALERT = _local_3[_local_4];
                _local_5.text = (((("[" + _local_6.getHours()) + ":") + _local_6.getMinutes()) + "] ");
                _local_5.styleSheet = _local_2;
                if (_local_3[_local_4].type == 0){
                    _local_5.text = (_local_5.text + (((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> veut être ton ami. <span class='accept'><A HREF='event:1'>Accepter</a></span>"));
                }
                else {
                    if (_local_3[_local_4].type == 1){
                        _local_5.text = (_local_5.text + (((((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].pid) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> vient de se connecter."));
                    }
                    else {
                        if (_local_3[_local_4].type == 2){
                            _local_5.text = (_local_5.text + (((((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].pid) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> quitte ta liste d'amis."));
                        }
                        else {
                            if (_local_3[_local_4].type == 3){
                                _local_5.text = (_local_5.text + (((((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].pid) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> est ajouté à ta liste d'amis."));
                            }
                            else {
                                if (_local_3[_local_4].type == 4){
                                    _local_5.text = (_local_5.text + (("<span class='info'>" + _local_3[_local_4].texte) + "</span>"));
                                }
                                else {
                                    if (_local_3[_local_4].type == 5){
                                        _local_5.text = (_local_5.text + (("<span class='info'>" + _local_3[_local_4].texte) + "</span>"));
                                    }
                                    else {
                                        if (_local_3[_local_4].type == 6){
                                            _local_5.text = (_local_5.text + (((((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].pid) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> t'invite à faire une 'Blablataille navale', <span class='accept'><A HREF='event:2'>Accepter</a></span>."));
                                        }
                                        else {
                                            if (_local_3[_local_4].type == 7){
                                                _local_5.text = (_local_5.text + (((((((("<span class='click_pseudo'><A HREF='event:0=" + escape(_local_3[_local_4].pseudo)) + "=") + _local_3[_local_4].pid) + "=") + _local_3[_local_4].uid) + "'>") + _local_3[_local_4].pseudo) + "</a></span> t'invite à faire un 'TicTacToe', <span class='accept'><A HREF='event:3'>Accepter</a></span>."));
                                            }
                                            else {
                                                if (_local_3[_local_4].type == 8){
                                                    _local_5.text = (_local_5.text + _local_3[_local_4].texte);
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                _local_4++;
            };
            this.liste.redraw();
        }

        public function onTextClick(_arg_1:ListGraphicEvent):*{
            var _local_3:FxLoader;
            var _local_4:Object;
            var _local_2:Array = _arg_1.text.split("=");
            if (_local_2[0] == "0"){
                Chat(GlobalChatProperties.chat).clickUser(uint(_local_2[3]), _local_2[1]);
            }
            else {
                if (_local_2[0] == "1"){
                    if (Chat(GlobalChatProperties.chat).blablaland.getFriendByUID(_arg_1.graphic.node.data.ALERT.uid)){
                        Chat(GlobalChatProperties.chat).msgPopup.open({
                            "APP":PopupMessage,
                            "TITLE":"Impossible !",
                            "DEPEND":this
                        }, {
                            "MSG":(('"' + _arg_1.graphic.node.data.ALERT.pseudo) + "\" est deja dans ta liste d'amis."),
                            "ACTION":"OK"
                        });
                    }
                    else {
                        _local_4 = Chat(GlobalChatProperties.chat).msgPopup.open({
                            "APP":PopupMessage,
                            "TITLE":"Confirme :",
                            "DEPEND":this
                        }, {
                            "MSG":(("Tu es sûr de vouloir être dans la liste d'amis de " + _arg_1.graphic.node.data.ALERT.pseudo) + " ?"),
                            "ACTION":"YESNO",
                            "ALERT":_arg_1.graphic.node.data.ALERT
                        });
                        _local_4.addEventListener("onEvent", this.acceptFriend, false, 0, true);
                    };
                }
                else {
                    if (_local_2[0] == "2"){
                        _local_3 = new FxLoader();
                        _local_3.initData = {
                            "CHAT":GlobalChatProperties.chat,
                            "ACTION":2,
                            "UID":_arg_1.graphic.node.data.ALERT.uid
                        };
                        _local_3.loadFx(10);
                        Object(parent).close();
                    }
                    else {
                        if (_local_2[0] == "3"){
                            _local_3 = new FxLoader();
                            _local_3.initData = {
                                "CHAT":GlobalChatProperties.chat,
                                "ACTION":2,
                                "UID":_arg_1.graphic.node.data.ALERT.uid
                            };
                            _local_3.loadFx(11);
                            Object(parent).close();
                        }
                        else {
                            if (_local_2[0] == "4"){
                                _local_3 = new FxLoader();
                                _local_3.initData = {
                                    "GB":GlobalProperties,
                                    "PARAM":_arg_1.graphic.node.data.ALERT.data
                                };
                                _local_3.loadFx(_arg_1.graphic.node.data.ALERT.fxFileId);
                                Object(parent).close();
                            };
                        };
                    };
                };
            };
        }

        public function acceptFriend(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                _arg_1.currentTarget.removeEventListener("onEvent", this.acceptFriend, false);
                Chat(GlobalChatProperties.chat).answerFriendAsk(true, _arg_1.currentTarget.data.ALERT.uid, _arg_1.currentTarget.data.ALERT.pseudo);
                Object(parent).close();
            };
        }

        public function onLineClick(_arg_1:ListGraphicEvent):*{
            if (_arg_1.graphic.node.data.ALERT.type == "5"){
                navigateToURL(new URLRequest("/site/shop_index.php"), "_blank");
            };
        }


    }
}//package chatbbl.application

