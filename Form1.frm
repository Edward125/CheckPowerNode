VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "CheckPowerNode"
   ClientHeight    =   2040
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5160
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   5160
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox cBoardShort 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Check board_short.txt"
      Height          =   255
      Left            =   3000
      TabIndex        =   3
      Top             =   360
      Width           =   2055
   End
   Begin VB.CheckBox cFixed 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Outtput Board Family"
      Height          =   255
      Left            =   3000
      TabIndex        =   2
      Top             =   720
      Value           =   1  'Checked
      Width           =   2055
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   6480
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DefaultExt      =   "*.txt|*.*"
      DialogTitle     =   "open"
   End
   Begin VB.CheckBox cAddStr 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Node Name Add"
      Height          =   255
      Left            =   3000
      TabIndex        =   0
      Top             =   1080
      Width           =   1575
   End
   Begin VB.Label Label1 
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "#%"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   375
      Left            =   4560
      TabIndex        =   1
      Top             =   960
      Width           =   495
   End
   Begin VB.Image Image1 
      Height          =   2055
      Left            =   0
      Picture         =   "Form1.frx":030A
      Top             =   0
      Width           =   5160
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Option Explicit
Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Const WM_NCLBUTTONDOWN = &HA1
Private Const HTCAPTION = 2
Dim strFileName As String
Dim strBoardShortFileName As String
Dim strTmpPath As String

Private Sub cAddStr_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
'If Button = 1 Then
'Call ReleaseCapture
'Call SendMessage(hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0)
'End If
End Sub

Private Sub cFamily_Click()

End Sub



Private Sub cBoardShort_Click()

If cBoardShort.Value = 1 Then

    CommonDialog1.Filter = "*board_short*.txt|*board_short*.txt|*.*|*.*|"     '前面一個表示,後面一個是篩選
    CommonDialog1.ShowOpen
    strBoardShortFileName = CommonDialog1.FileName
    If strBoardShortFileName = "" Then cBoardShort.Value = 0
   ' Call Read_BoardShort_File
End If
End Sub

Private Sub Read_BoardShort_File()
On Error Resume Next
'Dim strTmpPath As String
Dim strTmpNode() As String
Dim strMystr As String
Dim intT As Integer
Dim bCheckNull As Boolean

strTmpPath = App.Path
If Right(strTmpPath, 1) <> "\" Then strTmpPath = strTmpPath & "\"

If strBoardShortFileName = "" Then Exit Sub

If Dir(strBoardShortFileName) <> "" Then
Kill strTmpPath & "PowerNodeTmp\*.*"
RmDir strTmpPath & "PowerNodeTmp"
MkDir strTmpPath & "PowerNodeTmp"
    Open strBoardShortFileName For Input As #5
       Do Until EOF(5)
         Line Input #5, strMystr
            
           intT = intT + 1
           strMystr = Trim(strMystr)
           
           If strMystr <> "" Then
               strTmpNode = Split(strMystr, "->")
               For i = 0 To UBound(strTmpNode) - 1
                   
                   Open strTmpPath & "PowerNodeTmp\" & Trim(strTmpNode(i)) For Output As #6
                       Print #6, Trim(strTmpNode(UBound(strTmpNode)))
                       
                   Close #6
               Next
              bCheckNull = True
           End If
           DoEvents
           
       Loop
    Close #5
  If bCheckNull = False Then
     MsgBox "The file is null!,please check!", vbCritical
    Exit Sub
  End If
End If
End Sub

Private Sub Image1_Click()
'On Error GoTo ErrLib
Dim strMystr As String
Dim strFenPei() As String
Dim strNode() As String
Dim strV() As String
Dim intI As Integer
Dim intT As Integer
Dim strFamilyNode As String
Dim bCheckNull As Boolean
Dim TmpNode As String
Dim strJinHao As String
 If cAddStr.Value = 1 Then
    strJinHao = "#%"
    Else
    strJinHao = ""
 End If
CommonDialog1.Filter = "*.txt|*.txt|*.*|*.*|"     '前面一個表示,後面一個是篩選
CommonDialog1.ShowOpen
strFileName = CommonDialog1.FileName
If strFileName = "" Then Exit Sub
If Dir(strFileName) <> "" Then
    Open strFileName For Input As #1
       Do Until EOF(1)
         Line Input #1, strMystr
           intT = intT + 1
           strMystr = Trim(strMystr)
           If strMystr <> "" Then
              bCheckNull = True
           End If
           DoEvents
           
       Loop
    Close #1
  If bCheckNull = False Then
     MsgBox "The file is null!,please check!", vbCritical
    Exit Sub
  End If
  ReDim strNode(intT + 1)
  ReDim strV(intT + 1)
   
  intI = 0
If cBoardShort.Value = 1 Then Call Read_BoardShort_File
   Open strFileName For Input As #1
      Do Until EOF(1)
         Line Input #1, strMystr
            strMystr = Trim(strMystr)
            If strMystr <> "" Then
               strFenPei = Split(strMystr, ",")
               If cBoardShort.Value = 1 Then
                   If Dir(strTmpPath & "PowerNodeTmp\" & Trim(strFenPei(0))) <> "" Then
                       Open strTmpPath & "PowerNodeTmp\" & Trim(strFenPei(0)) For Input As #7
                         Line Input #7, TmpNode
                       Close #7
                       If Trim(TmpNode) <> "" Then
                          strFenPei(0) = Trim(TmpNode)
                       End If
                   End If
               End If
               
               strNode(intI) = strFenPei(0)
               strV(intI) = strFenPei(1)
               intI = intI + 1
            End If
            DoEvents
      Loop
      
   Close #1



Dim strCurrentPath As String
   strCurrentPath = App.Path
   If Right(strCurrentPath, 1) <> "\" Then strCurrentPath = strCurrentPath & "\"
   If Dir(strCurrentPath & "Power_Node.txt") <> "" Then FileCopy strCurrentPath & "Power_Node.txt", strCurrentPath & "Power_Node.vbbak.txt"
 If cFixed.Value = 1 Then
     Open strCurrentPath & "3070_Fixed_Node.txt" For Output As #4
 End If
 Open strCurrentPath & "Power_Node.txt" For Output As #2
      Print #2, "!!!!    2    0    1 1274062712  Vc000                                         "
      Print #2,
      Print #2, "!####################################################################"
      Print #2, "!CheckPowerNode_2.5"
      Print #2, "!Wistron 3B ATE"
      Print #2, "!! nonanalog pins 1,2,3,4"
      Print #2, "!! source dcv,am3,terminated 5000,ico1,on"
      Print #2, "!! auxiliary dcv,am3.5,ico1,on"
      Print #2, "!####################################################################"
      Print #2,
      Print #2, "test powered analog"
      Print #2,
        strNode = DellSameText(strNode)
         For i = 0 To UBound(strNode)
            If strNode(i) <> "" Then
'               If cBoardShort.Value = 1 Then
'                   If Dir(strTmpPath & "PowerNodeTmp\" & Trim(strNode(i))) <> "" Then
'                       Open strTmpPath & "PowerNodeTmp\" & Trim(strNode(i)) For Input As #7
'                         Line Input #7, TmpNode
'                       Close #7
'                       Print #2, "     test " & """" & TmpNode & """"
'                   End If
'                 Else
'                  Print #2, "     test " & """" & strNode(i) & """"
'               End If
                 
                 Print #2, "     test " & """" & strNode(i) & """"
                 
                 
               If cFixed.Value = 1 Then
                   Print #4, strNode(i) & "  Family ALL is 1;"
               End If
            End If
         Next
         Print #2,
         Print #2, "end test"
         Print #2,
         Print #2, "!===================================================================="
         Print #2,
         
         For i = 0 To UBound(strNode)
            If strNode(i) <> "" Then
               Print #2, "subtest " & """" & strNode(i) & """"
               Print #2, "   disconnect all"
             '  Print #2, "  !connect s to nodes "
             '  Print #2, "  !connect a to nodes "
               Print #2, "   connect i to nodes" & """" & strJinHao & UCase(strNode(i)) & """"
               Print #2, "   connect l to ground"
             '  Print #2, "   !source dcv,am3,terminated 5000,ico1,on"
             '  Print #2, "   !auxiliary dcv,am3.5,ico1,on"
               Print #2, "   detector dcv , expect " & strV(i)
               Print #2, "   measure " & strV(i) & "*" & "1.1," & strV(i) & "*" & "0.9"
               Print #2, "end subtest"
               Print #2,
            End If
         Next
          
         DoEvents
Close #2
  If cFixed.Value = 1 Then
     Close #4
  End If

      MsgBox "Save OK!" & Chr(13) & strCurrentPath & "Power_Node.txt", vbInformation
   Else
      MsgBox "File no found!", vbCritical
End If
Call DelFile
Call OpenFilePath
Exit Sub
ErrLib:
  On Error Resume Next
  
  Close #1
  If cFixed.Value = 1 Then
     Close #4
  End If
  Close #2
  Call DelFile
  MsgBox "Open file type error!,please check!", vbCritical
End Sub
Private Function DellSameText(strTmpStr() As String)
  For i = 0 To UBound(strTmpStr)
     For t = i + 1 To UBound(strTmpStr)
        If UCase(strTmpStr(i)) = UCase(strTmpStr(t)) Then
           strTmpStr(i) = ""
        End If
     Next
  Next
  DellSameText = strTmpStr
End Function

'Private Sub Image1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
'If Button = 1 Then
'Call ReleaseCapture
'Call SendMessage(hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0)
'End If

'End Sub

Private Sub Label1_Click()
 Call Image1_Click
End Sub

Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
'If Button = 1 Then
'Call ReleaseCapture
'Call SendMessage(hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0)
'End If
End Sub
Private Sub DelFile()
On Error Resume Next
If Dir("c:\1.txt") <> "" Then Debug.Print a
Kill strTmpPath & "PowerNodeTmp\*.*"
RmDir strTmpPath & "PowerNodeTmp"

'cBoardShort.Value = 0
End Sub
Private Sub OpenFilePath()
On Error Resume Next
Open "c:\wxhzw_xxnvren.bat" For Output As #9
    Print #9, "cd " & App.Path
    Print #9, "start Power_Node.txt"
    Print #9, "del c:\wxhzw_xxnvren.bat"
    Print #9, "exit"
    
Close #9
a = Shell("c:\wxhzw_xxnvren.bat", vbHide)
End Sub
