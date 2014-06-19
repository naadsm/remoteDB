/*
main.cpp
--------
Begin: 2007/03/19
Last revision: $Date: 2008-09-18 22:50:44 $ $Author: areeves $
Version: $Revision: 1.4 $
Project: NAADSM remote database support
Website: http://www.naadsm.org
Author: Aaron Reeves <aaron.reeves@naadsm.org>
--------------------------------------------------
Copyright (C) 2007 Animal Population Health Institute at Colorado State University

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/


#include <qdebug.h>
#include <qstring.h>

#include <gpClasses/ccmdLine.h>
#include <gpClasses/log.h>
#include <gpClasses/qcout.h>
#include <gpClasses/seh.h>

#include "cqapplication.h"
#include "cdatabaseparams.h"

#define EXITMAINEXCEPTION -2
/*
Some important definitions (set as compiler parameters)

QT_NO_DEBUG_OUTPUT:
  If defined, qDebug() won't do anything.  Consequently, this implies
  LOG_NO_DEBUG_OUTPUT as well.
  
GLOBAL_DEBUG_LOG:
  If defined, verbose logging will be enabled for every class or file.
  If not defined, then a constant in each file will determine whether
  verbose logging is enabled for classes/functions in that file.
  
LOG_NO_DEBUG_OUTPUT:
  If defined, log messages are saved to the log file, but not written to the
  debug stream.
  
NO_LOGGING:
  If defined, disables all logging regardless of settings for individual units. 
*/
  
  
void showVersion( void ) {
  cout << endl;
  cout << "NAADSM Remote Database Manager" << endl;
  cout <<  "Version 0.3.1" << endl;
  cout <<  "Copyright 2007 - 2008 Animal Population Health Institute at" << endl;
  cout <<  "Colorado State University." << endl;
  cout <<  "This is free software, released under the terms of the GNU General Public" << endl;
  cout <<  "License.  Please see the source or the following URL for copying conditions." << endl;
  cout <<  "NAADSM home page: <http://www.naadsm.org>" << endl;
  cout << endl;
}


void showError( const QString& error ) {
  showVersion();
  cout << error << endl;
  cout << endl; 
}


void showHelp( void ) {
  showVersion();
  cout << "USAGE:" << endl;
  cout << "--help, -?:     Display this help message." << endl;
  //cout << "--version, -v:  Display version information." << endl;
  cout << "--host <address>, -h <address>:" << endl;     
  cout << "                Specify the MySQL database server (host) address." << endl;
  cout << "                Default is 127.0.0.1 (localhost)." << endl;
  cout << "--port <number>, -P <number>:" << endl;
  cout << "                Specify the database server port.  Default is 3306." << endl;  
  cout << "--database <name>, -d <name>:" << endl;
  cout << "                Specify the database.  Required." << endl;    
  cout << "--user <name>, -u <name>:" << endl;
  cout << "                Specify the user for the database.  Required." << endl;  
   cout << "--password <password>, -p <password>:" << endl;
  cout << "                Specify the user password for the database.  Required." << endl;   
  cout << endl;
}


bool paramsOK( CCmdLine* cmdLine, CDatabaseParams* dbParams ) {
  // Get database  server address
  //-----------------------------
  if( !( cmdLine->HasSwitch( "--host" ) ) && !( cmdLine->HasSwitch( "-h" ) ) ) {
    dbParams->setHostAddr( "127.0.0.1" );  
  }
  else if( cmdLine->HasSwitch( "--host" ) && cmdLine->HasSwitch( "-h" ) ) {
    showError( "Ambiguous --host switch repetition.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--host" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "--host" ) ) {
      showError( "Incorrect arguments for --host switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setHostAddr( cmdLine->GetArgument( "--host", 0 ) );
    }  
  }
  else if( cmdLine->HasSwitch( "-h" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "-h" ) ) {
      showError( "Incorrect arguments for -h switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setHostAddr( cmdLine->GetArgument( "-h", 0 ) ); 
    }
  }

  // Get database server port
  //-------------------------
  if( !( cmdLine->HasSwitch( "--port" ) ) && !( cmdLine->HasSwitch( "-P" ) ) ) {
    dbParams->setHostPort( 3306 );
  }
  else if( cmdLine->HasSwitch( "--port" ) && cmdLine->HasSwitch( "-P" ) ) {
    showError( "Ambiguous --port switch repetition.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--port" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "--port" ) ) {
      showError( "Incorrect arguments for --port switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setHostPort( cmdLine->GetArgument( "--port", 0 ).toInt() );
    }
  }
  else if( cmdLine->HasSwitch( "-P" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "-P" ) ) {
      showError( "Incorrect arguments for -P switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setHostPort( cmdLine->GetArgument( "-P", 0 ).toInt() ); 
    } 
  }

  // Get database user name
  //-----------------------
  if( !( cmdLine->HasSwitch( "--user" ) ) && !( cmdLine->HasSwitch( "-u" ) ) ) {
    showError( "Missing --user switch.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--user" ) && cmdLine->HasSwitch( "-u" ) ) {
    showError( "Ambiguous --user switch repetition.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--user" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "--user" ) ) {
      showError( "Incorrect arguments for --user switch.  Use --help to view usage instructions." );
      return false;  
    }
    else
      dbParams->setUser( cmdLine->GetArgument( "--user", 0 ) );  
  }
  else if( cmdLine->HasSwitch( "-u" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "-u" ) ) {
      showError( "Incorrect arguments for -u switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setUser( cmdLine->GetArgument( "-u", 0 ) );
    }  
  }

  // Get database user password
  //---------------------------
  if( !( cmdLine->HasSwitch( "--password" ) ) && !( cmdLine->HasSwitch( "-p" ) ) ) {
    showError( "Missing --password switch.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--password" ) && cmdLine->HasSwitch( "-p" ) ) {
    showError( "Ambiguous --password switch repetition.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--password" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "--password" ) ) {
      showError( "Incorrect arguments for --password switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setPassword( cmdLine->GetArgument( "--password", 0 ) );  
    }
  }
  else if( cmdLine->HasSwitch( "-p" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "-p" ) ) {
      showError( "Incorrect arguments for -p switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setPassword( cmdLine->GetArgument( "-p", 0 ) );
    }  
  }

  // Get database name
  //------------------
  if( !( cmdLine->HasSwitch( "--database" ) ) && !( cmdLine->HasSwitch( "-d" ) ) ) {
    showError( "Missing --database switch.  Use --help to view usage instructions." );
    return false;      
  }
  else if( cmdLine->HasSwitch( "--database" ) && cmdLine->HasSwitch( "-d" ) ) {
    showError( "Ambiguous --database switch repetition.  Use --help to view usage instructions." );
    return false;  
  }
  else if( cmdLine->HasSwitch( "--database" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "--database" ) ) {
      showError( "Incorrect arguments for --database switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setDatabase( cmdLine->GetArgument( "--database", 0 ) ); 
    } 
  }
  else if( cmdLine->HasSwitch( "-d" ) ) {
    if( 1 != cmdLine->GetArgumentCount( "-d" ) ) {
      showError( "Incorrect arguments for -d switch.  Use --help to view usage instructions." );
      return false;  
    }
    else {
      dbParams->setDatabase( cmdLine->GetArgument( "-d", 0 ) );  
    }
  }

  // If we get this far...
  return true;
}


int main( int argc, char *argv[] ) {
  int result;
  int nParams;

  CCmdLine* cmdLine = NULL;
  CDatabaseParams* dbParams = NULL;
  
  log = NULL;
  
  __SEH_TRY {  
  	cmdLine = new CCmdLine();
  	dbParams = new CDatabaseParams();
  
  	cmdLine->SplitLine( argc, argv );
  
    if( cmdLine->HasSwitch( "--help" ) || cmdLine->HasSwitch( "-?" ) ) {
  		showHelp();
  		delete dbParams;
  		delete cmdLine;
  		return EXIT_SUCCESS;
  	} 
  	else if( !paramsOK( cmdLine, dbParams ) ) {
      delete dbParams;
      delete cmdLine;
      return EXIT_SUCCESS; 
    }
    else {
      log = new CAppLog( "NAADSMDB.log", CAppLog::LoggingVerbose );
    
      CQApplication a( argc, argv, dbParams );
    
      result = a.exec();
      
      delete log;
      delete dbParams;
      delete cmdLine;
      
      return result;
    }
  }
  __SEH_EXCEPT( info, context ){
    __SEH_TRY {
      log->typical( "SEH EXCEPTION: caught by main()" );
      delete log;
      delete dbParams;
      delete cmdLine;
      return EXITMAINEXCEPTION;
    }
    __SEH_EXCEPT( info, context ){
      delete log;
      delete dbParams;
      delete cmdLine;
      return EXITMAINEXCEPTION;
    }
    __SEH_END            
  }  
  __SEH_END 
}
