package accessibility.ui
{
	import accessibility.implementation.AccessibleButtonImplementation;

	public class AccessibleButton extends AccessibleSprite
	{

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function AccessibleButton()
		{
			super();
			this.buttonMode = true;
			this.accessibilityImplementation = new AccessibleButtonImplementation( this );
		}
	}
}
