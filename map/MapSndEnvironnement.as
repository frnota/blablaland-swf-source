// version 467 by nota

//map.MapSndEnvironnement

package map{
    import flash.events.Event;

    public class MapSndEnvironnement extends MapMeteoControl {

        public var sndList:Array = new Array();


        public function newSndEnvironnement():SndEnvironnement{
            var _local_1:* = new SndEnvironnement();
            _local_1.camera = this;
            _local_1.generalVolume = quality.ambiantVolume;
            this.sndList.push(_local_1);
            return (_local_1);
        }

        override public function onQualitySoundChange(_arg_1:Event):*{
            var _local_2:* = 0;
            while (_local_2 < this.sndList.length) {
                this.sndList[_local_2].generalVolume = quality.ambiantVolume;
                _local_2++;
            };
            super.onQualitySoundChange(_arg_1);
        }

        override public function unloadMap():*{
            var _local_1:Object;
            super.unloadMap();
            while (this.sndList.length) {
                _local_1 = this.sndList.shift();
                _local_1.dispose();
            };
        }

        public function addMeadowSndEnvironnement():*{
            var _local_1:SndEnvironnement;
            _local_1 = this.newSndEnvironnement();
            _local_1.soundClass = externalLoader.getClass("GrillonNuit");
            _local_1.volume = 0.2;
            _local_1.seed = 112;
            _local_1.mode = 1;
            _local_1.lightMode = 2;
            _local_1.timer.delay = 5000;
            _local_1.start();
            _local_1 = this.newSndEnvironnement();
            _local_1.volume = 0.05;
            _local_1.soundClass = externalLoader.getClass("CigaleMono");
            _local_1.mode = 1;
            _local_1.seed = 135;
            _local_1.lightThreshold = 0.7;
            _local_1.lightMode = 1;
            _local_1.rainMode = 1;
            _local_1.snowMode = 1;
            _local_1.temperatureMode = 1;
            _local_1.timer.delay = 5000;
            _local_1.start();
            _local_1 = this.newSndEnvironnement();
            _local_1.volume = 0.3;
            _local_1.soundClass = externalLoader.getClass("PiafA");
            _local_1.mode = 2;
            _local_1.seed = 186;
            _local_1.rate = 0.3;
            _local_1.lightMode = 1;
            _local_1.timer.delay = 2000;
            _local_1.start();
            _local_1 = this.newSndEnvironnement();
            _local_1.volume = 0.3;
            _local_1.soundClass = externalLoader.getClass("PiafB");
            _local_1.mode = 2;
            _local_1.rate = 0.3;
            _local_1.seed = 217;
            _local_1.lightMode = 1;
            _local_1.timer.delay = 2500;
            _local_1.start();
        }

        public function addBeachSndEnvironnement(_arg_1:Object=null):*{
            var _local_2:SndEnvironnement;
            if (!_arg_1){
                _arg_1 = new Object();
            };
            if (!_arg_1.ARBRE){
                _local_2 = this.newSndEnvironnement();
                _local_2.volume = 0.6;
                _local_2.seed = 50;
                _local_2.soundClass = externalLoader.getClass("SndPlage");
                _local_2.start();
            }
            else {
                _local_2 = this.newSndEnvironnement();
                _local_2.volume = 0.3;
                _local_2.soundClass = externalLoader.getClass("PiafA");
                _local_2.mode = 2;
                _local_2.seed = 186;
                _local_2.rate = 0.3;
                _local_2.lightMode = 1;
                _local_2.timer.delay = 2000;
                _local_2.start();
                _local_2 = this.newSndEnvironnement();
                _local_2.volume = 0.3;
                _local_2.soundClass = externalLoader.getClass("PiafB");
                _local_2.mode = 2;
                _local_2.rate = 0.3;
                _local_2.seed = 217;
                _local_2.lightMode = 1;
                _local_2.timer.delay = 2500;
                _local_2.start();
            };
            _local_2 = this.newSndEnvironnement();
            _local_2.volume = 0.05;
            _local_2.seed = 80;
            _local_2.soundClass = externalLoader.getClass("CigaleMono");
            _local_2.mode = 1;
            _local_2.lightThreshold = 0.7;
            _local_2.lightMode = 1;
            _local_2.rainMode = 1;
            _local_2.snowMode = 1;
            _local_2.temperatureMode = 1;
            _local_2.timer.delay = 5000;
            _local_2.start();
            _local_2 = this.newSndEnvironnement();
            _local_2.soundClass = externalLoader.getClass("Mouette");
            _local_2.mode = 1;
            _local_2.lightThreshold = 0.4;
            _local_2.lightMode = 1;
            _local_2.seed = 100;
            _local_2.rainMode = 1;
            _local_2.snowMode = 1;
            _local_2.timer.delay = 10000;
            _local_2.start();
            _local_2 = this.newSndEnvironnement();
            _local_2.soundClass = externalLoader.getClass("GrillonNuit");
            _local_2.volume = 0.2;
            _local_2.seed = 200;
            _local_2.mode = 1;
            _local_2.lightMode = 2;
            _local_2.timer.delay = 5000;
            _local_2.start();
        }


    }
}//package map

