While 1
	$rec=PixelSearch(739,189,805,256,0xACACAC)
	if IsArray($rec) Then
		Send('{up}')
		Sleep(100)
		Send('{up}')
		;Send('{down}')
	EndIf
WEnd