package ui
{

	public class SimpleToggleButton extends SimpleButton
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const SELECTED_COLOUR : Number = 0x0000A0;


		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var _isToggled : Boolean;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function SimpleToggleButton( buttonText : String )
		{
			super( buttonText );
			unhighlight();
		}


		//------------------------------------------------------------------------------
		//   Protected Functions 
		//------------------------------------------------------------------------------

		override protected function draw( colour : Number ) : void
		{
			super.draw( colour );
			_textField.text = ( _isToggled ) ? _buttonText + ' toggled' : _buttonText;
		}

		override protected function focusActivated() : void
		{
			_isToggled = !_isToggled;
			super.focusActivated();

			//Update accessibility properties to inform screen reader of change
			super.setAccessiblilityPropertes( _buttonText, super.accessibilityProperties.description );
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function unhighlight() : void
		{
			if ( _isToggled )
			{
				draw( SELECTED_COLOUR );
			}
			else
			{
				draw( UNHIGHLIGHT_COLOUR );
			}
		}
	}
}
