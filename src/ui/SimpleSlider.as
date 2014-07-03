package ui
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import accessibility.ui.AccessibleSlider;

	public class SimpleSlider extends AccessibleSlider
	{

		//------------------------------------------------------------------------------
		//   Static Private Properties 
		//------------------------------------------------------------------------------

		static private var STEP : int = 20;
		static private var WIDTH : int = 500;
		static private var HEIGHT : int = 50;


		//------------------------------------------------------------------------------
		//   Private Properties 
		//------------------------------------------------------------------------------

		private var _thumb : Sprite;

		//------------------------------------------------------------------------------
		//   Constructor 
		//------------------------------------------------------------------------------

		public function SimpleSlider()
		{
			super();
			createChildren();
			positionChildren();
			addListeners();
			draw( false );
		}


		//------------------------------------------------------------------------------
		//   Public Functions 
		//------------------------------------------------------------------------------

		public function getCurrentValue() : String
		{
			return _thumb.x.toString();
		}

		//------------------------------------------------------------------------------
		//   Protected Functions 
		//------------------------------------------------------------------------------

		override protected function focusIn() : void
		{
			super.focusIn();
			draw( true );
		}

		override protected function focusOut() : void
		{
			super.focusOut();
			draw( false );
		}

		//------------------------------------------------------------------------------
		//   Private Functions 
		//------------------------------------------------------------------------------

		private function addListeners() : void
		{
			this.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
		}

		private function onKeyDown( e : KeyboardEvent ) : void
		{
			switch ( e.keyCode )
			{
				case Keyboard.RIGHT:
				case Keyboard.UP:
				{
					incrementSlider();
					break;
				}
				case Keyboard.LEFT:
				case Keyboard.DOWN:
				{
					decrementSlider();
					break;
				}
			}
		}

		private function decrementSlider() : void
		{
			if ( _thumb.x - STEP > 0 )
			{
				_thumb.x -= STEP;
				this.updateSliderValue( _thumb.x.toString());
			}
		}

		private function incrementSlider() : void
		{
			if ( _thumb.x + _thumb.width + STEP < WIDTH )
			{
				_thumb.x += STEP;
				this.updateSliderValue( _thumb.x.toString());
			}
		}

		private function draw( isFocused : Boolean ) : void
		{
			var thumbColour : Number = ( isFocused ) ? 0xCC0000 : 0x0000A0;
			_thumb.graphics.clear();
			_thumb.graphics.beginFill( thumbColour, 1 );
			_thumb.graphics.drawRect( 0, 0, 50, HEIGHT * 2 );
			_thumb.graphics.endFill();

			this.graphics.clear();
			this.graphics.beginFill( 0x000000, 1 );
			this.graphics.drawRect( 0, 0, WIDTH, HEIGHT );
			this.graphics.endFill();
		}

		private function positionChildren() : void
		{
			_thumb.x = 10;
			_thumb.y = -( HEIGHT / 2 );
		}

		private function createChildren() : void
		{
			_thumb = new Sprite();
			addChild( _thumb );
		}
	}
}
