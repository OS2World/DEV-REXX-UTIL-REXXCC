/* ------------------------------------------------------------------ */
/* install program for REXXCC.CMD                                     */
/*                                                                    */
/* Initial Release:                                                   */
/*    11.08.1994 /bs                                                  */
/* Last Update:                                                       */
/*    04.06.1995 /bs                                                  */
/*      - corrected a bug, if installing in a relativ entered         */
/*        directory (like for example: "..")                          */
/*      - added code to support archives with missing                 */
/*        EAs for REXXCC.                                             */
/*      - added code to cleanup the install directory                 */
/*        after the installation                                      */
/*      - deleted code to install REXXCCW                             */
/*      - added code to install REXXCC/2 instead of                   */
/*        the old WPS frontend REXXCCW                                */
/*    16.10.1995 /bs                                                  */
/*      - added code to install UPCKREXX.CMD                          */
/*    09.09.1997 /bs                                                  */
/*      - added code to install REXXCCM.CMD                           */
/*      - corrected some errors in the statements to call CMD         */
/*        commands.                                                   */
/*                                                                    */
/*                                                                    */
/* Usage:                                                             */
/*    install                                                         */
/*                                                                    */
/* written by: Bernd Schemmer, Baeckerweg 48, D-60316 Frankfurt       */
/*             Germany, CompuServe: 100104,613                        */
/*                                                                    */
/* Note: This file needs the OS/2 REXX dll REXXUTIL                   */
/* ------------------------------------------------------------------ */

/* ------------------------------------------------------------------ */
                        /* install error handlers                     */

  signal on error  Name ErrorAbort
  signal on halt   Name UserAbort
  signal on syntax Name ErrorAbort

/* ------------------------------------------------------------------ */
                        /* get drive, path and name of this program   */

  parse source . . prog.__FullName
  prog.__Drive     = filespec( "drive", prog.__FullName )
  prog.__Path      = filespec( "path",  prog.__FullName )
  prog.__Dir       = prog.__Drive || prog.__Path
  prog.__Name      = filespec( "name",  prog.__FullName )
  prog.__Env       = 'OS2ENVIRONMENT'
  prog.__Version   = 'V3.21'
  prog.__CurDir    = directory()
  prog.__ExitCode  = 1          /* return code of INSTALL.CMD         */
  prog.__Files     = 'REXXCC*.*'
  prog.__UFiles    = 'UPCKREXX.*'
  prog.__rxFiles   = 'RX*.*'    /* files for Rexx Dialog              */

/* ------------------------------------------------------------------ */
                        /* save the OS/2 environment                  */
  call setlocal

/* ------------------------------------------------------------------ */
                        /* flush the keyobard buffer                  */
  do while lines() <> 0
    dummy = lineIn()
  end /* do while lines() <> 0 */

/* ------------------------------------------------------------------ */
                        /* load REXXUTIL                              */
  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs' 
  call SysLoadFuncs

/* ------------------------------------------------------------------ */
                        /* show the logo                              */

  do until InstallPath <> ''
    '@cls'
    Say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'É' || Left( 'Í', 75, 'Í' ) || '» '
    Say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' Installation program for REXXCC',75 ) || 'º '
    Say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( 'Version ' || prog.__Version, 75 ) || 'º '
    Say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( '(c) Bernd Schemmer 1994,1997',75 ) || 'º '
    Say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'È' || Left( 'Í',75,'Í' ) || '¼ '
    Say '1B'x || '[0;m'

    say ' Enter the target directory for REXXCC ("." for current dir, "exit" to abort)'
    call CharOut , ' >> '

    parse upper pull installPath
    installPath = strip( InstallPath )
    if installPath = 'EXIT' then
      signal UserAbort
  end /* do until InstallPath <> '' */

                    /* delete a trailing backslash if neccessary      */
  if right( installPath, 1 ) = '\' then
    installPath = substr( installPath, 1, length( installPath ) - 1 )

                    /* get the full name of the target directory      */
  testPath = stream( installPath || '\*.*', 'c', 'QUERY EXIST' )

  if testPath <> '' then
    testPath = fileSpec( "drive", TestPath ) || ,
               fileSpec( "path",  TestPath )
  else
    testPath = installPath

                    /* delete a trailing backslash if neccessary      */
  if right( testPath, 1 ) = '\' then
    testPath = substr( testPath, 1, length( testPath ) - 1 )

  say ''
  say ' Installing REXXCC into the directory '
  say '  ' || testPath || ' '

  if translate( testPath ) || '\' = translate( prog.__dir ) then
    call ShowError  'You can not use the installation directory as target directory!'

                    /* check if the target directory exist            */
  curDir = directory()
  newDirExist = directory( installPath ) <> ''
  call directory curDir

  if NewDirExist = 0 then
  do
    say ''
    thisKey = AskUser( 'YNQX', ' The directory does not exist. Create it (Y/N)? ' )
    if thisKey <> 'Y' then
      signal programAbort

    say ' Creating the directory'
    say '  ' || installPath || ' ...'
    '@md ' installPath '1>NUL'
    if rc <> 0 then
      call ShowError 'OS Error ' || rc || ' creating the directory "' || installPath || '"!'
  end /* if directory( installPath = '' ) then */

                    /* get the full name of the target directory      */
  call directory installpath
  installPath = directory()
  call directory curDir

  if stream( installPath || '\' || prog.__Files, 'c', 'QUERY EXIST' ) <> '' then
  do
    say ''
    say ' Installed version of REXXCC detected in the target directory.'
    thisKey = AskUser( 'YNQX', ' Delete the old version (Y/N)? ')
    if thisKey <> 'Y' then
      signal programAbort

    say ''
    say ' Deleting the old version of REXXCC in the directory '
    say '  ' || installPath || ' ...'

    '@attrib -r ' installPath || '\' || prog.__Files '1>NUL'
    if rc <> 0 then
      '@del ' installPath || '\' || prog.__Files '1>NUL'

    if rc <> 0 then
      call ShowError 'OS Error ' || rc || ' deleting the old version!'

            /* delete the object for the old WPS frontend REXXCCW     */
    call SysDestroyObject '<REXXCCW>'

        /* delete an existing object for the new frontend REXXCC/2    */
    call SysDestroyObject '<REXXCC/2>'
  end /* if stream( ... */

  say ''
  say ' Copying the files for REXXCC to '
  say '  ' || installPath || ' ...'
  '@copy /f  ' prog.__dir || prog.__Files ' ' installPath || '\' || prog.__Files '1>NUL'
  if rc <> 0 then
    call ShowError 'OS Error ' || rc || ' copying the files!'

  say ''
  say ' Copying the files for UPCKREXX to '
  say '  ' || installPath || ' ...'
  '@copy /f  ' prog.__dir || prog.__uFiles ' ' installPath || '\' || prog.__uFiles '1>NUL'
  if rc <> 0 then
    call ShowError 'OS Error ' || rc || ' copying the files!'

  say ''
  say ' Copying the files for REXXCC/2 to '
  say '  ' || installPath || ' ...'
  '@copy /f  ' prog.__dir || prog.__rxFiles ' ' installPath || '\' || prog.__rxFiles '1>NUL'
  if rc <> 0 then
    call ShowError 'OS Error ' || rc || ' copying the files!'

                                /* check the EAs of REXXCC.CMD        */
  thisRC = SysGetEA( InstallPath || '\' || 'REXXCC.CMD',,
               'REXX.TOKENSIMAGE' ,,
               testVar )

  if thisRC <> 0 | length( testVar ) < 100  then
  do
                        /* EAs are missing or invalid -- reAttach     */
                        /* the EAs to the file REXXCC.CMD             */
    say ' The EAs of REXXCC are missing or invalid. Reattaching the EAs to REXXCC ...'
    '@attrib -r '  InstallPath || '\' || 'REXXCC.CMD >NUL'
    '@EAUTIL ' InstallPath || '\' || 'REXXCC.CMD' InstallPath || '\' || 'REXXCC.EA' '/J /O /P'
  end /* if SysGetEA( ...*/

                        /* set the read-only attribute for the files  */
                        /* to avoid deleting them                     */
  '@attrib +r  ' installPath || '\' || prog.__Files '1>NUL'
  '@cls'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'É' || Left( 'Í', 75, 'Í' ) || '»'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( '',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' REXXCC includes a WPS frontend named REXXCC/2. This is a little program',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' to enter the parameter for REXXCC in common dialog boxes rather',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' than entering them on the commandline.',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( '',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' Note for users of previous versions of REXXCC:',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( ' REXXCC/2 is the successor of REXXCCW. REXXCC/2 won''t need VREXX2 anymore.',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'º' || Center( '',75 ) || 'º'
  say '1B'x || '[0;m ' || '1B'x || '[7;m' || 'È' || Left( 'Í',75,'Í' ) || '¼'
  say '1B'x || '[0;m'
  thisKey = AskUser( 'YNQ', ' Should I create an object for REXXCC/2 (Y/N)? ' )

  if thisKey = 'Y' then
  do
    say ' Creating an object for REXXCC/2 on your desktop ...'

     objectID  = '<REXXCC/2>'
        title  = 'REXXCC/2'
    className  = 'WPProgram'
     location  = '<WP_DESKTOP>'
        setup  = 'EXENAME=' || installPath || '\RX.EXE'          || ';' || ,
                 'PARAMETERS=' || installPath || '\REXXCC2.CMD'  || ';' || ,
                 'STARTUPDIR=' || installpath                    || ';' || ,
                 'ICONFILE=' || installPath || '\REXXCC2.ICO'    || ';' || ,
                 'PROGTYPE='   || 'PM'                           || ';' || ,
                 'NODROP='     || 'YES'                          || ';' || ,
                 'OBJECTID='   || objectID                       || ';'
    UpdateFlag = 'U'

    thisRC = SysCreateObject( className, title, location, setup , updateFlag )
    if thisRC <> 1 then
    do
      say ' Oops, can not create the object for REXXCC/2.' || '07'x
      say ' You must create it by hand.'
      say ''
    end /* if thisRC <> 1 */
    else
      prog.__ExitCode = 0

  end /* if thisKey = 'Y' then */

  thisKey = AskUser( 'YNQ', ' Should I cleanup the installation directory (Y/N)? ' )
  if thiskey= 'Q' then
    signal ProgramAbort

  if thiskey = 'Y' then
  do
    say ' Cleaning the directory '
    say '  ' || prog.__dir ' ...'

     call directory prog.__dir
     filesToDelete = prog.__files prog.__uFiles prog.__rxFiles ,
                     'INSTALL.CMD INSTALL.ICO README.CMD FILE_ID.DIZ'
     do i = 1 to words( filesToDelete )
       SIGNAL OFF ERROR
       curFile = word( filesToDelete, i )
       '@attrib -r ' || curFile  '2>NUL 1>NUL'
       '@del ' curFile '2>NUL 1>NUL'
     end /* do */

  end /* if thisKey = 'Y' then */

  prog.__ExitCode = 0

programEnd:

  say ' REXXCC successfully installed in the directory '
  say '  ' || installPath || '.'

programExit:
                        /* restore the OS/2 environment               */
  call endlocal
exit prog.__ExitCode

/* ------------------------------------------------------------------ */
/* AskUser - get input from the user                                  */
/*                                                                    */
/* Usage:    AskUser akeys, prompt                                    */
/*                                                                    */
/* where:    akeys - allowed keys (all keys are translated to         */
/*                   uppercase)                                       */
/*           prompt - prompt for the ask                              */
/*                                                                    */
/* Returns:  the pressed key in uppercase                             */
/*                                                                    */
AskUser:
  parse arg aKeys, prompt

  aKeys = translate( akeys )

  call charout ,  prompt

  thisKey = ' '
  do UNTIL pos( thisKey ,  aKeys ) <> 0
    call charOut ,'1B'x || '[s' || '1B'x || '[K' || '' || '07'x
    thisKey = translate( charIn() )
    call CharOut , '1B'x || '[u'
    dummy = lineIn()
  end /* do until ... */
  say ''

RETURN thisKey

/* ------------------------------------------------------------------ */
/* show an error message and end the program                          */
/*                                                                    */
ShowError:
  parse arg errorMessage

  say ''
  say ' REXXCC Install - Error: '
  say '  ' || errorMessage || '07'x

programAbort:
  say ''
  say ' Installation aborted.'
signal ProgramExit

/* ------------------------------------------------------------------ */
/* error handler                                                      */

ErrorAbort:
  thisLineNo = sigl

  say ''
  say ''
  say ' ------------------------------------------------------------------ '
  say ' ' || prog.__Name || ' - Unexpected error ' || rc || ' in line ' || thisLineNo || ' detected!'
  say ''

  say ' The line reads: '

  thisprefix = ' *-* '

  do forever
    thisSourceLine = sourceLine( thisLineNo )
    say thisPrefix || thisSourceLine
    if right( strip( thisSourceLine ) ,1,1 ) <> ',' then
      leave
    thisLineNo = thisLineNo +1
    thisPrefix = '     '
  end /* do forever */

  if datatype( rc, 'W' ) = 1 then
    if rc > 0 & rc < 100 then
    do
     say ''
     say ' The REXX error message is: ' errorText( rc )
    end /* if datatype( rc, 'W' ) = 1 then */

  say ' ------------------------------------------------------------------ '
  say ''

  prog.__ExitCode = 255
signal ProgramExit

/* break handler */
UserAbort:
    say ''
    say ' ------------------------------------------------------------------ '
    say ' ' || prog.__Name || ' - Unexpected error 997 detected!'
    say ''
    say ' The error message is: Program aborted by the user!'
    say ' ------------------------------------------------------------------ '
    say ''

  prog.__ExitCode = 254
signal ProgramExit

