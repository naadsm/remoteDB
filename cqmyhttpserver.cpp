/*
cqmyhttpserver.cpp
------------------
Begin: 2007/03/19
Last revision: $Date: 2008/09/18 22:50:44 $ $Author: areeves $
Version: $Revision: 1.4 $
Project: NAADSM remote database support
Website: http://www.naadsm.org
Author: Aaron Reeves <Aaron.Reeves@colostate.edu>
Author: Shaun Case <Shaun.Case@colostate.edu>
--------------------------------------------------
Copyright (C) 2007 Animal Population Health Institute at Colorado State University

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/


#include "cqmyhttpserver.h"

#include <qstringlist.h>
#include <qtextcodec.h>


#include "cqapplication.h"

#include <gpClasses/log.h>
#ifdef GLOBAL_DEBUG_LOG
# define USE_DEBUG_LOG true
#else
  // Set this to true to show debugging messages for this unit.
# define USE_DEBUG_LOG false
#endif


CQMyHTTPServer::CQMyHTTPServer( QHostAddress address, QObject* parent, const char* name, bool checkHost, quint16 port )
  : CQHTTPServer( address, parent, name, checkHost, port )
{
  myApp = (CQApplication*)parent;
}

void CQMyHTTPServer::replyToClient( CHTTPServerClient* client ) {
  QHttpRequestHeader Headers = client->headers();
  bool isRaw = false;
  bool messageProperlyProcessed = false;

  if( USE_DEBUG_LOG ) log->verbose( "CQMyHTTPServer::replyToClient( CHTTPServerClient * )" );
  
  /*
  qDebug() << endl << "========MESSAGE";
  qDebug() << client->rawData();
  qDebug() << "========END MESSAGE" << endl;
    
  qDebug() << "Headers:" << endl << Headers.toString();
  qDebug() << "User agent:" << Headers.value( "user-agent" );
  qDebug() << "Cookie:" << Headers.value( "cookie" );
  qDebug() << "Content type:" << Headers.contentType();
  */
    
  if( Headers.value( "user-agent" ).contains( "RemotePost" ) || Headers.value( "cookie" ).contains( "AaronReeves" ) ) {  
    if ( Headers.contentType() == "text/plain" )
      isRaw = true; 
      
    if( !isRaw ) {
      if( !( "message=" == client->message().trimmed().left(8) ) ) {
        if( USE_DEBUG_LOG ) log->verbose( "Attempted communication does not contain a message." );
        sendOK( client, false );
        if( USE_DEBUG_LOG ) log->verbose( "Leaving CQMyHTTPServer::replyToClient( CHTTPServerClient * ) early" );
        return;
      }
    }
    
    messageProperlyProcessed = myApp->handleMessage( client->message(), isRaw );
  
    sendOK( client, messageProperlyProcessed ); // Close the socket nicely and get on with things         
  }
  else {      
    if( USE_DEBUG_LOG ) log->verbose( "Attempted communication from a non-NAADSM application received: closing connection." );
    if( USE_DEBUG_LOG ) log->verbose( "Leaving CQMyHTTPServer::replyToClient( CHTTPServerClient* ) early" );      
    client->close();    
  }
  
  if( USE_DEBUG_LOG ) log->verbose( "Done CQMyHTTPServer::replyToClient( CHTTPServerClient* )" );
}


void CQMyHTTPServer::sendOK( CHTTPServerClient* client, bool messageOK ) {
  try {
    if( USE_DEBUG_LOG ) log->verbose( "CQMyHTTPServer::sendOK( CHTTPServerClient*, bool )" );

    QString stream;

    stream += "HTTP/1.0 200 OK\n";
    stream += "Server: NAADSMRemoteDB/0.1.0\n"; 
    stream += "Connection: close\n";
    stream += "Content-Type: text/html; charset=iso-8859-1\n\n";
    if( messageOK )
      stream += "X-NAADSMDB: NAADSMDBOK\n";
    else
      stream += "X-NAADSMDB: SENDAGAIN\n";
   
    client->sendString( stream );
    client->close();
    
    if( USE_DEBUG_LOG ) log->verbose( "Done CQMyHTTPServer::sendOK( CHTTPServerClient *, bool )" );
  }
  catch( ... ) {
    if( USE_DEBUG_LOG ) log->verbose( "EXCEPTION: CQMyHTTPServer::sendOK( CHTTPServerClient *, bool )" );
    log->typical( "EXCEPTION: CQMyHTTPServer::sendOK( CHTTPServerClient *, bool )" );
  }     
}

