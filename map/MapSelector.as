﻿// version 467 by nota

//map.MapSelector

package map{
    import flash.display.MovieClip;
    import fx.FxLoader;
    import flash.events.Event;
    import bbl.GlobalProperties;

    public class MapSelector extends MovieClip {

        private var fxLoader:FxLoader;
        private var fxManager:Object;
        private var loadingClip:LoadingClip;

        public function MapSelector(){
            this.fxLoader = new FxLoader();
            this.fxManager = null;
            this.addEventListener(Event.ADDED, this.init, false, 0, true);
        }

        public function init(_arg_1:Event):*{
            if (stage){
                parent.addEventListener("onKill", this.onKill, false, 0, true);
                this.removeEventListener(Event.ADDED, this.init, false);
                Object(parent).resizer.visible = true;
                parent.width = 300;
                parent.height = 200;
                Object(parent).redraw();
                this.loadingClip = new LoadingClip();
                addChild(this.loadingClip);
                this.loadingClip.x = (parent.width / 2);
                this.loadingClip.y = (parent.height / 2);
                this.fxLoader.addEventListener("onFxLoaded", this.onFxLoaded, false);
                this.fxLoader.loadFx(17);
            };
        }

        public function onKill(_arg_1:Event):*{
            this.fxLoader.removeEventListener("onFxLoaded", this.onFxLoaded, false);
            if (this.fxManager){
                this.fxManager.dispose();
            };
        }

        public function onFxLoaded(_arg_1:Event):*{
            this.fxLoader.removeEventListener("onFxLoaded", this.onFxLoaded, false);
            this.fxManager = new this.fxLoader.lastLoad.classRef();
            if (this.loadingClip.parent){
                removeChild(this.loadingClip);
            };
            addChild(MovieClip(this.fxManager));
            this.fxManager.GP = GlobalProperties;
            this.fxManager.mapSelector = this;
            this.fxManager.init();
        }

        public function get serverId():uint{
            if (this.fxManager){
                return (this.fxManager.serverId);
            };
            return (0);
        }

        public function addSelection(_arg_1:uint):*{
            if (this.fxManager){
                this.fxManager.addSelection(_arg_1);
            }
            else {
                if (!Object(parent).data.SELECTION){
                    Object(parent).data.SELECTION = new Array();
                };
                Object(parent).data.SELECTION.push(_arg_1);
            };
        }

        public function clearSelection():*{
            if (this.fxManager){
                this.fxManager.clearSelection();
            }
            else {
                if ((Object(parent).data.SELECTION is Array)){
                    Object(parent).data.SELECTION = new Array();
                };
            };
        }

        public function centerToMap(_arg_1:uint):*{
            if (this.fxManager){
                this.fxManager.centerToMap(_arg_1);
            };
        }

        public function get mapList():Array{
            if (this.fxManager){
                return (this.fxManager.mapList);
            };
            return (new Array());
        }


    }
}//package map

