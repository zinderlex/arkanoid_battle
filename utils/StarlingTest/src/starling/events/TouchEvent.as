// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/** A TouchEvent is triggered either by touch or mouse input.
     *  
     *  <p>In Starling, both touch events and mouse events are handled through the same class: 
     *  TouchEvent. To process user input from a touch screen or the mouse, you have to register
     *  an event listener for events of the type <code>TouchEvent.TOUCH</code>. This is the only
     *  event type you need to handle; the long list of mouse event types as they are used in
     *  conventional Flash are mapped to so-called "TouchPhases" instead.</p> 
     * 
     *  <p>The difference between mouse input and touch input is that</p>
     *  
     *  <ul>
     *    <li>only one mouse cursor can be present at a given moment and</li>
     *    <li>only the mouse can "hover" over an object without a pressed button.</li>
     *  </ul> 
     *  
     *  <strong>Which objects receive touch events?</strong>
     * 
     *  <p>In Starling, any display object receives touch events, as long as the  
     *  <code>touchable</code> property of the object and its parents is enabled. There 
     *  is no "InteractiveObject" class in Starling.</p>
     *  
     *  <strong>How to work with individual touches</strong>
     *  
     *  <p>The event contains a list of all touches that are currently present. Each individual
     *  touch is stored in an object of type "Touch". Since you are normally only interested in 
     *  the touches that occurred on top of certain objects, you can query the event for touches
     *  with a specific target:</p>
     * 
     *  <code>var touches:Vector.&lt;Touch&gt; = touchEvent.getTouches(this);</code>
     *  
     *  <p>This will return all touches of "this" or one of its children. When you are not using 
     *  multitouch, you can also access the touch object directly, like this:</p>
     * 
     *  <code>var touch:Touch = touchEvent.getTouch(this);</code>
     *  
     *  @see Touch
     *  @see TouchPhase
     */ 
    public class TouchEvent extends Event
    {
        /** Event type for touch or mouse input. */
        public static const TOUCH:String = "touch";
        
        private var mTouches:Vector.<Touch>;
        private var mShiftKey:Boolean;
        private var mCtrlKey:Boolean;
        private var mTimestamp:Number;
        
        /** Creates a new TouchEvent instance. */
        public function TouchEvent(type:String, touches:Vector.<Touch>, shiftKey:Boolean=false, 
                                   ctrlKey:Boolean=false, bubbles:Boolean=true)
        {
            super(type, bubbles, touches);
            
            mTouches = touches;
            mShiftKey = shiftKey;
            mCtrlKey = ctrlKey;
            mTimestamp = -1.0;
            
            var numTouches:int=touches.length;
            for (var i:int=0; i<numTouches; ++i)
                if (touches[i].timestamp > mTimestamp)
                    mTimestamp = touches[i].timestamp;
        }
        
        /** Returns a list of touches that originated over a certain target. */
        public function getTouches(target:DisplayObject, phase:String=null):Vector.<Touch>
        {
            var touchesFound:Vector.<Touch> = new <Touch>[];
            var numTouches:int = mTouches.length;
            
            for (var i:int=0; i<numTouches; ++i)
            {
                var touch:Touch = mTouches[i];
                var correctTarget:Boolean = (touch.target == target) ||
                    ((target is DisplayObjectContainer) && 
                     (target as DisplayObjectContainer).contains(touch.target));
                var correctPhase:Boolean = (phase == null || phase == touch.phase);
                    
                if (correctTarget && correctPhase)
                    touchesFound.push(touch);
            }
            return touchesFound;
        }
        
        /** Returns a touch that originated over a certain target. */
        public function getTouch(target:DisplayObject, phase:String=null):Touch
        {
            var touchesFound:Vector.<Touch> = getTouches(target, phase);
            if (touchesFound.length > 0) return touchesFound[0];
            else return null;
        }
        
        /** Indicates if a target is currently being touched or hovered over. */
        public function interactsWith(target:DisplayObject):Boolean
        {
            if (getTouch(target) == null)
                return false;
            else
            {
                var touches:Vector.<Touch> = getTouches(target);
                
                for (var i:int=touches.length-1; i>=0; --i)
                    if (touches[i].phase != TouchPhase.ENDED)
                        return true;
                
                return false;
            }
        }

        /** The time the event occurred (in seconds since application launch). */
        public function get timestamp():Number { return mTimestamp; }
        
        /** All touches that are currently available. */
        public function get touches():Vector.<Touch> { return mTouches.concat(); }
        
        /** Indicates if the shift key was pressed when the event occurred. */
        public function get shiftKey():Boolean { return mShiftKey; }
        
        /** Indicates if the ctrl key was pressed when the event occurred. (Mac OS: Cmd or Ctrl) */
        public function get ctrlKey():Boolean { return mCtrlKey; }
    }
}