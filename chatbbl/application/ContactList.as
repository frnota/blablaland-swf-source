// version 467 by nota

//chatbbl.application.ContactList

package chatbbl.application{
    import flash.display.MovieClip;
    import ui.List;
    import ui.ListTreeNode;
    import flash.events.Event;
    import bbl.GlobalProperties;
    import chatbbl.Chat;
    import chatbbl.GlobalChatProperties;
    import ui.ListGraphicEvent;
    import perso.User;
    import perso.WalkerPhysicEvent;
    import bbl.Contact;

    public class ContactList extends MovieClip {

        public var liste:List;
        public var friendNode:ListTreeNode;
        public var mapNode:ListTreeNode;
        public var muteNode:ListTreeNode;
        public var blackListNode:ListTreeNode;

        public function ContactList(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.friendNode = ListTreeNode(this.liste.node.addChild());
                this.friendNode.extended = (!(Boolean((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FFRIEND === false))));
                this.friendNode.data.TYPE = "AM";
                this.friendNode.icon = ((this.friendNode.data.TYPE + "_") + ((this.friendNode.extended) ? "folderOpen" : "folderClose"));
                this.mapNode = ListTreeNode(this.liste.node.addChild());
                this.mapNode.extended = (!(Boolean((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMAP === false))));
                this.mapNode.data.TYPE = "MA";
                this.mapNode.icon = ((this.mapNode.data.TYPE + "_") + ((this.mapNode.extended) ? "folderOpen" : "folderClose"));
                this.muteNode = ListTreeNode(this.liste.node.addChild());
                this.muteNode.extended = (!(Boolean((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMUTE === false))));
                this.muteNode.data.TYPE = "MU";
                this.muteNode.icon = ((this.muteNode.data.TYPE + "_") + ((this.muteNode.extended) ? "folderOpen" : "folderClose"));
                this.blackListNode = ListTreeNode(this.liste.node.addChild());
                this.blackListNode.extended = (!(Boolean((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FBLACK === false))));
                this.blackListNode.data.TYPE = "BL";
                this.blackListNode.icon = ((this.blackListNode.data.TYPE + "_") + ((this.blackListNode.extended) ? "folderOpen" : "folderClose"));
                this.removeEventListener(Event.ADDED, this.init, false);
                GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN = true;
                parent.height = ((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H) ? GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H : 180);
                parent.x = ((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X) ? GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X : parent.x);
                parent.y = ((GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y) ? GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y : parent.y);
                parent.width = 100;
                Object(parent).redraw();
                Object(parent).fontPanel.alpha = 0.8;
                Object(parent).areaPanel.alpha = 0.9;
                Object(parent).resizer.visible = true;
                Object(parent).addEventListener("onResized", this.onResized, false, 0, true);
                Object(parent).addEventListener("onStopDrag", this.onStopDrag, false, 0, true);
                Object(parent).addEventListener("onKill", this.onKill, false, 0, true);
                Object(parent).addEventListener("onClose", this.onClose, false, 0, true);
                this.liste.graphicLink = ListGraphicShort;
                this.liste.graphicWidth = 80;
                this.rebuildFriendList();
                this.rebuildMapList();
                this.rebuildMuteList();
                this.rebuildBlackList();
                this.updateSize();
                Chat(GlobalChatProperties.chat).blablaland.addEventListener("onFriendListChange", this.onFriendListChange, false, 0, true);
                Chat(GlobalChatProperties.chat).blablaland.addEventListener("onMuteListChange", this.onMuteListChange, false, 0, true);
                Chat(GlobalChatProperties.chat).blablaland.addEventListener("onBlackListChange", this.onBlackListChange, false, 0, true);
                Chat(GlobalChatProperties.chat).camera.addEventListener("onNewUser", this.onNewUser, false, 0, true);
                Chat(GlobalChatProperties.chat).camera.addEventListener("onLostUser", this.onLostUser, false, 0, true);
                this.liste.addEventListener("onClick", this.onListClick, false, 0, true);
                this.liste.addEventListener("onIconClick", this.onListClick, false, 0, true);
            };
        }

        public function onListClick(_arg_1:ListGraphicEvent):*{
            if (_arg_1.graphic.node.parent == this.liste.node){
                _arg_1.graphic.node.extended = (!(_arg_1.graphic.node.extended));
                _arg_1.graphic.node.icon = ((_arg_1.graphic.node.data.TYPE + "_") + ((_arg_1.graphic.node.extended) ? "folderOpen" : "folderClose"));
                this.liste.redraw();
                if (_arg_1.graphic.node == this.friendNode){
                    GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FFRIEND = _arg_1.graphic.node.extended;
                };
                if (_arg_1.graphic.node == this.mapNode){
                    GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMAP = _arg_1.graphic.node.extended;
                };
                if (_arg_1.graphic.node == this.muteNode){
                    GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FMUTE = _arg_1.graphic.node.extended;
                };
                if (_arg_1.graphic.node == this.blackListNode){
                    GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_FBLACK = _arg_1.graphic.node.extended;
                };
            }
            else {
                if (_arg_1.graphic.node.parent == this.friendNode){
                    Chat(GlobalChatProperties.chat).winPopup.open({
                        "APP":FriendDetail,
                        "ID":("friend_" + _arg_1.graphic.node.data.FRIEND.uid),
                        "TITLE":_arg_1.graphic.node.data.FRIEND.pseudo
                    }, {"FRIEND":_arg_1.graphic.node.data.FRIEND});
                }
                else {
                    if (_arg_1.graphic.node.parent == this.mapNode){
                        Chat(GlobalChatProperties.chat).clickUser(_arg_1.graphic.node.data.USER.userId, _arg_1.graphic.node.data.USER.pseudo);
                    }
                    else {
                        if (_arg_1.graphic.node.parent == this.muteNode){
                            Chat(GlobalChatProperties.chat).clickUser(_arg_1.graphic.node.data.CONTACT.uid, _arg_1.graphic.node.data.CONTACT.pseudo);
                        }
                        else {
                            if (_arg_1.graphic.node.parent == this.blackListNode){
                                Chat(GlobalChatProperties.chat).clickUser(_arg_1.graphic.node.data.CONTACT.uid, _arg_1.graphic.node.data.CONTACT.pseudo);
                            };
                        };
                    };
                };
            };
        }

        public function onBlackListChange(_arg_1:Event):*{
            this.rebuildBlackList();
            this.liste.redraw();
        }

        public function updateBlackListCount():*{
            this.blackListNode.text = (("Black list (<FONT COLOR='#000000'>" + this.blackListNode.childNode.length) + "</FONT>)");
        }

        public function rebuildBlackList():*{
            var _local_3:*;
            this.blackListNode.removeAllChild();
            var _local_1:Array = Chat(GlobalChatProperties.chat).blablaland.blackList;
            var _local_2:* = 0;
            while (_local_2 < _local_1.length) {
                _local_3 = this.blackListNode.addChild();
                _local_3.data.CONTACT = _local_1[_local_2];
                _local_3.text = _local_3.data.CONTACT.pseudo;
                _local_2++;
            };
            this.reorderBlackList();
        }

        public function reorderBlackList():*{
            this.updateBlackListCount();
        }

        public function onMuteListChange(_arg_1:Event):*{
            this.rebuildMuteList();
            this.liste.redraw();
        }

        public function updateMuteListCount():*{
            this.muteNode.text = (("Boulet (<FONT COLOR='#000000'>" + this.muteNode.childNode.length) + "</FONT>)");
        }

        public function rebuildMuteList():*{
            var _local_3:*;
            this.muteNode.removeAllChild();
            var _local_1:Array = Chat(GlobalChatProperties.chat).blablaland.muteList;
            var _local_2:* = 0;
            while (_local_2 < _local_1.length) {
                _local_3 = this.muteNode.addChild();
                _local_3.data.CONTACT = _local_1[_local_2];
                _local_3.text = _local_3.data.CONTACT.pseudo;
                _local_2++;
            };
            this.reorderMuteList();
        }

        public function reorderMuteList():*{
            this.updateMuteListCount();
        }

        public function onLostUser(_arg_1:WalkerPhysicEvent):*{
            var _local_2:*;
            if (!User(_arg_1.walker).clientControled){
                _local_2 = 0;
                while (_local_2 < this.mapNode.childNode.length) {
                    if (this.mapNode.childNode[_local_2].data.USER.userPid == User(_arg_1.walker).userPid){
                        this.mapNode.childNode.splice(_local_2, 1);
                        break;
                    };
                    _local_2++;
                };
                this.updateMapListCount();
                this.liste.redraw();
            };
        }

        public function onNewUser(_arg_1:WalkerPhysicEvent):*{
            var _local_2:*;
            if (!User(_arg_1.walker).clientControled){
                _local_2 = this.mapNode.addChild();
                _local_2.data.USER = _arg_1.walker;
                _local_2.icon = "onLine";
                _local_2.text = _local_2.data.USER.pseudo;
                this.reorderMapList();
                this.liste.redraw();
            };
        }

        public function rebuildMapList():*{
            var _local_3:*;
            this.mapNode.removeAllChild();
            var _local_1:Array = Chat(GlobalChatProperties.chat).camera.userList;
            var _local_2:* = 0;
            while (_local_2 < _local_1.length) {
                if (!User(_local_1[_local_2]).clientControled){
                    _local_3 = this.mapNode.addChild();
                    _local_3.data.USER = _local_1[_local_2];
                    _local_3.icon = "onLine";
                    _local_3.text = _local_3.data.USER.pseudo;
                };
                _local_2++;
            };
            this.reorderMapList();
        }

        public function updateMapListCount():*{
            this.mapNode.text = (("Map (<FONT COLOR='#00FF00'>" + this.mapNode.childNode.length) + "</FONT>)");
        }

        public function reorderMapList():*{
            this.mapNode.childNode.sort(function (_arg_1:Object, _arg_2:Object):*{
                if (_arg_1.data.USER.pseudo.toLowerCase() > _arg_2.data.USER.pseudo.toLowerCase()){
                    return (-1);
                };
                if (_arg_1.data.USER.pseudo.toLowerCase() < _arg_2.data.USER.pseudo.toLowerCase()){
                    return (1);
                };
                return (0);
            });
            this.updateMapListCount();
        }

        public function onFriendStateChanged(_arg_1:Event):*{
            var _local_2:Contact;
            var _local_3:* = 0;
            while (_local_3 < this.friendNode.childNode.length) {
                if (this.friendNode.childNode[_local_3].data.FRIEND == _arg_1.currentTarget){
                    this.friendNode.childNode[_local_3].icon = ((_arg_1.currentTarget.connected) ? "onLine" : "offLine");
                };
                _local_3++;
            };
            this.reorderFriendList();
            this.liste.redraw();
        }

        public function resetFriendList():*{
            var _local_1:* = 0;
            while (_local_1 < this.friendNode.childNode.length) {
                this.friendNode.childNode[_local_1].data.FRIEND.removeEventListener("onStateChanged", this.onFriendStateChanged, false);
                _local_1++;
            };
            this.friendNode.removeAllChild();
        }

        public function onFriendListChange(_arg_1:Event):*{
            this.rebuildFriendList();
            this.liste.redraw();
        }

        public function rebuildFriendList():*{
            var _local_3:*;
            this.resetFriendList();
            var _local_1:Array = Chat(GlobalChatProperties.chat).blablaland.friendList;
            var _local_2:* = 0;
            while (_local_2 < _local_1.length) {
                _local_3 = this.friendNode.addChild();
                _local_3.data.FRIEND = _local_1[_local_2];
                _local_3.data.FRIEND.addEventListener("onStateChanged", this.onFriendStateChanged, false, 0, true);
                _local_3.icon = ((_local_3.data.FRIEND.connected) ? "onLine" : "offLine");
                _local_3.text = _local_3.data.FRIEND.pseudo;
                _local_2++;
            };
            this.reorderFriendList();
        }

        public function reorderFriendList():*{
            this.friendNode.childNode.sort(function (_arg_1:Object, _arg_2:Object):*{
                if (((_arg_1.data.FRIEND.connected) && (!(_arg_2.data.FRIEND.connected)))){
                    return (-1);
                };
                if (((!(_arg_1.data.FRIEND.connected)) && (_arg_2.data.FRIEND.connected))){
                    return (1);
                };
                return (0);
            });
            var nbc:uint;
            var i:* = 0;
            while (i < this.friendNode.childNode.length) {
                if (this.friendNode.childNode[i].data.FRIEND.connected){
                    nbc++;
                };
                i++;
            };
            this.friendNode.text = (((("Amis (<FONT COLOR='#00FF00'>" + nbc) + "</FONT>)(<FONT COLOR='#FF0000'>") + (this.friendNode.childNode.length - nbc)) + "</FONT>)");
        }

        public function onClose(_arg_1:Event):*{
            GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_OPEN = false;
        }

        public function onKill(_arg_1:Event):*{
            this.resetFriendList();
            Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onFriendListChange", this.onFriendListChange, false);
            Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onMuteListChange", this.onMuteListChange, false);
            Chat(GlobalChatProperties.chat).blablaland.removeEventListener("onBlackListChange", this.onMuteListChange, false);
            if (Chat(GlobalChatProperties.chat).camera){
                Chat(GlobalChatProperties.chat).camera.removeEventListener("onNewUser", this.onNewUser, false);
                Chat(GlobalChatProperties.chat).camera.removeEventListener("onLostUser", this.onLostUser, false);
            };
        }

        public function updateSize():*{
            this.liste.size = Math.floor(((parent.height - (this.liste.y * 2)) / this.liste.graphicHeight));
            this.liste.redraw();
        }

        public function onResized(_arg_1:Event):*{
            parent.height = Math.min(parent.height, 350);
            parent.height = Math.max(parent.height, 50);
            GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_H = parent.height;
            parent.width = 100;
            this.updateSize();
        }

        public function onStopDrag(_arg_1:Event):*{
            GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_X = parent.x;
            GlobalProperties.sharedObject.data.POPUP.POP_CONTACTLIST_Y = parent.y;
        }


    }
}//package chatbbl.application

