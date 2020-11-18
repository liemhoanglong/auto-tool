#include<File.au3>
;tạo file để đọc và ghi
$fileInput= FileOpen("D:\input.txt",0)
$fileOutput = FileOpen("D:\output.txt",1)

Run("calc12.exe")			;chạy app calc12 ở chung folder
WinWaitActive("Calculator");chờ app mở lên
Sleep(500) 					;delay 500 micro giây

For $i=1 to _FileCountLines($fileInput);Tạo loop duyệt file input.txt
	$line= FileReadLine($fileInput,$i) ;đọc từng dòng
	AutoItSetOption("SendKeyDelay",200);delay 200 micro giây

	Send(StringMid($line, 1,1))			;truyền số đầu tiên cho app Calculator


	$operate=StringMid($line, 2,1)		;truyền dấu cho app Calculator

	;Vì auto ko hiểu + nên phải convert {+}
	if(StringCompare($operate,"+",0)) Then
		Send(StringMid($line, 2,1))
	Else
		Send("{+}")
	EndIf

	Send(StringMid($line, 3,1))			;truyền số thứ 2 cho app Calculator
	Send("=")							;truyền = cho app Calculator
	Sleep(1000)
	$actualResult = StringSplit($line,"=") ;lấy expected result trong input để test

	$result = ControlGetText("Calculator","","Static5") ; lấy out của app

	;$out= StringTrimLeft(StringTrimRight($result,1),1);format lại output cho giống expected result

	$out= StringTrimRight($result,1);format lại output cho giống expected result

	;MsgBox($MB_SYSTEMMODAL, "", $actualResult[2] & ", " & $out & ", "& StringCompare($actualResult[2],$out))

	;Check result trong file input với result của app
	If (StringCompare($actualResult[2],$out)) < 1 Then
		;FileWriteLine($fileOutput,$out);
		FileWriteLine($fileOutput,"Expected Result "&$actualResult[2]&"| Actual Result "&$out&"| Pass")
	Else
		;FileWriteLine($fileOutput,$out);
		FileWriteLine($fileOutput,"Expected Result "&$actualResult[2]&"| Actual Result "&$out&"| Fail");
	EndIf

	Send("{DEL}")	;clear output của app
Next

WinClose("Calculator") ; tắt calculator

