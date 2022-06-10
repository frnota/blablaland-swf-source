// version 467 by nota

//com.facebook.graph.data.BatchItem

package com.facebook.graph.data{
    public class BatchItem {

        public var relativeURL:String;
        public var callback:Function;
        public var params:*;
        public var requestMethod:String;

        public function BatchItem(_arg_1:String, _arg_2:Function=null, _arg_3:*=null, _arg_4:String="GET"){
            this.relativeURL = _arg_1;
            this.callback = _arg_2;
            this.params = _arg_3;
            this.requestMethod = _arg_4;
        }

    }
}//package com.facebook.graph.data

