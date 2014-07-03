package accessibility.ui
{
	import flash.events.Event;

	import accessibility.implementation.AccessibleSliderImplementation;

	public class AccessibleSlider extends AccessibleSprite
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const SLIDER_UPDATE : String = "AccessibleSlider.SLIDER_UPDATE";


		//------------------------------------------------------------------------------
		//   Public Properties 
		//------------------------------------------------------------------------------

		//--------------------------------------
		// currentValue 
		//--------------------------------------

		private var _currentValue : String;

		public function get currentValue() : String
		{
			return _currentValue;
		}

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibleSlider()
		{
			super();
			_currentValue = "";
			this.accessibilityImplementation = new AccessibleSliderImplementation( this );
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		override public function destroy() : void
		{
			super.destroy();
			_currentValue = '';
		}

		//------------------------------------------------------------------------------
		//   Protected Functions 
		//------------------------------------------------------------------------------

		protected function updateSliderValue( value : String ) : void
		{
			if ( value != _currentValue )
			{
				_currentValue = value;
				dispatchEvent( new Event( SLIDER_UPDATE ));
			}
		}
	}
}
