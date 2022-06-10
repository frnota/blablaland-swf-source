// version 467 by nota

//bbl.BblTracker

package bbl{
    import flash.events.Event;
    import net.SocketMessageEvent;
    import perso.SkinColor;
    import net.SocketMessage;

    public class BblTracker extends BblLoader {

        public var trackerList:Array;


        override public function init():*{
            this.trackerList = new Array();
            super.init();
        }

        override public function parsedEventMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_4:BblTrackerInstance;
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:uint;
            var _local_8:uint;
            var _local_9:uint;
            var _local_10:uint;
            var _local_11:uint;
            var _local_12:uint;
            var _local_13:Boolean;
            var _local_14:Boolean;
            var _local_15:Boolean;
            var _local_16:uint;
            var _local_17:String;
            var _local_18:BblTrackerUser;
            var _local_19:String;
            var _local_20:Boolean;
            var _local_21:String;
            if (_arg_1 == 7){
                this.checkForWreakedTracker();
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = 0;
                _local_10 = 0;
                _local_11 = 0;
                _local_12 = 0;
                if (_arg_2 == 4){
                    _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                    _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                    _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                    _local_15 = _arg_3.message.bitReadBoolean();
                    _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                    if (_local_4){
                        while (_arg_3.message.bitReadBoolean()) {
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                            _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                            _local_18 = this.getUserInTracker(_local_4, _local_7, _local_12);
                            if (!_local_18){
                                _local_18 = new BblTrackerUser();
                                _local_18.pid = _local_7;
                                _local_18.serverId = _local_12;
                                _local_4.userList.push(_local_18);
                            };
                            this.readUserData(_arg_3.message, _local_18);
                        };
                        if (_local_15){
                            _local_4.mapInformed = true;
                        };
                        _local_4.informed = true;
                        _local_4.dispatchEvent(new Event("onChanged"));
                    };
                }
                else {
                    if (_arg_2 == 2){
                        _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                        _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                        _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                        _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                        if (_local_4){
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                            _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                            _local_8 = 0;
                            while (_local_8 < _local_4.userList.length) {
                                if (((_local_4.userList[_local_8].pid == _local_7) && (_local_4.userList[_local_8].serverId == _local_12))){
                                    _local_4.userList.splice(_local_8, 1);
                                    _local_8--;
                                };
                                _local_8++;
                            };
                            _local_4.dispatchEvent(new Event("onChanged"));
                        };
                    }
                    else {
                        if (_arg_2 == 3){
                            _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                            _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                            _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                            _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                            _local_14 = _arg_3.message.bitReadBoolean();
                            _local_13 = _arg_3.message.bitReadBoolean();
                            _local_16 = _arg_3.message.bitReadUnsignedInt(3);
                            _local_17 = _arg_3.message.bitReadString();
                            if (!_local_14){
                                _local_17 = this.htmlEncode(_local_17);
                            };
                            if (_local_4){
                                _local_8 = 0;
                                while (_local_8 < _local_4.userList.length) {
                                    if (((_local_4.userList[_local_8].pid == _local_7) && (_local_4.userList[_local_8].serverId == _local_12))){
                                        _local_18 = _local_4.userList[_local_8];
                                        _local_19 = ((_local_13) ? "" : ((_local_16 == 0) ? "_U" : ((_local_16 == 1) ? "_M" : "_F")));
                                        _local_18.addMessage(((((("--&gt; <span class='message" + _local_19) + ((_local_13) ? "_modo" : "")) + "'>") + _local_17) + "</span>"));
                                    };
                                    _local_8++;
                                };
                                _local_4.dispatchEvent(new Event("onMessage"));
                            };
                        }
                        else {
                            if (_arg_2 == 5){
                                _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                                _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                                _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                                _local_14 = _arg_3.message.bitReadBoolean();
                                _local_13 = _arg_3.message.bitReadBoolean();
                                _local_20 = _arg_3.message.bitReadBoolean();
                                _local_21 = this.htmlEncode(_arg_3.message.bitReadString());
                                _local_17 = _arg_3.message.bitReadString();
                                if (!_local_14){
                                    _local_17 = this.htmlEncode(_local_17);
                                };
                                if (_local_4){
                                    _local_8 = 0;
                                    while (_local_8 < _local_4.userList.length) {
                                        if (((_local_4.userList[_local_8].pid == _local_7) && (_local_4.userList[_local_8].serverId == _local_12))){
                                            _local_18 = _local_4.userList[_local_8];
                                            _local_18.addMessage((((((((((("<span class='user" + ((_local_13) ? "_modo" : "")) + "_mp'>mp ") + ((_local_20) ? "DE" : "A")) + " ") + _local_21) + "</span> : </span><span class='message") + ((_local_13) ? "_modo" : "")) + "_mp'>") + _local_17) + "</span>"));
                                        };
                                        _local_8++;
                                    };
                                    _local_4.dispatchEvent(new Event("onMessage"));
                                };
                            }
                            else {
                                if (_arg_2 == 1){
                                    _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                                    _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                    _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                    _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                                    if (_local_4){
                                        _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                        _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                                        _local_18 = this.getUserInTracker(_local_4, _local_7, _local_12);
                                        if (!_local_18){
                                            _local_18 = new BblTrackerUser();
                                            _local_4.userList.push(_local_18);
                                        };
                                        this.readUserData(_arg_3.message, _local_18);
                                        _local_18.pid = _local_7;
                                        _local_18.serverId = _local_12;
                                        _local_4.dispatchEvent(new Event("onChanged"));
                                    };
                                }
                                else {
                                    if (_arg_2 == 6){
                                        _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                                        _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                        _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                        _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                                        if (_local_4){
                                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                            _local_12 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                                            _local_18 = this.getUserInTracker(_local_4, _local_7, _local_12);
                                            if (!_local_18){
                                                _local_18 = new BblTrackerUser();
                                                _local_18.pid = _local_7;
                                                _local_18.serverId = _local_12;
                                                this.readUserData(_arg_3.message, _local_18);
                                                _local_4.userList.push(_local_18);
                                            }
                                            else {
                                                _local_18.grade = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                                            };
                                            _local_4.dispatchEvent(new Event("onChanged"));
                                        };
                                    }
                                    else {
                                        if (_arg_2 == 7){
                                            _local_5 = _arg_3.message.bitReadUnsignedInt(32);
                                            _local_6 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                                            _local_7 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_PID);
                                            _local_4 = this.getTrackerByParams(_local_5, _local_6, _local_7);
                                            if (_local_4){
                                                _local_4.addTextEvent(this.htmlEncode(_arg_3.message.bitReadString()));
                                                _local_4.dispatchEvent(new Event("onTextEvent"));
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            }
            else {
                super.parsedEventMessage(_arg_1, _arg_2, _arg_3);
            };
        }

        private function readUserData(_arg_1:SocketMessage, _arg_2:BblTrackerUser):*{
            if (_arg_1.bitReadBoolean()){
                _arg_2.uid = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                _arg_2.ip = _arg_1.bitReadUnsignedInt(32);
                _arg_2.grade = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                _arg_2.skinId = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_SKIN_ID);
                _arg_2.pseudo = _arg_1.bitReadString();
                _arg_2.login = _arg_1.bitReadString();
                _arg_2.skinColor = new SkinColor();
                _arg_2.skinColor.readBinaryColor(_arg_1);
            };
            if (_arg_1.bitReadBoolean()){
                _arg_2.mapId = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
            };
        }

        private function htmlEncode(_arg_1:String):String{
            return (_arg_1.split("&").join("&amp;").split("<").join("&lt;"));
        }

        public function checkForWreakedTracker():*{
            var _local_1:uint;
            _local_1 = 0;
            while (_local_1 < this.trackerList.length) {
                if (!this.trackerList[_local_1].hasEventListener("onChanged")){
                    this.removeTrackerInstance(this.trackerList[_local_1]);
                    _local_1--;
                };
                _local_1++;
            };
        }

        private function removeTrackerInstance(_arg_1:BblTrackerInstance):*{
            var _local_3:*;
            var _local_2:uint;
            while (_local_2 < this.trackerList.length) {
                if (this.trackerList[_local_2] == _arg_1){
                    _local_3 = new SocketMessage();
                    _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 5);
                    _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 2);
                    _local_3.bitWriteUnsignedInt(32, _arg_1.ip);
                    _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID, _arg_1.uid);
                    _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID, _arg_1.pid);
                    send(_local_3);
                    this.trackerList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function unRegisterTracker(_arg_1:Tracker):*{
            if (_arg_1.trackerInstance){
                _arg_1.trackerInstance.nbInstance--;
                if (_arg_1.mapInform){
                    _arg_1.trackerInstance.nbMapInform--;
                };
                if (_arg_1.msgInform){
                    _arg_1.trackerInstance.nbMsgInform--;
                };
                if (_arg_1.trackerInstance.nbInstance <= 0){
                    this.removeTrackerInstance(_arg_1.trackerInstance);
                }
                else {
                    if ((((_arg_1.mapInform) && (_arg_1.trackerInstance.nbMapInform == 0)) || ((_arg_1.msgInform) && (_arg_1.trackerInstance.nbMsgInform == 0)))){
                        this.informServer(_arg_1.ip, _arg_1.uid, _arg_1.pid, (_arg_1.trackerInstance.nbMapInform > 0), (_arg_1.trackerInstance.nbMsgInform > 0));
                    };
                };
                if (_arg_1.trackerInstance.nbMapInform == 0){
                    _arg_1.trackerInstance.mapInformed = false;
                };
                _arg_1.trackerInstance = null;
            };
        }

        public function informServer(_arg_1:uint, _arg_2:uint, _arg_3:uint, _arg_4:Boolean, _arg_5:Boolean):*{
            var _local_6:* = new SocketMessage();
            _local_6.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 5);
            _local_6.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 1);
            _local_6.bitWriteUnsignedInt(32, _arg_1);
            _local_6.bitWriteUnsignedInt(GlobalProperties.BIT_USER_ID, _arg_2);
            _local_6.bitWriteUnsignedInt(GlobalProperties.BIT_USER_PID, _arg_3);
            _local_6.bitWriteBoolean(_arg_4);
            _local_6.bitWriteBoolean(_arg_5);
            send(_local_6);
        }

        public function registerTracker(_arg_1:Tracker):*{
            var _local_2:Boolean;
            var _local_3:BblTrackerInstance;
            if (!_arg_1.trackerInstance){
                _local_2 = false;
                _local_3 = this.getTrackerByParams(_arg_1.ip, _arg_1.uid, _arg_1.pid);
                if (!_local_3){
                    _local_3 = new BblTrackerInstance();
                    _local_3.ip = _arg_1.ip;
                    _local_3.uid = _arg_1.uid;
                    _local_3.pid = _arg_1.pid;
                    this.trackerList.push(_local_3);
                    _local_2 = true;
                };
                if ((((_local_3.nbMapInform == 0) && (_arg_1.mapInform)) || ((_local_3.nbMsgInform == 0) && (_arg_1.msgInform)))){
                    _local_2 = true;
                };
                if (_arg_1.mapInform){
                    _local_3.nbMapInform++;
                };
                if (_arg_1.msgInform){
                    _local_3.nbMsgInform++;
                };
                if (_local_2){
                    this.informServer(_arg_1.ip, _arg_1.uid, _arg_1.pid, _arg_1.mapInform, _arg_1.msgInform);
                };
                _arg_1.trackerInstance = _local_3;
                _local_3.nbInstance++;
                if (((_local_3.informed) && ((!(_arg_1.mapInform)) || (_local_3.mapInformed)))){
                    _arg_1.dispatchEvent(new Event("onChanged"));
                };
                this.checkForWreakedTracker();
            };
        }

        public function getUserInTracker(_arg_1:BblTrackerInstance, _arg_2:uint, _arg_3:uint):BblTrackerUser{
            var _local_4:uint;
            while (_local_4 < _arg_1.userList.length) {
                if (((_arg_1.userList[_local_4].pid == _arg_2) && (_arg_1.userList[_local_4].serverId == _arg_3))){
                    return (_arg_1.userList[_local_4]);
                };
                _local_4++;
            };
            return (null);
        }

        public function getTrackerByParams(_arg_1:uint, _arg_2:uint, _arg_3:uint):BblTrackerInstance{
            var _local_4:uint;
            _local_4 = 0;
            while (_local_4 < this.trackerList.length) {
                if ((((this.trackerList[_local_4].ip == _arg_1) && (this.trackerList[_local_4].uid == _arg_2)) && (this.trackerList[_local_4].pid == _arg_3))){
                    return (this.trackerList[_local_4]);
                };
                _local_4++;
            };
            return (null);
        }


    }
}//package bbl

