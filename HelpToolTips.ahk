/*
---------------------------------------------------------------------------
Function:
    To show defined GUI control help tooltips on hover.
---------------------------------------------------------------------------
*/

HelpToolTips( _Messages, _Delay := 300, _Duration := 0 ) {
    OnMessage( 0x200, Receive )

    Receive( wParam, lParam, msg, hwnd ) {
        static PrevHwnd := 0

        if ( hwnd != PrevHwnd ) {
            ToolTip()

            CurrControl := GuiCtrlFromHwnd( hwnd )

            if ( CurrControl && CurrControl.Name && _Messages.Has( CurrControl.Name ) ) {
                SetTimer () => ToolTip( _Messages[ CurrControl.Name ] ), - _Delay

                if ( _Duration ) {
                    SetTimer () => ToolTip(), - ( _Delay + _Duration )
                }
            }

            PrevHwnd := hwnd
        }
    }
}
