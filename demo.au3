; Tutorial

; message box yes/no? default no
;MsgBox(324, 'Hello', "Long")

;
#include <MsgBoxConstants.au3 >
MsgBox($MB_ICONINFORMATION+$MB_YESNO, 'Hello', "Long")
