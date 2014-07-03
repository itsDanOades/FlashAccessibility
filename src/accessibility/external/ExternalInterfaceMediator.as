package accessibility.external
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	public class ExternalInterfaceMediator extends EventDispatcher
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const FOCUS_ON_FIRST : String = 'focusOnFirst';
		static public const FOCUS_ON_LAST : String = 'focusOnLast';
		static public const FOCUS_BEFORE_FLASH : String = 'focusBeforeFlash';
		static public const FOCUS_AFTER_FLASH : String = 'focusAfterFlash';
		static public const FOCUS_ON_FLASH : String = 'focusOnFlash';
		static public const SEND_SCREEN_READER_ALERT : String = 'sendScreenReaderAlert';

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function ExternalInterfaceMediator()
		{
			super();
			init();
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		public function callPage( functionName : String, params : Object ) : void
		{
			try
			{
				if ( ExternalInterface.available )
				{
					ExternalInterface.call( functionName, params );
				}
			}
			catch ( e : Error )
			{
				//If running the swf file locally you may encounter security sandbox errors, add the file location to your
				//trusted Flash locations in the Global Security Settings
			}
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function init() : void
		{
			try
			{
				if ( ExternalInterface.available )
				{
					ExternalInterface.addCallback( FOCUS_ON_FIRST, focusOnFirst );
					ExternalInterface.addCallback( FOCUS_ON_LAST, focusOnLast );
				}
			}
			catch ( e : Error )
			{
				//If running the swf file locally you may encounter security sandbox errors, add the file location to your
				//trusted Flash locations in the Global Security Settings
			}
		}

		private function focusOnFirst() : void
		{
			dispatchEvent( new ExternalInterfaceEvent( ExternalInterfaceEvent.CALL_FROM_PAGE, FOCUS_ON_FIRST, {}));
		}

		private function focusOnLast() : void
		{
			dispatchEvent( new ExternalInterfaceEvent( ExternalInterfaceEvent.CALL_FROM_PAGE, FOCUS_ON_LAST, {}));
		}
	}
}
