// version 467 by nota

//PopupTuto

package {
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.display.*;
    import flash.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.filters.*;
    import flash.external.*;
    import flash.ui.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.errors.*;
    import flash.globalization.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.text.ime.*;
    import flash.text.engine.*;
    import flash.xml.*;

    public dynamic class PopupTuto extends MovieClip {

        public var bt_close:SimpleButton;
        public var bt_close2:SimpleButton;
        public var bt_next:SimpleButton;
        public var bt_nextB:SimpleButton;
        public var bt_prev:SimpleButton;
        public var btn_ins:SimpleButton;

        public function PopupTuto(){
            addFrameScript(0, this.frame1, 1, this.frame2, 3, this.frame4, 4, this.frame5);
        }

        public function onCloseEvt(_arg_1:Event):*{
            Object(this).camera.addHeadLocation();
            Object(this).win.close();
        }

        public function onNextEvt(_arg_1:Event):*{
            Object(this).camera.addHeadLocation();
            nextFrame();
            stop();
        }

        public function onPrevEvt(_arg_1:Event):*{
            Object(this).camera.addHeadLocation();
            gotoAndStop((currentFrame - 1));
            stop();
        }

        public function onInscriptionEvt(_arg_1:Event):*{
            navigateToURL(new URLRequest("/site/inscription.php"));
        }

        internal function frame1():*{
            this.bt_close.addEventListener("click", this.onCloseEvt, false);
            this.bt_next.addEventListener("click", this.onNextEvt, false);
            this.bt_nextB.addEventListener("click", this.onNextEvt, false);
            this.btn_ins.addEventListener("click", this.onInscriptionEvt, false);
            if (Object(this).isTouriste){
                this.btn_ins.visible = false;
            };
            stop();
        }

        internal function frame2():*{
            this.bt_prev.addEventListener("click", this.onPrevEvt, false);
        }

        internal function frame4():*{
            this.bt_next.addEventListener("click", this.onNextEvt, false);
        }

        internal function frame5():*{
            this.bt_close2.addEventListener("click", this.onCloseEvt, false);
        }


    }
}//package 

