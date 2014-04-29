/*
cdatabaseparams.h
-----------------
Begin: 2007/08/30
Last revision: $Date: 2007/09/24 18:13:22 $ $Author: areeves $
Version: $Revision: 1.1 $
Project: NAADSM remote database support
Website: http://www.naadsm.org
Author: Aaron Reeves <Aaron.Reeves@colostate.edu>
--------------------------------------------------
Copyright (C) 2007 Animal Population Health Institute at Colorado State University

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/

#ifndef _CDATABASEPARAMS_H_
#define _CDATABASEPARAMS_H_

#include <qstring.h>

class CDatabaseParams {
  public:
    CDatabaseParams( void );
    
    void debug( void );
    
    inline void setDatabase( QString val ) { _database = val; };
    inline void setUser( QString val ) { _user = val; };
    inline void setPassword( QString val ) { _password = val; };
    inline void setHostAddr( QString val ) { _hostAddr = val; };
    inline void setHostPort( int val ) { _hostPort = val; };
    
    inline QString database( void ) { return _database; };
    inline QString user( void ) { return _user; };
    inline QString password( void ) { return _password; };
    inline QString hostAddr( void ) { return _hostAddr; };
    inline int hostPort( void ) { return _hostPort; };
    
    QString asString( void );
    
  protected:
    QString _database;
    QString _user;
    QString _password;
    QString _hostAddr;
    int _hostPort;
};


#endif // _CDATABASEPARAMS_H_

