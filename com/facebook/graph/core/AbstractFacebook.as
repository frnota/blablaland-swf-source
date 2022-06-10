// version 467 by nota

//com.facebook.graph.core.AbstractFacebook

package com.facebook.graph.core{
    import com.facebook.graph.data.FacebookSession;
    import com.facebook.graph.data.FacebookAuthResponse;
    import flash.utils.Dictionary;
    import com.facebook.graph.net.FacebookRequest;
    import com.facebook.graph.utils.IResultParser;
    import com.facebook.graph.utils.FQLMultiQueryParser;
    import com.facebook.graph.data.FQLMultiQuery;
    import com.facebook.graph.net.FacebookBatchRequest;
    import com.facebook.graph.data.Batch;
    import flash.net.URLRequestMethod;

    public class AbstractFacebook {

        protected var session:FacebookSession;
        protected var authResponse:FacebookAuthResponse;
        protected var oauth2:Boolean;
        protected var openRequests:Dictionary;
        protected var resultHash:Dictionary;
        protected var locale:String;
        protected var parserHash:Dictionary;

        public function AbstractFacebook():void{
            this.openRequests = new Dictionary();
            this.resultHash = new Dictionary(true);
            this.parserHash = new Dictionary();
        }

        protected function get accessToken():String{
            if ((((this.oauth2) && (!(this.authResponse == null))) || (!(this.session == null)))){
                return ((this.oauth2) ? this.authResponse.accessToken : this.session.accessToken);
            };
            return (null);
        }

        protected function api(_arg_1:String, _arg_2:Function=null, _arg_3:*=null, _arg_4:String="GET"):void{
            _arg_1 = ((_arg_1.indexOf("/") != 0) ? ("/" + _arg_1) : _arg_1);
            if (this.accessToken){
                if (_arg_3 == null){
                    _arg_3 = {};
                };
                if (_arg_3.access_token == null){
                    _arg_3.access_token = this.accessToken;
                };
            };
            var _local_5:FacebookRequest = new FacebookRequest();
            if (this.locale){
                _arg_3.locale = this.locale;
            };
            this.openRequests[_local_5] = _arg_2;
            _local_5.call((FacebookURLDefaults.GRAPH_URL + _arg_1), _arg_4, this.handleRequestLoad, _arg_3);
        }

        protected function uploadVideo(_arg_1:String, _arg_2:Function=null, _arg_3:*=null):void{
            _arg_1 = ((_arg_1.indexOf("/") != 0) ? ("/" + _arg_1) : _arg_1);
            if (this.accessToken){
                if (_arg_3 == null){
                    _arg_3 = {};
                };
                if (_arg_3.access_token == null){
                    _arg_3.access_token = this.accessToken;
                };
            };
            var _local_4:FacebookRequest = new FacebookRequest();
            if (this.locale){
                _arg_3.locale = this.locale;
            };
            this.openRequests[_local_4] = _arg_2;
            _local_4.call((FacebookURLDefaults.VIDEO_URL + _arg_1), "POST", this.handleRequestLoad, _arg_3);
        }

        protected function pagingCall(_arg_1:String, _arg_2:Function):FacebookRequest{
            var _local_3:FacebookRequest = new FacebookRequest();
            this.openRequests[_local_3] = _arg_2;
            _local_3.callURL(this.handleRequestLoad, _arg_1, this.locale);
            return (_local_3);
        }

        protected function getRawResult(_arg_1:Object):Object{
            return (this.resultHash[_arg_1]);
        }

        protected function nextPage(_arg_1:Object, _arg_2:Function=null):FacebookRequest{
            var _local_3:FacebookRequest;
            var _local_4:Object = this.getRawResult(_arg_1);
            if ((((_local_4) && (_local_4.paging)) && (_local_4.paging.next))){
                _local_3 = this.pagingCall(_local_4.paging.next, _arg_2);
            }
            else {
                if (_arg_2 != null){
                    (_arg_2(null, "no page"));
                };
            };
            return (_local_3);
        }

        protected function previousPage(_arg_1:Object, _arg_2:Function=null):FacebookRequest{
            var _local_3:FacebookRequest;
            var _local_4:Object = this.getRawResult(_arg_1);
            if ((((_local_4) && (_local_4.paging)) && (_local_4.paging.previous))){
                _local_3 = this.pagingCall(_local_4.paging.previous, _arg_2);
            }
            else {
                if (_arg_2 != null){
                    (_arg_2(null, "no page"));
                };
            };
            return (_local_3);
        }

        protected function handleRequestLoad(_arg_1:FacebookRequest):void{
            var _local_3:Object;
            var _local_4:IResultParser;
            var _local_2:Function = this.openRequests[_arg_1];
            if (_local_2 === null){
                delete this.openRequests[_arg_1];
            };
            if (_arg_1.success){
                _local_3 = (("data" in _arg_1.data) ? _arg_1.data.data : _arg_1.data);
                this.resultHash[_local_3] = _arg_1.data;
                if (_local_3.hasOwnProperty("error_code")){
                    (_local_2(null, _local_3));
                }
                else {
                    if ((this.parserHash[_arg_1] is IResultParser)){
                        _local_4 = (this.parserHash[_arg_1] as IResultParser);
                        _local_3 = _local_4.parse(_local_3);
                        this.parserHash[_arg_1] = null;
                        delete this.parserHash[_arg_1];
                    };
                    (_local_2(_local_3, null));
                };
            }
            else {
                (_local_2(null, _arg_1.data));
            };
            delete this.openRequests[_arg_1];
        }

        protected function callRestAPI(_arg_1:String, _arg_2:Function=null, _arg_3:*=null, _arg_4:String="GET"):void{
            var _local_6:IResultParser;
            if (_arg_3 == null){
                _arg_3 = {};
            };
            _arg_3.format = "json";
            if (this.accessToken){
                _arg_3.access_token = this.accessToken;
            };
            if (this.locale){
                _arg_3.locale = this.locale;
            };
            var _local_5:FacebookRequest = new FacebookRequest();
            this.openRequests[_local_5] = _arg_2;
            if ((this.parserHash[_arg_3["queries"]] is IResultParser)){
                _local_6 = (this.parserHash[_arg_3["queries"]] as IResultParser);
                this.parserHash[_arg_3["queries"]] = null;
                delete this.parserHash[_arg_3["queries"]];
                this.parserHash[_local_5] = _local_6;
            };
            _local_5.call(((FacebookURLDefaults.API_URL + "/method/") + _arg_1), _arg_4, this.handleRequestLoad, _arg_3);
        }

        protected function fqlQuery(_arg_1:String, _arg_2:Function=null, _arg_3:Object=null):void{
            var _local_4:String;
            for (_local_4 in _arg_3) {
                _arg_1 = _arg_1.replace(new RegExp((("\\{" + _local_4) + "\\}"), "g"), _arg_3[_local_4]);
            };
            this.callRestAPI("fql.query", _arg_2, {"query":_arg_1});
        }

        protected function fqlMultiQuery(_arg_1:FQLMultiQuery, _arg_2:Function=null, _arg_3:IResultParser=null):void{
            this.parserHash[_arg_1.toString()] = ((_arg_3 != null) ? _arg_3 : new FQLMultiQueryParser());
            this.callRestAPI("fql.multiquery", _arg_2, {"queries":_arg_1.toString()});
        }

        protected function batchRequest(_arg_1:Batch, _arg_2:Function=null):void{
            var _local_3:FacebookBatchRequest;
            if (this.accessToken){
                _local_3 = new FacebookBatchRequest(_arg_1, _arg_2);
                this.resultHash[_local_3] = true;
                _local_3.call(this.accessToken);
            };
        }

        protected function deleteObject(_arg_1:String, _arg_2:Function=null):void{
            var _local_3:Object = {"method":"delete"};
            this.api(_arg_1, _arg_2, _local_3, URLRequestMethod.POST);
        }

        protected function getImageUrl(_arg_1:String, _arg_2:String=null):String{
            return ((((FacebookURLDefaults.GRAPH_URL + "/") + _arg_1) + "/picture") + ((_arg_2 != null) ? ("?type=" + _arg_2) : ""));
        }


    }
}//package com.facebook.graph.core

