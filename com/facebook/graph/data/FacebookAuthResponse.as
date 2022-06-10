// version 467 by nota

//com.facebook.graph.data.FacebookAuthResponse

package com.facebook.graph.data{
    public class FacebookAuthResponse {

        public var uid:String;
        public var expireDate:Date;
        public var accessToken:String;
        public var signedRequest:String;


        public function fromJSON(_arg_1:Object):void{
            if (_arg_1 != null){
                this.expireDate = new Date();
                this.expireDate.setTime((this.expireDate.time + (_arg_1.expiresIn * 1000)));
                this.accessToken = ((_arg_1.access_token) || (_arg_1.accessToken));
                this.signedRequest = _arg_1.signedRequest;
                this.uid = _arg_1.userID;
            };
        }

        public function toString():String{
            return (("[userId:" + this.uid) + "]");
        }


    }
}//package com.facebook.graph.data

