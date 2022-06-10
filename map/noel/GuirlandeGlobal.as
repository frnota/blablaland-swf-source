// version 467 by nota

//map.noel.GuirlandeGlobal

package map.noel{
    import flash.utils.Timer;
    import flash.media.SoundChannel;
    import fx.FxLoader;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.display.MovieClip;

    public class GuirlandeGlobal {

        public var itemList:Array;
        public var GB:Object;
        public var noelLight:Boolean;
        public var decoVisible:Boolean;
        public var _camera:Object;
        private var noelFxMng:Object;
        private var timer:Timer;
        private var noelSndChannel:SoundChannel;
        private var lastDate:Number;
        private var noelIlluDate:Number;
        private var nouvelAnDate:Number;
        private var endRepeat:Number;

        public function GuirlandeGlobal(){
            this.noelIlluDate = 1418499000000;
            this.nouvelAnDate = 1420066800000;
            this.endRepeat = (this.nouvelAnDate - ((24 * 3600) * 1000));
            this.itemList = new Array();
            this.noelLight = false;
            this.decoVisible = false;
        }

        public function onFxLoaded(_arg_1:Event):*{
            if (!this.noelFxMng){
                this.noelFxMng = new FxLoader().lastLoad.classRef();
                FxLoader(_arg_1.currentTarget).removeEventListener("onFxLoaded", this.onFxLoaded);
                if (((this._camera) && (this.GB))){
                    this.noelFxMng.onCamera(this._camera, this.GB);
                };
            };
        }

        public function onTimerEvt(_arg_1:Event):*{
            var _local_2:Object;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_6:uint;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Sound;
            if (this.noelFxMng){
                _local_3 = this.GB.serverTime;
                _local_4 = this.noelIlluDate;
                if (_local_3 > (_local_4 + 11000)){
                    this.noelLight = true;
                };
                if (((((this.GB.mainApplication.blablaland) && (this.GB.mainApplication.blablaland.serverId == 0)) && (_local_3 > (this.noelIlluDate + (3600 * 1000)))) && (_local_3 < this.endRepeat))){
                    _local_7 = ((2.5 * 3600) * 1000);
                    _local_8 = (_local_3 % _local_7);
                    if (_local_8 > (3600 * 1000)){
                        _local_4 = ((_local_3 + _local_7) - _local_8);
                    }
                    else {
                        _local_4 = (_local_3 - _local_8);
                    };
                };
                if ((((this.lastDate < (_local_4 + 16000)) && (_local_3 > _local_4)) && (!(this.noelSndChannel)))){
                    _local_2 = this.noelFxMng.getNoelSoundClass();
                    _local_9 = new (_local_2)();
                    this.noelSndChannel = _local_9.play((_local_3 - _local_4), 0);
                };
                _local_5 = _local_4;
                _local_6 = 0;
                if (_local_3 > (_local_5 + ((3600 * 24) * 2))){
                    _local_5 = this.nouvelAnDate;
                };
                if (((_local_3 > (_local_5 + 14000)) && (this.GB.mainApplication.camera))){
                    if (this.GB.mainApplication.camera.cameraReady){
                        _local_2 = this.noelFxMng.getFeuArtifice();
                        if (_local_3 < (_local_5 + 26000)){
                            this.timer.delay = 1000;
                            _local_6 = 0;
                            while (_local_6 < 10) {
                                this.startFeu(_local_2, (_local_3 + _local_6));
                                _local_6++;
                            };
                        }
                        else {
                            if (_local_3 >= (_local_5 + 28000)){
                                if (_local_3 < (_local_5 + 33000)){
                                    this.timer.delay = 100;
                                    this.startFeu(_local_2, _local_3);
                                }
                                else {
                                    if (_local_3 < (_local_5 + 40000)){
                                        this.timer.delay = 100;
                                        if (Math.random() > 0.7){
                                            _local_6 = 0;
                                            while (_local_6 < 5) {
                                                this.startFeu(_local_2, (_local_3 + _local_6), 0);
                                                _local_6++;
                                            };
                                        };
                                        this.startFeu(_local_2, _local_3);
                                    }
                                    else {
                                        if (_local_3 < (_local_5 + 50000)){
                                            this.timer.delay = 100;
                                            if (Math.random() > 0.8){
                                                _local_6 = 0;
                                                while (_local_6 < 2) {
                                                    this.startFeu(_local_2, (_local_3 + _local_6), 1);
                                                    _local_6++;
                                                };
                                            };
                                            if (Math.random() > 0.7){
                                                _local_6 = 0;
                                                while (_local_6 < 5) {
                                                    this.startFeu(_local_2, (_local_3 + _local_6), 0);
                                                    _local_6++;
                                                };
                                            };
                                            this.startFeu(_local_2, _local_3);
                                        }
                                        else {
                                            this.timer.delay = 200;
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function startFeu(_arg_1:Object, _arg_2:Number, _arg_3:uint=0):*{
            var _local_4:Object = new (_arg_1)();
            _local_4.GB = this.GB;
            _local_4.type = _arg_3;
            _local_4.seed = _arg_2;
            _local_4.camera = this.GB.mainApplication.camera;
            _local_4.init();
        }

        public function init():*{
            var _local_1:FxLoader;
            if (!this.noelFxMng){
                _local_1 = new FxLoader();
                _local_1.addEventListener("onFxLoaded", this.onFxLoaded);
                _local_1.loadFx(6);
                this.timer = new Timer(200);
                this.timer.addEventListener("timer", this.onTimerEvt, false);
                this.timer.start();
                this.lastDate = this.GB.serverTime;
            };
        }

        public function addGuirlande(_arg_1:MovieClip, _arg_2:Object, _arg_3:Object):*{
            var _local_4:GuirlandeItem;
            if (this.decoVisible){
                _arg_1.addEventListener("onDispose", this.disposeItem, false);
                _local_4 = new GuirlandeItem();
                _local_4.GB = _arg_2;
                _local_4.camera = _arg_3;
                _local_4.source = _arg_1;
                _local_4.init();
            }
            else {
                _arg_1.visible = false;
            };
        }

        public function disposeItem(_arg_1:Event):*{
            var _local_2:* = 0;
            while (_local_2 < this.itemList.length) {
                if (this.itemList[_local_2].source == _arg_1.currentTarget){
                    this.itemList[_local_2].dispose();
                    this.itemList.splice(_local_2, 1);
                    return;
                };
                _local_2++;
            };
        }

        public function set camera(_arg_1:Object):*{
            this._camera = _arg_1;
            if (this.noelFxMng){
                this.noelFxMng.onCamera(_arg_1, this.GB);
            };
        }


    }
}//package map.noel

