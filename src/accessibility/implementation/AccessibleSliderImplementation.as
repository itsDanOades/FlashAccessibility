package accessibility.implementation
{
	import flash.accessibility.Accessibility;
	import flash.events.Event;

	import accessibility.ui.AccessibleSlider;

	public class AccessibleSliderImplementation extends BaseAccessibleImplementation
	{

		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var currentValue : String;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibleSliderImplementation( master : AccessibleSlider )
		{
			super( master );
			currentValue = "";

			_master.addEventListener( AccessibleSlider.SLIDER_UPDATE, onSliderUpdate, false, 0, true );
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		override public function get_accName( childID : uint ) : String
		{
			return _master.accessibilityProperties.name;
		}

		override public function get_accRole( childID : uint ) : uint
		{
			return MSAAConstants.ROLE_SYSTEM_SLIDER
		}

		override public function get_accValue( childID : uint ) : String
		{
			return currentValue;
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function onSliderUpdate( e : Event ) : void
		{
			currentValue = _master.accessibilityProperties.name + 'updated to ' + AccessibleSlider( _master ).currentValue;

			if ( Accessibility.active )
			{
				Accessibility.sendEvent( _master, 0, MSAAConstants.EVENT_OBJECT_VALUECHANGE, true );
			}
		}
	}
}
