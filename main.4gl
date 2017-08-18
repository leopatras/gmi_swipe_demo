MAIN
    DEFINE i,pos INT
    DEFINE arr DYNAMIC ARRAY OF RECORD
      title STRING,
      subtitle STRING,
      detail STRING
    END RECORD

    FOR i=1 TO 100
      LET arr[i].title=sfmt("Title %1",i)
      LET arr[i].subtitle=sfmt("SubTitle %1",i)
      LET arr[i].detail=sfmt("Detail %1",i)
    END FOR
    CALL fgl_settitle("Swipe Right to Left")
    OPEN FORM f FROM "main"
    DISPLAY FORM f
    DISPLAY ARRAY arr TO scr.* ATTRIBUTE(ACCEPT=FALSE,CANCEL=FALSE,DOUBLECLICK=select,ACCESSORYTYPE=DISCLOSUREINDICATOR)
      --swiping right to left in this display array activates the
      --delete and select actions
      --see the IOS mail app list view
      ON DELETE
        MESSAGE sfmt("Deleted item %1",arr_curr())
      ON ACTION forward ATTRIBUTE(ROWBOUND,TEXT="Forward")
        MESSAGE sfmt("Forward item %1",arr_curr())
      ON ACTION select
        LET pos=arr_curr() 
        OPEN WINDOW detail WITH FORM "detail"
        --swiping left in this detail display array achieves "cancel"
        --see the IOS mail app in detail view
        DISPLAY ARRAY arr TO detail.* ATTRIBUTE(ACCEPT=FALSE)
          BEFORE DISPLAY
            CALL fgl_set_arr_curr(pos)
          BEFORE ROW
            LET pos=arr_curr()
            CALL fgl_settitle(sfmt("%1 of %2",pos,arr.getLength()))
        END DISPLAY
        CLOSE WINDOW detail
        CALL fgl_set_arr_curr(pos)
    END DISPLAY
END MAIN
