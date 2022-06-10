// version 467 by nota

//bbl.GlobalProperties

package bbl{
    import flash.display.MovieClip;
    import flash.text.StyleSheet;
    import flash.display.Stage;
    import flash.net.SharedObject;
    import ui.Cursor;
    import engine.SyncSteperClock;
    import flash.utils.Timer;
    import map.noel.GuirlandeGlobal;
    import flash.net.LocalConnection;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import com.facebook.graph.Facebook;
    import flash.utils.getTimer;

    public class GlobalProperties {

        public static var mainApplication:MovieClip;
        public static var qualityVersion:uint = 4;
        public static var socketHost:String = null;
        public static var socketPort:Number = 12301;
        public static var keepAliveDelay:Number = ((1000 * 60) * 5);//300000
        public static var scriptAdr:String = "/scripts/";
        public static var BIT_TYPE:uint = 5;
        public static var BIT_STYPE:uint = 5;
        public static var BIT_MAP_ID:uint = 12;
        public static var BIT_MAP_FILEID:uint = 12;
        public static var BIT_MAP_REGIONID:uint = 4;
        public static var BIT_MAP_PLANETID:uint = 4;
        public static var BIT_SWF_TYPE:uint = 2;
        public static var BIT_ERROR_ID:uint = 5;
        public static var BIT_CAMERA_ID:uint = 9;
        public static var BIT_USER_ID:uint = 24;
        public static var BIT_USER_PID:uint = 24;
        public static var BIT_METHODE_ID:uint = 6;
        public static var BIT_FX_ID:uint = 6;
        public static var BIT_FX_SID:uint = 16;
        public static var BIT_FX_OID:uint = 2;
        public static var BIT_SKIN_ID:uint = 10;
        public static var BIT_TRANSPORT_ID:uint = 10;
        public static var BIT_SMILEY_ID:uint = 6;
        public static var BIT_SMILEY_PACK_ID:uint = 5;
        public static var BIT_GRADE:uint = 10;
        public static var BIT_SKIN_ACTION:uint = 3;
        public static var BIT_SERVER_ID:uint = 2;
        public static var BIT_CHANNEL_ID:uint = 16;
        public static var chatStyleSheet:StyleSheet;
        public static var chatStyleSheetData:Array;
        public static var data:Object;
        public static var stage:Stage;
        public static var sharedObject:SharedObject;
        public static var cursor:Cursor;
        public static var debugger:Object;
        public static var screenSteper:SyncSteperClock = getSteper();
        public static var FBFROMAPP:Boolean;
        public static var FBAPPID:String;
        public static var FBPERMLIST:Object = {};
        public static var FBINIT:Object = null;
        private static var _FB_QUERY_LIST:Array = new Array();
        private static var lastTime:Number = new Date().getTime();
        private static var serverTimeOffset:Number = 0;
        private static var _init:* = initGlobal();
        private static var garbageTimer:Timer;
        public static var noelFx:GuirlandeGlobal;


        private static function initGlobal():*{
            data = new Object();
            noelFx = new GuirlandeGlobal();
            garbageTimer = new Timer(10000);
            garbageTimer.reset();
            garbageTimer.start();
            garbageTimer.addEventListener("timer", garbageTimerEvt, false, 0, true);
            chatStyleSheetData = new Array();
            var _local_1:Array = new Array();
            chatStyleSheetData.push(_local_1);
            _local_1 = new Array();
            chatStyleSheetData.push(_local_1);
            _local_1.push(".user");
            _local_1.push(".message_F");
            _local_1.push(".message_M");
            _local_1.push(".message_U");
            _local_1.push(".me");
            _local_1.push(".message_mp_to");
            _local_1.push(".message_mp");
            _local_1.push(".info");
            chatStyleSheet = new StyleSheet();
            resetChatStyleSheet();
        }

        public static function resetChatStyleSheet():*{
            chatStyleSheet.clear();
            chatStyleSheet.setStyle(".dailymsgsecu", {"color":"#00B000"});
            chatStyleSheet.setStyle(".me", {
                "color":"#00B201",
                "fontStyle":"italic",
                "fontFamily":"Arial Italic"
            });
            chatStyleSheet.setStyle(".info", {"color":"#DD00FF"});
            chatStyleSheet.setStyle(".user", {"color":"#0000FF"});
            chatStyleSheet.setStyle(".user_modo", {"color":"#FF0000"});
            chatStyleSheet.setStyle(".user_modo_mp", {
                "color":"#00B000",
                "fontWeight":"bold",
                "fontFamily":"Arial Bold"
            });
            chatStyleSheet.setStyle(".message_U", {"color":"#000000"});
            chatStyleSheet.setStyle(".message_M", {"color":"#005EF0"});
            chatStyleSheet.setStyle(".message_F", {"color":"#FE5EF0"});
            chatStyleSheet.setStyle(".message_mp", {
                "color":"#8900ff",
                "fontWeight":"bold",
                "fontFamily":"Arial Bold"
            });
            chatStyleSheet.setStyle(".message_mp_to", {
                "color":"#8900ff",
                "fontWeight":"bold",
                "fontFamily":"Arial Bold"
            });
            chatStyleSheet.setStyle(".message_modo", {"color":"#FF0000"});
            chatStyleSheet.setStyle(".message_modo_mp", {
                "color":"#00B000",
                "fontWeight":"bold",
                "fontFamily":"Arial Bold"
            });
        }

        private static function garbageTimerEvt(_arg_1:Event):*{
            try {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch(e) {
            };
        }

        public static function getClassByName(_arg_1:String):Object{
            return (getDefinitionByName(_arg_1));
        }

        public static function getTimer():*{
            return (new Date().getTime() - lastTime);
        }

        public static function getSteper():SyncSteperClock{
            return (new SyncSteperClock());
        }

        public static function get serverTime():Number{
            return (new Date().getTime() - serverTimeOffset);
        }

        public static function set serverTime(_arg_1:Number):*{
            if (((((new Date().getTime() - _arg_1) < serverTimeOffset) || (serverTimeOffset == 0)) || (_arg_1 == 0))){
                serverTimeOffset = (new Date().getTime() - _arg_1);
            };
        }

        public static function htmlEncode(_arg_1:String):String{
            return (_arg_1.split("&").join("&amp;").split("<").join("&lt;"));
        }

        public static function fbRequestPermissions(_arg_1:Array, _arg_2:Function=null):*{
            fbClearQuery();
            _FB_QUERY_LIST.push({
                "action":"requestperm",
                "perms":_arg_1
            });
            _FB_QUERY_LIST.push({
                "action":"getperm",
                "handle":_arg_2
            });
            fbNextQuery();
        }

        public static function fbInit():*{
            var _local_1:Object = {
                "status":true,
                "xfbml":true,
                "version":"v2.0",
                "cookie":true
            };
            Facebook.init(FBAPPID, fbInitEvt, _local_1);
        }

        private static function fbInitEvt(_arg_1:Object, _arg_2:Object):*{
            FBINIT = true;
            if (_arg_1){
                fbGetPermissions(null);
            };
        }

        private static function fbGetPermissions(_arg_1:Function=null):*{
            fbClearQuery();
            _FB_QUERY_LIST.push({
                "action":"getperm",
                "handle":_arg_1
            });
            fbNextQuery();
        }

        private static function fbClearQuery():*{
            while ((((_FB_QUERY_LIST.length) && (_FB_QUERY_LIST[0].pending)) && (_FB_QUERY_LIST[0].pending < (flash.utils.getTimer() - 10000)))) {
                _FB_QUERY_LIST.shift();
            };
        }

        private static function fbNextQuery():*{
            if (((_FB_QUERY_LIST.length) && (!(_FB_QUERY_LIST[0].pending)))){
                _FB_QUERY_LIST[0].pending = flash.utils.getTimer();
                if (_FB_QUERY_LIST[0].action == "requestperm"){
                    Facebook.login(onFBLogHandle, {"scope":[_FB_QUERY_LIST[0].perms].join(",")});
                }
                else {
                    if (_FB_QUERY_LIST[0].action == "getperm"){
                        Facebook.api("v2.0/me/permissions", onFBSPermHandle);
                    };
                };
            };
        }

        private static function onFBSPermHandle(_arg_1:Object, _arg_2:Object):*{
            var _local_4:int;
            FBPERMLIST = {};
            var _local_3:Object = _FB_QUERY_LIST.shift();
            if (_arg_1){
                _local_4 = 0;
                while (_local_4 < _arg_1.length) {
                    FBPERMLIST[_arg_1[_local_4]["permission"]] = (_arg_1[_local_4]["status"] == "granted");
                    _local_4++;
                };
            };
            if (((_local_3) && (_local_3.handle))){
                _local_3.handle();
            };
            fbNextQuery();
        }

        private static function onFBLogHandle(_arg_1:Object, _arg_2:Object):*{
            var _local_3:Object = _FB_QUERY_LIST.shift();
            if (((_local_3) && (_local_3.handle))){
                _local_3.handle();
            };
            fbNextQuery();
        }

        public static function loadSharedData(_arg_1:String):*{
            sharedObject = SharedObject.getLocal(_arg_1);
            if (!sharedObject.data.POPUP){
                sharedObject.data.POPUP = new Object();
            };
            initQuality();
        }

        public static function initQuality():*{
            if (!sharedObject.data.QUALITY){
                sharedObject.data.QUALITY = new Object();
            };
            if (sharedObject.data.QUALITY.qualityVersion != qualityVersion){
                sharedObject.data.QUALITY.quality = null;
                sharedObject.data.QUALITY.qualityVersion = qualityVersion;
            };
            var _local_1:Quality = new Quality();
            if (!sharedObject.data.QUALITY.quality){
                sharedObject.data.QUALITY.quality = _local_1;
                _local_1.autoDetect();
            }
            else {
                _local_1.scrollMode = sharedObject.data.QUALITY.quality.scrollMode;
                _local_1.rainRateQuality = sharedObject.data.QUALITY.quality.rainRateQuality;
                _local_1.graphicQuality = sharedObject.data.QUALITY.quality.graphicQuality;
                _local_1.persoMoveQuality = sharedObject.data.QUALITY.quality.persoMoveQuality;
                _local_1.generalVolume = sharedObject.data.QUALITY.quality.generalVolume;
                _local_1.ambiantVolume = sharedObject.data.QUALITY.quality.ambiantVolume;
                _local_1.interfaceVolume = sharedObject.data.QUALITY.quality.interfaceVolume;
                _local_1.actionVolume = sharedObject.data.QUALITY.quality.actionVolume;
                sharedObject.data.QUALITY.quality = _local_1;
            };
        }


    }
}//package bbl

