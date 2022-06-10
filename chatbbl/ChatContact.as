// version 467 by nota

//chatbbl.ChatContact

package chatbbl{
    import bbl.GlobalProperties;
    import flash.events.Event;
    import flash.net.URLVariables;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import bbl.Contact;
    import flash.external.ExternalInterface;
    import bbl.ContactEvent;
    import fx.FxLoader;
    import net.SocketMessage;
    import net.ParsedMessageEvent;

    public class ChatContact extends ChatInterface {


        override public function initBlablaland():*{
            super.initBlablaland();
            blablaland.addEventListener("onRemoveFriend", this.onFriendRemoved, false);
            blablaland.addEventListener("onFriendAdded", this.onFriendAdded, false);
            blablaland.addEventListener("onParsedMessage", this.onInterfaceMessage, false);
            blablaland.addEventListener("onFriendListChange", this.onFriendListChange, false);
        }

        override public function close():*{
            if (blablaland){
                blablaland.removeEventListener("onRemoveFriend", this.onFriendRemoved, false);
                blablaland.removeEventListener("onFriendAdded", this.onFriendAdded, false);
                blablaland.removeEventListener("onParsedMessage", this.onInterfaceMessage, false);
                blablaland.removeEventListener("onFriendListChange", this.onFriendListChange, false);
            };
            super.close();
        }

        override public function onGetCamera(_arg_1:Event):*{
            super.onGetCamera(_arg_1);
            if (((camera) && (GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN))){
                openFriendList();
            };
        }

        public function removeBlackList(_arg_1:uint):*{
            var _local_3:URLVariables;
            var _local_4:URLRequest;
            var _local_5:URLLoader;
            var _local_2:Contact = blablaland.getBlackListByUID(_arg_1);
            if (_local_2){
                _local_3 = new URLVariables();
                _local_3.CACHE = new Date().getTime();
                _local_3.ACTION = 5;
                _local_3.PARAMS = ((("SESSION=" + session) + "&TARGETID=") + _arg_1);
                _local_4 = new URLRequest((GlobalProperties.scriptAdr + "/chat/contactManager.php"));
                _local_4.method = "POST";
                _local_4.data = _local_3;
                _local_5 = new URLLoader();
                _local_5.dataFormat = "variables";
                _local_5.load(_local_4);
                userInterface.addLocalMessage("<span class='info'>Ce blabla n'est plus back listé :).</span>");
            };
        }

        public function addBlackList(_arg_1:uint):*{
            var _local_3:URLVariables;
            var _local_4:URLRequest;
            var _local_5:URLLoader;
            var _local_2:Contact = blablaland.getBlackListByUID(_arg_1);
            if (!_local_2){
                _local_3 = new URLVariables();
                _local_3.CACHE = new Date().getTime();
                _local_3.ACTION = 4;
                _local_3.PARAMS = ((("SESSION=" + session) + "&TARGETID=") + _arg_1);
                _local_4 = new URLRequest((GlobalProperties.scriptAdr + "/chat/contactManager.php"));
                _local_4.method = "POST";
                _local_4.data = _local_3;
                _local_5 = new URLLoader();
                _local_5.dataFormat = "variables";
                _local_5.load(_local_4);
                _local_5.addEventListener("complete", this.addBlackListMessage, false, 0, true);
            };
        }

        public function addBlackListMessage(_arg_1:Event):*{
            var _local_2:uint = Number(_arg_1.currentTarget.data.RES);
            var _local_3:String = _arg_1.currentTarget.data.ERROR;
            if (((_local_2) && (!(_local_3)))){
                userInterface.addLocalMessage("<span class='info'>Blabla black listé ^^</span>");
            }
            else {
                if (((!(_local_2)) && (_local_3 == "BLACK_LISTED"))){
                    userInterface.addLocalMessage("<span class='info'>Ce blabla est déja dans ta black list :).</span>");
                }
                else {
                    if (((!(_local_2)) && (_local_3 == "BLACK_LIST_FULL"))){
                        userInterface.addLocalMessage("<span class='info'>Impossible, ta black liste est pleine :/.</span>");
                    };
                };
            };
        }

        public function removeMute(_arg_1:uint):*{
            blablaland.removeMute(_arg_1);
        }

        public function addMute(_arg_1:uint, _arg_2:String):*{
            blablaland.addMute(_arg_1, _arg_2);
        }

        public function removeFriend(_arg_1:uint):*{
            var _local_3:URLVariables;
            var _local_4:URLRequest;
            var _local_5:URLLoader;
            var _local_2:Contact = blablaland.getFriendByUID(_arg_1);
            if (_local_2){
                _local_3 = new URLVariables();
                _local_3.CACHE = new Date().getTime();
                _local_3.ACTION = 3;
                _local_3.PARAMS = ((("SESSION=" + session) + "&TARGETID=") + _arg_1);
                _local_4 = new URLRequest((GlobalProperties.scriptAdr + "/chat/contactManager.php"));
                _local_4.method = "POST";
                _local_4.data = _local_3;
                _local_5 = new URLLoader();
                _local_5.dataFormat = "variables";
                _local_5.load(_local_4);
            };
        }

        public function addFriend(_arg_1:uint):*{
            var _local_3:URLVariables;
            var _local_4:URLRequest;
            var _local_5:URLLoader;
            var _local_2:Contact = blablaland.getFriendByUID(_arg_1);
            if (!_local_2){
                _local_3 = new URLVariables();
                _local_3.CACHE = new Date().getTime();
                _local_3.ACTION = 1;
                _local_3.PARAMS = ((("SESSION=" + session) + "&TARGETID=") + _arg_1);
                _local_4 = new URLRequest((GlobalProperties.scriptAdr + "/chat/contactManager.php"));
                _local_4.method = "POST";
                _local_4.data = _local_3;
                _local_5 = new URLLoader();
                _local_5.dataFormat = "variables";
                _local_5.load(_local_4);
                _local_5.addEventListener("complete", this.addFriendMessage, false, 0, true);
            };
        }

        public function addFriendMessage(_arg_1:Event):*{
            var _local_2:uint = Number(_arg_1.currentTarget.data.RES);
            var _local_3:String = _arg_1.currentTarget.data.ERROR;
            var _local_4:String = _arg_1.currentTarget.data.INFO;
            if ((((_local_2) && (!(_local_3))) && (!(_local_4)))){
                userInterface.addLocalMessage("<span class='info'>Demande d'ajout à la liste d'amis transmise.</span>");
            }
            else {
                if (((!(_local_2)) && (_local_3 == "PENDING"))){
                    userInterface.addLocalMessage("<span class='info'>Tu as déja fais cette demande d'amis. Tu dois attendre que le blabla réponde.</span>");
                }
                else {
                    if (((!(_local_2)) && (_local_3 == "FRIEND_LISTED"))){
                        userInterface.addLocalMessage("<span class='info'>Ce blabla est déja dans ta liste d'amis ^^.</span>");
                    }
                    else {
                        if (((!(_local_2)) && (_local_3 == "BLACK_LISTED"))){
                            userInterface.addLocalMessage("<span class='info'>Impossible de faire la demande, tu es dans la black liste de ce blabla.</span>");
                        }
                        else {
                            if (((!(_local_2)) && (_local_3 == "FROM_LIST_FULL"))){
                                userInterface.addLocalMessage("<span class='info'>Impossible, ta liste d'amis est pleine :/.</span>");
                            }
                            else {
                                if (((!(_local_2)) && (_local_3 == "TARGET_LIST_FULL"))){
                                    userInterface.addLocalMessage("<span class='info'>Impossible, sa liste d'amis est pleine.</span>");
                                }
                                else {
                                    if (((!(_local_2)) && (_local_3 == "SELF_INVIT"))){
                                        userInterface.addLocalMessage("<span class='info'>Impossible de s'inviter soi-même !!</span>");
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function answerFriendAsk(_arg_1:Boolean, _arg_2:uint, _arg_3:String):*{
            var _local_5:URLVariables;
            var _local_6:URLRequest;
            var _local_7:URLLoader;
            var _local_4:Contact = blablaland.getFriendByUID(_arg_2);
            if (!_local_4){
                _local_5 = new URLVariables();
                _local_5.CACHE = new Date().getTime();
                _local_5.ACTION = 2;
                _local_5.PARAMS = ((((("SESSION=" + session) + "&TARGETID=") + _arg_2) + "&ACCEPT=") + ((_arg_1) ? 1 : 0));
                _local_6 = new URLRequest((GlobalProperties.scriptAdr + "/chat/contactManager.php"));
                _local_6.method = "POST";
                _local_6.data = _local_5;
                _local_7 = new URLLoader();
                _local_7.dataFormat = "variables";
                _local_7.load(_local_6);
                _local_7.addEventListener("complete", this.answerFriendAskMessage, false, 0, true);
            };
        }

        public function answerFriendAskMessage(_arg_1:Event):*{
            var _local_2:uint = Number(_arg_1.currentTarget.data.RES);
            var _local_3:String = _arg_1.currentTarget.data.ERROR;
            if (((!(_local_2)) && (_local_3 == "FRIEND_LISTED"))){
                userInterface.addLocalMessage("<span class='info'>Ce blabla est déja dans ta liste d'amis ^^.</span>");
            }
            else {
                if (((!(_local_2)) && (_local_3 == "BLACK_LISTED"))){
                    userInterface.addLocalMessage("<span class='info'>Impossible de faire la demande, tu es dans la black liste de ce blabla.</span>");
                }
                else {
                    if (((!(_local_2)) && (_local_3 == "FROM_LIST_FULL"))){
                        userInterface.addLocalMessage("<span class='info'>Impossible, ta liste d'amis est pleine :/.</span>");
                    }
                    else {
                        if (((!(_local_2)) && (_local_3 == "TARGET_LIST_FULL"))){
                            userInterface.addLocalMessage("<span class='info'>Impossible, sa liste d'amis est pleine.</span>");
                        };
                    };
                };
            };
        }

        public function updateFriendConnected():*{
            var _local_1:uint;
            var _local_2:* = 0;
            while (_local_2 < blablaland.friendList.length) {
                if (blablaland.friendList[_local_2].connected){
                    _local_1++;
                };
                _local_2++;
            };
            ExternalInterface.call("bblinfos_setAmis", _local_1, blablaland.friendList.length);
            userInterface.friendCount = _local_1;
        }

        public function onFriendListChange(_arg_1:Event):*{
            var _local_2:* = 0;
            while (_local_2 < blablaland.friendList.length) {
                blablaland.friendList[_local_2].addEventListener("onStateChanged", this.onFriendStateChanged, false, 0, true);
                _local_2++;
            };
            this.updateFriendConnected();
        }

        public function onFriendStateChanged(_arg_1:Event):*{
            var _local_2:ChatAlertItem;
            var _local_3:String;
            userInterface.friendCount = (userInterface.friendCount + ((_arg_1.currentTarget.connected) ? 1 : -1));
            ExternalInterface.call("bblinfos_setAmis", userInterface.friendCount, blablaland.friendList.length);
            if ((((_arg_1.currentTarget.connected) && (_arg_1.currentTarget.informed)) && ((GlobalProperties.serverTime - _arg_1.currentTarget.lastDecoTime) > 10000))){
                _local_2 = new ChatAlertItem();
                _local_2.uid = _arg_1.currentTarget.tracker.userList[0].uid;
                _local_2.pid = _arg_1.currentTarget.tracker.userList[0].pid;
                _local_2.pseudo = _arg_1.currentTarget.tracker.userList[0].pseudo;
                _local_2.type = 1;
                addAlert(_local_2);
                _local_3 = "";
                _local_3 = (_local_3 + "<span class='info'>");
                _local_3 = (_local_3 + (((((((("<span class='user'><U><A HREF='event:0=" + escape(_local_2.pseudo)) + "=") + _local_2.pid) + "=") + _local_2.uid) + "'>") + _local_2.pseudo) + "</A></U> "));
                _local_3 = (_local_3 + "Vient de se connecter.");
                userInterface.addLocalMessage(_local_3);
            };
        }

        public function onFriendAdded(_arg_1:ContactEvent):*{
            var _local_2:ChatAlertItem = new ChatAlertItem();
            _local_2.uid = _arg_1.contact.uid;
            _local_2.pseudo = _arg_1.contact.pseudo;
            _local_2.type = 3;
            addAlert(_local_2);
            var _local_3:* = "";
            _local_3 = (_local_3 + "<span class='info'>");
            _local_3 = (_local_3 + (((((("<span class='user'><U><A HREF='event:0=" + escape(_local_2.pseudo)) + "=0=") + _local_2.uid) + "'>") + _local_2.pseudo) + "</A></U> "));
            _local_3 = (_local_3 + "est ajouté à ta liste d'amis.");
            userInterface.addLocalMessage(_local_3);
        }

        public function onFriendRemoved(_arg_1:ContactEvent):*{
            _arg_1.contact.removeEventListener("onStateChanged", this.onFriendStateChanged, false);
            var _local_2:ChatAlertItem = new ChatAlertItem();
            _local_2.uid = _arg_1.contact.uid;
            _local_2.pseudo = _arg_1.contact.pseudo;
            _local_2.type = 2;
            addAlert(_local_2);
            var _local_3:* = "";
            _local_3 = (_local_3 + "<span class='info'>");
            _local_3 = (_local_3 + (((((("<span class='user'><U><A HREF='event:0=" + escape(_local_2.pseudo)) + "=0=") + _local_2.uid) + "'>") + _local_2.pseudo) + "</A></U> "));
            _local_3 = (_local_3 + "Ne fait plus partie de ta liste d'amis");
            userInterface.addLocalMessage(_local_3);
        }

        public function onInterfaceMessage(_arg_1:ParsedMessageEvent):*{
            var _local_3:String;
            var _local_4:uint;
            var _local_5:ChatAlertItem;
            var _local_6:String;
            var _local_7:FxLoader;
            var _local_2:SocketMessage = _arg_1.getMessage();
            if (((_arg_1.evtType == 2) && (_arg_1.evtStype == 5))){
                _local_4 = _local_2.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                _local_3 = _local_2.bitReadString();
                _local_5 = new ChatAlertItem();
                _local_5.uid = _local_4;
                _local_5.pseudo = _local_3;
                _local_5.type = 0;
                addAlert(_local_5);
                _local_6 = "";
                _local_6 = (_local_6 + "<span class='info'>");
                _local_6 = (_local_6 + (((((("<span class='user'><U><A HREF='event:0=" + escape(_local_3)) + "=") + _local_4) + "'>") + _local_3) + "</A></U> "));
                _local_6 = (_local_6 + "veut t'ajouter dans sa liste d'amis. <A HREF='event:1'><U>Cliquer ici.</U></A>");
                userInterface.addLocalMessage(_local_6);
                _arg_1.stopImmediatePropagation();
            }
            else {
                if (((_arg_1.evtType == 2) && (_arg_1.evtStype == 10))){
                    _arg_1.stopImmediatePropagation();
                }
                else {
                    if (((_arg_1.evtType == 2) && (_arg_1.evtStype == 15))){
                        _local_7 = new FxLoader();
                        _local_7.initData = {
                            "CHAT":this,
                            "GB":GlobalProperties,
                            "ACTION":1,
                            "SM":_local_2
                        };
                        _local_7.loadFx(41);
                        _arg_1.stopImmediatePropagation();
                    };
                };
            };
        }


    }
}//package chatbbl

