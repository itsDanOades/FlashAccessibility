package ui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import accessibility.ui.AccessibleSprite;

	public class SimpleButton extends AccessibleSprite
	{

		//------------------------------------------------------------------------------
		//   Static Public Properties 
		//------------------------------------------------------------------------------

		static public const UNHIGHLIGHT_COLOUR : Number = 0x000000;
		static public const HIGHLIGHT_COLOUR : Number = 0xCC0000;


		//------------------------------------------------------------------------------
		//   Protected Properties 
		//------------------------------------------------------------------------------

		protected var _buttonText : String;
		protected var _textField : TextField;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function SimpleButton( buttonText : String )
		{
			super();
			this.buttonMode = true;
			this._buttonText = buttonText;
			createChildren();
			unhighlight();
		}


		//------------------------------------------------------------------------------
		//   Protected Functions 
		//------------------------------------------------------------------------------

		override protected function focusIn() : void
		{
			super.focusIn();

			highlight();
		}

		override protected function focusOut() : void
		{
			super.focusOut();

			unhighlight();
		}

		override protected function focusActivated() : void
		{
			super.focusActivated();
			highlight();
		}

		protected function draw( colour : Number ) : void
		{
			this.graphics.clear();
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawRect( 0, 0, 100, 100 );
			this.graphics.endFill();

			_textField.text = _buttonText;
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function createChildren() : void
		{
			var tf : TextFormat = new TextFormat();
			tf.color = 0xFFFFFF;
			tf.size = 15;
			tf.bold = true;
			tf.font = 'ariel';

			_textField = new TextField();
			_textField.selectable = false;
			_textField.defaultTextFormat = tf;
			_textField.autoSize = TextFieldAutoSize.CENTER;
			_textField.wordWrap = true;
			addChild( _textField );
		}

		private function unhighlight() : void
		{
			draw( UNHIGHLIGHT_COLOUR );
		}

		private function highlight() : void
		{
			draw( HIGHLIGHT_COLOUR );
		}
	}
}
