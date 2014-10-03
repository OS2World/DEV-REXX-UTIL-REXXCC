/* ------------------------------------------------------------------ */
/* REXXCC2.CMD - simple WPS front end for REXXCC.CMD v3.00 and above  */
/*                                                                    */
/* (c) 1995 - 1997 Bernd Schemmer                                     */
/*                                                                    */
/* Author:                                                            */
/*   Bernd Schemmer                                                   */
/*   Baeckerweg 48                                                    */
/*   D-60316 Frankfurt                                                */
/*   Germany                                                          */
/*   CompuServe: 100104,613                                           */
/*                                                                    */
/* Initial Release:                                                   */
/*   18.05.1995 /bs                                                   */
/* Last Update:                                                       */
/*   01.06.1995 /bs v1.00                                             */
/*     - version 1.00                                                 */
/*   15.06.1995 /bs v1.01                                             */
/*     - use TIMEOUT events for the compile status window             */
/*   25.10.1995 /bs v1.10                                             */
/*     - added the support for the new REXXCC parameter /CMode and    */
/*     - /ShowDate                                                    */
/*                                                                    */
/* Usage:                                                             */
/*  {RX} REXXCC2                                                      */
/*                                                                    */
/* Parameters:                                                        */
/*   *** no parameter possible for programs running under RX ***      */
/*                                                                    */
/* Note:                                                              */
/*   The prefix 'RX' is possible but not neccessary, you should only  */
/*   use it if you create an object for REXXCC/2 (see install.cmd).   */
/*                                                                    */
/*   This program needs the OS/2 REXX dll REXXUTIL and                */
/*   the "Rexx Dialog" package.                                       */
/*                                                                    */
/*   CAUTION: The documentation for "Rexx Dialog" states that there   */
/*            should be a DLL called RX.DLL. This is a typo!          */
/*            "Rexx Dialog" consists out of the file RX.EXE and       */
/*            RXDLG.DLL.                                              */
/*                                                                    */
/*   "Rexx Dialog" is an excellent REXX extension for using PM        */
/*   dialogs in REXX programs developed by Jeff Glatt.                */
/*   "Rexx Dialog" is distributed as freeware.                        */
/*   The neccessary parts of this package are included in the         */
/*   archiv containing this program.                                  */
/*   You may view RX.INF, the online help for "Rexx Dialog", for      */
/*   further information about using "Rexx Dialog".                   */
/*   You can get the original "Rexx Dialog" package from your         */
/*   favorite BBS or CompuServe (GO OS2DF1, Libary 6).                */
/*   The name of the archiv is RXDLG10.ZIP.                           */
/*   Again, "Rexx Dialog" is a real good work. Thanks Jeff.           */
/*                                                                    */
/*   See the file REXXCC.CMD for further information about the        */
/*   "compiler" REXXCC.CMD.                                           */
/*                                                                    */
/*   Workarounds for bugs (well, I think that are bugs) in            */
/*   Rexx Dialog 1.0 are marked with (*?*)                            */
/*                                                                    */
/*   REXXCC/2 saves it configuration in an ini file called            */
/*   REXXCC2.INI. The search algorithm for this file is:              */
/*        1. search in the current directory                          */
/*        2. if not found: search in the DPATH directorys             */
/*        3. if not found: search in the directory with               */
/*           REXXCC2.CMD                                              */
/*        4. if not found: use defaults (don't load an inifile)       */
/*                                                                    */
/* Hints:                                                             */
/*                                                                    */
/*   IMPORTANT: YOU CAN ONLY USE A PM EDITOR FROM WITHIN REXXCC/2!!!  */
/*                                                                    */
/*   The keyboard handling in version 1.0 of Rexx Dialog is limited   */
/*   and has some minor bugs. So avoid using the keyboard to change   */
/*   the active dialog element.                                       */
/*                                                                    */
/*   If your WPS seems to lockup while using REXXCC/2 hit CTRL-ESC    */
/*   several times and wait at least 30 seconds. Normally OS/2 will   */
/*   then popup a dialog to allow aborting REXXCC/2.                  */
/*                                                                    */
/* Developed for using on 1024*768 display sizes but works also in    */
/* the resolution 800*600. I haven't tested it in VGA resolution      */
/* because I think it's silly to use OS/2 in VGA mode.                */
/* For display resolutions higher than 1024*768 you must change the   */
/* window dimensions and the control positions & sizes in the         */
/* source code yourself.                                              */
/*                                                                    */
/* Distribution                                                       */
/*   This program is part of the REXXCC package. Please see the file  */
/*   REXXCC.CMD for my distribution policy.                           */
/*   See the file RX.INF for the using & distribution policy for      */
/*   Rexx Dialog.                                                     */
/* ------------------------------------------------------------------ */

                        /* init some global variables                 */
  parse upper source . . prog.__FullName

  prog.__name = fileSpec( 'N', prog.__FullName )

  prog.__Path = fileSpec( 'D', prog.__FullName ) || ,
                fileSpec( 'P', prog.__FullName )
                    /* prog.__Path should never end with a backslash  */
  if right( prog.__Path,1 ) = '\' then
    prog.__Path = dbrright( prog.__Path,1 )

                        /* OS/2 environment                           */
  prog.__env = 'OS2ENVIRONMENT'

                        /* version of REXXCC/2                        */
  prog.__Version = 'v1.10'

                        /* version of the inifile                     */
  prog.__IniFileVersion = 'v1.00'

                        /* name of REXXCC/2 for the dialogs           */
  prog.__vName = 'REXXCC/2'

                        /* copyright note                             */
  prog.__vCopyright = '(c) Bernd Schemmer 1997'

                        /* program exit code                          */
  prog.__ExitCode = 255

                        /* name for the inifile                       */
  prog.__IniFileName = 'REXXCC2.INI'

                        /* name of the stems all procedures must know */
  exposeList = 'prog. global. REXXCC. REXXCC2. window. CRLF'

                        /* ASCII codes for CR/LF                      */
  CRLF = '0D0A'x


/* ------------------------------------------------------------------ */
                        /* load the DLL REXXUTIL                      */
                        /* (we need REXXUTIL for searching RX.EXE     */
  if LoadRexxUtil() <> 1 then
  do
    say prog.__Name || ,
        '- Error: Can not load REXXUTIL!' || '07'x
    exit 255
  end /* if LoadRexxUtil() <> 1 then */

/* ------------------------------------------------------------------ */
                        /* check the address environment              */
  if address() <> 'RXDLG' then
  do
                        /* THIS part is only executed if NOT running  */
                        /* under RXDLG!                               */

                        /* not currently running under RX             */

                        /* check for parameter                        */
    parse arg thisParms
    if thisParms <> '' then
    do
                        /* parameter are not possible for programs    */
                        /* running under "Rexx Dialog"                */
      say 'Usage: {RX} 'prog.__Name
      exit 2
    end /* if thisParms <> '' then */

                        /* search RX.EXE                              */
    prog.__RX =  SearchProgram( 'RX.EXE' )
    if prog.__RX = '' then
    do
                        /* RX.EXE not found                           */
      say prog.__Name || ,
          '- Error: Can not find RX.EXE!' || '07'x
      exit prog.__ExitCode
    end /* if SearchProgram( 'RX.EXE' ) = '' then */
    else
    do
                        /* RX.EXE found -- call it with this file as  */
                        /* parameter.                                 */
      ADDRESS 'CMD' '@' || prog.__RX prog.__FullName
      exit rc
    end /* else */
  end /* if adress() <> 'RXDLG' then */

/* ------------------------------------------------------------------ */
                        /* the ADDRESS environment is okay --         */
                        /* already running under RX.EXE               */

/* ------------------------------------------------------------------ */
                        /* install error handler(s)                   */
  SIGNAL ON NOVALUE Name NoValue

/* ------------------------------------------------------------------ */
                        /* init the global data                       */
  call InitVariables

                        /* init the data for Rexx Dialog              */
  call InitRxDlg

/* ------------------------------------------------------------------ */
                        /* check if RXQUEUE is in one of the PATH     */
                        /* directorys                                 */
  if SearchProgram( 'RXQUEUE.*' ) = '' then
  do
    call ShowErrorMsg , 'Can not find the program RXQUEUE. ' || crlf ,
                        'Ensure that RXQUEUE is in one of the PATH directorys.'
    exit 255
  end /* if SearchProgram( ... */

/* ------------------------------------------------------------------ */
                        /* search the ini file                        */
  curIniFileName = ''   /* default: no inifile found                  */

                        /* show a status msg                          */
  call ShowStatusMsg 'OPEN', 'Searching an ini file ...'

                        /* update the status msg                      */
  call ShowStatusMsg 'UPDATE', '=' '00'x 'Searching in the current directory ... '

                        /* search in the current directory            */
  if FileExist( directory() || '\' || prog.__IniFileName ) <> 0 then
    curIniFileName = directory() || '\' || prog.__IniFileName

                        /* update the status msg                      */
  call ShowStatusMsg 'UPDATE', '=' '00'x 'Searching the directorys in the DPATH ...'

                        /* search in the DPATH directorys             */
  if curIniFileName = '' then
    curIniFileName = SearchDataFile( prog.__IniFileName )

                        /* search in the directory with REXXCC.CMD    */
  if curIniFileName = '' then
  do
                        /* update the status msg                      */
    call ShowStatusMsg 'UPDATE', '=' '00'x 'Searching the directory with REXXCC2.CMD ... '

    if FileExist( prog.__Path || '\' || prog.__IniFileName ) <> 0 then
      curIniFileName = prog.__Path || '\' || prog.__IniFileName
  end /* if curIniFileName = '' then */

                        /* load the infile if found                   */
  if curIniFileName <> '' then
    call LoadSaveConfigData 'LOAD', curIniFileName
  else                  /* close the status msg                       */
    call ShowStatusMsg 'CLOSE'


/* ------------------------------------------------------------------ */
                        /* setup the variables for the main dialog    */

                        /* main dialog title                          */
  MainWindowTitle = prog.__vName prog.__Version prog.__vCopyright

                        /* groups & fields for the main dialog        */
  i = 0

                        /* drop down box for the source file          */
  i = i+1                       ; md.__SourceFileDropBox = i
  RXTYPE.i  = 'DROP'
  RXFLAGS.i = ' '
  RXLABEL.i = 'SourceFile:'
  RXINFO.i  = '1 1 1000'
  RXVAL.i   = 'sourceFiles'
  RXX.i     = 120
  RXY.i     = 245

                        /* drop down box for the target file          */
  i = i+1                       ; md.__TargetFileDropBox = i
  RXTYPE.i  = 'DROP'
  RXFLAGS.i = ' '
  RXLABEL.i = 'TargetFile:'
  RXINFO.i  = '1 1 1000'
  RXVAL.i   = 'targetFiles'
  RXX.i     = 120
  RXY.i     = 218

                        /* drop down box for the copyright file       */
  i = i+1                       ; md.__CopyrightFileDropBox = i
  RXTYPE.i  = 'DROP'
  RXFLAGS.i = ' '
  RXLABEL.i = 'CopyrightFile:'
  RXINFO.i  = '1 1 1000'
  RXVAL.i   = 'copyrightFiles'
  RXX.i     = 120
  RXY.i     = 191

                        /* push buttons for the file dialogs          */
  i=i+1                         ; md.__SourceTargetCopyrightPushButtons = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Search | Search | Search '
  RXINFO.i  = '3 1 0'
  RXVAL.i   = '1'
  RXX.i     = 365
  RXY.i     = 185

        /* push buttons for the misc. action on the s/t/c files       */
  i=i+1                         ; md.__MiscActionPushButtons = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = ' Edit copyrightFile | Use default targetDir | Create Tokenimage '
  RXINFO.i  = '3 1 200'
  RXVAL.i   = '1'
  RXX.i     = 445
  RXY.i     = 185

                        /* radio buttons for the mode of REXXCC       */
  i=i+1                         ; md.__ModeRadioButtons = i
  RXTYPE.i  = 'RADIO'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Compress | Compile | Mode'
  RXINFO.i  = '2 1 0'
  RXVAL.i   = REXXCC.__Mode
  RXX.i     = 505
  RXY.i     = 75

                        /* check boxes for the REXXCC options         */
  i=i+1                         ; md.__OptionCheckBoxes = i
  RXTYPE.i  = 'CHECK'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Add Code | Ignore Date | Ignore Version | Ignore Extension | ',
              'Overwrite | Use Source | Use CMode | ShowDate | REXXCC Options '
  RXINFO.i  = '8 2 0'
  RXVAL.i   = REXXCC.__Options
  RXX.i     = 15
  RXY.i     = 50

                        /* push buttons for the actions               */
  i=i+1                         ; md.__ActionPushButtons = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Exit | Reset | Options '
  RXINFO.i  = '3 3 0'
  RXVAL.i   = '3'
  RXX.i     = 130
  RXY.i     = 5

                        /* push buttons for compiling                 */
  i=i+1                         ; md.__CompilePushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Compile'
  RXINFO.i  = '1 1 0'
  RXVAL.i   = '1'
  RXX.i     = 370
  RXY.i     = 5

                        /* push buttons for compressing               */
  i=i+1                         ; md.__CompressPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Compress'
  RXINFO.i  = '1 1 0'
  RXVAL.i   = '1'
  RXX.i     = 370
  RXY.i     = 5

                        /* spin control for the linecount value       */
  i=i+1                         ; md.__LineCountSpin = i
  RXTYPE.i  = 'SPIN'
  RXFLAGS.i = ' '
  RXLABEL.i = '255 0 Linecount:'
  RXINFO.i  = '1 1 60'
  RXVAL.i   = REXXCC.__LineCount
  RXX.i     = 430
  RXY.i     = 120

                        /* push button for about                      */
  i=i+1                         ; md.__AboutPushButtons = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'About'
  RXINFO.i  = '1 1 0'
  RXVAL.i   = '1'
  RXX.i     = 535
  RXY.i     = 5

                        /* no. of groups in the main window           */
  noOfGroupsInMainWIn = i

/* ------------------------------------------------------------------ */

                        /* main program loop                          */
  do forever
                        /* check if the main window is already open   */
    RxQuery '"'mainWindowTitle'"'
    if rc = 0 then
    do
                    /* main window not yet open -> show the dialog    */
      RxDlg noOfGroupsInMainWin  ,  /* no. of groups                  */
            '"'mainWindowTitle'"',  /* window Title                   */
            'WINDOW.__MAINWINDOWDIM'  , /* dimension                  */
            'NOCLOSE|RESULT|KEYS'   /* flags, possible values:        */
                                    /* SIZE MIN SMALL MODAL NOCLOSE   */
                                    /* RESULT KEYS ONE NEWSIZE        */


                                    /* update the entry fields of the */
                                    /* drop down boxes                */
      if sourceFiles.0 <> '' then
        RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox 1 'VAL' sourceFiles.0

      if targetFiles.0 <> '' then
        RxSet '"'MainWindowTitle'"' md.__TargetFiledropBox 1 'VAL' targetFiles.0

      if copyrightFiles.0 <> '' then
        RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox 1 'VAL' copyrightFiles.0

    end /* if rc = 0 then */

                                    /* show the correct action button */
                                    /* (compile or compress)          */
    if value( 'RXVAL.' || md.__ModeRadioButtons ) = 2 then
    do
      RxSet '"'MainWindowTitle'"' md.__CompressPushButton 1 'HIDE' 0
      RxSet '"'MainWindowTitle'"' md.__CompilePushButton  1 'SHOW' 0
    end /* if */
    else
    do
      RxSet '"'MainWindowTitle'"' md.__CompilePushButton  1 'HIDE' 1
      RxSet '"'MainWindowTitle'"' md.__CompressPushButton 1 'SHOW' 0
    end /* else */

                        /* perform user actions                       */
    RxDlg '"'mainWindowTitle'"' 0

                        /* update REXX variables                      */
    RxDlg '"'mainWindowTitle'"' 2

                        /* clear the PM message queue                 */
    RxDlg '""' 255

                        /* process the RxDlg return code              */

    /* ------------------ alt keycode processing -------------------- */
    /* (*) neccessary, because accelerator keys are not handled in    */
    /*     the version 1.0 of Rexx Dialog                             */

    select

      when rxID = -1 then
      do
                        /* ALT-letter pressed                         */

                        /* rxSubID = letter                           */
        rxSubId = translate( rxSubID )

        possibleKeys    = 'S T C E R O M A X'
        rxIDsForKeys    = md.__SourceTargetCopyrightPushButtons ,
                          md.__SourceTargetCopyrightPushButtons ,
                          md.__SourceTargetCopyrightPushButtons ,
                          md.__ActionPushButtons ,
                          md.__ActionPushButtons ,
                          md.__ActionPushButtons ,
                          md.__ActionPushButtons ,
                          md.__AboutPushButtons ,
                          md.__ActionPushButtons
        rxSubIDsForKeys = '3 2 1 1 2 3 4 1 1'

        i = wordPos( rxSubId, possibleKeys )
        if i <> 0 then
        do
                        /* change the rxID & the rxSubID to the IDs   */
                        /* for the dialog element using this hotkey   */
          rxID = word( rxIDsForKeys, i )
          rxSubID = word( rxSubIDsForKeys, i )
        end /* if i <> 0 then */
      end /* if */

      otherwise
        nop
    end /* select */


    select
      /* ------------------ time out action ------------------------- */
      when rxID = 0 & rxSubID = 0 then
      do
                        /* timeout occured                            */
      end /* when */

      /* ------------------ key pressed action ---------------------- */
      when rxID < 0 & rxID > -11 then
      do
      end /* when */

      /* ------------------ ESC pressed ----------------------------- */
      when rxID = -12 then
      do
                        /* set the program return code                */
        prog.__ExitCode = 1

        leave
      end /* when */

      /* ------------------ window resized -------------------------- */
      when rxID = -20 then
      do
      end /* when */

      /* ------------------ CLOSE ICON used ------------------------- */
      when rxID = -98 then
      do
                    /* exit REXXCC2 without saving the configuration! */

                        /* set the program return code                */
        prog.__ExitCode = 1

        leave
      end /* when */

      /* ------------------ abort forced by another application ----- */
      when rxID = -99 then
      do
                    /* exit REXXCC2 without saving the configuration! */

                        /* set the program return code                */
        prog.__ExitCode = 1

        leave
      end /* when */

      /* ------------------ unknown action occured ------------------ */
      when rxID < 0 then
      do
                    /* exit REXXCC2 without saving the configuration! */
                        /* set the program return code                */
        prog.__ExitCode = 254

        leave
      end /* when */

      /* ------------------------------------------------------------ */
                        /* if we come to this point,                  */
                        /* RXID contains the group no.                */

      /* ------------------ sourcefile drop down box ---------------- */
      when rxID = md.__SourceFileDropBox then
      do
      end /* when */

      /* ------------------ target file drop down box --------------- */
      when rxID = md.__TargetFileDropBox then
      do
      end /* when */

      /* ------------------ copyright box drop down box ------------- */
      when rxID = md.__CopyrightFileDropBox then
      do
      end /* when */

      /* ------------------ search push buttons --------------------- */
      when rxID = md.__SourceTargetCopyrightPushButtons then
      do

        select

          /* -------------- sourcefile search button ---------------- */
          when rxSubID = 3 then
          do
                        /* search the sourcefile                      */
            thisFileMask = sourceFiles.__CurPath || '\*.CMD'
            rxFile 'LOAD' 'THISFILEMASK' 'OK | Select the source file'

            if ( rc = '' ) & thisFileMask <> '' then
            do
              sourceFiles.__CurPath = filespec( 'D', thisFileMask ) || ,
                                      fileSpec( 'P', thisFileMask )
              if length( sourceFiles.__CurPath ) > 3 & ,
                 right( sourceFiles.__CurPath,1 ) = '\' then
                sourceFiles.__CurPath = dbrright( sourceFiles.__CurPath,1 )

/*
                        /* add the new entry to the drop down list    */
              RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox 1 'ADD' thisFileMask || '| -1'
*/
                        /* update the entry field of the drop box    */
              RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox 1 'VAL' thisFileMask

            end /* if rc = '' & ... */

          end /* when */

          /* -------------- target file search push button ---------- */
          when rxSubID = 2 then
          do
                        /* search the targetfile                      */
            thisFileMask = targetFiles.__CurPath || '\*.CMD'
            rxFile 'LOAD' 'THISFILEMASK' 'OK | Select the target file'

            if ( rc = '' ) & thisFileMask <> '' then
            do
              targetFiles.__CurPath = filespec( 'D', thisFileMask ) || ,
                                      fileSpec( 'P', thisFileMask )
              if length( targetFiles.__CurPath ) > 3 & ,
                 right( targetFiles.__CurPath,1 ) = '\' then
                targetFiles.__CurPath = dbrright( targetFiles.__CurPath,1 )

/*
                        /* add the new entry to the drop down list    */
              RxSet '"'MainWindowTitle'"' md.__TargetFileDropBox 1 'ADD' thisFileMask || '| -1'
*/
                        /* update the entry field of the drop box    */
              RxSet '"'MainWindowTitle'"' md.__TargetFileDropBox 1 'VAL' thisFileMask

            end /* if rc = '' & ... */

          end /* when */

          /* -------------- copyright file search push button ------- */
          when rxSubID = 1 then
          do
                        /* search the copyrightfile                   */

            thisFileMask = CopyrightFiles.__CurPath || '\*.CMD'
            rxFile 'LOAD' 'THISFILEMASK' 'OK | Select the copyright file'

            if ( rc = '' ) & thisFileMask <> '' then
            do
              CopyrightFiles.__CurPath = filespec( 'D', thisFileMask ) || ,
                                      fileSpec( 'P', thisFileMask )
              if length( CopyrightFiles.__CurPath ) > 3 & ,
                 right( CopyrightFiles.__CurPath,1 ) = '\' then
                CopyrightFiles.__CurPath = dbrright( CopyrightFiles.__CurPath,1 )

/*
                        /* add the new entry to the drop down list    */
              RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox 1 'ADD' thisFileMask || '| -1'
*/
                        /* update the entry field of the drop box    */
              RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox 1 'VAL' thisFileMask

            end /* if rc = '' & ... */

          end /* when */

          /* -------------- unknown push button --------------------- */
          otherwise
            nop

        end /* select */

      end /* when */


      /* ------------------ create tokenimage / edit / use def.       */
      /*                    target dir push buttons ----------------- */
      when rxID = md.__MiscActionPushButtons then
      do

        select

          /* -------------- create Tokenimage push button ----------- */
          when rxSubID = 3 then
          do
                        /* Note: We use a select block here to avoid  */
                        /*       using a lot of nested IF statements  */

            select

              when sourceFiles.0 = '' then
                call ShowErrorMsg , 'No sourceFile selected'

              when FileExist( sourceFiles.0 ) <= 0 then
                call ShowErrorMsg , 'The file '  || crlf ,
                                    sourceFiles.0      || crlf ,
                                    'does not exist'

              when translate( FileSpec( 'E', sourceFiles.0 ) ) <> 'CMD' then
                call ShowErrorMsg , 'The extension of the sourceFile must be .CMD'

              otherwise
              do
                testLine = lineIn( sourceFiles.0 )
                call stream sourceFiles.0, 'c', 'CLOSE'

                if left( testLine,2 ) <> '/' || '*' then
                   call ShowErrorMsg , 'The file '         crlf || ,
                                        sourceFiles.0      crlf || ,
                                       'is not a valid REXX program'
                else
                do
                        /* clear the PM message queue                 */
                  RxDlg '""' 255

                                                /* show a status msg                  */
                  call ShowStatusMsg 'OPEN', 'Creating the tokenimage of ',
                                             '00'x sourceFiles.0

                        /* clear the PM message queue                 */
                  RxDlg '""' 255

                                /* create the token image             */
                  ADDRESS 'CMD' sourceFiles.0 ' //t 2>NUL 1>NUL'

                        /* clear the PM message queue                 */
                  RxDlg '""' 255

                                /* close the status msg               */
                  call ShowStatusMsg 'CLOSE'

                        /* clear the PM message queue                 */
                  RxDlg '""' 255

                            /* check if the creation was successfull  */
                  testRC = SysGetEA( sourceFiles.0, 'REXX.TOKENSIMAGE', 'testEA' )
                  if testRC <> 0 | length( testEA ) = 0 then
                    call ShowErrorMsg , 'Error creating the tokenimage of the file' || crlf || ,
                                        sourceFiles.0                               || crlf || ,
                                        'Hint: Either the file is read-only or the program is to big'
                  else
                    call ShowMsg 'Tokenimage of the file' crlf || ,
                                 sourceFiles.0            crlf || ,
                                 'succesfully created.'
                end /* else */
              end /* otherwise */
            end /* select */
          end /* when */

          /* -------------- use default target dir push button ------ */
          when rxSubID = 2 then
          do
            if REXXCC2.__DefaultTargetDir <> '' then
              RxSet '"'mainWindowTitle'"' md.__TargetFileDropBox 1 'VAL' REXXCC2.__DefaultTargetDir
            else
              call ShowErrorMsg , 'No default targetDir selected.' || crlf || ,
                                  'Hint: Use the options dialog to select a default targetDir'

          end /* when */

          /* -------------- edit copyrightfile push button ---------- */
          when rxSubID = 1 then
          do
            ADDRESS 'CMD' REXXCC2.__EditorName  copyrightFiles.0
          end /* when */

          /* -------------- unknown push button --------------------- */
          otherwise
            nop

        end /* select */

      end /* when */


      /* ------------------ mode radio buttons ---------------------- */
      when rxID = md.__ModeRadioButtons  then
      do
                        /* radio buttons                              */

                        /* RXSBUID : no. of active radio button       */
                        /*  2: compile 1: compress                    */
      end /* when */

      /* ------------------ REXXCC option checkboxes ---------------- */
      when rxID = md.__OptionCheckBoxes then
      do
                        /* check boxes                                */

                        /* RXSBUID : no. of the checked box           */
      end /* when */

      /* ------------------ action push buttons --------------------- */
      when rxID = md.__ActionPushButtons then
      do
                        /* result push buttons                        */

                        /* RXSBUID contains the no. of the button     */
                        /*  1:exit 2:reset 3:options 4:compile        */
        select

          /* -------------- exit button ----------------------------- */
          when rxSubID = 1 then
          do
                        /* update the REXX variables with the dialog  */
                        /* values                                     */
            call UpdateGlobalREXXVariables

                                /* close the main dialog              */
            RxDlg '"'mainWindowTitle'"' 4

                        /* clear the PM message queue                 */
            RxDlg '""' 255

            if wordPos( '1', REXXCC2.__Options ) <> 0 then
            do
                        /* save the current configuration             */
              call LoadSaveConfigData 'SAVE' , REXXCC2.__IniFileName
            end /* if wordPos( ... */

                        /* clear the PM message queue                 */
            RxDlg '""' 255

                        /* set the program return code                */
            prog.__ExitCode = 0
            leave
          end /* when */

          /* -------------- reset button ---------------------------- */
          when rxSubID = 2 then
          do
                        /* clear the lists of the drop down boxes     */
            call ClearFileLists
          end /* when */

          /* -------------- options button -------------------------- */
          when rxSubID = 3 then
          do
                        /* update the REXX variables with the dialog  */
                        /* values                                     */
            call UpdateGlobalREXXVariables

                                /* close the main dialog              */
                                /* to force an update if new options  */
                                /* are loaded                         */
            RxDlg '"'mainWindowTitle'"' 4

/*
                        /* (*?*) hide the drop down boxes -           */
                        /* neccessary if we don't close the main dlg  */
                        /* because of a bug (?) in Rexx Dialog 1.0    */
            RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox     1 'HIDE' 1
            RxSet '"'MainWindowTitle'"' md.__TargetFileDropbox     1 'HIDE' 1
            RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox  1 'HIDE' 1
*/

                        /* call the option dialog                     */
            call OptionDialog

/*
                        /* (*?*) show the drop down boxes again       */
            RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox     1 'SHOW' 1
            RxSet '"'MainWindowTitle'"' md.__TargetFileDropbox     1 'SHOW' 1
            RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox  1 'SHOW' 1
*/
          end /* when */


          /* -------------- unknown button -------------------------- */
          otherwise
          do
          end /* otherwise */

        end /* select */

      end /* when */

      /* ------------------ Compile/Compress Push button              */
      when rxID = md.__CompilePushButton | rxID = md.__CompressPushButton then
      do

                    /* update the REXX variables with the dialog      */
                    /* values                                         */
        call UpdateGlobalREXXVariables

        startCompile = 0

        if REXXCC2.__CompilerName = '' then
        do
          call ShowErrorMsg , 'No compiler selected.' || crlf || ,
                              'Hint: Use the options dialog to select a compiler'
        end /* if REXXCC2.__CompilerName = '' then */
        else
        do
          if stream( REXXCC2.__CompilerName, 'c', 'QUERY EXIST' ) = '' then
            call ShowErrorMsg , 'Can not find the compiler ' || crLF || ,
                              REXXCC2.__CompilerName || '!' || crLF || ,
                              'Hint: Use the options dialog to select a compiler'
          else
            startCompile = 1
        end /* else */

        if startCompile = 1 & ,
           CheckCompiler( REXXCC2.__CompilerName ) <> 1 then
        do
          if ShowWarningMsg( 4, REXXCC2.__CompilerName ,
                                ' seems not to be a valid compiler!' || crlf || ,
                                'Press YES to use it anyway' ) <> 6 then
            startCompile = 0
        end /* if CheckCompiler( ... */

        select

          when startCompile <> 1 then
            nop

          when sourceFiles.0 = '' & wordPos( '3', REXXCC2.__Options ) = 0 then
            call ShowErrorMsg , 'No sourcefile entered'

          when targetFiles.0 = '' & wordPos( '3', REXXCC2.__Options ) = 0 then
            call ShowErrorMsg , 'No targetfile entered'

          otherwise
          do

                            /* close the main dialog                  */
            RxDlg '"'mainWindowTitle'"' 4

                            /* start the compiler                     */
            call StartCompile
          end /* otherwise */

        end /* select */

      end /* when */

      /* ------------------ Linecount spin -------------------------- */
      when rxID = md.__LineCountSpin then
      do
                        /* spin entry for LineCount                   */
      end /* when */

      /* ------------------ about push button ----------------------- */
      when rxID = md.__AboutPushButtons then
      do

                        /* about push button                          */

                                /* close the main dialog              */
                                /* to force an update                 */
        RxDlg '"'mainWindowTitle'"' 4

        rxSay prog.__vName prog.__Version ' - PM frontend for REXXCC'            crlf || ,
              prog.__vCopyright                                                  crlf || ,
              'See the source code for the limitations of this version.'         crlf || ,
              'See the REXXCC documentation for further information.'            crlf || ,
              ''                                                                 crlf || ,
              'REXXCC/2 uses the famous "Rexx Dialog" package from Jeff Glatt.' || ,
              ' See the file RX.INF for further information about "Rexx Dialog".' ,
              '|' 0+48 'About'

      end /* when */

      /* ------------------ unknow result --------------------------- */
      otherwise
      do
      end /* otherwise */

    end /* select */

  end /* do forever */

exit prog.__ExitCode

/* ------------------------------------------------------------------ */
/* UpdateGlobalREXXVariables                                          */
/*                                                                    */
/* Function: Update the global REXX variables with the dialog values  */
/*                                                                    */
/* Usage:    UpdateGlobalREXXVariables                                */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
UpdateGlobalREXXVariables:
                        /* update the global variables                */

                    /* check if the filename is already in the list   */
  AddFileName = ( sourceFiles.0 <> '' )

  do i = 1 while sourceFiles.i <> '' & AddFileName = 1
    if translate( sourceFiles.i ) = translate( sourceFiles.0 ) then
      AddFileName = 0
  end /* do */

  if AddFileName = 1 then
  do
                        /* filename not yet in the list -- add it     */
    sourceFiles.i = sourceFiles.0

/*
                        /* add the source file to the drop down list  */
    RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox 1 'ADD' sourceFiles.0 || '| -1'
*/

  end /* if AddFileName = 1 then */

                    /* check if the filename is already in the list   */
  AddFileName = ( targetFiles.0 <> '' )
  do i = 1 while targetFiles.i <> '' & AddFileName = 1
    if translate( TargetFiles.i ) = translate( TargetFiles.0 ) then
      AddFileName = 0
  end /* do */
  if AddFileName = 1 then
  do
                        /* filename not yet in the list -- add it     */
    targetFiles.i = targetFiles.0

/*
                        /* add the new entry to the drop down list    */
    RxSet '"'MainWindowTitle'"' md.__TargetFileDropBox 1 'ADD' targetFiles.0 || '| -1'
*/

  end /* if AddFileName = 1 then */

                    /* check if the filename is already in the list   */
  AddFileName = ( copyrightFiles.0 <> '' )
  do i = 1 while  CopyrightFiles.i <> '' & AddFileName = 1
    if translate( CopyrightFiles.i ) = translate( CopyrightFiles.0 ) then
      AddFileName = 0
  end /* do */
  if AddFileName = 1 then
  do
                        /* filename not yet in the list -- add it     */
    copyrightFiles.i = copyrightFiles.0

/*
                        /* add the new entry to the drop down list    */
    RxSet '"'MainWindowTitle'"' md.__TargetFileDropBox 1 'ADD' CopyrightFiles.0 || '| -1'
*/

  end /* if AddFileName = 1 then */

  REXXCC.__Mode      = value( 'RXVAL.' || md.__ModeRadioButtons )
  REXXCC.__Options   = value( 'RXVAL.' || md.__OptionCheckBoxes )
  REXXCC.__LineCount = value( 'RXVAL.' || md.__LineCountSpin )

RETURN

/* ------------------------------------------------------------------ */
/* OptionDialog                                                       */
/*                                                                    */
/* Function: Show & handle the option dialog                          */
/*                                                                    */
/* Usage:    OptionDialog                                             */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
OptionDialog: PROCEDURE expose (exposeList)

InitOptionDialogAgain:

                    /* copy the global values into local variables    */
  curIniFile          = REXXCC2.__IniFileName
  curCompiler         = REXXCC2.__CompilerName
  curREXXCC2Options   = REXXCC2.__Options
  curEditor           = REXXCC2.__EditorName
  curDefaultTargetDir = REXXCC2.__DefaultTargetDir

                    /* init the variables for the dialog              */

                    /* title of the dialog                            */
  OptionWindowTitle = prog.__vName prog.__Version || ' - Options'

  i = 0

  i = i+1;                      ; op.__IniFileText = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Current inifile:'
  RXINFO.i  = '1 1 400'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 315

  i = i+1;                      ; op.__CurIniFileName = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = ' '
  if curIniFile = '' then
    RXLABEL.i = '*** no inifile selected ***'
  else
    RXLABEL.i = PackFileName( curIniFile, 50 )
  RXINFO.i  = '1 1 400'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 295

  i=i+1                         ; op.__ChangeIniFilePushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Change Inifile'
  RXINFO.i  = '1 1 225'
  RXVAL.i   = ' '
  RXX.i     = 380
  RXY.i     = 315

  i = i+1;                      ; op.__CompilerText = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Current compiler:'
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 265

  i = i+1;                      ; op.__CurCompilerName = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  if curCompiler = '' then
    RXLABEL.i = '*** no compiler selected ***'
  else
    RXLABEL.i = PackFileName( curCompiler, 50 )
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 245

  i=i+1;                        ; op.__CompilerSearchPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Change Compiler'
  RXINFO.i  = '1 1 225'
  RXVAL.i   = ' '
  RXX.i     = 380
  RXY.i     = 265

  i = i+1;                      ; op.__EditorText = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Current editor:'
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 215

  i = i+1;                      ; op.__CurEditorName = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  if curEditor = '' then
    RXLABEL.i = '*** no editor selected ***'
  else
    RXLABEL.i = PackFileName( curEditor, 50 )
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 195

  i=i+1;                        ; op.__EditorSearchPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Change Editor'
  RXINFO.i  = '1 1 225'
  RXVAL.i   = ' '
  RXX.i     = 380
  RXY.i     = 215

  i = i+1;                      ; op.__TargetDirText = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Current default TargetDir:'
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 170

  i = i+1;                      ; op.__CurTargetDirName = i
  RXTYPE.i = 'TEXT'
  RXFLAGS.i = ' '
  if curDefaultTargetDir = '' then
    RXLABEL.i = '*** no default target directory selected ***'
  else
    RXLABEL.i = PackFileName( curDefaultTargetDir, 50 )
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 150

  i=i+1;                        ; op.__TargetDirSearchPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Change default TargetDir'
  RXINFO.i  = '1 1 225'
  RXVAL.i   = ' '
  RXX.i     = 380
  RXY.i     = 170

  i=i+1                         ; op.__REXXCC2CheckBox = i
  RXTYPE.i  = 'CHECK'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Save options at program end | ' ,
              'Use Environment variable REXXCC |' ,
              'Edit compile command before executing | ' ,
              'REXXCC/2 Options '
  RXINFO.i  = '3 1 0'
  RXVAL.i   = curREXXCC2Options
  RXX.i     = 15
  RXY.i     = 40

  i=i+1;                        ; op.__SaveConfigDataPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Save configuration'
  RXINFO.i  = '2 1 175'
  RXVAL.i   = ' '
  RXX.i     = 430
  RXY.i     = 35


  i=i+1;                        ; op.__LoadConfigDataPushButton = i
  RXTYPE.i  = 'PUSH'
  RXFLAGS.i = 'END'
  RXLABEL.i = 'Load configuration'
  RXINFO.i  = '2 1 175'
  RXVAL.i   = ' '
  RXX.i     = 430
  RXY.i     = 60

  i=i+1;                        ; op.__ResultPushButtons = i
  RXTYPE.i  = 'RESULT'
  RXFLAGS.i = 'BOOL'
  RXLABEL.i = ' '
  RXINFO.i  = '1 2'
  RXVAL.i   = ' '
  RXX.i     = 250
  RXY.i     = 5

                                /* number of groups in this dialog    */
  noOfGroupsInOptionWIn = i

                                /* show the dialog                    */
  RxDlg noOfGroupsInOptionWin   ,
        '"'optionWindowTitle'"' ,
        'WINDOW.__OPTIONWINDOWDIM'  ,
        'NOCLOSE|MODAL|KEYS|RESULT'


                        /* change the size of the text fields         */
                        /* (*?*) this is neccessary because the       */
                        /* initial size of the fields is limited to   */
                        /* 31                                         */
  RxSet '"'optionWindowTitle'"' op.__CurIniFileName   1 'SIZE' 475
  RxSet '"'optionWindowTitle'"' op.__CurCompilerName  1 'SIZE' 475
  RxSet '"'optionWindowTitle'"' op.__CurEditorName    1 'SIZE' 475
  RxSet '"'optionWindowTitle'"' op.__CurTargetDirName 1 'SIZE' 475

  do forever
                        /* perform user actions                       */
    RxDlg '"'optionWindowTitle'"' 0

                        /* update the REXX variables with the user    */
                        /* input                                      */
    RxDlg '"'optionWindowTitle'"' 2

                        /* clear the PM message queue                 */
    RxDlg '""' 255

    /* ------------------ alt keycode processing -------------------- */
    select

      when rxID = -1 then
      do
                        /* (*?*) simulate accelerator keys -- see     */
                        /*       note for the main dialog             */
        rxSubId = translate( rxSubID )

        possibleKeys    = 'I C L S E T'
        rxIDsForKeys    = op.__ChangeIniFilePushButton ,
                          op.__CompilerSearchPushbutton ,
                          op.__LoadConfigDataPushButton ,
                          op.__SaveConfigDataPushButton ,
                          op.__ChangeEditorPushButton ,
                          op.__TargetDirSearchbutton

        rxSubIDsForKeys = '1 1 1 1 1 1'

        i = wordPos( rxSubId, possibleKeys )
        if i <> 0 then
        do
          rxID = word( rxIDsForKeys, i )
          rxSubID = word( rxSubIDsForKeys, i )
        end /* if i <> 0 then */
      end /* if */

      otherwise
        nop
    end /* select */

    select

      /* ------------------ Close & abort --------------------------- */
      when rxID <= 0 then
      do
                                /* end the dialog                     */
        leave
      end /* when */

      /* ------------------ ChangeIniFile push button --------------- */

      when rxID = op.__ChangeIniFilePushButton then
      do
                        /* get a new path for the ini file            */
        tempStr = GetIniFilePathDialog()
        if tempStr <> '' then
        do
          tempStr = tempStr || prog.__IniFileName

          if DriveReady( tempStr ) <> 1 then
            call ShowErrorMsg , 'The drive ' || ,
                             substr( tempStr,1,2 ) || ,
                             ' is not ready'
          else if WriteReadTestIniFile( 'TEST', tempStr ) >= 0 then
          do
                                /* choosen inifile is okay            */

                                /* change the value in the dialog     */
            curIniFile = tempStr
            RxSet '"'optionWindowTitle'"',
                  op.__CurIniFileName 1 'VAL' PackFileName( tempStr, 50 )
          end /* if WriteReadTestIniFile( ... */
          else
            call ShowErrorMsg , 'The format of the ini file ' || crlf || ,
                                 tempStr                      || crlf || ,
                                'is invalid'
        end /* if tempStr1 <> '' then */

      end /* when */

      /* ------------------ CompilerSearch push button -------------- */
      when rxID = op.__CompilerSearchPushButton then
      do forever
                        /* search the compiler                        */
        tempStr = curCompiler
        rxFile 'LOAD' 'TEMPSTR' 'OK | Select the compiler'

        if ( rc = '' ) & tempStr <> '' then
        do
          if CheckCompiler( tempStr ) = 1 then
          do
            curCompiler = tempStr
                                /* change the value in the dialog     */
            RxSet '"'optionWindowTitle'"',
                  op.__CurCompilerName 1 'VAL' PackFileName( tempStr, 50 )
            leave
          end /* if CheckCompiler( tempStr ) <> '' then */
          else
            call ShowErrorMsg , tempStr || ' is not a valid compiler'
        end /* if */
        else
          leave
      end /* when */

      /* ------------------ EditorSearch push button ---------------- */
      when rxID = op.__EditorSearchPushButton then
      do
        if ShowWarningMsg( 4, 'The current editor is '    || crlf || ,
                           PackFileName( curEditor, 40 )  || crlf || ,
                           'Do you want to change it?'    || crlf || ,
                           'Caution: You can only use a PM editor' ,
                      ) = 6 then
        do forever
                        /* search the editor                          */
          tempStr = curEditor
          rxFile 'LOAD' 'TEMPSTR' 'OK | Select the editor'

          if ( rc = '' ) & tempStr <> '' then
          do
            if stream( tempStr, 'c', 'QUERY EXIST' ) <> '' then
            do
              curEditor = tempStr
                                /* change the value in the dialog     */
              RxSet '"'optionWindowTitle'"',
                    op.__CurEditorName 1 'VAL' PackFileName( tempStr, 50 )
              leave
            end /* if stream( ... */
            else
              call ShowErrorMsg ,'Program "' || tempStr || '" not found'
          end /* if */
          else
            leave

        end /* do forever */
      end /* when */

      /* ------------------ Change default targetdir push button ---- */
      when rxID = op.__TargetDirSearchPushButton then
      do
                        /* get the default target directory           */
        tempStr = curDefaultTargetDir || 'dummy'
        rxFile 'LOAD' 'TEMPSTR' 'OK | Select a file in the default target directory'

        if ( rc = '' ) & tempStr <> '' then
        do
          curDefaultTargetDir = fileSpec( 'D', tempStr ) || ,
                                fileSpec( 'P', tempStr )

                                /* change the value in the dialog     */
          RxSet '"'optionWindowTitle'"',
                op.__CurTargetDirName 1 'VAL' PackFileName( curDefaultTargetDir, 50 )
        end /* if ( rc = '' ) & ... */
      end /* when */

      /* ------------------ LoadConfigData push button -------------- */
      when rxID = op.__LoadConfigDataPushButton then
      do
                        /* load configuration push button             */
        if curIniFile = '' then
        do
                        /* no inifile selcected                       */
          tempStr = GetIniFilePathDialog()
          if tempStr <> '' then
            tempStr = tempStr || prog.__IniFileName
        end
        else
          tempStr = curIniFile

        if tempStr <> '' then
        do
          if LoadSaveConfigData( 'LOAD', tempStr ) = 1 then
          do
                        /* ini file successfully loaded               */
                        /* Note: LoadSaveConfigData changes the       */
                        /*       global variable!                     */
            curIniFile = REXXCC2.__IniFileName

                        /* close the dialog                           */
            RxDlg '"'optionWindowTitle'"' 4

            call ShowMsg , 'Configuration data loaded.'

                        /* init stem for the dialog variables again   */
                        /* and create the the dialog again            */
                        /* no good style -- but works                 */
            signal InitOptionDialogAgain

          end /* if LoadSaveConfigData( ... */
        end /* if tempStr <> '' then */
      end /* when */

      /* ------------------ SaveConfigData push button -------------- */
      when rxID = op.__SaveConfigDataPushButton then
      do
                        /* save configuration push button             */
        if curIniFile = '' then
        do
                        /* no inifile selcected                       */
          tempStr = GetIniFilePathDialog()
          if tempStr <> '' then
            tempStr = tempStr || prog.__IniFileName
        end
        else
          tempStr = curIniFile

        if tempStr <> '' then
        do
                    /* save the new values in the global variables    */
          REXXCC2.__CompilerName     = curCompiler
          REXXCC2.__IniFileName      = curIniFile
          REXXCC2.__EditorName       = curEditor
          REXXCC2.__DefaultTargetDir = curDefaultTargetDir
          REXXCC2.__Options = value( 'RXVAL.' || op.__REXXCC2CheckBox )

          if LoadSaveConfigData( 'SAVE', tempStr ) = 1 then
          do
            call ShowMsg , 'Configuration data saved.'
                        /* Note: LoadSaveConfigData changes the       */
                        /*       global variable!                     */
            curIniFile = REXXCC2.__IniFileName

                                /* change the value in the dialog     */
            RxSet '"'optionWindowTitle'"',
                  op.__CurIniFileName 1 'VAL' PackFileName( curIniFile, 50 )
          end /* if */
        end /* if tempStr <> '' then */
      end /* when */

      /* ------------------ Result push buttons --------------------- */
      when rxID = op.__ResultPushButtons then
      do
                        /* Result push buttons                        */
        i = op.__ResultPushButtons

        /* ---------------- OK push button -------------------------- */
        if RXVAL.i = 1 then
        do
                    /* save the new values in the global variables    */
          REXXCC2.__CompilerName     = curCompiler
          REXXCC2.__IniFileName      = curIniFile
          REXXCC2.__EditorName       = curEditor
          REXXCC2.__DefaultTargetDir = curDefaultTargetDir
          REXXCC2.__Options = value( 'RXVAL.' || op.__REXXCC2CheckBox )
        end /* if */

        leave
      end /* when */

      /* ------------------ unknown result code --------------------- */
      otherwise
      do
      end /* otherwise */

    end /* select */
  end /* do forever */

                        /* close the window                           */
  RxDlg '"'optionWindowTitle'"' 4

RETURN

/* ------------------------------------------------------------------ */
/* GetIniFilePathDialog                                               */
/*                                                                    */
/* Function: Get the path for the ini file                            */
/*                                                                    */
/* Usage:    GetIniFilePathDialog                                     */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  the path of the inifile or '' if aborted by the user     */
/*                                                                    */
/* note:     The path ends always with a backslash '\'.               */
/*           You can select the path from all a list containing       */
/*           - the current directory                                  */
/*           - the directory with REXXCC2.CMD                         */
/*           and                                                      */
/*           - all existing directorys from the environment variable  */
/*             DPATH (except the directorys on a "not ready" medium)  */
/*                                                                    */
GetIniFilePathDialog: PROCEDURE expose (exposeList)

                        /* init the return code                       */
  iniFilePath = ''

                        /* setup the stem with the possible pathes    */
  possiblePathes. = ' '

  i=1
  possiblePathes.i = translate( directory() )

  if prog.__Path <> possiblePathes.i  then
  do
    if DirExist( prog.__Path ) <> '' then
    do
      i=i+1
      possiblePathes.i = prog.__Path
    end /* if DirExist( prog.__Path ) <> '' then */
  end /* if ... */
                        /* get the current value of the environment   */
                        /* variable DPATH                             */
  dpathVar = value( 'DPATH' ,, prog.__env )

                        /* check each entry of the environment        */
                        /* variable DPATH and add it to the list      */
                        /* of possible directorys for the ini file    */
                        /* if the directory exist and is okay         */
  do until DPathVar = ''
    parse var DPathVar curDPathPart ';' DPathVar
    if curDpathPart <> '' then
    do
                    /* only add existing directorys to the list       */
      curDPathPart = DirExist( curDPathPart )
      if curDPathPart <> '' then
      do
        i=i+1
        possiblePathes.i = translate( curDPathPart )
      end /* if curDPathPart <> '' then */
    end /* if curDPathPart <> '' then */
    else
      if DPathVar <> '' then
        iterate
  end /* do until DPathVar = '' */

                  /* setup variables for the dialog to ask the user   */

                  /* title for the dialog                             */
  GetIniFileWindowTitle = prog.__vName prog.__Version || ' - Get IniFilepath'

  i = 0

  i = i+1;                      ; gif.__PathesText = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = ' '
  RXLABEL.i = 'Select a path for the ini file:'
  RXINFO.i  = '1 1'
  RXVAL.i   = ' '
  RXX.i     = 10
  RXY.i     = 150

  i = i+1;                      ; gif.__PathesListBox = i
  RXTYPE.i  = 'LIST'
  RXFLAGS.i = ' '
  RXLABEL.i = ' '
  RXINFO.i  = '1 1 511 6'
  RXVAL.i   = 'possiblePathes'
  RXX.i     = 10
  RXY.i     = 50

                  /* push buttons for the action                      */
  i=i+1                         ; gif.__ResultPushButtons = i
  RXTYPE.i  = 'RESULT'
  RXFLAGS.i = 'BOOL'
  RXLABEL.i = ' '
  RXINFO.i  = '1 2'
  RXVAL.i   = ' '
  RXX.i     = 60
  RXY.i     = 5

                          /* number of groups in this dialog          */
  noOfGroupsInGetIniFileWindow = i

                          /* show the dialog                          */
  RxDlg noOfGroupsInGetIniFileWindow ,
        '"'GetIniFileWindowTitle'"'  ,
        'WINDOW.__GETINIFILEWINDOWDIM'   ,
        'MODAL|KEYS|NOCLOSE'

                          /* (*?*) resize the LIST BOX                */
                          /* Note that the size for the LIST Box at   */
                          /* creation time is limited to 31           */
  rxSet '"'GetIniFileWindowTitle'"'  gif.__PathesListBox 1 'SIZE' 575

  do forever


                          /* perform user actions                     */
    RxDlg '"'GetIniFileWindowTitle'"' 0

                          /* update the REXX variables                */
    RxDlg '"'GetIniFileWindowTitle'"' 2

                        /* clear the PM message queue                 */
    RxDlg '""' 255

    /* -------------------- RETURN key processing ------------------- */
    if rxID = 0 & rxSubID = 10 then
    do
      rxID = gif.__ResultPushButtons
      rxVal.rxID = 1
    end /* if rxID = 0 & ... */

    if rxID = gif.__ResultPushButtons then
    do
      i = gif.__ResultPushButtons

    /* -------------------- OK push button -------------------------- */
      if RXVAL.i = 1 then
      do
        if possiblePathes.0 = '' then
          call ShowErrorMsg , 'Hey!: Either select a path for the inifile or press CANCEL to abort'
        else
        do
                      /* copy the selected PATH in the return code    */
                      /* variable                                     */
          iniFilePath = possiblePathes.0

                        /* add a trailing backslash if neccessary     */
          if right( iniFilePath,1 ) <> '\' then
            iniFilePath = iniFilePath || '\'

          leave
        end /* else */
      end /* if rxSubID = 1 then */
      else
        leave
    end /* if */
    else
      leave
  end /* do forever */

                          /* close the dialog                         */
  RxDlg '"'GetIniFileWindowTitle'"' 4

RETURN iniFilePath

/* ------------------------------------------------------------------ */
/* LoadSaveConfigData                                                 */
/*                                                                    */
/* Function: Load/Save the configuration data to/from the inifile     */
/*                                                                    */
/* Usage:    LoadSaveConfigData {action} , curIniFileName             */
/*                                                                    */
/* where:    action - action to take (LOAD or SAVE, def.: LOAD)       */
/*           curIniFileName - name & path of the ini file             */
/*                                                                    */
/* returns:  1 - ok, data loaded or saved                             */
/*           0 - loading or saving aborted by the user                */
/*          -1 - loading or saving aborted due to an error            */
/*                                                                    */
LoadSaveConfigData: PROCEDURE expose (exposeList)
  parse upper arg action , curIniFileName .

  thisRC = 1

  if action = 'SAVE' then
  do
                        /* save the config data to the ini file       */
    do i = 1

      if curIniFileName = '' | thisRC = -1 then
      do
        curIniFileName = ''
        tempStr = GetIniFilePathDialog()
        if tempStr <> '' then
           curIniFileName = tempStr || prog.__IniFileName
      end /* if curIniFileName = '' | ... */

      if curIniFileName = '' then
      do
                        /* saving aborted by the user                 */
        thisRC = 0
        leave i
      end
      else
      do
        if FileExist( curIniFileName ) <> 0 then
          if DriveReady( curIniFileName ) <> 1 then
            call ShowError, 'The drive ' || ,
                            substr( curIniFileName,1,2 ) || ,
                            ' is not ready'
          else
            tempRC = WriteReadtestIniFile( 'TEST', curIniFileName )
        else
          tempRC = 1

        if tempRC = -1 then
        do
          tempRC = ShowErrorMsg( 5, 'The format of the ini file ' || crlf || ,
                                    curIniFileName                || crlf || ,
                                    'is invalid. '                || crlf || ,
                                    'Press YES to overwrite the file' )

          select

            when tempRC = 6 then
            do
                        /* YES pressed                                */

                        /* delete the existing INI file               */
              rc = SysFileDelete( curIniFileName )
              if rc <> 0 & rc <> 2 then
              do

                OS2Message = SysGetMessage( rc, 'OSO001.MSG', curIniFileName )
                    /* note: the dbrright call removes the trailing   */
                    /*       point and CR/LF from the message.        */
                if OS2Message <> '' then
                  OS2Message = '(' || dbrright( OS2Message, 3 ) || ')'

                rc = ShowErrorMsg( 1 , 'OS Error ' || rc || ' deleting the ini file.' || crLf || ,
                                       OS2Message )
                if rc = 1 then
                  thisRC = -1
                else
                do
                        /* CANCEL pressed                             */
                  curIniFileName = ''
                  thisRC = 0
                  leave i
                end /* else */
              end /* if rc <> 0 then */
              else
                thisRC = 1
            end /* when */

            when tempRC = 7 then
            do
                        /* NO pressed                                 */
              thisRC = -1
            end /* when */

            when tempRC = 2 then
            do
                        /* ABORT pressed                              */
              curIniFileName = ''
              thisRC = 0
              leave i
            end /* when */

            otherwise
            do
                        /* unknown return code                        */
              thisRC = -1
            end /* when */

          end /* select */

        end /* if tempStr = '' then */
      end /* else */

      if curIniFileName <> '' & thisRC = 1 then
      do
                    /* write the configuration data to the ini file   */
        thisRC = WriteReadTestIniFile( 'SAVE', curIniFileName )
        if thisRC = 1 then
        do
          REXXCC2.__IniFileName = curIniFileName
          leave i
        end /* if ThisRC = 1 then */
        else
        do
          call ShowErrorMsg , 'Error saving the configuration data'
          curIniFileName = ''
          thisRC = 1
        end /* else */
      end /* if curIniFileName <> '' then */

    end /* do i = 1 */

  end /* if action = 'SAVE' then */

  else  /* action = 'LOAD' */
  do
                        /* load the config data from the ini file     */

    thisRC = -1         /* def.: error loading the inifile            */

    iniFileLoaded = 0
                        /* test & load the inifile                    */
    if DriveReady( curIniFileName ) <> 1 then
      call ShowErrorMsg , 'The drive ' || ,
                          substr( curIniFielName,1,2 ) || ,
                          ' is not ready'
    else
      if FileExist( curIniFileName ) = 0 then
        call ShowErrorMsg , 'The ini file ' || crlf || ,
                            curIniFileName  || crlf || ,
                            'does not yet exist'

      else
      do
        if WriteReadTestIniFile( 'TEST', curIniFileName ) = 1 then
          if WriteReadTestIniFile( 'LOAD', curIniFileName ) = 1 then
            iniFileLoaded = 1

        if iniFileLoaded = 1 then
        do
                        /* inifile loaded                             */

                        /* change the return code                     */
          thisRC = 1
                        /* change the global variable                 */
          REXXCC2.__IniFileName = curIniFileName
        end /* if iniFileLoaded = 1 then */
        else
        do
                        /* inifile format is invalid or error loading */
                        /* the inifile                                */

          call ShowErrorMsg , 'The format of the ini file ' || crlf || ,
                              curIniFileName                || crlf || ,
                              'is invalid'
        end /* else */
      end /* else */
  end /* else ACTION = 'LOAD' */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* WriteReadTestIniFile                                               */
/*                                                                    */
/* Function: write, read or test the inifile                          */
/*                                                                    */
/* Usage:    WriteReadTestIniFile {action} , iniFileName              */
/*                                                                    */
/* where:    action - action to take:                                 */
/*                    LOAD, SAVE or TEST, def.: TEST                  */
/*                                                                    */
/* returns:  1 - ok, data written, read or tested                     */
/*           0 - file or application not found                        */
/*          -1 - error writing or reading the inifile, inifile        */
/*               is invalid or used by another process                */
/*                                                                    */
/*                                                                    */
WriteReadTestIniFile:
  parse arg action, iniFileName .

                        /* clear the PM message queue                 */
  RxDlg '""' 255

  action = strip( action )
  if action = '' then
    action = 'TEST'     /* default action is TEST                     */


                        /* setup the message for the status window    */
  select

    when action = 'LOAD' then
      actionMsg = 'Loading the inifile "' || ,
                  PackFileName( iniFileName, 30 ) || '" ...'

    when action = 'SAVE' then
      actionMsg = 'Writing the inifile "' || ,
                  PackFileName( iniFileName, 30 ) || '" ...'

    otherwise
      actionMsg = 'Testing the inifile "' || ,
                  PackFileName( iniFileName, 30 ) || '" ...'

  end /* select */

                        /* open the status window                     */
  call ShowStatusMsg 'OPEN', actionMsg '00'x 'Initialising ...'


                    /* default is: error processing the ini file      */
  thisRC = -1

                    /* separator for the fields in the ini file       */
                    /* values with more than one field                */
  fieldSep = '00'x

                    /* application name for the ini file              */
  appName = 'REXXCC/2'

                    /* name of the special key for the status of the  */
                    /* inifile                                        */
  statusKey = 'STATUS'

                    /* init the stem with the key names and values    */
  IniFileKeys.0 = 0             /* no. of keys                        */

  i=IniFileKeys.0

  i=i+1                         ; iniFileVersionIndex = i
                    /* name of the key                                */
  IniFileKeys.i.name    = 'INIFILEVERSION'
                    /* name of the corresponding REXX variable        */
  IniFileKeys.i.rexxVar = 'prog.__IniFileVersion'

  i=i+1
  IniFileKeys.i.Name    = 'COMPILERNAME'
  IniFileKeys.i.rexxVar = 'REXXCC2.__CompilerName'

  i=i+1
  IniFileKeys.i.Name    = 'EDITORNAME'
  IniFileKeys.i.rexxVar = 'REXXCC2.__EditorName'

  i=i+1
  IniFileKeys.i.Name    = 'DEFAULTTARGETDIR'
  IniFileKeys.i.rexxVar = 'REXXCC2.__DefaultTargetDir'

  i=i+1
  IniFileKeys.i.Name    = 'MODE'
  IniFileKeys.i.rexxVar = 'rexxcc.__mode'

  i=i+1
  IniFileKeys.i.Name    = 'REXXCC_OPTIONS'
  IniFileKeys.i.rexxVar = 'rexxcc.__Options'

  i=i+1
  IniFileKeys.i.Name    = 'LINECOUNT'
  IniFileKeys.i.rexxVar = 'rexxcc.__LineCount'

  i=i+1
  IniFileKeys.i.Name    = 'REXXCC2_OPTIONS'
  IniFileKeys.i.rexxVar = 'REXXCC2.__Options'

  i=i+1
  IniFileKeys.i.Name    = 'SOURCEFILES'
  IniFileKeys.i.rexxVar = 'sourceFiles.'

  i=i+1
  IniFileKeys.i.Name    = 'TARGETFILES'
  IniFileKeys.i.rexxVar = 'targetfiles.'

  i=i+1
  IniFileKeys.i.Name    = 'COPYRIGHTFILES'
  IniFileKeys.i.rexxVar = 'copyrightfiles.'

  i=i+1
  IniFileKeys.i.Name    = 'SOURCEFILES_CURPATH'
  IniFileKeys.i.rexxVar = 'sourceFiles.__Curpath'

  i=i+1
  IniFileKeys.i.Name    = 'TARGETFILES_CURPATH'
  IniFileKeys.i.rexxVar = 'targetfiles.__CurPath'

  i=i+1
  IniFileKeys.i.Name    = 'COPYRIGHTFILES_CURPATH'
  IniFileKeys.i.rexxVar = 'copyrightfiles.__CurPath'

  i=i+1
  IniFileKeys.i.Name    = 'COMPILECOMMANDS'
  IniFileKeys.i.rexxVar = 'compileCommands.'

  i=i+1
  IniFileKeys.i.Name    = 'MAINWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__mainWindowDim'

  i=i+1
  IniFileKeys.i.Name    = 'OPTIONWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__optionWindowDim'

  i=i+1
  IniFileKeys.i.Name    = 'GETINIFILEWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__getiniFileWindowDim'

  i=i+1
  IniFileKeys.i.Name    = 'EDITCOMMANDWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__EditCommandWindowDim'

  i=i+1
  IniFileKeys.i.Name    = 'COMPILESTATUSWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__CompileStatusWindowDim'

  i=i+1
  IniFileKeys.i.Name    = 'STATUSWINDOWDIM'
  IniFileKeys.i.rexxVar = 'window.__StatusWindowDim'

                    /* correct the variable with the number of keys   */
  IniFileKeys.0 = i

                                /* get the status of the ini file     */
  curStatus = 'ERROR:'
  testStem.0 = 0

                        /* clear the PM message queue                 */
  RxDlg '""' 255

  if FileExist( iniFileName ) = 0 then
    curStatus = 'FILENOTFOUND'
  else
    if SysIni( iniFileName, appName, 'ALL:', 'testStem' ) <> 'ERROR:' then
      if testStem.0 = 0 then
        curStatus = 'APPNOTFOUND'       /* application not found      */
      else
        curStatus = SysIni( iniFileName, appName, statusKey )

                        /* clear the PM message queue                 */
  RxDlg '""' 255

  select
                        /* CAUTION:                                   */
                        /*   DO NOT CHANGE THE SEQUENCE OF THE WHEN   */
                        /*   STATEMENTS!                              */
    when curStatus = 'ERROR:' then
    do
                        /* in case of an error do nothing             */
      nop
    end

    when action = 'SAVE' then
    do

                                /* set the status of the ini file     */
      if SysIni( iniFileName, appName, statusKey, 'PENDING' ) = '' then
      do

        curSaveRC = ''

                         /* save the values                           */
        do i = 1 to IniFileKeys.0 while curSaveRC <> 'ERROR:'

                         /* update the status message                 */
          call ShowStatusMsg 'UPDATE', '=' '00'x ,
                             'Writing the key "' || iniFileKeys.i.name || '" ...'

                        /* clear the PM message queue                 */
          RxDlg '""' 255

                         /* create the value for the entry            */
          if right( IniFileKeys.i.rexxVar,1 ) <> '.' then
          do
                                /* handle single variables            */
            curValue = value( IniFileKeys.i.rexxVar )

          end /* if right( IniFileKeys.i.rexxVar,1 ) <> '.' then */
          else
          do
                                /* handle stem vars                   */
            curValue = ''
            do j = 1
                        /* clear the PM message queue                 */
              RxDlg '""' 255

              curSourceVarValue = value( IniFileKeys.i.rexxVar || j )

              if curSourceVarValue = '' then
                leave
              else
                curValue = curSourceVarValue || fieldSep || curValue
            end /* do j = 1 */

            curValue = j-1 || fieldSep || curValue

          end /* else */


          if curValue <> '' then
            curSaveRC = SysIni( iniFileName ,,
                                appName ,,
                                IniFileKeys.i.name ,,
                                curValue )
          else
            call SysIni iniFileName, appName, IniFileKeys.i.name 'DELETE:'

                        /* clear the PM message queue                 */
          RxDlg '""' 255

        end /* do i = 1 to IniFileKeys.0 while ... */

        if curSaveRC <> 'ERROR:' then
        do
                          /* reset the status key of the ini file   */
          if SysIni( iniFileName, appName, statusKey, 'READY' ) = '' then
            thisRC = 1
        end  /* if curValue <> 'ERROR:' then */
        else
        do
              /* error saveing the inifile                          */

              /* delete the application from the inifile            */
          call SysIni iniFileName ,,
                       appName ,,
                       'DELETE:'

        end /* else */
      end /* if */

                        /* clear the PM message queue                 */
      RxDlg '""' 255

    end /* when */

    when curStatus = 'FILENOTFOUND' then
    do
                        /* we can't load or test a not existing file  */
      thisRC = 0
    end

    when curStatus = 'APPNOTFOUND' then
    do
                        /* it's also impossible to load or test an    */
                        /* ini file without the application key       */
      thisRC = 0
    end

    when action = 'LOAD' then
    do

                    /* set the status key of the ini file             */
      if SysIni( iniFileName, appName, statusKey, 'PENDING' ) = '' then
      do

                /* reset all global variables to their default values */
        call InitVariables

        curValue = ''

                /* read the values                                    */
        do i = 1 to IniFileKeys.0

                         /* update the status message                 */
          call ShowStatusMsg 'UPDATE', '=' '00'x ,
                             'Loading the key "' || iniFileKeys.i.name || '" ...'

                        /* clear the PM message queue                 */
          RxDlg '""' 255

          curValue = SysIni( iniFileName,,
                             appName,,
                             IniFileKeys.i.name )

          if curValue <> 'ERROR:' & curValue <> '' then
          do
            if right( IniFileKeys.i.rexxVar,1 ) <> '.' then
            do
                                /* handle single variables            */
              iLine = IniFileKeys.i.rexxVar ' =  curValue '
              interpret iLine
            end /* if right( IniFileKeys.i.rexxVar,1 ) <> '.' then */
            else
            do
                                /* handle stem vars                   */

                                /* get the number of fields           */
              parse var curValue curValueCount (fieldSep) curValue

                    /* copy the field values into the REXX variables  */
              do j = 1 to curValueCount

                        /* clear the PM message queue                 */
                RxDlg '""' 255

                parse var curValue curFieldValue (fieldSep) curValue
                iLine = iniFilekeys.i.rexxVar || j ' = curFieldValue '
                interpret iLine
              end /* do j = 1 to curValueCount */

            end /* else */
          end /* if curValue <> 'ERROR:' then */
        end /* do i = 1 to IniFileKeys.0 */

                            /* reset the status key of the ini file   */
        if SysIni( iniFileName, appName, statusKey, 'READY' ) = '' then
          thisRC = 1

      end /* if SysIni( ... */

                        /* clear the PM message queue                 */
      RxDlg '""' 255

    end /* when */

    when action = 'TEST' then
    do
                    /* check the version of the ini file              */
      i = IniFileVersionIndex
      curIniFileVersion = SysIni( iniFileName, appName, IniFileKeys.i.name )

      if curIniFileVersion <> '' & curIniFileVersion <= value( IniFileKeys.i.rexxVar ) then
        thisRC = 1
                        /* clear the PM message queue                 */
      RxDlg '""' 255

    end /* when */

    otherwise
      nop

  end /* select */

                        /* close the status window                    */
  call ShowStatusMsg 'CLOSE'

                        /* clear the PM message queue                 */
  RxDlg '""' 255

RETURN thisRC

/* ------------------------------------------------------------------ */
/* StartCompile                                                       */
/*                                                                    */
/* Function: Start the compiler                                       */
/*                                                                    */
/* Usage:    StartCompile                                             */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  returncode of REXXCC or -1 in case of an error           */
/*                                                                    */
StartCompile: PROCEDURE expose (exposeList)

                        /* init the return code                       */
  thisRC = -1

                        /* create the command to compile              */
  compileCommand = ''

  if sourceFiles.0 <> '' then
    compileCommand = compileCommand || sourceFiles.0

  if targetFiles.0 <> '' then
    compileCommand = compileCommand || ' TO ' || targetFiles.0

  if copyrightFiles.0 <> '' then
    compileCommand = compileCommand || ' WITH ' || copyrightFiles.0

  if REXXCC.__Mode = 1 then
    compileCommand = compileCommand || ' /compress'

  REXXCCSwitches = '/AddCode /IDate /IVer /IExt /Overwrite /UseSource /CMode /ShowDate'

  do i = 1 to words( REXXCC.__Options )
    curIndex = word( REXXCC.__Options, i )
    compileCommand = compileCommand word( REXXCCSwitches, curIndex )
  end /* do i = 1 to ... */

  if REXXCC.__LineCount <> 0 then
    compileCommand = compileCommand '/LineCount=' || REXXCC.__LineCount

                        /* doCompile = 1 -> start the compiler        */
  doCompile = 1

  if wordPos( '3', REXXCC2.__Options ) <> 0 then
  do
                        /* edit the command before executing it       */

    EditCommandWindowTitle = prog.__vName || ' - Edit the compile command'
    i = 0

    i = i+1;                    ; ecw.__EditField = 1
    RXTYPE.i  = 'DROP'
    RXFLAGS.i = ' '
    RXLABEL.i = 'Compile command:'
    RXINFO.1  = '1 1 511'
    RXVAL.i   = 'CompileCommands'
    RXX.i     = 175
    RXY.i     = 50

    i = i+1                     ; ecw.__ResultPushButtons = i
    RXTYPE.i  = 'RESULT'
    RXFLAGS.i = 'BOOL'
    RXLABEL.i = ' '
    RXINFO.i  = '1 2'
    RXVAL.i   = ' '
    RXX.i     = 225
    RXY.i     = 5

                          /* number of groups in this dialog          */
    noOfGroupsinEditCmdWindow = i

                          /* show the dialog                          */
    RxDlg noOfGroupsInEditCmdWindow ,
          '"'EDITCOMMANDWINDOWTITLE'"'  ,
          'WINDOW.__EDITCOMMANDWINDOWDIM' ,
          'MODAL|KEYS|NOCLOSE'

                            /* insert the command into the input box  */
    RxSet '"'EditCommandWindowTitle'"' ecw.__EditField 1 'VAL' compileCommand

                            /* change the size of the drop down box   */
                        /* (*?*) this is neccessary because the       */
                        /* initial size of the fields is limited      */
    RxSet '"'EditCommandWindowTitle'"' ecw.__EditField 1 'SIZE' 480


    do forever

                            /* perform user actions                   */
      RxDlg '"'EditCommandWindowTitle'"' 0

                            /* update REXX variables                  */
      RxDlg '"'EditCommandWindowTitle'"' 2

                        /* clear the PM message queue                 */
      RxDlg '""' 255

      /* ------------------ RETURN key processing ------------------- */
      if rxID = 0 & rxSubID = 10 then
      do
        rxID = ecw.__ResultPushButtons
        rxVal.rxID = 1
      end /* if rxID = 0 & ... */

      /* -------------------- Result push buttons ------------------- */
      if rxID = ecw.__ResultPushButtons then
      do
        i = ecw.__ResultPushButtons

        select
          /* --------------- CANCEL push button --------------------- */
          when RXVAL.i = 0 then
            doCompile = 0

          /* --------------- OK push button ------------------------- */
          when RXVAL.i = 1 then
            CompileCommand = CompileCommands.0
        end /* select */

        leave
      end /* if */
    end /* do forever */

                            /* close the dialog                       */
    RxDlg '"'EditCommandWindowTitle'"' 4

  end /* if wordPos( ... */

  if doCompile = 1 then
  do

                        /* check if this command is already in the    */
                        /* stem with the already executed compile     */
                        /* commands                                   */
    addCommand = ( CompileCommand <> '' )
    do i = 1 while CompileCommands.i <> '' & addCommand = 1
      if translate( CompileCommands.i ) = translate( CompileCommand ) then
        addCommand = 0
    end /* do */

    if addCommand = 1 then
    do
                        /* add the command to the stem with the       */
                        /* already executed compile commands          */
      CompileCommands.i = CompileCommand
    end /* if addCommand = 1 then */

    CompileCommand = REXXCC2.__CompilerName ' ' compileCommand

                        /* flush the queue                            */
    do while queued() <> 0
                        /* clear the PM message queue                 */
      RxDlg '""' 255

      pull queue
    end /* do while queued() <> 0 */

                        /* temporary set the environment variable     */
                        /* ANSI to 'OFF'                              */
    ansiVarValue = value( 'ANSI', 'OFF', prog.__env )

                        /* temporary delete the environment variable  */
                        /* REXXCC if neccessary                       */
    if wordPos( '2', REXXCC2.__Options ) <> 0 then
      envVarValue = value( 'REXXCC', '', prog.__env )

                        /* init the stem for the message of REXXCC    */
    REXXCCOutput. = ' '

    CompileStatusWindowTitle = prog.__vName || ' - REXXCC Compile status'

    i = 0

    i = i+1                       ; csw.__StatustextField = i
    RXTYPE.i  = 'TEXT'
    RXFLAGS.i = ' '
    RXLABEL.i = 'Status: Calling the compiler ... '
    RXINFO.i  = '1 1 511 1'
    RXVAL.i   = ' '
    RXX.i     = 10
    RXY.i     = 200

    i=i+1;                        ; csw.__ResultListBox = i
    RXTYPE.i  = 'LIST'
    RXFLAGS.i = ' '
    RXLABEL.i = ' '
    RXINFO.i  = '1 1 510 10'
    RXVAL.i   = 'REXXCCOutput'
    RXX.i     = 10
    RXY.i     = 35


    i=i+1;                        ; csw.__ResultPushButtons = i
    RXTYPE.i  = 'PUSH'
    RXFLAGS.i = 'END'
    RXLABEL.i = 'OK'
    RXINFO.i  = '1 1 0'
    RXVAL.i   = '1'
    RXX.i     = 335
    RXY.i     = 5

    noOfGroupsInCompileStatusWin = i

                        /* show the compile status window             */
    RxDlg noOfGroupsInCompileStatusWin   ,
          '"'compileStatusWindowTitle'"' ,
          'WINDOW.__COMPILESTATUSWINDOWDIM' ,
          'NOCLOSE|MODAL|KEYS|RESULT'

                        /* hide the OK button                         */
    RxSet '"'compileStatusWindowTitle'"' csw.__ResultPushButtons 1 'HIDE'

                        /* change the size of the status text field   */
                        /* (*?*) this is neccessary because the       */
                        /* initial size of the fields is limited      */
    RxSet '"'compileStatusWindowTitle'"' csw.__StatusTextField 1 'SIZE' 675

                        /* (*?*) resize the LIST BOX                  */
                        /* Note that the size for the LIST Box at     */
                        /* creation time is limited to 31             */
    rxSet '"'compileStatusWindowTitle'"'  csw.__ResultListBox 1  'SIZE' 675

                        /* update the window contents                 */
    RxDlg '"'compileStatusWindowTitle'"' 255

                        /* clear the PM message queue                 */
    RxDlg '""' 255

                        /* set the timeout for the window             */
                        /* (value in milliseconds)                    */
    rxSet '"'compileStatusWindowTitle'"' 'TIME' 100

    ADDRESS 'CMD' 'detach ' CompileCommand '2>&1 | rxqueue '

                        /* returncode of REXXCC: 0 = okay, else error */
    REXXCC.__rc = 255

                        /* if not zero REXXCC has ended               */
    REXXCCEnded = 0

                        /* if zero we need to update the status line  */
    StatusUpdated = 0

                        /* help variable to check if REXXCC has ended */
    SecondProcessTimeOut = 5000

    do forever
                        /* update the status line and show the OK     */
                        /* button if REXXCC has ended                 */
      if (REXXCCEnded <> 0) & (StatusUpdated = 0) then
      do
                        /* correct the status line                    */
        if REXXCC.__rc = 0 then
          rxSet '"'compileStatusWindowTitle'"' csw.__StatustextField 1 'VAL' ,
                'Status: Succesfully compiled.'
        else
          rxSet '"'compileStatusWindowTitle'"' csw.__StatustextField 1 'VAL' ,
                'Status: Compiling endet with an error.'

                        /* stop the timeout timer                     */
        rxSet '"'compileStatusWindowTitle'"' 'TIME' 0

                        /* unhide the OK button                       */
        RxSet '"'compileStatusWindowTitle'"' csw.__ResultPushButtons 1 'SHOW'

        StatusUpdated = 1
      end /* if REXXCCEnded <> 0 & ... */

                        /* perform user actions                       */
      RxDlg '"'compileStatusWindowTitle'"' 0

      select

        /* ---------------- time out action ------------------------- */
        when rxID = 0 & rxSubID = 0 then
        do
          if queued() = 0 then
          do

                        /* check for a timeOut                        */
            SecondProcessTimeOut = SecondProcessTimeOut -1
            if SecondProcessTimeOut <= 0 then
            do
                        /* set marker that REXXCC has ended           */
              REXXCCEnded = 1
            end /* if ... */
            else
            do
              RxSet '"'compileStatusWindowTitle'"' csw.__StatustextField 1 'VAL' ,
                    'Status: Calling the compiler ... (TimeOut = ' || SecondProcessTimeOut || ')'
            end /* else */

          end /* if queued() = 0 then */
          else
          do
                        /* get the output from REXXCC and insert it   */
                        /* into the list dialog                       */
            iLine = lineIN( 'QUEUE:' )
            if pos( 'successfully created' , iLine ) <> 0 then
              REXXCC.__rc = 0

                        /* check if REXXCC has ended                  */
            if pos( 'ended on' , iLine ) <> 0 then
              REXXCCEnded = 1

            if pos( 'lost it''s extended attributes', iLine ) <> 0 then
              REXXCCEnded = 1

            do until iLine = ''
              tempStr = substr( iLine,1,80 )
              iLine = substr( iLine, 81 )
              rxSet '"'compileStatusWindowTitle'"' csw.__ResultListBox 1 'ADD ' tempStr '|' '-1'
              i = i +1

                        /* update the window contents                 */
              RxDlg '"'compileStatusWindowTitle'"' 255

                        /* clear the PM message queue                 */
              RxDlg '""' 255

            end /* do until iLine = '' */

          end /* else */

                        /* set the timeout for the window again if    */
                        /* neccessary (value in milliseconds)         */
          if REXXCCEnded <> 0 then
            rxSet '"'compileStatusWindowTitle'"' 'TIME' 100
        end /* when */

        /* ---------------- OK button ------------------------------- */
        when rxID > 0 then
        do
          if REXXCCEnded <> 0 then
            leave
        end /* when */

        /* ---------------- misc. events ---------------------------- */
        otherwise
        do
          if REXXCCEnded <> 0 then
            leave
        end /* when */
      end /* select */
    end /* do forever */

                        /* close the dialog                           */
    RxDlg '"'compileStatusWindowTitle'"' 4

                        /* restore the environment variable           */
                        /* REXXCC if neccessary                       */
    if wordPos( '2', REXXCC2.__Options ) <> 0 then
      envVarValue = value( 'REXXCC', envVarValue, prog.__env)

                        /* restore the environment variable ANSI      */
    ansiVarValue = value( 'ANSI', ansiVarValue, prog.__env )

                        /* flush the queue if neccessary              */
    do while queued() <> 0
      pull queue
                        /* clear the PM message queue                 */
      RxDlg '""' 255

    end /* do while queued() <> 0 */

  end /* if doCompile = 1 then */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* ClearFileLists                                                     */
/*                                                                    */
/* Function: Clear the filelists & the command history                */
/*                                                                    */
/* Usage:    ClearFileLists                                           */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  1 - filelists & command history cleared                  */
/*           0 - operation aborted by the user                        */
/*                                                                    */
ClearFileLists:
  thisRC = 0
  rxSay 'Clear all 3 filelists and the command history?' '|' 4+16  'Warning'

  if rc = 6 then
  do
                        /* clear the drop down boxes                  */
    RxSet '"'MainWindowTitle'"' md.__SourceFileDropBox    1 'DEL'
    RxSet '"'MainWindowTitle'"' md.__TargetFileDropbox    1 'DEL'
    RxSet '"'MainWindowTitle'"' md.__CopyrightFileDropBox 1 'DEL'

                        /* clear the REXX variables                   */
    SourceFiles. = ' '
    targetFiles. = ' '
    copyrightFiles. = ' '
    CompileCommands. = ' '

    thisRC = 1
  end /* if rc = 0 then */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: Search a file in the current directory and in the        */
/*           directorys saved in an environment variable              */
/*           (e.g. PATH, DPATH, ... )                                 */
/*                                                                    */
/* call:     SearchFile( fileName, varName {,environment})            */
/*                                                                    */
/* where:    fileName - name of the file to search                    */
/*           varName - name of the environment variable containing    */
/*                     the directorys to search (e.g. PATH)           */
/*           environment - environment with the environment Variable  */
/*                         (Def.: OS2ENVIRONMENT)                     */
/*                                                                    */
/* returns:  fully qualified name of the file or "" if not found      */
/*                                                                    */
SearchFile: PROCEDURE expose (exposeList)
  parse arg fileName , envVar, environment
  resultStr = ""

  if fileName <> "" & envVar <> "" then
  do
    if environment = '' then
      environment = "OS2ENVIRONMENT"

                /* insert the current directory in the path variable  */
    searchDirs = ".;" || value( envVar, , environment )

    do forever
      parse var searchDirs curSearchDir ";" searchDirs

      curSearchDir = strip( curSearchDir )

      if curSearchDir = "" then
        iterate

      if right( curSearchDir, 1 ) <> "\" & ,
         right( curSearchDir, 1 ) <> ":" then
        curSearchDir = curSearchDir || "\"

      if FileExist( curSearchDir || fileName ) >= 1 then
      do
        resultStr = curSearchDir || fileName
        leave
      end

      if SearchDirs = "" then
        leave           /* file not found                             */

    end /* do forverver */
  end /* if fileName <> "" & ... */

  if resultStr <> '' then
    resultStr = stream( resultStr, 'c', 'QUERY EXIST' )

RETURN resultStr

/* ------------------------------------------------------------------ */
/* function: Check if a file exists (finds also hidden, read-only and */
/*           system files)                                            */
/*                                                                    */
/* call:     FileExist( fileName )                                    */
/*                                                                    */
/* where:    fileName - name of the file to search (joker are allowed)*/
/*                                                                    */
/* returns:  0 - file does not exist                                  */
/*           else returning the number of files found                 */
/*                                                                    */
FileExist: PROCEDURE expose (exposeList)
  parse arg fileName

  if substr( fileName,2,1 ) = ':' then
    thisRC = DriveReady( fileName )
  else
    thisRC = 1

  if thisRC = 1 then
  do
    searchRC = SysFileTree( fileName , 'fileStem', 'FO' )
    if searchRC = 0 then
      thisRC = fileStem.0
    else
      thisRC = 0
  end /* if thisRC = 1 then */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: Search a file in the current directory and in the        */
/*           directorys saved in the environment variable PATH        */
/*                                                                    */
/* call:     SearchProgram( progName {,environment})                  */
/*                                                                    */
/* where:    progName - name of the program to search                 */
/*           environment - environment with the environment Variable  */
/*                         (Def.: OS2ENVIRONMENT)                     */
/*                                                                    */
/* returns:  full name of the program or "" if not found              */
/*                                                                    */
SearchProgram: PROCEDURE expose (exposeList)
  parse arg progName , environment
  resultStr = ""
  if progName <> "" then
    resultStr = SearchFile( progName, "PATH", environment )
RETURN resultStr

/* ------------------------------------------------------------------ */
/* function: Search a datafile in the current directory and in the    */
/*           directorys saved in the environment variable DPATH       */
/*                                                                    */
/* call:     SearchProgram( datafileName {,environment})              */
/*                                                                    */
/* where:    datafileName - name of the datafile to search            */
/*           environment - environment with the environment Variable  */
/*                         (Def.: OS2ENVIRONMENT)                     */
/*                                                                    */
/* returns:  full name of the datafile or "" if not found             */
/*                                                                    */
SearchDataFile: PROCEDURE expose (exposeList)
  parse arg dataFileName , environment
  resultStr = ""
  if dataFileName <> "" then
    resultStr = SearchFile( datafileName, "DPATH", environment )
RETURN resultStr

/* ------------------------------------------------------------------ */
/* function: extended FILESPEC function                               */
/*                                                                    */
/* call:     FileSpec option,fileName                                 */
/*                                                                    */
/* where:    option                                                   */
/*             - E{xtension}                                          */
/*               return the extension of the file                     */
/*             All other values for "option" are processed by the     */
/*             original FILESPEC function.                            */
/*           fileName                                                 */
/*             - name of the file                                     */
/*                                                                    */
/* returns:  if option = E{xtension}:                                 */
/*             the extension of the fileName or "" if none            */
/*           else                                                     */
/*             the return code of the original FILESPEC function      */
/*             or "SYNTAX ERROR" if called with invalid parameter(s)  */
/*                                                                    */
/* note:     To call the original FILESPEC function direct use        */
/*             myResult = "FILESPEC"( option, fileName )              */
/*                                                                    */
FileSpec: PROCEDURE
  parse arg option, fileName

                        /* init the return code                       */
  rc = "SYNTAX ERROR"
                        /* install a local error handler              */
  SIGNAL ON SYNTAX NAME FileSpecError

  option = translate( strip( option ) )
                        /* check the option code                      */
  if abbrev( "EXTENSION", option ) = 1 then
  do
                        /* process the new added option code          */
    i = lastPos( ".", fileName )
    if i > lastPos( "\", fileName ) then
      rc = substr( fileName, i+1 )
    else
      rc = ""
  end
  else                  /* call the original FILESPEC function        */
    rc = "FILESPEC"( option, fileName )

FileSpecError:

RETURN rc

/* ------------------------------------------------------------------ */
/* function: test if a directory exist                                */
/*                                                                    */
/* call:     DirExist( testDir )                                      */
/*                                                                    */
/* where:    testDir - name of the directory to test                  */
/*                                                                    */
/* returns:  full name of the directory or "" if the directory        */
/*           don't exist                                              */
/*                                                                    */
DirExist: PROCEDURE expose (exposeList)
  parse arg testDir .

                        /* init the return code                       */
  thisRC = ""

                        /* install a temporary error handler to check */
                        /* if the drive with the directory to test is */
                        /* ready                                      */
  SIGNAL ON NOTREADY NAME DirDoesNotExist

                        /* check if the drive is ready                */
  call stream testDir || "*", "D"

                        /* save the current directory of the current  */
                        /* drive                                      */
  curDir = directory()

                        /* save the current directory of the drive    */
                        /* with the directory to test                 */
  curDir1 = directory( fileSpec( "drive", testDir ) )

                        /* test if the directory exist                */
  thisRC = directory( testDir )

                        /* restore the current directory of the drive */
                        /* with the directory to test                 */
  call directory curDir1

                        /* restore the current directory of the       */
                        /* current drive                              */
  call directory curDir
DirDoesNotExist:

return thisRC

/* ------------------------------------------------------------------ */
/* PackFileName                                                       */
/*                                                                    */
/* Function: convert a filename to a given length                     */
/*                                                                    */
/* Usage:    PackFileName filename, fieldLength                       */
/*                                                                    */
/* where:    filename - the name of the file                          */
/*           fieldLength - the field length                           */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
PackFileName: PROCEDURE expose (exposeList)
  parse arg fileName, fieldLength

  fileName = strip( fileName )

  if length( fileName ) > fieldLength then
  do
    if substr( fileName, 2, 1 ) = ':' then
      resStr = substr( fileName,1,3 ) || '...' ||,
               substr( fileName, length( fileName ) - fieldLength + 6 )
    else
      resStr = '...' || substr( fileName, length( fileName ) - fieldLength + 3 )
  end
  else
    resStr = fileName

RETURN resStr

/* ------------------------------------------------------------------ */
/* CheckCompiler                                                      */
/*                                                                    */
/* Function: checks if a compiler is valid                            */
/*                                                                    */
/* Usage:    CheckCompiler compilerName                               */
/*                                                                    */
/* where:    compilerName - name of the compiler                      */
/*                                                                    */
/* returns:  1 - ok                                                   */
/*           0 - no                                                   */
/*                                                                    */
/* notes:    This function checks the extension of the program and    */
/*           the EAs.                                                 */
/*                                                                    */
CheckCompiler: PROCEDURE expose (exposeList)
  parse upper arg compilerName .
  thisRC = 0

  if compilerName <> '' then
    if stream( compilerName, 'c', 'QUERY EXIST' ) <> '' then
      if fileSpec( 'E', compilerName ) = 'CMD' then

        if SysGetEA( compilerName, 'REXX.LITERALPOOL', 'EA.__REXXLiteralPool' ) = 0 then
          if length( EA.__RexxLiteralPool ) >= 8700 then

            if SysGetEA( compilerName, 'REXX.METACONTROL', 'EA.__REXXMetaControl' ) = 0 then
              if length( EA.__RexxMetaControl ) >= 68 then

                if SysGetEA( compilerName, 'REXX.TOKENSIMAGE', 'EA.__REXXTokensImage' ) = 0 then
                  if length( EA.__RexxTokensImage ) >= 51500 then

                    if SysGetEA( compilerName, 'REXX.VARIABLEBUF', 'EA.__REXXVariableBuf' ) = 0 then
                      if length( EA.__RexxVariableBuf ) >= 3500 then
                        thisRC = 1
RETURN thisRC

/* ------------------------------------------------------------------ */
/* ShowStatusMsg                                                      */
/*                                                                    */
/* Function: shows, updates or closes a status window                 */
/*                                                                    */
/* Usage:    ShowStatusMsg OPEN, statusMsg1 '00'x statusMsg2          */
/*           ShowStatusMsg UPDATE, newStatuMsg1 '00'x newStatusMsg2   */
/*           ShowStatusMsg CLOSE                                      */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  -                                                        */
/*                                                                    */
/* Note:     Use '=' if you don't want to overwrite the previous      */
/*           statusMsg.                                               */
/*                                                                    */
ShowStatusMsg: PROCEDURE expose (exposeList)
  parse arg action, statusMsg1 '00'x statusMsg2

  action = translate( strip( action ) )
  statusMsg1 = strip( statusMsg1 )
  statusMsg2 = strip( statusMsg2 )

                        /* setup the variables for the status window  */

                        /* title for the status window                */
  StatusWindowTitle = prog.__Vname prog.__Version || ' - Working '

                    /* ignore dimension & position from the inifile   */
  window.__StatusWindowDim        = '550 150 10 10'

  i = 0

  i = i +1                      ; sw.__StatusMsgText1 = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = 'CENTER'
  RXLABEL.i = ' '
  RXINFO.i  = '1 1 31'
  RXVAL.i   = statusMsg1
  RXX.i     = 10
  RXY.i     = 80

  i = i +1                      ; sw.__StatusMsgText2 = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = 'CENTER'
  RXLABEL.i = ' '
  RXINFO.i  = '1 1 31'
  RXVAL.i   = statusMsg2
  RXX.i     = 10
  RXY.i     = 50

  i = i +1                      ; sw.__StaticStatusMsgText = i
  RXTYPE.i  = 'TEXT'
  RXFLAGS.i = 'CENTER'
  RXLABEL.i = '|'
  RXINFO.i  = '1 1 31'
  RXVAL.i   = 'Please wait.'
  RXX.i     = 20
  RXY.i     = 20

                                /* number of groups in this dialog    */
  noOfGroupsInStatusWin = i

                        /* check if the status window is already open */
  RxQuery '"'statusWindowTitle'"'
  statusWindowOpen = rc         /* rc = 1 -> window already open      */

  if ( action = 'OPEN' | action = 'UPDATE' ) then
  do
    if rc = 0 then
    do
                        /* open the status window                     */
      RxDlg noOfGroupsInStatusWin  ,
            '"'statusWindowTitle'"' ,
            'WINDOW.__STATUSWINDOWDIM' ,
            'NOCLOSE|MODAL'

                        /* change the size of the text fields         */
                        /* (*?*) this is neccessary because the       */
                        /* initial size of the fields is limited to   */
                        /* 31                                         */
      RxSet '"'statusWindowTitle'"' sw.__StaticStatusMsgText  1 'SIZE' 475
      RxSet '"'statusWindowTitle'"' sw.__StatusMsgText1       1 'SIZE' 475
      RxSet '"'statusWindowTitle'"' sw.__StatusMsgText2       1 'SIZE' 475


      RxSet '"'statusWindowTitle'"' sw.__StaticStatusMsgText  1 'VAL' 'Please wait.'
    end /* if rc = 0 then */

                        /* update the text fields                     */
    if StatusMsg1 <> '=' then
      RxSet '"'statusWindowTitle'"' sw.__StatusMsgText1       1 'VAL' statusMsg1

    if StatusMsg2 <> '=' then
      RxSet '"'statusWindowTitle'"' sw.__StatusMsgText2       1 'VAL' statusMsg2

  end /* if ( action = 'OPEN' | ... */

  if action = 'CLOSE' & rc = 1 then
  do
                        /* close the status window                    */
    RxDlg '"'statusWindowTitle'"' 4
  end /* if action = 'CLOSE' & rc = 1 then */

                        /* clear the PM message queue                 */
  RxDlg '""' 255

RETURN

/* ------------------------------------------------------------------ */
/* ShowWarningMsg                                                     */
/*                                                                    */
/* Function: show a warning message box                               */
/*                                                                    */
/* Usage:    ShowWarningMsg {buttons,} warningMsg                     */
/*                                                                    */
/* where:    buttons - no. of the buttons to use (def. 0)             */
/*           warningMsg - warning message                             */
/*                                                                    */
/* returns:  the returncode of rxsay                                  */
/*                                                                    */
ShowWarningMsg: PROCEDURE expose (exposeList)
  parse arg buttons, warningMsg

  if datatype( buttons ) <> 'NUM' & buttons <> '' then
  do
    warningMsg = buttons || warningMsg
    buttons = 0
  end /* if datatype( ... */
  else
    if strip( buttons ) = '' then
      buttons = 0

  rxSay warningMsg || '!' '|' buttons+16  prog.__vName || ' - Warning'

RETURN rc

/* ------------------------------------------------------------------ */
/* ShowErrorMsg                                                       */
/*                                                                    */
/* Function: show a error message box                                 */
/*                                                                    */
/* Usage:    ShowErrorMsg {buttons,} errorMsg                         */
/*                                                                    */
/* where:    buttons - no. of the buttons to use (def. 0)             */
/*           errorMsg - error message                                 */
/*                                                                    */
/* returns:  the returncode of rxsay                                  */
/*                                                                    */
ShowErrorMsg: PROCEDURE expose (exposeList)
  parse arg buttons, errorMsg

  if datatype( buttons ) <> 'NUM' & buttons <> '' then
  do
    errorMsg = buttons || errorMsg
    buttons = 0
  end /* if datatype( ... */
  else
    if strip( buttons ) = '' then
      buttons = 0

  rxSay errorMsg || '!' '|' buttons+64  prog.__vName || ' - Error'

RETURN rc

/* ------------------------------------------------------------------ */
/* ShowMsg                                                            */
/*                                                                    */
/* Function: show a message box                                       */
/*                                                                    */
/* Usage:    ShowMsg {buttons,} Msg                                   */
/*                                                                    */
/* where:    buttons - no. of the buttons to use (def. 0)             */
/*           Msg - message                                            */
/*                                                                    */
/* returns:  the returncode of rxsay                                  */
/*                                                                    */
ShowMsg: PROCEDURE expose (exposeList)
  parse arg buttons, Msg

  if datatype( buttons ) <> 'NUM' & buttons <> '' then
  do
    Msg = buttons || Msg
    buttons = 0
  end /* if datatype( ... */
  else
    if strip( buttons ) = '' then
      buttons = 0

  rxSay Msg || '|' buttons+32  prog.__vName || ' - Message'
RETURN

/* ------------------------------------------------------------------ */
/* LoadRexxUtil                                                       */
/*                                                                    */
/* Function: load the DLL REXXUTIL                                    */
/*                                                                    */
/* Usage:    LoadREXXUtil                                             */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  1 - okay                                                 */
/*           else error                                               */
/*                                                                    */
LoadREXXUtil:
                        /* install a temporary error handler          */
                        /* note: the previous errorhandler is auto-   */
                        /*       maticly restored a the end of the    */
                        /*       routine                              */
   SIGNAL ON SYNTAX NAME InitDllError
 
                        /* set a marker                               */
   dllInitOK = 0
 
                        /* first deregister the function              */
   call rxFuncDrop "SysLoadFuncs"
 
                        /* load the function                          */
   call rxFuncAdd "SysLoadFuncs", "REXXUTIL", "SysLoadFuncs"

                        /* call the init function                     */
   call SysLoadFuncs

   dllInitOK = 1        /* set the marker, this statement is not      */
                        /* executed if the previous statement fails!  */
 
InitDllError:
                        /* deRegister the name if the init call       */
                        /* failed                                     */
   if dllInitOK = 0 then
     call rxFuncDrop "SysLoadFuncs"
 
                        /* returns: 1 - dll init ok                   */
                        /*          0 - dll init error                */
RETURN dllInitOK

/* ------------------------------------------------------------------ */
/* function: test if a drive is ready                                 */
/*                                                                    */
/* call:     DriveReady( testDrive )                                  */
/*                                                                    */
/* where:    testdrive - Name of the drive to test (e.g. "A:")        */
/*                                                                    */
/* returns:  1 - drive is ready                                       */
/*           0 - drive is not ready                                   */
/*                                                                    */
DriveReady: PROCEDURE
  parse arg driveToTest ":" .

  thisRC = 0

                        /* install a temporary error handler to check */
                        /* if the drive is ready                      */
  SIGNAL ON NOTREADY Name DriveReadyEnd

  call stream driveToTest || ":\*", "D"
  thisRC = 1

DriveReadyEnd:
  RETURN thisRC

/* ------------------------------------------------------------------ */
/* InitRxDlg                                                          */
/*                                                                    */
/* Function: init Rexx Dialog variables                               */
/*                                                                    */
/* Usage:    InitRxDlg                                                */
/*                                                                    */
/* where:                                                             */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
InitRxDlg:
                    /* declare some REXX variables to avoid NOVALUE   */
                    /* condition if using the Rexx Dialog commands    */
  RXACTIVE = 'RXACTIVE'
  RXERR    = 'RXERR'
  RXDLG    = 'RXDLG'
  RXSAY    = 'RXSAY'
  RXQUERY  = 'RXQUERY'
  RXFILE   = 'RXFILE'
  RXSET    = 'RXSET'

  exposeList = exposeList ' RXACTIVE RXERR RXDLG RXSAY RXQUERY RXFILE RXSET '

  RXERR 'NUM|FULL'
RETURN

/* ------------------------------------------------------------------ */
/* InitVariables                                                      */
/*                                                                    */
/* Function: init the global variables                                */
/*                                                                    */
/* Usage:    InitVariables                                            */
/*                                                                    */
/* where:                                                             */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
InitVariables:
  exposeList = exposeList ,
               ' sourceFiles. targetFiles. copyrightFiles. compileCommands. '

                    /* name & path of the current ini file            */
  REXXCC2.__IniFileName = ''

                    /* name & path of the compiler                    */
  REXXCC2.__CompilerName = SearchProgram( 'REXXCC.CMD' )
  if CheckCompiler( REXXCC2.__CompilerName ) = 0 then
    REXXCC2.__CompilerName = ''

                    /* name of the editor                             */
  REXXCC2.__EditorName = 'E'

                    /* default target directory                       */
  REXXCC2.__DefaultTargetDir = ''

                    /* mode for REXXCC (1 - compress, 2 - compile)    */
  REXXCC.__Mode = 2

                    /* options for REXXCC                             */
                    /* 1 - add Code          2 - ignore Date          */
                    /* 3 - ignore version    4 - ignore extension     */
                    /* 5 - overwrite         6 - Use source           */
  REXXCC.__Options = '1'

                    /* linecount value for REXXCC                     */
  REXXCC.__LineCount = 0

                    /* options for REXXCC/2                           */
                    /* 1 : save options at program end                */
                    /* 2 : use environment variable REXXCC            */
                    /* 3 : edit compile command before executing      */
  REXXCC2.__Options = '2'

                    /* stem with the sourcefiles already selected     */
  SOURCEFILES.        = ' '
  SourceFiles.__CurPath = directory()

                    /* stem with the targetfiles already selected     */
  TARGETFILES.        = ' '
  TargetFiles.__CurPath = directory()

                    /* stem with the copyrightfiles already selected  */
  COPYRIGHTFILES.     = ' '
  CopyrightFiles.__CurPath = directory()

                    /* stem with the commands already executed        */
  CompileCommands. = ' '

                        /* default window dimensions & sizes          */
                        /* for the windows                            */
                        /* format: width height xpos ypos             */
  window.__MainWindowDim          = '650 300 100 50'
  window.__OptionWindowDim        = '625 375 10 10'
  window.__GetIniFileWindowDim    = '600 200 10 10'
  window.__EditCommandWindowDim   = '775 100 10 10'
  window.__CompileStatusWindowDim = '700 265 10 10'
  window.__StatusWindowDim        = '550 150 10 10'

RETURN

/* ------------------------------------------------------------------ */
/* error exit for NoValue errors                                      */
/*                                                                    */
NoValue:
  call ShowErrorMsg , 'NOVALUE error occured in line ' || sigl || '.' || crlf ||,
                      'The uninitialisized variable is "' || condition('D') || '"'

exit 255

/* ------------------------------------------------------------------ */

