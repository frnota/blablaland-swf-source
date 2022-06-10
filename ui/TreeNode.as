// version 467 by nota

//ui.TreeNode

package ui{
    public class TreeNode {

        public var data:Object;
        public var childNode:Array;

        public function TreeNode(){
            this.data = new Object();
            this.childNode = new Array();
        }

        public function addChild():TreeNode{
            var _local_1:TreeNode = new TreeNode();
            this.childNode.push(_local_1);
            return (_local_1);
        }

        public function swapChild(_arg_1:TreeNode, _arg_2:Number):*{
            if (_arg_2 < 0){
                _arg_2 = 0;
            };
            if (_arg_2 >= this.childNode.length){
                _arg_2 = (this.childNode.length - 1);
            };
            var _local_3:* = 0;
            while (_local_3 < this.childNode.length) {
                if (this.childNode[_local_3] == _arg_1){
                    this.childNode.splice(_local_3, 1);
                    this.childNode.splice(_arg_2, 0, _arg_1);
                    return;
                };
                _local_3++;
            };
        }

        public function removeChild(_arg_1:TreeNode):*{
            var _local_2:* = 0;
            while (_local_2 < this.childNode.length) {
                if (this.childNode[_local_2] == _arg_1){
                    this.childNode.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function removeAllChild():*{
            this.childNode.splice(0, this.childNode.length);
        }


    }
}//package ui

