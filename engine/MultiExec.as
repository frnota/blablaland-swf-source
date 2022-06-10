// version 467 by nota

//engine.MultiExec

package engine{
    public class MultiExec {

        public var objectList:Array;

        public function MultiExec(){
            this.objectList = new Array();
        }

        public function forEach(_arg_1:Function):void{
            var _local_2:* = 0;
            while (_local_2 < this.objectList.length) {
                (_arg_1(this.objectList[_local_2]));
                _local_2++;
            };
        }

        public function clear():void{
            this.objectList.splice(0, this.objectList.length);
        }

        public function removeObject(_arg_1:Object, _arg_2:Boolean=false):void{
            var _local_3:* = 0;
            while (_local_3 < this.objectList.length) {
                if (this.objectList[_local_3] == _arg_1){
                    this.objectList.splice(_local_3, 1);
                    _local_3--;
                    if (_arg_2) break;
                };
                _local_3++;
            };
        }

        public function addObject(_arg_1:Object, _arg_2:Boolean=false):void{
            var _local_4:*;
            var _local_3:Boolean = true;
            if (_arg_2){
                _local_4 = 0;
                while (_local_4 < this.objectList.length) {
                    if (this.objectList[_local_4] == _arg_1){
                        _local_3 = false;
                        break;
                    };
                    _local_4++;
                };
            };
            if (_local_3){
                this.objectList.push(_arg_1);
            };
        }

        public function getIndexByObject(_arg_1:Object):int{
            var _local_2:* = 0;
            while (_local_2 < this.objectList.length) {
                if (this.objectList[_local_2] == _arg_1){
                    return (_local_2);
                };
                _local_2++;
            };
            return (-1);
        }


    }
}//package engine

