// source 467 by nota

//bbl.CameraMapControl

package bbl{
    import flash.events.Event;
    import net.SocketMessage;

    public class CameraMapControl extends CameraMapSocket {


        override public function enterFrame(_arg_1:Event):*{
            super.enterFrame(_arg_1);
            if (((((mainUser) && (blablaland)) && (currentMap)) && (!(mainUserChangingMap)))){
                if (((mainUser.position.y > (currentMap.mapHeight + 10000)) && (!(mainUser.paused)))){
                    this.teleportToRespawn();
                };
            };
        }

        public function teleportToRespawn():*{
            sendMainUserState();
            mainUser.paused = true;
            var _local_1:* = new SocketMessage();
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
            _local_1.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 10);
            blablaland.send(_local_1);
        }

        public function userDie(_arg_1:String="", _arg_2:uint=7):*{
            var _local_3:*;
            if (mainUser){
                sendMainUserState();
                _local_3 = new SocketMessage();
                _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_TYPE, 1);
                _local_3.bitWriteUnsignedInt(GlobalProperties.BIT_STYPE, 9);
                _local_3.bitWriteString(_arg_1);
                _local_3.bitWriteUnsignedInt(8, _arg_2);
                blablaland.send(_local_3);
            };
        }


    }
}//package bbl

