// version 467 by nota

//chatbbl.application.FriendDetail

package chatbbl.application{
    import flash.display.MovieClip;
    import perso.SkinManager;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.text.TextField;
    import bbl.Tracker;
    import flash.events.Event;
    import chatbbl.Chat;
    import chatbbl.GlobalChatProperties;
    import flash.events.TextEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import map.MapSelector;

    public class FriendDetail extends MovieClip {

        public var popupMap:Object;
        public var skin:SkinManager;
        public var bt_delamis:SimpleButton;
        public var bt_profil:SimpleButton;
        public var noSkin:Sprite;
        public var txt_pseudo:TextField;
        public var txt_map:TextField;
        public var txt_uni:TextField;
        public var txt_unis:TextField;
        public var tracker:Tracker;

        public function FriendDetail(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.removeEventListener(Event.ADDED, this.init, false);
                parent.width = 230;
                parent.height = 85;
                Object(parent).redraw();
                Object(parent).addEventListener("onClose", this.onClose, false, 0, true);
                this.skin = new SkinManager();
                this.skin.x = 25;
                this.skin.y = 50;
                this.skin.addEventListener("onClickUser", this.onUserClick, false, 0, true);
                addChild(this.skin);
                this.tracker = new Tracker(0, Object(parent).data.FRIEND.tracker.uid, 0, true, false);
                this.tracker.addEventListener("onChanged", this.onFriendStateChanged, false, 0, true);
                Chat(GlobalChatProperties.chat).blablaland.registerTracker(this.tracker);
                this.bt_delamis.addEventListener("click", this.onRemoveFriend, false, 0, true);
                this.bt_profil.addEventListener("click", this.onShowProfil, false, 0, true);
                this.txt_pseudo.addEventListener(TextEvent.LINK, this.onUserClick, false, 0, true);
                this.txt_map.addEventListener(TextEvent.LINK, this.onUserClickMap, false, 0, true);
            };
        }

        public function onShowProfil(_arg_1:Event):*{
            navigateToURL(new URLRequest(("/site/membres.php?&border=0&p=" + Object(parent).data.FRIEND.uid)), "_blank");
        }

        public function onRemoveFriend(_arg_1:Event):*{
            var _local_2:Object = Chat(GlobalChatProperties.chat).msgPopup.open({
                "APP":PopupMessage,
                "TITLE":"Confirme :",
                "DEPEND":this
            }, {
                "MSG":(("Tu es sur de vouloir supprimer " + Object(parent).data.FRIEND.pseudo) + " de ta liste d'amis ?"),
                "ACTION":"YESNO",
                "FRIEND":Object(parent).data.FRIEND
            });
            _local_2.addEventListener("onEvent", this.acceptRemoveFriend, false, 0, true);
        }

        public function acceptRemoveFriend(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                Chat(GlobalChatProperties.chat).removeFriend(_arg_1.currentTarget.data.FRIEND.uid);
                Object(parent).close();
            };
        }

        public function onUserClick(_arg_1:Event):*{
            Chat(GlobalChatProperties.chat).clickUser(Object(parent).data.FRIEND.uid, Object(parent).data.FRIEND.pseudo);
        }

        public function onPopupMapClose(_arg_1:Event):*{
            this.popupMap = null;
        }

        public function onUserClickMap(_arg_1:Event):*{
            if (!this.popupMap){
                this.popupMap = Chat(GlobalChatProperties.chat).winPopup.open({
                    "APP":MapSelector,
                    "ID":("maplocator_" + Object(parent).data.FRIEND.uid),
                    "TITLE":"Localisation :",
                    "DEPEND":this
                }, {
                    "SELECTABLE":false,
                    "SERVERID":Object(parent).data.FRIEND.tracker.userList[0].serverId
                });
                this.popupMap.addEventListener("onKill", this.onPopupMapClose, false, 0, true);
                this.onFriendStateChanged();
            };
        }

        public function onFriendStateChanged(_arg_1:Event=null):*{
            var _local_4:Object;
            var _local_5:Object;
            this.skin.visible = false;
            this.txt_map.htmlText = "Non connecté";
            this.txt_uni.htmlText = "----";
            var _local_2:uint;
            if (this.popupMap){
                _local_2 = this.popupMap.content.mapList.length;
                this.popupMap.content.clearSelection();
            };
            var _local_3:String = ("<U><B><FONT COLOR='#0000FF'><A HREF='event:0'>" + Object(parent).data.FRIEND.pseudo);
            if (this.tracker){
                _local_4 = null;
                if (((this.tracker.userList.length) && (this.tracker.trackerInstance.mapInformed))){
                    _local_4 = this.tracker.userList[0];
                };
                if (_local_4){
                    this.skin.visible = true;
                    this.skin.skinColor = _local_4.skinColor;
                    this.skin.skinId = _local_4.skinId;
                    _local_5 = Chat(GlobalChatProperties.chat).blablaland.getServerMapById(_local_4.mapId);
                    _local_3 = (_local_3 + (" / " + _local_4.login));
                    if (_local_4.mapId >= 1000){
                        this.txt_map.htmlText = "[Dans une maison]";
                    }
                    else {
                        if (_local_5){
                            this.txt_map.htmlText = ((("<U><B><FONT COLOR='#0000FF'><A HREF='event:" + _local_5.id) + "'>") + _local_5.nom);
                            this.txt_map.text = _local_5.nom;
                            if (this.popupMap){
                                this.popupMap.content.addSelection(_local_5.id);
                                if (!_local_2){
                                    this.popupMap.content.centerToMap(_local_5.id);
                                };
                            };
                        };
                    };
                    this.txt_uni.htmlText = ("<B><FONT COLOR='#0000FF'>" + Chat(GlobalChatProperties.chat).blablaland.serverList[_local_4.serverId].nom);
                };
            };
            this.noSkin.visible = (!(this.skin.visible));
            this.txt_pseudo.htmlText = _local_3;
        }

        public function onClose(_arg_1:Event):*{
            if (this.tracker){
                this.tracker.removeEventListener("onChanged", this.onFriendStateChanged, false);
                Chat(GlobalChatProperties.chat).blablaland.unRegisterTracker(this.tracker);
                this.tracker = null;
            };
            Object(parent).data.FRIEND.removeEventListener("onStateChanged", this.onFriendStateChanged, false);
        }


    }
}//package chatbbl.application

