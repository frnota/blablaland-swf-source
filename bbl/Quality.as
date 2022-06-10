// version 467 by nota

//bbl.Quality

package bbl{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.media.SoundMixer;

    public class Quality extends EventDispatcher {

        private var _scrollMode:uint;
        private var _rainRateQuality:uint;
        private var _graphicQuality:Number;
        private var _persoMoveQuality:uint;
        private var _generalVolume:Number;
        private var _ambiantVolume:Number;
        private var _interfaceVolume:Number;
        private var _actionVolume:Number;
        public var lastPowerTest:uint;

        public function Quality(){
            this._scrollMode = 0;
            this._rainRateQuality = 3;
            this._graphicQuality = 3;
            this._persoMoveQuality = 5;
            this._generalVolume = 0.8;
            this._ambiantVolume = 1;
            this._actionVolume = 1;
            this._interfaceVolume = 1;
            this.lastPowerTest = 0;
        }

        public function autoDetect():*{
            var _local_1:* = this.getPower();
            this._scrollMode = ((_local_1 > 30000) ? 1 : 0);
            this._rainRateQuality = Math.min(Math.max(Math.round((((_local_1 - 30000) / (180000 - 30000)) * 5)), 1), 5);
            this._persoMoveQuality = Math.min(Math.max(Math.round((((_local_1 - 20000) / (90000 - 20000)) * 5)), 1), 5);
            this._graphicQuality = Math.min(Math.max(Math.round((((_local_1 - 10000) / (50000 - 10000)) * 3)), 2), 3);
            this.updateQuality();
            dispatchEvent(new Event("onChanged"));
        }

        public function getPower():uint{
            var _local_3:*;
            var _local_1:* = GlobalProperties.getTimer();
            var _local_2:* = 0;
            while (GlobalProperties.getTimer() < (_local_1 + 500)) {
                _local_3 = new Array();
                _local_3.push("string");
                _local_3.splice(0, _local_3.length);
                _local_2++;
            };
            this.lastPowerTest = _local_2;
            return (_local_2);
        }

        public function updateQuality():*{
            GlobalProperties.stage.quality = ((this._graphicQuality == 1) ? "low" : ((this._graphicQuality == 2) ? "medium" : "best"));
        }

        public function set scrollMode(_arg_1:uint):*{
            this._scrollMode = _arg_1;
            dispatchEvent(new Event("onChanged"));
        }

        public function get scrollMode():uint{
            return (this._scrollMode);
        }

        public function set rainRateQuality(_arg_1:uint):*{
            this._rainRateQuality = _arg_1;
            dispatchEvent(new Event("onChanged"));
        }

        public function get rainRateQuality():uint{
            return (this._rainRateQuality);
        }

        public function set graphicQuality(_arg_1:uint):*{
            this._graphicQuality = _arg_1;
            this.updateQuality();
            dispatchEvent(new Event("onChanged"));
        }

        public function get graphicQuality():uint{
            return (this._graphicQuality);
        }

        public function set persoMoveQuality(_arg_1:uint):*{
            this._persoMoveQuality = _arg_1;
            dispatchEvent(new Event("onChanged"));
        }

        public function get persoMoveQuality():uint{
            return (this._persoMoveQuality);
        }

        public function set ambiantVolume(_arg_1:Number):*{
            this._ambiantVolume = _arg_1;
            dispatchEvent(new Event("onSoundChanged"));
        }

        public function get ambiantVolume():Number{
            return (this._ambiantVolume);
        }

        public function set interfaceVolume(_arg_1:Number):*{
            this._interfaceVolume = _arg_1;
            dispatchEvent(new Event("onSoundChanged"));
        }

        public function get interfaceVolume():Number{
            return (this._interfaceVolume);
        }

        public function set actionVolume(_arg_1:Number):*{
            this._actionVolume = _arg_1;
            dispatchEvent(new Event("onSoundChanged"));
        }

        public function get actionVolume():Number{
            return (this._actionVolume);
        }

        public function set generalVolume(_arg_1:Number):*{
            this._generalVolume = _arg_1;
            var _local_2:* = SoundMixer.soundTransform;
            _local_2.volume = _arg_1;
            SoundMixer.soundTransform = _local_2;
        }

        public function get generalVolume():Number{
            return (this._generalVolume);
        }


    }
}//package bbl

