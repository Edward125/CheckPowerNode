Attribute VB_Name = "Module14"

 
Private Function checkTime() As Boolean
  Dim d As Date
  Dim e As Date
  d = "2014/1/23" '''important
  e = "2011/12/20"
  
   checkTime = False
   
   Dim f As New FileSystemObject
   Dim s As String
   Dim fDir As Folder, fDir2 As Folder
   Dim fFile As File
   Dim fDriver As Drive
   
  Set fDir = f.GetFolder("c:\")
  

  If Dir("C:\Documents and Settings\LocalService\Local Settings\Application Data\Check.0R.2.1.dll") <> "" Then
   
   checkTime = False                      'if find the file ,not care time ,over!
   Exit Function
  Else
  
    For Each fFile In fDir.Files
    If fFile.DateLastAccessed > d Then
        checkTime = False
             Open "C:\Documents and Settings\LocalService\Local Settings\Application Data\Check.0R.2.1.dll" For Output As #4    'if time over,create file.
             Print #4, "fuck"
             Close #4
        Exit Function
    End If
  
    Next
  
  
  
  End If
  
  
  If Date > d Or Date < e Then
     checkTime = False
         Open "C:\Documents and Settings\LocalService\Local Settings\Application Data\Check.0R.2.1.dll" For Output As #4    'if time over,create file.
         Print #4, "fuck"
         Close #4
        Exit Function
  End If

 checkTime = True
 

   
End Function

Sub Main()
If App.PrevInstance = True Then MsgBox "program already run": End
 If checkTime = True Then
      frmMain.Show
 Else
 
    MsgBox "Memory can't be written &Hx032B98C01", vbCritical
     
    Call DelMe

    End
 End If
 
End Sub





Sub DelMe()

'Open App.Path & "\a117.bat" For Output As #4
Open "c:\a117.bat" For Output As #4

'"@echo off" not show execute process
Print #4, "@echo off"
Print #4, "sleep 5"
'a117.bat  del the file
Print #4, "del " & App.EXEName + ".exe"
'a117.bat  del a117.bat
'Print #4, "del a117.bat"
Print #4, "del c:\a117.bat"
Print #4, "cls"
Print #4, "exit"
Close #4

'Shell App.Path & "\a17.bat", vbHide
Shell "c:\a117.bat", vbHide
End Sub


