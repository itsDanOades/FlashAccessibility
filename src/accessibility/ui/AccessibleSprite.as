package accessibility.ui
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import accessibility.events.AccessibilityEvent;

	public class AccessibleSprite extends Sprite
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const DEFAULT_TAB_INDEX : Number = -1;


		//------------------------------------------------------------------------------
		//   Public Properties 
		//------------------------------------------------------------------------------

		//--------------------------------------
		// tabIndex 
		//--------------------------------------

		private var _tabIndex : Number;

		override public function get tabIndex() : int
		{
			return _tabIndex;
		}

		override public function set tabIndex( value : int ) : void
		{
			if ( value != _tabIndex )
			{
				_tabIndex = value;
				dispatchEvent( new AccessibilityEvent( AccessibilityEvent.TAB_UPDATE, this ));
			}
		}

		//--------------------------------------
		// componentIndex 
		//--------------------------------------

		private var _componentIndex : Number;

		public function get componentIndex() : Number
		{
			return _componentIndex;
		}

		public function set componentIndex( value : Number ) : void
		{
			_componentIndex = value;
		}

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibleSprite()
		{
			super();
			this.tabEnabled = false;
			this.tabChildren = false;
			_tabIndex = DEFAULT_TAB_INDEX;
			_componentIndex = DEFAULT_TAB_INDEX;
			addListeners()
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		public function setAccessiblilityPropertes( name : String, description : String ) : void
		{
			if ( !this.accessibilityProperties )
			{
				this.accessibilityProperties = new AccessibilityProperties();
			}

			this.accessibilityProperties.name = name;
			this.accessibilityProperties.description = description;

			dispatchEvent( new AccessibilityEvent( AccessibilityEvent.UPDATE, this ));
		}

		public function destroy() : void
		{
			removeListeners();
			_tabIndex = DEFAULT_TAB_INDEX;
		}

		//------------------------------------------------------------------------------
		//   Protected Functions 
		//------------------------------------------------------------------------------

		protected function focusIn() : void
		{
			//Override in sub class			
		}

		protected function focusOut() : void
		{
			//Override in sub class						
		}

		protected function focusActivated() : void
		{
			//Override in sub class
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function addListeners() : void
		{
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			this.addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			this.addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			this.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			this.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			this.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			this.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			this.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			this.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}

		private function onKeyDown( event : KeyboardEvent ) : void
		{
			//Treat ENTER and SPACE as if they were a mouse click
			if ( event.keyCode === Keyboard.ENTER || event.keyCode === Keyboard.SPACE )
			{
				dispatchEvent( new MouseEvent( MouseEvent.MOUSE_DOWN ));
			}
		}

		private function onKeyUp( event : KeyboardEvent ) : void
		{
			//Treat ENTER and SPACE as if they were a mouse click
			if ( event.keyCode === Keyboard.ENTER || event.keyCode === Keyboard.SPACE )
			{
				dispatchEvent( new MouseEvent( MouseEvent.MOUSE_UP ));
			}
		}

		private function onMouseDown( event : MouseEvent ) : void
		{
			dispatchEvent( new AccessibilityEvent( AccessibilityEvent.FOCUS, this ));
			focusActivated();
		}

		private function onMouseOver( event : MouseEvent ) : void
		{
			focusIn();
		}

		private function onMouseOut( event : MouseEvent ) : void
		{
			focusOut();
		}

		private function removeListeners() : void
		{
			this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			this.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			this.removeEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			this.removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			this.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			this.removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			this.removeEventListener( MouseEvent.MOUSE_OVER, onFocusIn );
			this.removeEventListener( MouseEvent.MOUSE_OUT, onFocusOut );
		}

		private function onFocusOut( event : Event ) : void
		{
			focusOut();
		}

		private function onFocusIn( event : Event ) : void
		{
			focusIn();
		}

		private function onRemovedFromStage( event : Event ) : void
		{
			//Remove component from tab order when removed from stage
			dispatchEvent( new AccessibilityEvent( AccessibilityEvent.REMOVED, this ));
		}

		private function onAddedToStage( event : Event ) : void
		{
			//Add component to tab order when added to stage
			dispatchEvent( new AccessibilityEvent( AccessibilityEvent.ADDED, this ));
		}
	}
}
