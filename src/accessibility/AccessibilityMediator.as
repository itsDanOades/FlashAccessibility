package accessibility
{
	import flash.accessibility.Accessibility;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import accessibility.events.AccessibilityEvent;
	import accessibility.external.ExternalInterfaceEvent;
	import accessibility.external.ExternalInterfaceMediator;
	import accessibility.keyboard.KeyboardMediator;

	public class AccessibilityMediator
	{

		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var _stage : Stage;
		private var _keyboardMediator : KeyboardMediator;
		private var _externalInterfaceMediator : ExternalInterfaceMediator;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibilityMediator( stage : Stage )
		{
			_stage = stage;
			init();
			addListeners();
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		//TODO send screen reader alert when in full screen
		//Add comments and destroy code to reusable components
		//Upload to sourceforge and add links
		//Edit docs to match Henny

		public function destroy() : void
		{
			removeListeners();
			_stage = null;
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function init() : void
		{
			_keyboardMediator = new KeyboardMediator( _stage );
			_externalInterfaceMediator = new ExternalInterfaceMediator();
		}

		private function onComponentRemoved( event : AccessibilityEvent ) : void
		{
			_keyboardMediator.removeComponent( event.component );
		}

		private function addListeners() : void
		{
			//Accessibility Events from stage
			_stage.addEventListener( AccessibilityEvent.ADDED, onComponentAdded );
			_stage.addEventListener( AccessibilityEvent.TAB_UPDATE, onComponentUpdated );
			_stage.addEventListener( AccessibilityEvent.REMOVED, onComponentRemoved );
			_stage.addEventListener( AccessibilityEvent.FOCUS, onComponentFocus );
			_stage.addEventListener( AccessibilityEvent.UPDATE, onAccessibilityUpdate );
			_stage.addEventListener( FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange );
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_stage.addEventListener( FullScreenEvent.FULL_SCREEN, onFullScreenChange );
			_stage.addEventListener( ExternalInterfaceEvent.CALL_TO_PAGE, onCallToPage );


			//Accessibility events from page
			_externalInterfaceMediator.addEventListener( ExternalInterfaceEvent.CALL_FROM_PAGE, onCallFromPage );
		}

		private function onAccessibilityUpdate( event : Event ) : void
		{
			//If a screen reader is active, inform it of changes to the user interface
			if ( Accessibility.active )
			{
				Accessibility.updateProperties();
			}
		}

		private function onFullScreenChange( event : FullScreenEvent ) : void
		{
			//If going full screen send a screen reader alert to inform the user
			if ( _stage.displayState === StageDisplayState.FULL_SCREEN )
			{
				_externalInterfaceMediator.callPage( ExternalInterfaceMediator.SEND_SCREEN_READER_ALERT, "Press escape to exit full screen, whilst in full screen use the space bar to activate controls" );
			}
			else
			{
				//Older browsers lose focus on the Flash player component when exiting full screen, request the browser re focus Flash
				_externalInterfaceMediator.callPage( ExternalInterfaceMediator.FOCUS_ON_FLASH, {});
			}
		}

		private function removeListeners() : void
		{
			_stage.removeEventListener( AccessibilityEvent.ADDED, onComponentAdded );
			_stage.removeEventListener( AccessibilityEvent.TAB_UPDATE, onComponentUpdated );
			_stage.removeEventListener( AccessibilityEvent.REMOVED, onComponentRemoved );
			_stage.removeEventListener( AccessibilityEvent.FOCUS, onComponentFocus );
			_stage.removeEventListener( AccessibilityEvent.UPDATE, onAccessibilityUpdate );
			_stage.removeEventListener( FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange );
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_stage.removeEventListener( FullScreenEvent.FULL_SCREEN, onFullScreenChange );
			_stage.removeEventListener( ExternalInterfaceEvent.CALL_TO_PAGE, onCallToPage );

			_externalInterfaceMediator.removeEventListener( ExternalInterfaceEvent.CALL_FROM_PAGE, onCallFromPage );
		}

		private function onCallToPage( event : ExternalInterfaceEvent ) : void
		{
			//Callbacks to JS ExternalInterface
			_externalInterfaceMediator.callPage( event.functionName, event.additionalParams );
		}

		private function onCallFromPage( event : ExternalInterfaceEvent ) : void
		{
			if ( event.functionName === ExternalInterfaceMediator.FOCUS_ON_FIRST )
			{
				//Web page has requested Flash to focus on the first component in the tab order
				_keyboardMediator.setFocusToFirst();
			}
			else if ( event.functionName === ExternalInterfaceMediator.FOCUS_ON_LAST )
			{
				//Web page has requested Flash to focus on the last component in the tab order
				_keyboardMediator.setFocusToLast();
			}
		}

		private function onComponentFocus( event : AccessibilityEvent ) : void
		{
			//A component has requested focus, update tab index
			_keyboardMediator.setFocusOn( event.component );
		}

		private function onKeyDown( event : KeyboardEvent ) : void
		{
			//Override tab key presses to force manual control of tab index
			if ( event.keyCode === Keyboard.TAB )
			{
				//event.stopImmediatePropagation();
				if ( event.shiftKey )
				{
					_keyboardMediator.shiftTab();
				}
				else
				{
					_keyboardMediator.tab();
				}
			}
		}

		private function onKeyFocusChange( event : FocusEvent ) : void
		{
			//Prevent key focus change on tabbing
			event.preventDefault();
			event.stopImmediatePropagation();
		}

		private function onComponentAdded( event : AccessibilityEvent ) : void
		{
			//If the component has no tab index set then insert in order added to stage
			if ( event.component.tabIndex === -1 )
			{
				_keyboardMediator.addComponent( event.component, _keyboardMediator.tabIndex + 1, false );
			}
			else
			{
				_keyboardMediator.addComponent( event.component, event.component.tabIndex, false );
			}

		}

		private function onComponentUpdated( event : AccessibilityEvent ) : void
		{
			_keyboardMediator.addComponent( event.component, event.component.tabIndex, false );
		}
	}
}
