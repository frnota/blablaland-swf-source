// version 467 by nota

//com.facebook.graph.net.AbstractFacebookRequest

package com.facebook.graph.net{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.net.FileReference;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import com.adobe.serialization.json.JSON;
    import com.facebook.graph.utils.PostRequest;
    import com.adobe.images.PNGEncoder;

    public class AbstractFacebookRequest {

        protected var urlLoader:URLLoader;
        protected var urlRequest:URLRequest;
        protected var _rawResult:String;
        protected var _data:Object;
        protected var _success:Boolean;
        protected var _url:String;
        protected var _requestMethod:String;
        protected var _callback:Function;

        public function AbstractFacebookRequest():void{
        }

        public function get rawResult():String{
            return (this._rawResult);
        }

        public function get success():Boolean{
            return (this._success);
        }

        public function get data():Object{
            return (this._data);
        }

        public function callURL(_arg_1:Function, _arg_2:String="", _arg_3:String=null):void{
            var _local_4:URLVariables;
            this._callback = _arg_1;
            this.urlRequest = new URLRequest(((_arg_2.length) ? _arg_2 : this._url));
            if (_arg_3){
                _local_4 = new URLVariables();
                _local_4.locale = _arg_3;
                this.urlRequest.data = _local_4;
            };
            this.loadURLLoader();
        }

        public function set successCallback(_arg_1:Function):void{
            this._callback = _arg_1;
        }

        protected function isValueFile(_arg_1:Object):Boolean{
            return ((((_arg_1 is FileReference) || (_arg_1 is Bitmap)) || (_arg_1 is BitmapData)) || (_arg_1 is ByteArray));
        }

        protected function objectToURLVariables(_arg_1:Object):URLVariables{
            var _local_3:String;
            var _local_2:URLVariables = new URLVariables();
            if (_arg_1 == null){
                return (_local_2);
            };
            for (_local_3 in _arg_1) {
                _local_2[_local_3] = _arg_1[_local_3];
            };
            return (_local_2);
        }

        public function close():void{
            if (this.urlLoader != null){
                this.urlLoader.removeEventListener(Event.COMPLETE, this.handleURLLoaderComplete);
                this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleURLLoaderIOError);
                this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleURLLoaderSecurityError);
                try {
                    this.urlLoader.close();
                }
                catch(e) {
                };
                this.urlLoader = null;
            };
        }

        protected function loadURLLoader():void{
            this.urlLoader = new URLLoader();
            this.urlLoader.addEventListener(Event.COMPLETE, this.handleURLLoaderComplete, false, 0, false);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.handleURLLoaderIOError, false, 0, true);
            this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleURLLoaderSecurityError, false, 0, true);
            this.urlLoader.load(this.urlRequest);
        }

        protected function handleURLLoaderComplete(_arg_1:Event):void{
            this.handleDataLoad(this.urlLoader.data);
        }

        protected function handleDataLoad(result:Object, dispatchCompleteEvent:Boolean=true):void{
            this._rawResult = (result as String);
            this._success = true;
            try {
                this._data = com.adobe.serialization.json.JSON.decode(this._rawResult);
            }
            catch(e) {
                _data = _rawResult;
                _success = false;
            };
            this.handleDataReady();
            if (dispatchCompleteEvent){
                this.dispatchComplete();
            };
        }

        protected function handleDataReady():void{
        }

        protected function dispatchComplete():void{
            if (this._callback != null){
                this._callback(this);
            };
            this.close();
        }

        protected function handleURLLoaderIOError(event:IOErrorEvent):void{
            this._success = false;
            this._rawResult = (event.target as URLLoader).data;
            if (this._rawResult != ""){
                try {
                    this._data = com.adobe.serialization.json.JSON.decode(this._rawResult);
                }
                catch(e) {
                    _data = {
                        "type":"Exception",
                        "message":_rawResult
                    };
                };
            }
            else {
                this._data = event;
            };
            this.dispatchComplete();
        }

        protected function handleURLLoaderSecurityError(event:SecurityErrorEvent):void{
            this._success = false;
            this._rawResult = (event.target as URLLoader).data;
            try {
                this._data = com.adobe.serialization.json.JSON.decode((event.target as URLLoader).data);
            }
            catch(e) {
                _data = event;
            };
            this.dispatchComplete();
        }

        protected function extractFileData(_arg_1:Object):Object{
            var _local_2:Object;
            var _local_3:String;
            if (_arg_1 == null){
                return (null);
            };
            if (this.isValueFile(_arg_1)){
                _local_2 = _arg_1;
            }
            else {
                if (_arg_1 != null){
                    for (_local_3 in _arg_1) {
                        if (this.isValueFile(_arg_1[_local_3])){
                            _local_2 = _arg_1[_local_3];
                            delete _arg_1[_local_3];
                            break;
                        };
                    };
                };
            };
            return (_local_2);
        }

        protected function createUploadFileRequest(_arg_1:Object, _arg_2:Object=null):PostRequest{
            var _local_4:String;
            var _local_5:ByteArray;
            var _local_3:PostRequest = new PostRequest();
            if (_arg_2){
                for (_local_4 in _arg_2) {
                    _local_3.writePostData(_local_4, _arg_2[_local_4]);
                };
            };
            if ((_arg_1 is Bitmap)){
                _arg_1 = (_arg_1 as Bitmap).bitmapData;
            };
            if ((_arg_1 is ByteArray)){
                _local_3.writeFileData(_arg_2.fileName, (_arg_1 as ByteArray), _arg_2.contentType);
            }
            else {
                if ((_arg_1 is BitmapData)){
                    _local_5 = PNGEncoder.encode((_arg_1 as BitmapData));
                    _local_3.writeFileData(_arg_2.fileName, _local_5, "image/png");
                };
            };
            _local_3.close();
            this.urlRequest.contentType = ("multipart/form-data; boundary=" + _local_3.boundary);
            return (_local_3);
        }

        public function toString():String{
            return (this.urlRequest.url + ((this.urlRequest.data == null) ? "" : ("?" + unescape(this.urlRequest.data.toString()))));
        }


    }
}//package com.facebook.graph.net

