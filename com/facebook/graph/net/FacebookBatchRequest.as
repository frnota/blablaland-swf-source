// version 467 by nota

//com.facebook.graph.net.FacebookBatchRequest

package com.facebook.graph.net{
    import com.facebook.graph.data.Batch;
    import com.facebook.graph.data.BatchItem;
    import flash.net.URLVariables;
    import flash.net.URLRequest;
    import com.facebook.graph.core.FacebookURLDefaults;
    import flash.net.URLRequestMethod;
    import com.adobe.serialization.json.JSON;
    import flash.utils.ByteArray;
    import com.facebook.graph.utils.PostRequest;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.adobe.images.PNGEncoder;

    public class FacebookBatchRequest extends AbstractFacebookRequest {

        protected var _params:Object;
        protected var _relativeURL:String;
        protected var _fileData:Object;
        protected var _accessToken:String;
        protected var _batch:Batch;

        public function FacebookBatchRequest(_arg_1:Batch, _arg_2:Function=null){
            this._batch = _arg_1;
            _callback = _arg_2;
        }

        public function call(_arg_1:String):void{
            var _local_8:BatchItem;
            var _local_9:Object;
            var _local_10:Object;
            var _local_11:String;
            var _local_12:URLVariables;
            this._accessToken = _arg_1;
            urlRequest = new URLRequest(FacebookURLDefaults.GRAPH_URL);
            urlRequest.method = URLRequestMethod.POST;
            var _local_2:Array = [];
            var _local_3:Array = [];
            var _local_4:Boolean;
            var _local_5:Array = this._batch.requests;
            var _local_6:uint = _local_5.length;
            var _local_7:uint;
            while (_local_7 < _local_6) {
                _local_8 = _local_5[_local_7];
                _local_9 = this.extractFileData(_local_8.params);
                _local_10 = {
                    "method":_local_8.requestMethod,
                    "relative_url":_local_8.relativeURL
                };
                if (_local_8.params){
                    if (_local_8.params["contentType"] != undefined){
                        _local_10.contentType = _local_8.params["contentType"];
                    };
                    _local_11 = this.objectToURLVariables(_local_8.params).toString();
                    if (((_local_8.requestMethod == URLRequestMethod.GET) || (_local_8.requestMethod.toUpperCase() == "DELETE"))){
                        _local_10.relative_url = (_local_10.relative_url + ("?" + _local_11));
                    }
                    else {
                        _local_10.body = _local_11;
                    };
                };
                _local_2.push(_local_10);
                if (_local_9){
                    _local_3.push(_local_9);
                    _local_10.attached_files = ((_local_8.params.fileName == null) ? ("file" + _local_7) : _local_8.params.fileName);
                    _local_4 = true;
                }
                else {
                    _local_3.push(null);
                };
                _local_7++;
            };
            if (!_local_4){
                _local_12 = new URLVariables();
                _local_12.access_token = _arg_1;
                _local_12.batch = com.adobe.serialization.json.JSON.encode(_local_2);
                urlRequest.data = _local_12;
                loadURLLoader();
            }
            else {
                this.sendPostRequest(_local_2, _local_3);
            };
        }

        protected function sendPostRequest(_arg_1:Array, _arg_2:Array):void{
            var _local_6:Object;
            var _local_7:Object;
            var _local_8:ByteArray;
            var _local_3:PostRequest = new PostRequest();
            _local_3.writePostData("access_token", this._accessToken);
            _local_3.writePostData("batch", com.adobe.serialization.json.JSON.encode(_arg_1));
            var _local_4:uint = _arg_1.length;
            var _local_5:uint;
            while (_local_5 < _local_4) {
                _local_6 = _arg_1[_local_5];
                _local_7 = _arg_2[_local_5];
                if (_local_7){
                    if ((_local_7 is Bitmap)){
                        _local_7 = (_local_7 as Bitmap).bitmapData;
                    };
                    if ((_local_7 is ByteArray)){
                        _local_3.writeFileData(_local_6.attached_files, (_local_7 as ByteArray), _local_6.contentType);
                    }
                    else {
                        if ((_local_7 is BitmapData)){
                            _local_8 = PNGEncoder.encode((_local_7 as BitmapData));
                            _local_3.writeFileData(_local_6.attached_files, _local_8, "image/png");
                        };
                    };
                };
                _local_5++;
            };
            _local_3.close();
            urlRequest.contentType = ("multipart/form-data; boundary=" + _local_3.boundary);
            urlRequest.data = _local_3.getPostData();
            loadURLLoader();
        }

        override protected function handleDataReady():void{
            var _local_4:Object;
            var _local_1:Array = (_data as Array);
            var _local_2:uint = _local_1.length;
            var _local_3:uint;
            while (_local_3 < _local_2) {
                _local_4 = com.adobe.serialization.json.JSON.decode(_data[_local_3].body);
                _data[_local_3].body = _local_4;
                if ((this._batch.requests[_local_3] as BatchItem).callback != null){
                    (this._batch.requests[_local_3] as BatchItem).callback(_data[_local_3]);
                };
                _local_3++;
            };
        }


    }
}//package com.facebook.graph.net

