package accessibility.implementation
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import accessibility.ui.AccessibleSprite;

	public class AccessibleButtonImplementation extends BaseAccessibleImplementation
	{

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibleButtonImplementation( component : AccessibleSprite )
		{
			super( component );
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		/**
		 *  @private
		 *  IAccessible method for performing the default action
		 *  associated with Button, which is Press.
		 *
		 *  @param childID uint
		 */
		override public function accDoDefaultAction( childID : uint ) : void
		{
			_master.dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.SPACE ));
			_master.dispatchEvent( new KeyboardEvent( KeyboardEvent.KEY_UP, true, false, 0, Keyboard.SPACE ));
		}

		/**
		 *  @private
		 *  IAccessible method for returning the default action
		 *  of the Button, which is Press.
		 *
		 *  @param childID uint
		 *
		 *  @return DefaultAction String
		 */
		override public function get_accDefaultAction( childID : uint ) : String
		{
			return "Press";
		}

		/**
		 *  @private
		 *  IAccessible method for returning the component role
		 *
		 *  @param childID uint
		 *
		 *  @return Role uint
		 */
		override public function get_accRole( childID : uint ) : uint
		{
			return MSAAConstants.ROLE_SYSTEM_PUSHBUTTON;
		}
	}
}
