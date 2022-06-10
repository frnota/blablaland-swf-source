// version 467 by nota

//map.LightEffectItem

package map{
    import flash.display.DisplayObject;

    public class LightEffectItem {

        public var system:LightEffect;
        public var target:DisplayObject;
        public var invertLight:Boolean;

        public function LightEffectItem(){
            this.invertLight = false;
        }

        public function redraw():*{
            if (((this.invertLight) && (this.target))){
                this.target.transform.colorTransform = this.system.lastUnColorTransform;
            }
            else {
                this.target.transform.colorTransform = this.system.lastColorTransform;
            };
        }


    }
}//package map

