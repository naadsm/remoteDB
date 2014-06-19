/*
cqapplication.cpp
-----------------
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

#include "cqapplication.h"

#include <qdebug.h>
#include <qfile.h>
#include <qtextstream.h>
#include <qstringlist.h>
#include <qtimer.h>
#include <qdatetime.h>

#include "cqmyhttpserver.h"
#include "cdatabaseparams.h"

#include <gpClasses/cformstring.h>
#include <gpClasses/csql.h>

#include <gpClasses/log.h>
#ifdef GLOBAL_DEBUG_LOG
# define USE_DEBUG_LOG true
#else
  // Set this to true to show debugging messages for this unit.
# define USE_DEBUG_LOG false
#endif



CQApplication::CQApplication( int &argc, char **argv, CDatabaseParams* dbParams )
  : QCoreApplication( argc, argv ) 
{
  
  log->typical( "Application is starting." );
  // FIX ME: there should be a lot of parameters specified at the command line or someplace.
  // e.g., host address and port, database address, port, user, etc.
  
  // Start the HTTP server
  //----------------------
  // FIX ME: what happens if the specified port isn't available?  Show some kind of error message.
  pHttpServer = new CQMyHTTPServer( QHostAddress::Any, this, "httpServer", false, 8083 );
  
  // Start the database
  //-------------------
  pDatabase = new CSqlDatabase( 
    CSqlDatabase::DBMySQL, 
    dbParams->database(), 
    CSqlDatabase::DBOpen, 
    dbParams->user(),
    dbParams->password(),
    dbParams->hostAddr(),
    dbParams->hostPort()
  );
  if( !( pDatabase->isOpen() ) ) {
    log->typical( QString( "Database could not be opened with the following parameters:\n%1" ).arg( dbParams->asString() ) );
    QTimer::singleShot( 500, this, SLOT( quit( void ) ) );
    delete pDatabase;
    pDatabase = NULL;
  }
  else {
    log->typical( "Database is open." );
   
    // Start the timer
    //----------------  
    // It will ping the database server every 5 minutes,
    // thereby (hopefully) preventing it from going away.
    // FIX ME: consider implementing the CSql classes with QSql.  That might
    // avoid the problem with ADO timing out.
    pTimer = new QTimer( this );
    pTimer->setSingleShot( false );
    connect( pTimer, SIGNAL( timeout( void ) ), this, SLOT( pingDatabase( void ) ) );
    pTimer->start( 5 * 60 * 1000 );
  }
}


CQApplication::~CQApplication( void ) {
  log->typical( "Application is shutting down." );
  
  // pHttpServer and pTimer are children of the application object, 
  // and will be deleted automatically.
  
  if( NULL != pDatabase ) {
    if( pDatabase->isOpen() ) {
      pDatabase->close();  
    }
    delete pDatabase;
  }
}


CQStringList* CQApplication::newSqlListFromString( const QString& str ) {
  QString contents = QString();
  QString line;
  QString temp;
  QString* cmd;
  QStringList tempList;
  int i;
  
  if( USE_DEBUG_LOG ) log->verbose( "CQApplication::newSqlListFromString()" );  
  
  // Break the string into individual SQL queries
  //---------------------------------------------
  CQStringList* cmdList = new CQStringList;
  cmdList->setAutoDelete( true );
  
  tempList = str.split( '\n' );
  
  temp = "";
  for( i = 0; i < tempList.count(); ++i ) {
    line = tempList.at(i).trimmed();
    // Make sure that the line is not a comment
    if( ( "--" != line.left( 2 ) ) && ( "#" != line.left( 1 ) ) ) {
      temp.append( line ); 
    
      if( ";" == temp.right( 1 ) || "\\G" == temp.right( 2 ) ) {
        cmd = new QString( temp );
        cmdList->append( cmd );
        //qDebug() << "Query is complete:" << *cmd;
        temp = "";
      }
      else {
        temp.append( " " );
      }    
    }     
  }
  if( USE_DEBUG_LOG ) log->verbose( "Done CQApplication::newSqlListFromString()" );  
  return cmdList;
}


bool CQApplication::handleMessage( const QString& message, const bool isRawData ) {
  CFormString uMessage;
  CQStringList* cmdList;
  int i;
  QString* cmd;
  int unsigned rowsAffected;

  if( USE_DEBUG_LOG ) log->verbose( "CQApplication::handleMessage()" );

  // Decode the message, if necessary
  //---------------------------------
  if( isRawData ) {
    uMessage= CFormString( message, false );
  }
  else {
    uMessage = CFormString( message, true );
    uMessage = uMessage.right( uMessage.length() - 8 );
    uMessage.urlDecode();
  }
  uMessage = uMessage.trimmed();
 
  /* 
  qDebug() << endl << endl;
  qDebug() << "Original message:" << endl << message;
  qDebug() << "Message decoded:" << endl << uMessage ;
  qDebug() << endl << endl;
  */
  
  // Process queries
  //----------------
  // Every query must end with a semicolon.  If the last one is missing, 
  // there is a problem (the message was maybe truncated or something).
  if( !( uMessage.endsWith( ";" ) ) ) {
    log->typical( QString( "INCOMPLETE MESSAGE:\r\n%1\r\n\r\n" ).arg( uMessage ) );
    return false; 
  }
  
  // Split into individual queries...
  cmdList = newSqlListFromString( uMessage );

  // ... and process the list items
  log->verbose( QString( "Command count: %1\r\n\r\n" ).arg( cmdList->count() ) );
  for( i = 0; i < cmdList->count(); ++i ) {
    cmd = cmdList->at(i);

    if( ";" == *cmd ) {
      // skip it
    }
    else {
     //log->verbose( QString( "Executing:\r\n%2\r\n" ).arg( *cmd ) ); 
      
     if( !( pDatabase->execute( *cmd, &rowsAffected ) ) ) {
        // If a query doesn't run, make an entry in the log file
        log->typical( QString( "BAD QUERY: %1\r\n%2\r\n\r\n" ).arg( pDatabase->lastError() ).arg( *cmd ) );
      }
      else {
        //log->verbose( "Good query" );      
      }    
    }
  }

  // Clean up and go home
  //---------------------
  delete cmdList;
  if( USE_DEBUG_LOG ) log->verbose( "Done CQApplication::handleMessage()" );
  return true;
}


void CQApplication::pingDatabase( void ) {
  qDebug() << "Pinging server at" << QDateTime::currentDateTime().toString();
  if( pDatabase->execute( "SELECT NOW()" ) ) {
    qDebug() << "Ping OK.";
  }
  else {
    qDebug() << "Ping failed:" << pDatabase->lastError();
  } 
}

