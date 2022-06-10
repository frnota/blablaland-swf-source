// version 467 by nota

//com.facebook.graph.net.FacebookRequest

package com.facebook.graph.net{
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.events.DataEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ErrorEvent;

    public class FacebookRequest extends AbstractFacebookRequest {

        protected var fileReference:FileReference;

        public function FacebookRequest():void{
        }

        public function call(_arg_1:String, _arg_2:String="GET", _arg_3:Function=null, _arg_4:*=null):void{
            _url = _arg_1;
            _requestMethod = _arg_2;
            _callback = _arg_3;
            var _local_5:String = _arg_1;
            urlRequest = new URLRequest(_local_5);
            urlRequest.method = _requestMethod;
            if (_arg_4 == null){
                loadURLLoader();
                return;
            };
            var _local_6:Object = extractFileData(_arg_4);
            if (_local_6 == null){
                urlRequest.data = objectToURLVariables(_arg_4);
                loadURLLoader();
                return;
            };
            if ((_local_6 is FileReference)){
                urlRequest.data = objectToURLVariables(_arg_4);
                urlRequest.method = URLRequestMethod.POST;
                this.fileReference = (_local_6 as FileReference);
                this.fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.handleFileReferenceData, false, 0, true);
                this.fileReference.addEventListener(IOErrorEvent.IO_ERROR, this.handelFileReferenceError, false, 0, false);
                this.fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handelFileReferenceError, false, 0, false);
                this.fileReference.upload(urlRequest);
                return;
            };
            urlRequest.data = createUploadFileRequest(_local_6, _arg_4).getPostData();
            urlRequest.method = URLRequestMethod.POST;
            loadURLLoader();
        }

        override public function close():void{
            super.close();
            if (this.fileReference != null){
                this.fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.handleFileReferenceData);
                this.fileReference.removeEventListener(IOErrorEvent.IO_ERROR, this.handelFileReferenceError);
                this.fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handelFileReferenceError);
                try {
                    this.fileReference.cancel();
                }
                catch(e) {
                };
                this.fileReference = null;
            };
        }

        protected function handleFileReferenceData(_arg_1:DataEvent):void{
            handleDataLoad(_arg_1.data);
        }

        protected function handelFileReferenceError(_arg_1:ErrorEvent):void{
            _success = false;
            _data = _arg_1;
            dispatchComplete();
        }


    }
}//package com.facebook.graph.net

