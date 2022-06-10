// version 467 by nota

//com.facebook.graph.data.FQLMultiQuery

package com.facebook.graph.data{
    import com.adobe.serialization.json.JSON;

    public class FQLMultiQuery {

        public var queries:Object;

        public function FQLMultiQuery(){
            this.queries = {};
        }

        public function add(_arg_1:String, _arg_2:String, _arg_3:Object=null):void{
            var _local_4:String;
            if (this.queries.hasOwnProperty(_arg_2)){
                throw (new Error("Query name already exists, there cannot be duplicate names"));
            };
            for (_local_4 in _arg_3) {
                _arg_1 = _arg_1.replace(new RegExp((("\\{" + _local_4) + "\\}"), "g"), _arg_3[_local_4]);
            };
            this.queries[_arg_2] = _arg_1;
        }

        public function toString():String{
            return (com.adobe.serialization.json.JSON.encode(this.queries));
        }


    }
}//package com.facebook.graph.data

