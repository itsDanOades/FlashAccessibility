package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import accessibility.AccessibilityMediator;
	import accessibility.external.ExternalInterfaceEvent;
	import accessibility.external.ExternalInterfaceMediator;
	import accessibility.ui.AccessibleSlider;
	import accessibility.ui.AccessibleSprite;
	import ui.SimpleButton;
	import ui.SimpleSlider;
	import ui.SimpleToggleButton;

	[SWF( backgroundColor = '0xFFFFFF', width = '1280', height = '200', frameRate = '60' )]
	public class FlashAccessibility extends Sprite
	{

		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var _accessibilityMediator : AccessibilityMediator;
		private var _buttons : Vector.<AccessibleSprite>;
		private var _slider : AccessibleSlider;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function FlashAccessibility()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}


		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function onFullScreenButtonMouseDown( event : MouseEvent ) : void
		{
			if ( stage.displayState === StageDisplayState.NORMAL )
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}

		private function onAlertButtonMouseDown( event : MouseEvent ) : void
		{
			var screenReaderAlert : String = "This is a test message to the screen reader. Hello World";
			stage.dispatchEvent( new ExternalInterfaceEvent( ExternalInterfaceEvent.CALL_TO_PAGE, ExternalInterfaceMediator.SEND_SCREEN_READER_ALERT, screenReaderAlert ));
		}

		private function onAddedToStage( event : Event ) : void
		{
			init();
			createChildren();
			positionChildren();
		}

		private function positionChildren() : void
		{
			var xPos : int = 50;
			var yPos : int = 50;
			var tabIndex : int = 0;

			for each ( var button : AccessibleSprite in _buttons )
			{
				button.x = xPos;
				button.y = yPos;
				xPos += button.width + 10;

				button.tabIndex = tabIndex;
				tabIndex++;
			}

			_slider.x = xPos;
			_slider.y = yPos + 25;
			_slider.tabIndex = tabIndex;
		}

		private function createChildren() : void
		{
			var simpleButton : AccessibleSprite = addAccessibleButton( "Simple Toggle", "Press to toggle", true );

			var alertButton : AccessibleSprite = addAccessibleButton( "Screen reader alert", "Press to send a screen reader alert" );
			alertButton.addEventListener( MouseEvent.MOUSE_DOWN, onAlertButtonMouseDown );

			var fullScreenButton : AccessibleSprite = addAccessibleButton( "Full screen toggle", "Press to toggle Flash full screen" );
			fullScreenButton.addEventListener( MouseEvent.MOUSE_DOWN, onFullScreenButtonMouseDown );

			_slider = new SimpleSlider();
			_slider.setAccessiblilityPropertes( 'Simple slider', 'Use the arrow keys to increase and decrease the slider' );
			addChild( _slider );
		}

		private function addAccessibleButton( name : String, description : String, isToggle : Boolean = false ) : AccessibleSprite
		{
			var button : AccessibleSprite = ( !isToggle ) ? new SimpleButton( name ) : new SimpleToggleButton( name );
			button.setAccessiblilityPropertes( name, description );
			addChild( button );
			_buttons.push( button );

			return button;
		}

		private function init() : void
		{
			_buttons = new Vector.<AccessibleSprite>();
			_accessibilityMediator = new AccessibilityMediator( stage );
		}
	}
}
