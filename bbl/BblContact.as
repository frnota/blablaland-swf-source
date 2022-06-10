// version 467 by nota

//bbl.BblContact

package bbl{
    import flash.events.Event;

    public class BblContact extends BblTracker {

        public var friendList:Array;
        public var blackList:Array;
        public var muteList:Array;


        override public function init():*{
            this.friendList = new Array();
            this.blackList = new Array();
            this.muteList = new Array();
            super.init();
        }

        public function isMuted(_arg_1:uint):Contact{
            var _local_2:uint;
            _local_2 = 0;
            while (_local_2 < this.muteList.length) {
                if (this.muteList[_local_2].uid == _arg_1){
                    return (this.muteList[_local_2]);
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.blackList.length) {
                if (this.blackList[_local_2].uid == _arg_1){
                    return (this.blackList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function getMuteByUID(_arg_1:uint):Contact{
            var _local_2:* = 0;
            while (_local_2 < this.muteList.length) {
                if (this.muteList[_local_2].uid == _arg_1){
                    return (this.muteList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function removeMute(_arg_1:uint):*{
            var _local_2:* = 0;
            while (_local_2 < this.muteList.length) {
                if (this.muteList[_local_2].uid == _arg_1){
                    this.muteList.splice(_local_2, 1);
                    break;
                };
                _local_2++;
            };
            this.dispatchEvent(new Event("onMuteListChange"));
        }

        public function addMute(_arg_1:uint, _arg_2:String):*{
            var _local_3:Contact = new Contact();
            _local_3.uid = _arg_1;
            _local_3.pseudo = _arg_2;
            this.muteList.push(_local_3);
            this.dispatchEvent(new Event("onMuteListChange"));
        }

        public function removeFriend(_arg_1:uint):*{
            var _local_2:Contact;
            var _local_4:ContactEvent;
            var _local_3:uint;
            while (_local_3 < this.friendList.length) {
                _local_2 = this.friendList[_local_3];
                if (_local_2.uid == _arg_1){
                    if (_local_2.tracker){
                        unRegisterTracker(_local_2.tracker);
                    };
                    this.friendList.splice(_local_3, 1);
                    _local_4 = new ContactEvent("onRemoveFriend");
                    _local_4.contact = _local_2;
                    dispatchEvent(_local_4);
                    return;
                };
                _local_3++;
            };
        }

        public function addFriend(_arg_1:uint, _arg_2:String):*{
            var _local_3:Contact = new Contact();
            _local_3.uid = _arg_1;
            _local_3.pseudo = _arg_2;
            _local_3.tracker = new Tracker(0, _arg_1);
            registerTracker(_local_3.tracker);
            this.friendList.push(_local_3);
        }

        public function getFriendByUID(_arg_1:uint):Contact{
            var _local_2:uint;
            while (_local_2 < this.friendList.length) {
                if (this.friendList[_local_2].uid == _arg_1){
                    return (this.friendList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function removeBlackList(_arg_1:uint):*{
            var _local_2:Contact;
            var _local_4:ContactEvent;
            var _local_3:uint;
            while (_local_3 < this.blackList.length) {
                _local_2 = this.blackList[_local_3];
                if (_local_2.uid == _arg_1){
                    this.blackList.splice(_local_3, 1);
                    _local_4 = new ContactEvent("onRemoveBlackList");
                    _local_4.contact = _local_2;
                    dispatchEvent(_local_4);
                    return;
                };
                _local_3++;
            };
        }

        public function addBlackList(_arg_1:uint, _arg_2:String):*{
            var _local_3:Contact = new Contact();
            _local_3.uid = _arg_1;
            _local_3.pseudo = _arg_2;
            this.blackList.push(_local_3);
        }

        public function getBlackListByUID(_arg_1:uint):Contact{
            var _local_2:uint;
            while (_local_2 < this.blackList.length) {
                if (this.blackList[_local_2].uid == _arg_1){
                    return (this.blackList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }


    }
}//package bbl

