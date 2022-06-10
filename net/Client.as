// version 467 by nota

//net.Client

package net{
    import bbl.GlobalProperties;
    import map.ServerMap;
    import bbl.Transport;
    import flash.events.TextEvent;
    import bbl.Server;
    import flash.utils.ByteArray;
    import flash.events.Event;

    public class Client extends SocketAdv {

        private var serverTimeCount:uint;
        private var serverTimeOffset:Number;
        private var serverTimePing:uint;
        public var pid:uint;
        public var mapList:Array;
        public var serverList:Array;
        public var serverId:uint;
        public var transportList:Array;
        private var _cacheVersion:uint;

        public function Client(){
            var _local_1:Channel;
            super();
            this._cacheVersion = 0;
            this.serverTimeOffset = 0;
            this.serverTimeCount = 0;
            this.serverTimePing = 0;
            this.mapList = new Array();
            this.serverList = new Array();
            this.transportList = new Array();
            this.pid = 0;
        }

        public function getServerTime():*{
            this.serverTimeOffset = 0;
            this.serverTimeCount = 5;
            this.getServerTimeLunch();
        }

        public function getPID():*{
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 3);
            send(_local_1);
        }

        public function getServerMapById(_arg_1:uint):ServerMap{
            var _local_2:uint;
            while (_local_2 < this.mapList.length) {
                if (this.mapList[_local_2].id == _arg_1){
                    return (this.mapList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function getTransportById(_arg_1:uint):Transport{
            var _local_2:uint;
            while (_local_2 < this.transportList.length) {
                if (this.transportList[_local_2].id == _arg_1){
                    return (this.transportList[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function getVariables():*{
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 6);
            send(_local_1);
        }

        private function getServerTimeLunch():*{
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 1);
            _local_1.bitWriteUnsignedInt(32, GlobalProperties.getTimer());
            send(_local_1);
            this.serverTimePing = new Date().getTime();
        }

        override public function eventMessage(_arg_1:SocketMessageEvent):*{
            var _local_2:uint = _arg_1.message.bitReadUnsignedInt(GlobalProperties.BIT_TYPE);
            var _local_3:uint = _arg_1.message.bitReadUnsignedInt(GlobalProperties.BIT_STYPE);
            this.parsedEventMessage(_local_2, _local_3, _arg_1);
            super.eventMessage(_arg_1);
        }

        public function parsedEventMessage(_arg_1:uint, _arg_2:uint, _arg_3:SocketMessageEvent):*{
            var _local_4:TextEvent;
            var _local_5:uint;
            var _local_6:Transport;
            var _local_7:ServerMap;
            var _local_8:uint;
            var _local_9:uint;
            var _local_10:Server;
            var _local_11:uint;
            var _local_12:String;
            var _local_13:uint;
            var _local_14:int;
            var _local_15:int;
            var _local_16:int;
            var _local_17:*;
            var _local_18:ByteArray;
            var _local_19:int;
            var _local_20:*;
            if (_arg_1 == 1){
                if (_arg_2 == 1){
                    this.serverTimeMessage(_arg_3);
                }
                else {
                    if (_arg_2 == 2){
                        _local_4 = new TextEvent("onFatalAlert");
                        _local_4.text = unescape(_arg_3.message.bitReadString());
                        this.dispatchEvent(_local_4);
                    }
                    else {
                        if (_arg_2 == 3){
                            this.pid = _arg_3.message.bitReadUnsignedInt(24);
                            this.dispatchEvent(new Event("onGetPID"));
                        }
                        else {
                            if (_arg_2 == 4){
                                this.transportList.splice(0, this.transportList.length);
                                while (_arg_3.message.bitReadBoolean()) {
                                    _local_6 = new Transport();
                                    _local_6.readBinary(_arg_3.message);
                                    this.transportList.push(_local_6);
                                };
                                this.mapList.splice(0, this.mapList.length);
                                while (_arg_3.message.bitReadBoolean()) {
                                    _local_7 = new ServerMap();
                                    _local_7.id = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_ID);
                                    _local_7.fileId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_FILEID);
                                    _local_7.nom = _arg_3.message.bitReadString();
                                    _local_7.transportId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_TRANSPORT_ID);
                                    _local_7.mapXpos = _arg_3.message.bitReadSignedInt(17);
                                    _local_7.mapYpos = _arg_3.message.bitReadSignedInt(17);
                                    _local_7.meteoId = _arg_3.message.bitReadUnsignedInt(5);
                                    _local_7.peace = _arg_3.message.bitReadUnsignedInt(2);
                                    _local_7.regionId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_REGIONID);
                                    _local_7.planetId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_MAP_PLANETID);
                                    _local_8 = 0;
                                    while (_local_8 < this.transportList.length) {
                                        _local_9 = 0;
                                        while (_local_9 < this.transportList[_local_8].mapList.length) {
                                            if (this.transportList[_local_8].mapList[_local_9].id == _local_7.id){
                                                this.transportList[_local_8].mapList[_local_9] = _local_7;
                                            };
                                            _local_9++;
                                        };
                                        _local_8++;
                                    };
                                    this.mapList.push(_local_7);
                                };
                                this.serverList.splice(0, this.serverList.length);
                                while (_arg_3.message.bitReadBoolean()) {
                                    _local_10 = new Server();
                                    _local_10.nom = _arg_3.message.bitReadString();
                                    _local_10.port = _arg_3.message.bitReadUnsignedInt(16);
                                    this.serverList.push(_local_10);
                                };
                                this.serverId = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_SERVER_ID);
                                _local_5 = _arg_3.message.bitReadUnsignedInt(8);
                                if (GlobalProperties.stage.loaderInfo.loaderURL.split("file:///").length != 2){
                                    this.cacheVersion = _local_5;
                                };
                                this.dispatchEvent(new Event("onGetVariables"));
                            }
                            else {
                                if (_arg_2 == 7){
                                    _local_11 = 0;
                                    while (_local_11 < this.serverList.length) {
                                        Server(this.serverList[_local_11]).nbCo = _arg_3.message.bitReadUnsignedInt(16);
                                        _local_11++;
                                    };
                                    dispatchEvent(new Event("onUniversCounterUpdate"));
                                }
                                else {
                                    if (_arg_2 != 8){
                                        if (_arg_2 == 12){
                                            _local_12 = _arg_3.message.bitReadString();
                                            this.dexecDynFx(_local_12);
                                        }
                                        else {
                                            if (_arg_2 == 16){
                                                _local_13 = _arg_3.message.bitReadUnsignedInt(GlobalProperties.BIT_CHANNEL_ID);
                                                Channel.dispatchMesage(_local_13, _arg_3.message);
                                            }
                                            else {
                                                if (_arg_2 == 18){
                                                    _local_14 = _arg_3.message.bitReadUnsignedInt(32);
                                                    _local_15 = _arg_3.message.bitReadUnsignedInt(32);
                                                    _local_16 = _arg_3.message.bitReadUnsignedInt(32);
                                                    _local_17 = new SocketMessage();
                                                    _local_17.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
                                                    _local_17.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 18);
                                                    _local_17.bitWriteUnsignedInt(32, _local_14);
                                                    _local_18 = GlobalProperties.stage.loaderInfo.bytes;
                                                    _local_19 = 0;
                                                    while (_local_19 < _local_16) {
                                                        _local_20 = ((_local_19 + _local_15) % (_local_18.length - 8));
                                                        _local_18.position = (_local_20 + 8);
                                                        _local_17.bitWriteUnsignedInt(8, _local_18.readUnsignedByte());
                                                        _local_19++;
                                                    };
                                                    send(_local_17);
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

        public function dexecDynFx(_arg_1:String):void{
        }

        public function serverTimeMessage(_arg_1:SocketMessageEvent):*{
            this.serverTimeCount--;
            var _local_2:Number = (_arg_1.message.bitReadUnsignedInt(32) * 1000);
            _local_2 = (_local_2 + _arg_1.message.bitReadUnsignedInt(10));
            var _local_3:uint = (new Date().getTime() - this.serverTimePing);
            _local_2 = (_local_2 - Math.round((_local_3 / 2)));
            if ((((new Date().getTime() - _local_2) < this.serverTimeOffset) || (this.serverTimeOffset == 0))){
                this.serverTimeOffset = (new Date().getTime() - _local_2);
            };
            if (this.serverTimeCount <= 0){
                GlobalProperties.serverTime = 0;
                GlobalProperties.serverTime = _local_2;
                dispatchEvent(new Event("onGetTime"));
            }
            else {
                this.getServerTimeLunch();
            };
        }

        public function set cacheVersion(_arg_1:uint):*{
            this._cacheVersion = Math.max(_arg_1, this._cacheVersion);
        }

        public function get cacheVersion():uint{
            return (this._cacheVersion);
        }


    }
}//package net

