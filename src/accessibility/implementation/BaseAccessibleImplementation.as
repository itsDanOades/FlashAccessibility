package accessibility.implementation
{
	import flash.accessibility.AccessibilityImplementation;

	import accessibility.ui.AccessibleSprite;

	public class BaseAccessibleImplementation extends AccessibilityImplementation
	{

		//------------------------------------------------------------------------------
		//   Protected Properties 
		//------------------------------------------------------------------------------

		protected var _master : AccessibleSprite;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function BaseAccessibleImplementation( component : AccessibleSprite )
		{
			super();
			this._master = component;
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		/**
		 *  @private
		 *  IAccessible method for returning the state of the Button.
		 *  States are predefined for all the components in MSAA.
		 *  Values are assigned to each state.
		 *
		 *  @param childID uint
		 *
		 *  @return State uint
		 */
		override public function get_accState( childID : uint ) : uint
		{
			var state : uint = MSAAConstants.STATE_SYSTEM_NORMAL;
			if ( _master && childID == 0 )
			{
				if ( _master.stage && _master.stage.focus === _master )
				{
					state = MSAAConstants.STATE_SYSTEM_FOCUSED;
				}
				else if ( _master.stage )
				{
					state = MSAAConstants.STATE_SYSTEM_FOCUSABLE;
				}
				else
				{
					state = MSAAConstants.STATE_SYSTEM_UNAVAILABLE
				}
			}

			return state;
		}
	}
}
