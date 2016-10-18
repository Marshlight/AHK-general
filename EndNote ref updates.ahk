; This AutoHotKey script performs the following actions:
; 1. Checks that EndNote is open
; 2. Initiates "Find Reference Updates" for selected publications
; 3. Checks for the existence of a "Review Available Updates" window, then activates that window
; 4. Automates the acceptance of empty field changes for each record, or skips records with no "Update Empty Fields" option
;
; To use: 
; 1. Turn off EndNote's A)"We were unable to find a reliable match for this record" error, and B) "No updates were found at this time." error
; 2. Select desired publications to update
; 3. Open or reload this AutoHotKey file
; 4. Press ctrl-shift-f (f for find!)
;
; This script written by Melissa Day                                  

^+f::

SetTitleMatchMode,1 ; title must begin with String
IfWinExist,EndNote  ; make sure EndNote is open first
{
  Send !r      ; press alt r to access the references menu
  Send {f 3}   ; press f 3x to access "Find Reference Updates"
  Send {ENTER} ; enter to choose
  sleep,200    ; wait

  Loop 
  {
    SetTitleMatchMode,2 ; title must contain string
    IfWinExist,Review Available Updates       ; wait for correct window
;    WinWaitActive,Review Available Updates   ; alternative
;    If WinActive("Review Available Updates") ; alternative
    {
;      MsgBox, Active-Review Available Updates          ; checkpoint
      WinActivate
      ControlGet, status_UEF , Enabled, , Update Empty Fields -> 
      ControlGet, status_skip, Enabled, , Skip
;      MsgBox, UEF #%status_UEF% & skip #%status_skip%  ; checkpoint

;;;;; If Update Empty Fields button is available, click it & save
      If (status_UEF = 1) {
        ControlClick, Update Empty Fields ->, Review Available Updates
        sleep,1000       ; wait (length is important here)
        ControlClick, Save Updates, Review Available Updates
        sleep,1000       ; wait
      }

;;;;; If Update Available Fields isn't available, click Skip instead
      else if (status_UEF = 0) and (status_skip = 1) {
        ControlClick, Skip, Review Available Updates 
      }

;;;;; If Update Available Fields AND Skip aren't available, click Cancel
      else if (status_UEF = 0) and (status_skip = 0) {
        ControlClick, Cancel, Review Available Updates 
      }

      sleep,3000        ; wait for entry to advance

;;;;; To thwart screensaver in case of long runs
      MouseMove,  1, 0, 1, R ; Move the mouse one pixel to the right
      MouseMove, -1, 0, 1, R ; Move the mouse back one pixel

    }
  }
}

; Old loop action code:
;        Send {TAB}   ; tab key to position on "Update Empty Fields"
;        sleep,300    ; wait
;        Send {ENTER} ; enter to choose 
;                     ; NOTE: this will cancel if no "Update Empty Fields"
;        sleep,300    ; wait
;        Send {Left}  ; left key choose "Save Updates"
;        sleep,300    ; wait
;        Send {ENTER} ; enter to choose
;        sleep,3000   ; wait