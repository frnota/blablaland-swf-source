// version 467 by nota

//perso.UserSelector

package perso{
    import flash.display.MovieClip;
    import ui.List;
    import flash.events.Event;
    import bbl.CameraMapSocket;
    import ui.ListTreeNode;
    import ui.ListGraphicEvent;
    import bbl.GlobalProperties;

    public class UserSelector extends MovieClip {

        public var multiSelect:Boolean;
        public var userList:List;
        public var cameraList:Array;
        private var _showOnlineFriendList:Boolean;
        private var _showOfflineFriendList:Boolean;
        private var _showMapList:Boolean;
        private var _showSelf:Boolean;

        public function UserSelector(){
            this.cameraList = new Array();
            this.multiSelect = false;
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
            this._showOnlineFriendList = false;
            this._showOfflineFriendList = false;
            this._showMapList = true;
            this._showSelf = false;
            this.userList.addEventListener("onClick", this.onListClick, false, 0, true);
            this.userList.addEventListener("onIconClick", this.onListClick, false, 0, true);
            this.userList.graphicLink = ListGraphicShort;
            this.userList.graphicWidth = 80;
            this.userList.size = 10;
        }

        public function redraw():*{
            this.userList.node.childNode.sort(function (_arg_1:Object, _arg_2:Object):*{
                if (_arg_1.data.PSEUDO.toLowerCase() > _arg_2.data.PSEUDO.toLowerCase()){
                    return (-1);
                };
                if (_arg_1.data.PSEUDO.toLowerCase() < _arg_2.data.PSEUDO.toLowerCase()){
                    return (1);
                };
                return (0);
            });
            this.userList.redraw();
        }

        public function removeCamera(_arg_1:CameraMapSocket):*{
            var _local_2:* = 0;
            while (_local_2 < this.cameraList.length) {
                if (this.cameraList[_local_2] == _arg_1){
                    _arg_1.removeEventListener("onNewUser", this.onNewCameraUser, false);
                    _arg_1.removeEventListener("onLostUser", this.onLostCameraUser, false);
                    if (this._showMapList){
                        this.clearUserMapList(_arg_1);
                    };
                    return;
                };
                _local_2++;
            };
        }

        public function addCamera(_arg_1:CameraMapSocket):*{
            var _local_2:Boolean;
            var _local_3:* = 0;
            while (_local_3 < this.cameraList.length) {
                if (this.cameraList[_local_3] == _arg_1){
                    _local_2 = true;
                    break;
                };
                _local_3++;
            };
            if (!_local_2){
                _arg_1.addEventListener("onNewUser", this.onNewCameraUser, false, 0, true);
                _arg_1.addEventListener("onLostUser", this.onLostCameraUser, false, 0, true);
                if (this._showMapList){
                    this.addUserMapList(_arg_1);
                };
                this.cameraList.push(_arg_1);
            };
        }

        public function clearSelection():*{
            this.userList.node.unSelectAllItem();
        }

        public function addSelection(_arg_1:uint):*{
            var _local_2:uint;
            while (_local_2 < this.userList.node.childNode.length) {
                if (this.userList.node.childNode[_local_2].data.UID == _arg_1){
                    this.userList.node.childNode[_local_2].selected = true;
                };
                _local_2++;
            };
        }

        public function getNodeByPid(_arg_1:uint):ListTreeNode{
            var _local_2:uint;
            while (_local_2 < this.userList.node.childNode.length) {
                if (this.userList.node.childNode[_local_2].data.PID == _arg_1){
                    return (this.userList.node.childNode[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function removeNodeByPid(_arg_1:uint, _arg_2:uint):*{
            var _local_3:uint;
            while (_local_3 < this.userList.node.childNode.length) {
                if (((this.userList.node.childNode[_local_3].data.PID == _arg_1) && ((_arg_2 == 0) || (this.userList.node.childNode[_local_3].data.TYPE == _arg_2)))){
                    this.userList.node.childNode.splice(_local_3, 1);
                    return;
                };
                _local_3++;
            };
        }

        public function onListClick(_arg_1:ListGraphicEvent):*{
            if (!this.multiSelect){
                this.clearSelection();
            };
            _arg_1.graphic.node.selected = true;
            this.userList.redraw();
            var _local_2:Event = new Event("onChanged");
            parent.dispatchEvent(_local_2);
        }

        public function addUserToList(_arg_1:User, _arg_2:uint):*{
            var _local_3:* = this.userList.node.addChild();
            _local_3.data.TYPE = _arg_2;
            _local_3.data.PSEUDO = _arg_1.pseudo;
            _local_3.data.PID = _arg_1.userPid;
            _local_3.data.UID = _arg_1.userId;
            _local_3.text = _local_3.data.PSEUDO;
            if (_arg_2 == 1){
                _local_3.data.CAMERA = _arg_1.camera;
            };
        }

        public function init(_arg_1:Event):*{
            this.removeEventListener(Event.ADDED, this.init, false);
            parent.addEventListener("onKill", this.onKill, false, 0, true);
            parent.width = 100;
            parent.height = 134;
            Object(parent).redraw();
        }

        public function onKill(_arg_1:Event):*{
            while (this.cameraList.length) {
                this.removeCamera(this.cameraList.shift());
            };
            this.removeFriendEvent();
        }

        public function onNewCameraUser(_arg_1:WalkerPhysicEvent):*{
            if (((this._showMapList) && ((this._showSelf) || (!(_arg_1.walker.clientControled))))){
                this.addUserToList(User(_arg_1.walker), 1);
                this.redraw();
            };
        }

        public function onLostCameraUser(_arg_1:WalkerPhysicEvent):*{
            if (((this._showMapList) && ((this._showSelf) || (!(_arg_1.walker.clientControled))))){
                this.removeNodeByPid(User(_arg_1.walker).userPid, 1);
                this.redraw();
            };
        }

        public function clearUserMapList(_arg_1:CameraMapSocket=null):*{
            var _local_2:uint;
            while (_local_2 < this.userList.node.childNode.length) {
                if (((this.userList.node.childNode[_local_2].data.TYPE == 1) && ((!(_arg_1)) || (_arg_1 == this.userList.node.childNode[_local_2].data.CAMERA)))){
                    this.userList.node.childNode.splice(_local_2, 1);
                    _local_2--;
                };
                _local_2++;
            };
        }

        public function addUserMapList(_arg_1:CameraMapSocket=null):*{
            var _local_2:uint;
            while (_local_2 < _arg_1.userList.length) {
                if (((!(_arg_1.userList[_local_2].clientControled)) || (this._showSelf))){
                    this.addUserToList(_arg_1.userList[_local_2], 1);
                };
                _local_2++;
            };
        }

        public function addFriendEvent():*{
            GlobalProperties.mainApplication.blablaland.addEventListener("onFriendListChange", this.rebuildFriendList, false);
        }

        public function removeFriendEvent():*{
            GlobalProperties.mainApplication.blablaland.removeEventListener("onFriendListChange", this.rebuildFriendList, false);
        }

        public function resetFriendList():*{
            var _local_1:* = 0;
            while (_local_1 < this.userList.node.childNode.length) {
                if (this.userList.node.childNode[_local_1].data.FRIEND){
                    this.userList.node.childNode[_local_1].data.FRIEND.removeEventListener("onStateChanged", this.friendStateChanged, false);
                };
                _local_1++;
            };
            this.userList.node.removeAllChild();
            this.userList.redraw();
        }

        public function friendStateChanged(_arg_1:Event):*{
            this.rebuildFriendList();
        }

        public function rebuildFriendList(_arg_1:Event=null):*{
            var _local_4:*;
            this.resetFriendList();
            var _local_2:Array = GlobalProperties.mainApplication.blablaland.friendList;
            var _local_3:* = 0;
            while (_local_3 < _local_2.length) {
                _local_2[_local_3].addEventListener("onStateChanged", this.friendStateChanged, false, 0, true);
                if ((((_local_2[_local_3].connected) && (this._showOnlineFriendList)) || ((!(_local_2[_local_3].connected)) && (this._showOfflineFriendList)))){
                    _local_4 = this.userList.node.addChild();
                    _local_4.data.FRIEND = _local_2[_local_3];
                    _local_4.data.TYPE = 2;
                    _local_4.data.PSEUDO = _local_2[_local_3].pseudo;
                    _local_4.data.UID = _local_2[_local_3].uid;
                    _local_4.icon = ((_local_2[_local_3].connected) ? "onLine" : "offLine");
                    _local_4.text = _local_4.data.PSEUDO;
                };
                _local_3++;
            };
            this.userList.redraw();
        }

        public function get showOnlineFriendList():Boolean{
            return (this._showOnlineFriendList);
        }

        public function set showOnlineFriendList(_arg_1:Boolean):*{
            this._showOnlineFriendList = _arg_1;
            if (((this._showOnlineFriendList) || (this.showOfflineFriendList))){
                this.rebuildFriendList();
                this.addFriendEvent();
            }
            else {
                this.resetFriendList();
                this.removeFriendEvent();
            };
        }

        public function get showOfflineFriendList():Boolean{
            return (this._showOfflineFriendList);
        }

        public function set showOfflineFriendList(_arg_1:Boolean):*{
            this._showOfflineFriendList = _arg_1;
            if (((this._showOnlineFriendList) || (this.showOfflineFriendList))){
                this.rebuildFriendList();
                this.addFriendEvent();
            }
            else {
                this.resetFriendList();
                this.removeFriendEvent();
            };
        }

        public function get showSelf():Boolean{
            return (this._showSelf);
        }

        public function set showSelf(_arg_1:Boolean):*{
            var _local_2:uint;
            var _local_3:uint;
            this._showSelf = _arg_1;
            _local_2 = 0;
            while (_local_2 < this.cameraList.length) {
                _local_3 = 0;
                while (_local_3 < this.cameraList[_local_2].userList.length) {
                    if (this.cameraList[_local_2].userList[_local_3].clientControled){
                        if (_arg_1){
                            this.addUserToList(this.cameraList[_local_2].userList[_local_3], 1);
                        }
                        else {
                            this.removeNodeByPid(this.cameraList[_local_2].userList[_local_3].userPid, 1);
                        };
                    };
                    _local_3++;
                };
                _local_2++;
            };
        }

        public function get showMapList():Boolean{
            return (this._showMapList);
        }

        public function set showMapList(_arg_1:Boolean):*{
            var _local_2:uint;
            this._showMapList = _arg_1;
            if (_arg_1){
                _local_2 = 0;
                while (_local_2 < this.cameraList.length) {
                    this.addUserMapList(this.cameraList[_local_2]);
                    _local_2++;
                };
            }
            else {
                this.clearUserMapList();
            };
        }


    }
}//package perso

