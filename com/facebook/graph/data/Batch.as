// version 467 by nota

//com.facebook.graph.data.Batch

package com.facebook.graph.data{
    import com.facebook.graph.core.FacebookLimits;

    public class Batch {

        protected var _requests:Array;

        public function Batch(){
            this._requests = [];
        }

        public function get requests():Array{
            return (this._requests);
        }

        public function add(_arg_1:String, _arg_2:Function=null, _arg_3:*=null, _arg_4:String="GET"):void{
            if (this._requests.length == FacebookLimits.BATCH_REQUESTS){
                throw (new Error((("Facebook limits you to " + FacebookLimits.BATCH_REQUESTS) + " requests in a single batch.")));
            };
            this._requests.push(new BatchItem(_arg_1, _arg_2, _arg_3, _arg_4));
        }


    }
}//package com.facebook.graph.data

