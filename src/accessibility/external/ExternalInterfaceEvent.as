package accessibility.external
{
	import flash.events.Event;

	public class ExternalInterfaceEvent extends Event
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const CALL_FROM_PAGE : String = 'ExternalInterfaceEvent.CALL_FROM_PAGE';
		static public const CALL_TO_PAGE : String = 'ExternalInterfaceEvent.CALL_TO_PAGE';


		//------------------------------------------------------------------------------
		//   Public Properties 
		//------------------------------------------------------------------------------

		public var functionName : String;
		public var additionalParams : Object;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function ExternalInterfaceEvent( type : String, functionName : String, additionalParams : Object )
		{
			super( type );
			this.functionName = functionName;
			this.additionalParams = additionalParams;
		}
	}
}
