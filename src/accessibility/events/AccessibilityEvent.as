package accessibility.events
{
	import flash.events.Event;

	import accessibility.ui.AccessibleSprite;

	public class AccessibilityEvent extends Event
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const UPDATE : String = 'AccessibilityEvent.UPDATE';
		static public const ADDED : String = 'AccessibilityEvent.ADDED';
		static public const REMOVED : String = 'AccessibilityEvent.REMOVED';
		static public const TAB_UPDATE : String = 'AccessibilityEvent.TAB_UPDATE';
		static public const FOCUS : String = 'AccessibilityEvent.FOCUS';


		//------------------------------------------------------------------------------
		//   Public Properties 
		//------------------------------------------------------------------------------

		public var component : AccessibleSprite;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibilityEvent( type : String, component : AccessibleSprite )
		{
			super( type, true );
			this.component = component;
		}
	}
}
