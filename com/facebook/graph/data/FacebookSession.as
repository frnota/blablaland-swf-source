// version 467 by nota

//com.facebook.graph.data.FacebookSession

package com.facebook.graph.data{
    public class FacebookSession {

        public var uid:String;
        public var user:Object;
        public var sessionKey:String;
        public var expireDate:Date;
        public var accessToken:String;
        public var secret:String;
        public var sig:String;
        public var availablePermissions:Array;


        public function fromJSON(_arg_1:Object):void{
            if (_arg_1 != null){
                this.sessionKey = _arg_1.session_key;
                this.expireDate = new Date(_arg_1.expires);
                this.accessToken = _arg_1.access_token;
                this.secret = _arg_1.secret;
                this.sig = _arg_1.sig;
                this.uid = _arg_1.uid;
            };
        }

        public function toString():String{
            return (("[userId:" + this.uid) + "]");
        }


    }
}//package com.facebook.graph.data

