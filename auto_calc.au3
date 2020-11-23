#include<File.au3>
;tạo file để đọc và ghi
$fileInput= FileOpen("D:\input.txt",0)
$fileOutput = FileOpen("D:\output.csv",1)

;ghi dòng đầu tiên cho file output.csv
FileWriteLine($fileOutput,"No,No1,operater,No2,Expected Result,Actualy Result,Status"& @CRLF)

Run("calc.exe")					;chạy app calc
WinWaitActive("Calculator")		;chờ app mở lên
Sleep(500) 						;delay 500 micro giây

For $i=1 to _FileCountLines($fileInput);Tạo loop duyệt file input.txt
	$line= FileReadLine($fileInput,$i) ;đọc từng dòng
	AutoItSetOption("SendKeyDelay",200);delay 200 micro giây

	$no1=StringMid($line, 1,1)
	Send($no1)							;truyền số đầu tiên cho app Calculator

	$operate=StringMid($line, 2,1)		;truyền dấu cho app Calculator
	;Vì autoIT ko hiểu kí tự + nên phải convert {+}
	if(StringCompare($operate,"+",0)) Then
		Send(StringMid($line, 2,1))
	Else
		Send("{+}")
	EndIf

	$no2=StringMid($line, 3,1)
	Send($no2)							;truyền số thứ 2 cho app Calculator

	Send("=")							;truyền dấu = cho app Calculator
	Sleep(100)
	$actualResult = StringSplit($line,"=") ;lấy expected result trong input để test

	Sleep(250)
	Send("^c")			;crtl + C
	Sleep(250)
	$result = ClipGet() ;lấy out của app

	$out = $result

	;MsgBox($MB_SYSTEMMODAL, "", $actualResult[2] & ", " & $out & ", "& StringCompare($actualResult[2],$out))

	;Check result trong file input với result của app
	If (StringCompare($actualResult[2],$out)) < 1 Then
		;FileWriteLine($fileOutput,$out);
		FileWriteLine($fileOutput,$i&','&$no1&','&$operate&','&$no2&','&$actualResult[2]&","&$out&",Pass"& @CRLF)
	Else
		;FileWriteLine($fileOutput,$out);
		FileWriteLine($fileOutput,$i&','&$no1&','&$operate&','&$no2&','&$actualResult[2]&","&$out&",Fail"& @CRLF)
	EndIf

	Send("{DEL}")	;clear output của app
Next

WinClose("Calculator") ; tắt calculator

