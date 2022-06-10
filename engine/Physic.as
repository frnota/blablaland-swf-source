// version 467 by nota

//engine.Physic

package engine{
    public class Physic extends CollisionMap {

        public var cloudTile:Object;
        public var waterTile:Object;
        private var _walkSpeed:Object;
        private var _swimSpeed:Object;
        private var _jumpStrength:Object;
        private var _gravity:Object;
        private var _skinGraphicHeight:Object;
        private var _skinPhysicHeight:Object;
        private var _skinWaterGraphicHeight:Object;
        private var _skinWaterPhysicHeight:Object;

        public function Physic(){
            this.cloudTile = new Object();
            this.waterTile = new Object();
            this.walkSpeed = 1;
            this.skinPhysicHeight = 25;
            this.skinGraphicHeight = 32;
            this.skinWaterPhysicHeight = 20;
            this.skinWaterGraphicHeight = 25;
            this.swimSpeed = 1;
            this.jumpStrength = 1;
            this.gravity = 1;
        }

        public function addCloudTileColor(_arg_1:Number):*{
            this.cloudTile[String(_arg_1)] = true;
        }

        public function removeCloudTileColor(_arg_1:Number):*{
            delete this.cloudTile[String(_arg_1)];
        }

        public function addWaterTileColor(_arg_1:Number):*{
            this.waterTile[String(_arg_1)] = true;
        }

        public function removeWaterTileColor(_arg_1:Number):*{
            delete this.waterTile[String(_arg_1)];
        }

        public function get gravity():Number{
            return (this._gravity.v * 0.0011);
        }

        public function set gravity(_arg_1:Number):*{
            this._gravity = {"v":_arg_1};
        }

        public function get walkSpeed():Number{
            return (this._walkSpeed.v * 0.14);
        }

        public function set walkSpeed(_arg_1:Number):*{
            this._walkSpeed = {"v":_arg_1};
        }

        public function get skinPhysicHeight():Number{
            return (this._skinPhysicHeight.v);
        }

        public function set skinPhysicHeight(_arg_1:Number):*{
            this._skinPhysicHeight = {"v":_arg_1};
        }

        public function get skinGraphicHeight():Number{
            return (this._skinGraphicHeight.v);
        }

        public function set skinGraphicHeight(_arg_1:Number):*{
            this._skinGraphicHeight = {"v":_arg_1};
        }

        public function get skinWaterPhysicHeight():Number{
            return (this._skinWaterPhysicHeight.v);
        }

        public function set skinWaterPhysicHeight(_arg_1:Number):*{
            this._skinWaterPhysicHeight = {"v":_arg_1};
        }

        public function get skinWaterGraphicHeight():Number{
            return (this._skinWaterGraphicHeight.v);
        }

        public function set skinWaterGraphicHeight(_arg_1:Number):*{
            this._skinWaterGraphicHeight = {"v":_arg_1};
        }

        public function get swimSpeed():Number{
            return (this._swimSpeed.v * 0.14);
        }

        public function set swimSpeed(_arg_1:Number):*{
            this._swimSpeed = {"v":_arg_1};
        }

        public function get jumpStrength():Number{
            return (this._jumpStrength.v * 0.45);
        }

        public function set jumpStrength(_arg_1:Number):*{
            this._jumpStrength = {"v":_arg_1};
        }


    }
}//package engine

