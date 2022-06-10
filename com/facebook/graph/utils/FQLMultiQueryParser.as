// version 467 by nota

//com.facebook.graph.utils.FQLMultiQueryParser

package com.facebook.graph.utils{
    public class FQLMultiQueryParser implements IResultParser {


        public function parse(_arg_1:Object):Object{
            var _local_3:String;
            var _local_2:Object = {};
            for (_local_3 in _arg_1) {
                _local_2[_arg_1[_local_3].name] = _arg_1[_local_3].fql_result_set;
            };
            return (_local_2);
        }


    }
}//package com.facebook.graph.utils

