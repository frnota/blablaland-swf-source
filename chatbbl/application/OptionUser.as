// version 467 by nota

//chatbbl.application.OptionUser

package chatbbl.application{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import chatbbl.Chat;
    import chatbbl.GlobalChatProperties;

    public class OptionUser extends MovieClip {

        public var bt_amis:SimpleButton;
        public var bt_boulet:SimpleButton;
        public var bt_profil:SimpleButton;

        public function OptionUser(){
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                this.removeEventListener(Event.ADDED, this.init, false);
                parent.width = 200;
                parent.height = 70;
                Object(parent).redraw();
                parent.addEventListener("onKill", this.onKill, false, 0, true);
                this.bt_amis.addEventListener("click", this.btAmisEvt, false, 0, true);
                this.bt_boulet.addEventListener("click", this.btBouletEvt, false, 0, true);
                this.bt_profil.addEventListener("click", this.onShowProfil, false, 0, true);
            };
        }

        public function onShowProfil(_arg_1:Event):*{
            navigateToURL(new URLRequest(("/site/membres.php?p=" + Object(parent).data.UID)), "_blank");
        }

        public function onRemoveMuteEvt(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                Chat(GlobalChatProperties.chat).removeMute(Object(parent).data.UID);
            };
        }

        public function onRemoveBlackListEvt(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                Chat(GlobalChatProperties.chat).removeBlackList(Object(parent).data.UID);
            };
        }

        public function onAddMuteEvt(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RESA){
                Chat(GlobalChatProperties.chat).addMute(Object(parent).data.UID, Object(parent).data.PSEUDO);
            }
            else {
                if (_arg_1.currentTarget.data.RESB){
                    Chat(GlobalChatProperties.chat).addBlackList(Object(parent).data.UID);
                };
            };
        }

        public function btBouletEvt(_arg_1:Event):*{
            var _local_2:Object;
            if (Chat(GlobalChatProperties.chat).blablaland.getMuteByUID(Object(parent).data.UID)){
                _local_2 = Chat(GlobalChatProperties.chat).msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Confirme :",
                    "DEPEND":this
                }, {
                    "MSG":(("Ne plus considerer " + Object(parent).data.PSEUDO) + " comme un boulet ?"),
                    "ACTION":"YESNO"
                });
                _local_2.addEventListener("onEvent", this.onRemoveMuteEvt, false, 0, true);
            }
            else {
                if (Chat(GlobalChatProperties.chat).blablaland.getBlackListByUID(Object(parent).data.UID)){
                    _local_2 = Chat(GlobalChatProperties.chat).msgPopup.open({
                        "APP":PopupMessage,
                        "TITLE":"Confirme :",
                        "DEPEND":this
                    }, {
                        "MSG":(("Retirer " + Object(parent).data.PSEUDO) + " de sa black liste ?"),
                        "ACTION":"YESNO"
                    });
                    _local_2.addEventListener("onEvent", this.onRemoveBlackListEvt, false, 0, true);
                }
                else {
                    _local_2 = Chat(GlobalChatProperties.chat).msgPopup.open({
                        "APP":PopupMessage,
                        "TITLE":"Confirme :",
                        "DEPEND":this
                    }, {
                        "MSG":(("Considerer " + Object(parent).data.PSEUDO) + " comme un boulet ?"),
                        "VALA":"Juste un boulet",
                        "VALB":"Pour toujours dans ma black list",
                        "ACTION":"2OPTOKCANCEL"
                    });
                    _local_2.addEventListener("onEvent", this.onAddMuteEvt, false, 0, true);
                };
            };
        }

        public function btAmisEvt(_arg_1:Event):*{
            var _local_2:Object;
            if (Chat(GlobalChatProperties.chat).blablaland.getFriendByUID(Object(parent).data.UID)){
                _local_2 = Chat(GlobalChatProperties.chat).msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Confirme :",
                    "DEPEND":this
                }, {
                    "MSG":(("Tu es sur de vouloir retirer " + Object(parent).data.PSEUDO) + " de ta liste d'amis ?"),
                    "ACTION":"YESNO"
                });
                _local_2.addEventListener("onEvent", this.onRemoveAmisEvt, false, 0, true);
            }
            else {
                _local_2 = Chat(GlobalChatProperties.chat).msgPopup.open({
                    "APP":PopupMessage,
                    "TITLE":"Confirme :",
                    "DEPEND":this
                }, {
                    "MSG":(("Tu es sur de vouloir demander à " + Object(parent).data.PSEUDO) + " d'etre dans ta liste d'amis ?"),
                    "ACTION":"YESNO"
                });
                _local_2.addEventListener("onEvent", this.onAddAmisEvt, false, 0, true);
            };
        }

        public function onRemoveAmisEvt(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                Chat(GlobalChatProperties.chat).removeFriend(Object(parent).data.UID);
            };
        }

        public function onAddAmisEvt(_arg_1:Event):*{
            if (_arg_1.currentTarget.data.RES){
                Chat(GlobalChatProperties.chat).addFriend(Object(parent).data.UID);
            };
        }

        public function onKill(_arg_1:Event):*{
        }


    }
}//package chatbbl.application

