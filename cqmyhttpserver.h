/*
cqmyhttpserver.h
----------------
Begin: 2007/03/19
Last revision: $Date: 2007/04/25 17:56:56 $ $Author: areeves $
Version: $Revision: 1.2 $
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

#ifndef _CQMYHTTPSERVER_H_
#define _CQMYHTTPSERVER_H_

#include <atrShared/cqhttpserver.h>

class CQApplication;

class CQMyHTTPServer : public CQHTTPServer {
  Q_OBJECT

  public:
    /** Constructs a server socket and starts listening on the specified port.  
        If checkHost is true, only recognized hosts receive a real response. */
    CQMyHTTPServer( QHostAddress address, QObject* parent = 0, const char* name = 0, bool checkHost = true, quint16 port = 8080 );

  public slots:
    /** Handles replies to clients. */
    virtual void replyToClient( CHTTPServerClient* client ); // reimplemented   
    
  protected:
    void sendOK( CHTTPServerClient* client, bool messageOK );
    
    /** A pointer to the main application object */
    CQApplication* myApp;
};

#endif // _CQMYHTTPSERVER_H_


 
