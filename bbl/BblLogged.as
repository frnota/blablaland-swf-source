// version 467 by nota

//bbl.BblLogged

package bbl{
    import net.SocketMessage;
    import perso.User;
    import perso.WalkerPhysicEvent;
    import flash.events.Event;
    import map.ServerMap;
    import flash.utils.getDefinitionByName;
    import net.ParsedMessageEvent;
    import net.SocketMessageEvent;

    public class BblLogged extends BblCamera {

        public var xp:uint;
        public var uid:uint;
        public var grade:uint;
        public var identified:Boolean;

        public function BblLogged(){
            this.identified = false;
            this.uid = 0;
            this.xp = 0;
        }

        public function login(_arg_1:String):*{
            var _local_2:* = new SocketMessage();
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_2.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 2);
            _local_2.bitWriteString(_arg_1);
            send(_local_2);
        }

        override public function init():*{
            this.uid = 0;
            super.init();
        }

        public function onNewUser(_arg_1:WalkerPhysicEvent):*{
            User(_arg_1.walker).mute = Boolean(isMuted(User(_arg_1.walker).userId));
        }

        override public function removeCamera(_arg_1:CameraMapControl):*{
            _arg_1.removeEventListener("onNewUser", this.onNewUser, false);
            super.removeCamera(_arg_1);
        }

        public function userSmileyEvent(_arg_1:SocketMessage):*{
            var _local_3:uint;
            var _local_4:uint;
            var _local_2:Boolean;
            while (_arg_1.bitReadBoolean()) {
                _local_3 = _arg_1.bitReadUnsignedInt(8);
                if (_local_3 == 0){
                    _local_4 = _arg_1.bitReadUnsignedInt(GlobalProperties.BIT_SMILEY_PACK_ID);
                    smileyAllowList.push(_local_4);
                    _local_2 = true;
                };
            };
            if (_local_2){
                this.dispatchEvent(new Event("onSmileyListChange"));
            };
        }

        override public function parsedEventMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_4:ContactEvent;
            var _local_5:uint;
            var _local_6:String;
            var _local_7:Array;
            var _local_8:Object;
            var _local_9:ServerMap;
            var _local_10:User;
            var _local_11:int;
            var _local_12:Array;
            var _local_13:int;
            var _local_14:int;
            var _local_15:Object;
            var _local_16:*;
            if (((_arg_1 == 2) && (_arg_2 == 1))){
                this.uid = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID);
                pseudo = _arg_3.message.bitReadString();
                this.grade = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                this.dispatchEvent(new Event("onIdentity"));
                this.xp = _arg_3.message.bitReadUnsignedInt(32);
                this.dispatchEvent(new Event("onXPChange"));
            }
            else {
                if (((_arg_1 == 2) && (_arg_2 == 4))){
                    this.grade = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_GRADE);
                    this.dispatchEvent(new Event("onGradeChange"));
                }
                else {
                    if (((_arg_1 == 3) && (_arg_2 == 2))){
                        _local_5 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_ERROR_ID);
                        newCamera = new CameraMapControl();
                        newCamera.addEventListener("onNewUser", this.onNewUser, false, 0, true);
                        cameraList.push(newCamera);
                        newCamera.cameraId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_CAMERA_ID);
                        newCamera.blablaland = this;
                        this.dispatchEvent(new Event("onNewCamera"));
                        _local_6 = _arg_3.message.bitReadString();
                        _local_7 = _local_6.split("");
                        _local_8 = null;
                        try {
                            _local_8 = getDefinitionByName("perso.SkinManager");
                        }
                        catch(err) {
                        };
                        if (((_local_7.length > 2) && (_local_8))){
                            _local_11 = Number((("0x" + _local_7.shift()) + _local_7.shift()));
                            if (_local_11){
                                _local_12 = GlobalProperties.chatStyleSheetData[_local_11];
                                _local_13 = 0;
                                while (((_local_13 < _local_12.length) && (_local_7.length >= 2))) {
                                    _local_14 = Number((("0x" + _local_7.shift()) + _local_7.shift()));
                                    if (_local_14 < _local_8.colorList.length){
                                        _local_15 = GlobalProperties.chatStyleSheet.getStyle(GlobalProperties.chatStyleSheetData[_local_11][_local_13]);
                                        _local_15.color = ("#" + _local_8.colorList[_local_14][0].toString(16));
                                        GlobalProperties.chatStyleSheet.setStyle(GlobalProperties.chatStyleSheetData[_local_11][_local_13], _local_15);
                                    };
                                    _local_13++;
                                };
                            };
                        };
                        _local_9 = new ServerMap();
                        _local_9.serverId = serverId;
                        _local_9.id = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                        _local_9.fileId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
                        _local_10 = new User();
                        if (this.uid){
                            _local_10.pseudo = pseudo;
                        }
                        else {
                            _local_10.pseudo = ("touriste_" + pid);
                        };
                        _local_10.clientControled = true;
                        _local_10.userId = this.uid;
                        _local_10.userPid = pid;
                        newCamera.mainUser = _local_10;
                        this.userSmileyEvent(_arg_3.message);
                        while (_arg_3.message.bitReadBoolean()) {
                            addFriend(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID), _arg_3.message.bitReadString());
                        };
                        this.dispatchEvent(new Event("onFriendListChange"));
                        while (_arg_3.message.bitReadBoolean()) {
                            addBlackList(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID), _arg_3.message.bitReadString());
                        };
                        this.dispatchEvent(new Event("onBlackListChange"));
                        userObjectEvent(_arg_3.message);
                        newCamera.gotoMap(_local_9);
                    }
                    else {
                        if (((_arg_1 == 2) && (_arg_2 == 6))){
                            addBlackList(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID), _arg_3.message.bitReadString());
                            _local_4 = new ContactEvent("onBlackListAdded");
                            _local_4.contact = blackList[(friendList.length - 1)];
                            dispatchEvent(_local_4);
                            dispatchEvent(new Event("onBlackListChange"));
                        }
                        else {
                            if (((_arg_1 == 2) && (_arg_2 == 7))){
                                addFriend(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID), _arg_3.message.bitReadString());
                                _local_4 = new ContactEvent("onFriendAdded");
                                _local_4.contact = friendList[(friendList.length - 1)];
                                dispatchEvent(_local_4);
                                this.dispatchEvent(new Event("onFriendListChange"));
                            }
                            else {
                                if (((_arg_1 == 2) && (_arg_2 == 8))){
                                    removeFriend(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
                                    this.dispatchEvent(new Event("onFriendListChange"));
                                }
                                else {
                                    if (((_arg_1 == 2) && (_arg_2 == 9))){
                                        removeBlackList(_arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_USER_ID));
                                        this.dispatchEvent(new Event("onBlackListChange"));
                                    }
                                    else {
                                        if (((_arg_1 == 2) && (_arg_2 == 11))){
                                            this.xp = _arg_3.message.bitReadUnsignedInt(32);
                                            this.dispatchEvent(new Event("onXPChange"));
                                        }
                                        else {
                                            if (((_arg_1 == 2) && (_arg_2 == 12))){
                                                userObjectEvent(_arg_3.message);
                                            }
                                            else {
                                                if (((_arg_1 == 2) && (_arg_2 == 13))){
                                                    this.dispatchEvent(new Event("onReloadBBL"));
                                                }
                                                else {
                                                    if (((_arg_1 == 2) && (_arg_2 == 14))){
                                                        this.userSmileyEvent(_arg_3.message);
                                                    }
                                                    else {
                                                        _local_16 = new ParsedMessageEvent("onParsedMessage");
                                                        _local_16._message = _arg_3.message;
                                                        _local_16.evtType = _arg_1;
                                                        _local_16.evtStype = _arg_2;
                                                        this.dispatchEvent(_local_16);
                                                        super.parsedEventMessage(_arg_1, _arg_2, _arg_3);
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
        }


    }
}//package bbl

