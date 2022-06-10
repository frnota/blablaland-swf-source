// version 467 by nota

//ui.DragDrop

package ui{
    import flash.events.Event;

    public class DragDrop {

        public var itemList:Array;
        public var targetList:Array;
        public var dragger:DragDropItem;

        public function DragDrop(){
            this.itemList = new Array();
            this.targetList = new Array();
            this.dragger = null;
        }

        public function addItem():DragDropItem{
            this.checkWeakedItem();
            var _local_1:DragDropItem = new DragDropItem();
            this.itemList.push(_local_1);
            _local_1.system = this;
            return (_local_1);
        }

        public function removeItem(_arg_1:DragDropItem):*{
            var _local_2:uint;
            while (_local_2 < this.itemList.length) {
                if (this.itemList[_local_2] == _arg_1){
                    this.itemList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        private function checkWeakedItem():*{
            var _local_1:uint;
            while (_local_1 < this.itemList.length) {
                if (!this.itemList[_local_1].hasEventListener("onTestDrag")){
                    this.itemList[_local_1].dispose();
                    _local_1--;
                };
                _local_1++;
            };
        }

        public function testDrag(_arg_1:DragDropItem=null):Array{
            this.dragger = _arg_1;
            this.targetList.splice(0, this.targetList.length);
            var _local_2:uint;
            while (_local_2 < this.itemList.length) {
                this.itemList[_local_2].isTarget = false;
                this.itemList[_local_2].dispatchEvent(new Event("onTestDrag"));
                if (this.itemList[_local_2].isTarget){
                    this.targetList.push(this.itemList[_local_2]);
                };
                _local_2++;
            };
            return (this.targetList);
        }


    }
}//package ui

