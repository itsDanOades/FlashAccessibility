package accessibility.keyboard
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;

	import accessibility.external.ExternalInterfaceEvent;
	import accessibility.external.ExternalInterfaceMediator;
	import accessibility.ui.AccessibleSprite;

	public class KeyboardMediator extends EventDispatcher
	{

		//------------------------------------------------------------------------------
		//   Static Private Properties 
		//------------------------------------------------------------------------------

		static private const NOT_FOUND : int = -1;


		//------------------------------------------------------------------------------
		//   Public Properties 
		//------------------------------------------------------------------------------

		public function get isFullScreen() : Boolean
		{
			return _stage.displayState != StageDisplayState.NORMAL;
		}

		//--------------------------------------
		// tabIndex 
		//--------------------------------------

		private var _tabIndex : Number;

		public function get tabIndex() : Number
		{
			return _displayObjects.length - 1;
		}

		//------------------------------------------------------------------------------
		//   Protected Properties 
		//------------------------------------------------------------------------------

		protected var _displayObjects : Vector.<InteractiveObject>;

		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var _stage : Stage;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function KeyboardMediator( stage : Stage )
		{
			super();
			_stage = stage;
			_tabIndex = 0;
			_displayObjects = new Vector.<InteractiveObject>();
			_stage.stageFocusRect = false;
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		public function addComponent( component : AccessibleSprite, tabIndex : uint, insert : Boolean ) : void
		{
			// First, see if this component is already registered.
			var existingIndex : int = getComponentIndex( component );
			if ( existingIndex != NOT_FOUND )
			{
				if ( _displayObjects[ existingIndex ].componentIndex == tabIndex )
				{
					return;
				}
				else
				{
					removeComponent( component );
				}
			}

			component.componentIndex = tabIndex;

			var insertBeforeIndex : int = determineInsertPoint( tabIndex );
			if ( insertBeforeIndex < 0 )
			{
				_displayObjects.push( component );
			}
			else
			{
				if ( insert || _displayObjects[ insertBeforeIndex ].componentIndex != tabIndex )
				{
					_displayObjects.splice( insertBeforeIndex, 0, component );
				}
				else
				{
					_displayObjects.splice( insertBeforeIndex, 1, component );
				}
			}
		}

		public function destroy() : void
		{
			_displayObjects = null;
			_stage = null;
			_tabIndex = 0;
		}

		public function removeComponent( component : InteractiveObject ) : void
		{
			var index : int = getComponentIndex( component );
			if ( index != NOT_FOUND )
			{
				_tabIndex = index == _tabIndex ? -1 : _tabIndex;
				_displayObjects.splice( index, 1 );
			}
		}

		public function setFocusOn( component : InteractiveObject ) : void
		{
			var index : int = getComponentIndex( component );
			if ( index != NOT_FOUND )
			{
				_tabIndex = index;
				setFocusOnTabIndex();
			}
		}

		public function tab() : void
		{
			if ( _displayObjects.length > 0 )
			{
				shouldReturnLostFocus() ? setFocusOnTabIndex() : tabForwards();
			}
		}

		public function shiftTab() : void
		{
			if ( _displayObjects.length > 0 )
			{
				shouldReturnLostFocus() ? setFocusOnTabIndex() : tabBackwards();
			}
		}

		public function setFocusToFirst() : void
		{
			_tabIndex = -1;
			tabForwards();
		}

		public function setFocusToLast() : void
		{
			_tabIndex = _displayObjects.length;
			tabBackwards();
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		//If current focus index has lost focus due to a mouse click, request focus back
		private function shouldReturnLostFocus() : Boolean
		{
			// Ensure that the _tabIndex is within bounds.
			if ( _tabIndex != -1 && _displayObjects.length > _tabIndex )
			{
				return ( _stage.focus != _displayObjects[ _tabIndex ])
			}
			return false;
		}

		private function determineInsertPoint( tabIndex : int ) : int
		{
			var i : int;
			for ( i = 0; i < _displayObjects.length; i++ )
			{
				if ( _displayObjects[ i ].componentIndex >= tabIndex )
				{
					return i;
				}
			}

			return -1;
		}

		private function getComponentIndex( component : InteractiveObject ) : int
		{
			var index : int = NOT_FOUND;
			for ( var i : uint = 0; i < _displayObjects.length; i++ )
			{
				if ( _displayObjects[ i ] === component )
				{
					index = i;
					break;
				}
			}
			return index;
		}

		private function isVisible( displayObject : DisplayObjectContainer ) : Boolean
		{
			return ( displayObject.visible && displayObject.alpha > 0 );
		}

		private function setFocusOnTabIndex() : void
		{
			_stage.focus = _displayObjects[ _tabIndex ];
		}

		private function tabBackwards() : void
		{
			//Decrease tab index
			if ( _tabIndex > 0 )
			{
				_tabIndex--;

				//If the new focused component is not visible then tab backwards again
				if ( isVisible( _displayObjects[ _tabIndex ]))
				{
					setFocusOnTabIndex();
				}
				else
				{
					tabBackwards();
				}
			}
			else if ( isFullScreen )
			{
				//if in full screen then loop tab index
				_tabIndex = _displayObjects.length;
				tabBackwards();
			}
			else
			{
				//If not in full screen then pass key focus back to HTML
				_stage.dispatchEvent( new ExternalInterfaceEvent( ExternalInterfaceEvent.CALL_TO_PAGE, ExternalInterfaceMediator.FOCUS_BEFORE_FLASH, {}));
			}
		}

		private function tabForwards() : void
		{
			//Increase tab index
			if ( _tabIndex < _displayObjects.length - 1 )
			{
				_tabIndex++;

				//If new focus is not visible then tab forwards again
				if ( isVisible( _displayObjects[ _tabIndex ]))
				{
					setFocusOnTabIndex();
				}
				else
				{
					tabForwards();
				}
			}
			else if ( isFullScreen )
			{
				//If in full screen then loop tab index
				_tabIndex = -1;
				tabForwards();
			}
			else
			{
				//If not in full screen the pass focus back to HTML
				_stage.dispatchEvent( new ExternalInterfaceEvent( ExternalInterfaceEvent.CALL_TO_PAGE, ExternalInterfaceMediator.FOCUS_AFTER_FLASH, {}));
			}
		}
	}
}
