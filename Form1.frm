VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmMain 
   Caption         =   "CheckPowerNode"
   ClientHeight    =   2040
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5160
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   5160
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox cFixed 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Outtput Board Family"
      Height          =   255
      Left            =   3000
      TabIndex        =   2
      Top             =   600
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
      Top             =   960
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
      Top             =   840
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

Private Sub cAddStr_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
'If Button = 1 Then
'Call ReleaseCapture
'Call SendMessage(hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0)
'End If
End Sub

Private Sub cFamily_Click()

End Sub

Private Sub Image1_Click()
On Error GoTo ErrLib
Dim strMystr As String
Dim strFenPei() As String
Dim strNode() As String
Dim strV() As String
Dim intI As Integer
Dim intT As Integer
Dim strFamilyNode As String
Dim bCheckNull As Boolean
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
   Open strFileName For Input As #1
      Do Until EOF(1)
         Line Input #1, strMystr
            strMystr = Trim(strMystr)
            If strMystr <> "" Then
               strFenPei = Split(strMystr, ",")
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
      Print #2, ""
      Print #2, "test powered analog"
      Print #2,
        strNode = DellSameText(strNode)
         For i = 0 To UBound(strNode)
            If strNode(i) <> "" Then
               Print #2, "     test " & """" & strNode(i) & """"
               If cFixed.Value = 1 Then
                   Print #4, strNode(i) & "  Family ALL is 1;"
               End If
            End If
         Next
         Print #2,
         Print #2, "end test"
         Print #2,
         Print #2, "!====================================================================="
         Print #2,
         
         For i = 0 To UBound(strNode)
            If strNode(i) <> "" Then
               Print #2, "subtest " & """" & strNode(i) & """"
               Print #2, "   disconnect all"
               Print #2, "   connect i to nodes" & """" & strJinHao & UCase(strNode(i)) & """"
               Print #2, "   connect l to ground"
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
Exit Sub
ErrLib:
  On Error Resume Next
  Close #1
  If cFixed.Value = 1 Then
     Close #4
  End If
  Close #2
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
