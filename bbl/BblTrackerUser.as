// version 467 by nota

//bbl.BblTrackerUser

package bbl{
    import perso.SkinColor;

    public class BblTrackerUser {

        public var pid:uint;
        public var uid:uint;
        public var ip:uint;
        public var grade:uint;
        public var pseudo:String;
        public var login:String;
        public var mapId:uint;
        public var serverId:uint;
        public var skinId:uint;
        public var skinColor:SkinColor;
        public var msgList:Array;
        public var ptsAlert:Number;
        public var ptsAlertVisible:Boolean;

        public function BblTrackerUser(){
            this.msgList = new Array();
            this.ptsAlert = 0;
            this.ptsAlertVisible = false;
            this.skinId = 0;
            this.ip = 0;
            this.grade = 0;
            this.uid = 0;
            this.pseudo = "";
            this.login = "";
            this.pid = 0;
            this.mapId = 0;
            this.serverId = 0;
        }

        public function addMessage(_arg_1:String):*{
            this.msgList.push(_arg_1);
            if (this.msgList.length > 50){
                this.msgList.shift();
            };
        }


    }
}//package bbl

