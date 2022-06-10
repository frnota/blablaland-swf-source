// version 467 by nota

//com.facebook.graph.Facebook

package com.facebook.graph{
    import com.facebook.graph.core.AbstractFacebook;
    import flash.utils.Dictionary;
    import com.facebook.graph.core.FacebookJSBridge;
    import flash.net.URLVariables;
    import flash.net.URLRequest;
    import com.facebook.graph.core.FacebookURLDefaults;
    import flash.net.URLRequestMethod;
    import flash.net.navigateToURL;
    import com.facebook.graph.net.FacebookRequest;
    import com.facebook.graph.data.FQLMultiQuery;
    import com.facebook.graph.utils.IResultParser;
    import com.facebook.graph.data.Batch;
    import com.facebook.graph.data.FacebookAuthResponse;
    import flash.external.ExternalInterface;
    import com.adobe.serialization.json.JSON;
    import com.adobe.serialization.json.JSONParseError;

    public class Facebook extends AbstractFacebook {

        protected static var _instance:Facebook;
        protected static var _canInit:Boolean = false;

        protected var jsCallbacks:Object;
        protected var openUICalls:Dictionary;
        protected var jsBridge:FacebookJSBridge;
        protected var applicationId:String;
        protected var _initCallback:Function;
        protected var _loginCallback:Function;
        protected var _logoutCallback:Function;

        public function Facebook(){
            if (_canInit == false){
                throw (new Error("Facebook is an singleton and cannot be instantiated."));
            };
            this.jsBridge = new FacebookJSBridge();
            this.jsCallbacks = {};
            this.openUICalls = new Dictionary();
        }

        public static function init(_arg_1:String, _arg_2:Function=null, _arg_3:Object=null, _arg_4:String=null):void{
            getInstance().protected::init(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public static function set locale(_arg_1:String):void{
            getInstance().locale = _arg_1;
        }

        public static function login(_arg_1:Function, _arg_2:Object=null):void{
            getInstance().protected::login(_arg_1, _arg_2);
        }

        public static function mobileLogin(_arg_1:String, _arg_2:String="touch", _arg_3:Array=null):void{
            var _local_4:URLVariables = new URLVariables();
            _local_4.client_id = getInstance().applicationId;
            _local_4.redirect_uri = _arg_1;
            _local_4.display = _arg_2;
            if (_arg_3 != null){
                _local_4.scope = _arg_3.join(",");
            };
            var _local_5:URLRequest = new URLRequest(FacebookURLDefaults.AUTH_URL);
            _local_5.method = URLRequestMethod.GET;
            _local_5.data = _local_4;
            navigateToURL(_local_5, "_self");
        }

        public static function mobileLogout(_arg_1:String):void{
            getInstance().authResponse = null;
            var _local_2:URLVariables = new URLVariables();
            _local_2.confirm = 1;
            _local_2.next = _arg_1;
            var _local_3:URLRequest = new URLRequest("http://m.facebook.com/logout.php");
            _local_3.method = URLRequestMethod.GET;
            _local_3.data = _local_2;
            navigateToURL(_local_3, "_self");
        }

        public static function logout(_arg_1:Function):void{
            getInstance().protected::logout(_arg_1);
        }

        public static function ui(_arg_1:String, _arg_2:Object, _arg_3:Function=null, _arg_4:String=null):void{
            getInstance().protected::ui(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public static function api(_arg_1:String, _arg_2:Function=null, _arg_3:*=null, _arg_4:String="GET"):void{
            getInstance().api(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public static function getRawResult(_arg_1:Object):Object{
            return (getInstance().getRawResult(_arg_1));
        }

        public static function hasNext(_arg_1:Object):Boolean{
            var _local_2:Object = getInstance().getRawResult(_arg_1);
            if (!_local_2.paging){
                return (false);
            };
            return (!(_local_2.paging.next == null));
        }

        public static function hasPrevious(_arg_1:Object):Boolean{
            var _local_2:Object = getInstance().getRawResult(_arg_1);
            if (!_local_2.paging){
                return (false);
            };
            return (!(_local_2.paging.previous == null));
        }

        public static function nextPage(_arg_1:Object, _arg_2:Function):FacebookRequest{
            return (getInstance().nextPage(_arg_1, _arg_2));
        }

        public static function previousPage(_arg_1:Object, _arg_2:Function):FacebookRequest{
            return (getInstance().previousPage(_arg_1, _arg_2));
        }

        public static function postData(_arg_1:String, _arg_2:Function=null, _arg_3:Object=null):void{
            api(_arg_1, _arg_2, _arg_3, URLRequestMethod.POST);
        }

        public static function uploadVideo(_arg_1:String, _arg_2:Function=null, _arg_3:*=null):void{
            getInstance().uploadVideo(_arg_1, _arg_2, _arg_3);
        }

        public static function fqlQuery(_arg_1:String, _arg_2:Function=null, _arg_3:Object=null):void{
            getInstance().fqlQuery(_arg_1, _arg_2, _arg_3);
        }

        public static function fqlMultiQuery(_arg_1:FQLMultiQuery, _arg_2:Function=null, _arg_3:IResultParser=null):void{
            getInstance().fqlMultiQuery(_arg_1, _arg_2, _arg_3);
        }

        public static function batchRequest(_arg_1:Batch, _arg_2:Function=null):void{
            getInstance().batchRequest(_arg_1, _arg_2);
        }

        public static function callRestAPI(_arg_1:String, _arg_2:Function, _arg_3:*=null, _arg_4:String="GET"):void{
            getInstance().callRestAPI(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        public static function getImageUrl(_arg_1:String, _arg_2:String=null):String{
            return (getInstance().getImageUrl(_arg_1, _arg_2));
        }

        public static function deleteObject(_arg_1:String, _arg_2:Function=null):void{
            getInstance().deleteObject(_arg_1, _arg_2);
        }

        public static function addJSEventListener(_arg_1:String, _arg_2:Function):void{
            getInstance().protected::addJSEventListener(_arg_1, _arg_2);
        }

        public static function removeJSEventListener(_arg_1:String, _arg_2:Function):void{
            getInstance().protected::removeJSEventListener(_arg_1, _arg_2);
        }

        public static function hasJSEventListener(_arg_1:String, _arg_2:Function):Boolean{
            return (getInstance().protected::hasJSEventListener(_arg_1, _arg_2));
        }

        public static function setCanvasAutoResize(_arg_1:Boolean=true, _arg_2:uint=100):void{
            getInstance().protected::setCanvasAutoResize(_arg_1, _arg_2);
        }

        public static function setCanvasSize(_arg_1:Number, _arg_2:Number):void{
            getInstance().protected::setCanvasSize(_arg_1, _arg_2);
        }

        public static function callJS(_arg_1:String, _arg_2:Object):void{
            getInstance().protected::callJS(_arg_1, _arg_2);
        }

        public static function getAuthResponse():FacebookAuthResponse{
            return (getInstance().protected::getAuthResponse());
        }

        public static function getLoginStatus():void{
            getInstance().protected::getLoginStatus();
        }

        protected static function getInstance():Facebook{
            if (_instance == null){
                _canInit = true;
                _instance = new (Facebook)();
                _canInit = false;
            };
            return (_instance);
        }


        protected function init(_arg_1:String, _arg_2:Function=null, _arg_3:Object=null, _arg_4:String=null):void{
            ExternalInterface.addCallback("handleJsEvent", this.handleJSEvent);
            ExternalInterface.addCallback("authResponseChange", this.handleAuthResponseChange);
            ExternalInterface.addCallback("logout", this.handleLogout);
            ExternalInterface.addCallback("uiResponse", this.handleUI);
            this._initCallback = _arg_2;
            this.applicationId = _arg_1;
            this.oauth2 = true;
            if (_arg_3 == null){
                _arg_3 = {};
            };
            _arg_3.appId = _arg_1;
            _arg_3.oauth = true;
            ExternalInterface.call("FBAS.init", com.adobe.serialization.json.JSON.encode(_arg_3));
            if (_arg_4 != null){
                authResponse = new FacebookAuthResponse();
                authResponse.accessToken = _arg_4;
            };
            if (_arg_3.status !== false){
                this.protected::getLoginStatus();
            }
            else {
                if (this._initCallback != null){
                    this._initCallback(authResponse, null);
                    this._initCallback = null;
                };
            };
        }

        protected function getLoginStatus():void{
            ExternalInterface.call("FBAS.getLoginStatus");
        }

        protected function callJS(_arg_1:String, _arg_2:Object):void{
            ExternalInterface.call(_arg_1, _arg_2);
        }

        protected function setCanvasSize(_arg_1:Number, _arg_2:Number):void{
            ExternalInterface.call("FBAS.setCanvasSize", _arg_1, _arg_2);
        }

        protected function setCanvasAutoResize(_arg_1:Boolean=true, _arg_2:uint=100):void{
            ExternalInterface.call("FBAS.setCanvasAutoResize", _arg_1, _arg_2);
        }

        protected function login(_arg_1:Function, _arg_2:Object=null):void{
            this._loginCallback = _arg_1;
            ExternalInterface.call("FBAS.login", com.adobe.serialization.json.JSON.encode(_arg_2));
        }

        protected function logout(_arg_1:Function):void{
            this._logoutCallback = _arg_1;
            ExternalInterface.call("FBAS.logout");
        }

        protected function getAuthResponse():FacebookAuthResponse{
            var authResponseObj:Object;
            var result:String = ExternalInterface.call("FBAS.getAuthResponse");
            try {
                authResponseObj = com.adobe.serialization.json.JSON.decode(result);
            }
            catch(e) {
                return (null);
            };
            var a:FacebookAuthResponse = new FacebookAuthResponse();
            a.fromJSON(authResponseObj);
            this.authResponse = a;
            return (authResponse);
        }

        protected function ui(_arg_1:String, _arg_2:Object, _arg_3:Function=null, _arg_4:String=null):void{
            _arg_2.method = _arg_1;
            if (_arg_3 != null){
                this.openUICalls[_arg_1] = _arg_3;
            };
            if (_arg_4){
                _arg_2.display = _arg_4;
            };
            ExternalInterface.call("FBAS.ui", com.adobe.serialization.json.JSON.encode(_arg_2));
        }

        protected function addJSEventListener(_arg_1:String, _arg_2:Function):void{
            if (this.jsCallbacks[_arg_1] == null){
                this.jsCallbacks[_arg_1] = new Dictionary();
                ExternalInterface.call("FBAS.addEventListener", _arg_1);
            };
            this.jsCallbacks[_arg_1][_arg_2] = null;
        }

        protected function removeJSEventListener(_arg_1:String, _arg_2:Function):void{
            if (this.jsCallbacks[_arg_1] == null){
                return;
            };
            delete this.jsCallbacks[_arg_1][_arg_2];
        }

        protected function hasJSEventListener(_arg_1:String, _arg_2:Function):Boolean{
            if (((this.jsCallbacks[_arg_1] == null) || (!(this.jsCallbacks[_arg_1][_arg_2] === null)))){
                return (false);
            };
            return (true);
        }

        protected function handleUI(_arg_1:String, _arg_2:String):void{
            var _local_3:Object = ((_arg_1) ? com.adobe.serialization.json.JSON.decode(_arg_1) : null);
            var _local_4:Function = this.openUICalls[_arg_2];
            if (_local_4 === null){
                delete this.openUICalls[_arg_2];
            }
            else {
                (_local_4(_local_3));
                delete this.openUICalls[_arg_2];
            };
        }

        protected function handleLogout():void{
            authResponse = null;
            if (this._logoutCallback != null){
                this._logoutCallback(true);
                this._logoutCallback = null;
            };
        }

        protected function handleJSEvent(_arg_1:String, _arg_2:String=null):void{
            var _local_3:Object;
            var _local_4:Object;
            if (this.jsCallbacks[_arg_1] != null){
                try {
                    _local_3 = com.adobe.serialization.json.JSON.decode(_arg_2);
                }
                catch(e:JSONParseError) {
                };
                for (_local_4 in this.jsCallbacks[_arg_1]) {
                    ((_local_4 as Function)(_local_3));
                    delete this.jsCallbacks[_arg_1][_local_4];
                };
            };
        }

        protected function handleAuthResponseChange(result:String):void{
            var resultObj:Object;
            var success:Boolean = true;
            if (result != null){
                try {
                    resultObj = com.adobe.serialization.json.JSON.decode(result);
                }
                catch(e:JSONParseError) {
                    success = false;
                };
            }
            else {
                success = false;
            };
            if (success){
                if (authResponse == null){
                    authResponse = new FacebookAuthResponse();
                    authResponse.fromJSON(resultObj);
                }
                else {
                    authResponse.fromJSON(resultObj);
                };
            };
            if (this._initCallback != null){
                this._initCallback(authResponse, null);
                this._initCallback = null;
            };
            if (this._loginCallback != null){
                this._loginCallback(authResponse, null);
                this._loginCallback = null;
            };
        }


    }
}//package com.facebook.graph

