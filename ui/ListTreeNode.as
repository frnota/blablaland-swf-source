// version 467 by nota

//ui.ListTreeNode

package ui{
    import flash.text.StyleSheet;

    public class ListTreeNode extends TreeNode {

        public var text:String;
        public var selected:Boolean;
        public var icon:String;
        public var extended:Boolean;
        public var styleSheet:StyleSheet;
        public var parent:ListTreeNode;

        public function ListTreeNode(){
            this.parent = null;
            this.selected = false;
            this.extended = false;
            this.icon = null;
            this.text = "Texte";
            this.styleSheet = null;
        }

        public function getLevel():Number{
            var _local_1:* = this.parent;
            var _local_2:* = 0;
            while (_local_1) {
                _local_1 = _local_1.parent;
                _local_2++;
            };
            return (_local_2 - 1);
        }

        public function getVisibleList():*{
            var _local_3:*;
            var _local_1:* = new Array();
            var _local_2:* = 0;
            while (_local_2 < childNode.length) {
                _local_1.push(childNode[_local_2]);
                if (childNode[_local_2].extended){
                    _local_3 = childNode[_local_2].getVisibleList();
                    _local_1 = _local_1.concat(_local_3);
                };
                _local_2++;
            };
            return (_local_1);
        }

        override public function addChild():TreeNode{
            var _local_1:* = new ListTreeNode();
            _local_1.parent = this;
            childNode.push(_local_1);
            return (_local_1);
        }

        public function getSelectedList():Array{
            var _local_1:* = new Array();
            var _local_2:* = 0;
            while (_local_2 < childNode.length) {
                if (childNode[_local_2].selected){
                    _local_1.push(childNode[_local_2]);
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function invertSelection():*{
            this.selected = (!(this.selected));
            var _local_1:* = 0;
            while (_local_1 < childNode.length) {
                childNode[_local_1].invertSelection();
                _local_1++;
            };
        }

        public function unSelectAllItem():*{
            this.selected = false;
            var _local_1:* = 0;
            while (_local_1 < childNode.length) {
                childNode[_local_1].unSelectAllItem();
                _local_1++;
            };
        }


    }
}//package ui

