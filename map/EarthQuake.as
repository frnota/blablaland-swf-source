// version 467 by nota

//map.EarthQuake

package map{
    import flash.display.Sprite;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.media.SoundTransform;
    import bbl.GlobalProperties;

    public class EarthQuake {

        public var soundClass:Class;
        public var volume:Number;
        private var itemList:Array;
        private var _target:Sprite;
        private var _currentposX:Number;
        private var _currentposY:Number;
        private var _flip:uint;
        private var _sprite:Sprite;
        private var _soundChannel:SoundChannel;

        public function EarthQuake(){
            this.itemList = new Array();
            this.volume = 1;
            this._sprite = new Sprite();
            this.target = null;
            this._soundChannel = null;
            this._flip = 0;
        }

        public function addItem():EarthQuakeItem{
            var _local_2:Sound;
            var _local_1:EarthQuakeItem = new EarthQuakeItem();
            this.itemList.push(_local_1);
            if (this.itemList.length == 1){
                this._sprite.addEventListener(Event.ENTER_FRAME, this.enterf, false, 0, true);
                _local_2 = new this.soundClass();
                this._soundChannel = _local_2.play(0, 9999, new SoundTransform(0));
                if (this._target){
                    this._currentposX = this._target.x;
                    this._currentposY = this._target.y;
                };
            };
            return (_local_1);
        }

        public function stop():*{
            if (this._soundChannel){
                this._soundChannel.stop();
                this._soundChannel = null;
            };
            if (this._target){
                this._target.x = this._currentposX;
                this._target.y = this._currentposY;
            };
            this._sprite.removeEventListener(Event.ENTER_FRAME, this.enterf);
            this.itemList.splice(0, this.itemList.length);
        }

        public function enterf(_arg_1:Event):*{
            var _local_4:EarthQuakeItem;
            var _local_5:Number;
            var _local_2:Number = 0;
            var _local_3:uint;
            while (_local_3 < this.itemList.length) {
                _local_4 = this.itemList[_local_3];
                _local_5 = ((GlobalProperties.serverTime - _local_4.startAt) / _local_4.duration);
                if (_local_5 > 1){
                    this.itemList.splice(_local_3, 1);
                    _local_3--;
                }
                else {
                    _local_4.curAmplitude = (Math.pow(Math.sin((Math.PI * _local_5)), 0.6) * _local_4.amplitude);
                    _local_2 = Math.max(_local_4.curAmplitude, _local_2);
                };
                _local_3++;
            };
            if (this.itemList.length){
                if (this._soundChannel){
                    this._soundChannel.soundTransform = new SoundTransform(((_local_2 * 4) * this.volume));
                };
                if (((this._target) && ((this._flip % 3) == 0))){
                    this.target.x = (this._currentposX + (((Math.random() * 20) - 10) * _local_2));
                    this.target.y = (this._currentposY + (((Math.random() * 20) - 10) * _local_2));
                };
                this._flip++;
            }
            else {
                this.stop();
            };
        }

        public function get target():Sprite{
            return (this._target);
        }

        public function set target(_arg_1:Sprite):*{
            this._target = _arg_1;
            if (_arg_1){
                this._currentposX = _arg_1.x;
                this._currentposY = _arg_1.y;
            };
        }


    }
}//package map

