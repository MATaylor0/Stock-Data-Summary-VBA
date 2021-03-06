Attribute VB_Name = "Module1"
Option Explicit

Sub summariseData()
    ' A macro to summarise stock price data to understand yearly price change, expressed as a value and percentage, and total stock volume
    ' Written by Matt Taylor
    
    ' Declaring counter variables and arrays of unknown size
    Dim i As Double
    Dim j As Double
    Dim k As Double
    Dim x As Integer
    Dim strTicker() As String
    Dim dblChange As Double
    Dim dblPercent As Double
    Dim dblVolume As Double
    Dim sheet As Worksheet
    
    On Error GoTo errorhandler
    
    x = 1
    For Each sheet In Worksheets
        Sheets(x).Select
        ' Count the number of values in column A & set counter variables
        i = Application.WorksheetFunction.CountA(Range("A:A")) - 1
        j = 1
        k = 1
        
        ' Redefining array based on rows of data available on the sheet
        ReDim strTicker(1 To i)
        
        ' Filling the array with data
        For i = 1 To i
            strTicker(i) = Cells(i + 1, 1)
        Next
        
        ' Summarise the Ticker code data
        i = i - 1
        Range("L2") = strTicker(1)
        For i = 1 To i
            dblVolume = dblVolume + Cells(i + 1, 7)
            If Not Cells(j + 1, 12) = strTicker(i) Then
                ' Write the next Ticker code
                Cells(j + 2, 12) = strTicker(i)
                ' Calculate the change in price for the previous ticker code
                dblChange = Cells(i, 6) - Cells(k + 1, 3)
                Cells(j + 1, 13) = dblChange
                Call formatChange(dblChange, j)
                ' Calculate the percentage change in price for the previous ticker code
                dblPercent = dblChange / Cells(k + 1, 3)
                Cells(j + 1, 14) = dblPercent
                ' Print the volume for the ticker code and reset for the next
                Cells(j + 1, 15) = dblVolume
                dblVolume = 0
                ' Iterate the counter variables
                k = i
                j = j + 1
            End If
        Next
        ' Calculate the change in price and volume for the final Ticker code
        dblChange = Cells(i, 6) - Cells(k + 1, 3)
        Cells(j + 1, 13) = dblChange
        Call formatChange(dblChange, j)
        Cells(j + 1, 14) = dblPercent
        Cells(j + 1, 15) = dblVolume
        
        ' Formatting the percentages
        Range("N:N").Select
        Selection.Style = "Percent"
        Selection.NumberFormat = "0.00%"
    
        ' Call challenge function
        Call findMax
        
        ' Call function to create headers
        Call createHeaders
        
        x = x + 1
    Next sheet
    
errorhandler:
    ' If a divide by zero error occurs when calculating the percentage change, override the variable to zero
    dblPercent = 0
    Resume Next
    
End Sub

Sub createHeaders()
    
    ' Create header names
    Range("L1") = "Ticker"
    Range("M1") = "Yearly Change"
    Range("N1") = "Percent Change"
    Range("O1") = "Total Stock Volume"
    
    Range("R2") = "Greatest % Increase"
    Range("R3") = "Greatest % Decrease"
    Range("R4") = "Greatest Total Volume"
    Range("S1") = "Ticker"
    Range("T1") = "Value"
    
    ' Autofit the column widths
    Range("M1:O1").Columns.AutoFit
    Range("R:R").Columns.AutoFit

End Sub

Sub formatChange(x, y)
    ' Use conditional formatting to colour the cells
    If x > 0 Then
        Cells(y + 1, 13).Interior.ColorIndex = 4
    Else
        Cells(y + 1, 13).Interior.ColorIndex = 3
    End If
    ' Change the formatting for Percent change to percentage
    Cells(y + 1, 14).NumberFormat = "0.00%"
End Sub

Sub findMax()
    Dim x As Integer
    Dim dblMax As Double
    Dim dblMin As Double
    Dim dblVMax As Double
    
    x = Application.WorksheetFunction.Count(Range("N:N"))
    
    For x = 1 To x
        If dblMax < Cells(x + 1, 14) Then
            dblMax = Cells(x + 1, 14)
            Range("S2") = Cells(x + 1, 12)
        End If
        If dblMin > Cells(x + 1, 14) Then
            dblMin = Cells(x + 1, 14)
            Range("S3") = Cells(x + 1, 12)
        End If
        If dblVMax < Cells(x + 1, 15) Then
            dblVMax = Cells(x + 1, 15)
            Range("S4") = Cells(x + 1, 12)
        End If
    Next
    
    Range("T2") = dblMax
    Range("T3") = dblMin
    Range("T4") = dblVMax
    Range("T2:T3").NumberFormat = "0.00%"

End Sub
