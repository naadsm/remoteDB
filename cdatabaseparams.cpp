/*
cdatabaseparams.cpp
-------------------
Begin: 2007/08/30
Last revision: $Date: 2007-09-24 18:13:22 $ $Author: areeves $
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

#include <qdebug.h>

#include "cdatabaseparams.h"

CDatabaseParams::CDatabaseParams( void ) {
  _database = "";
  _user = "";
  _password = "";
  _hostAddr = "127.0.0.1";
  _hostPort = 3306; 
}


void CDatabaseParams::debug( void ) {
  qDebug() << "database:" << _database;
  qDebug() << "user:" << _user;
  qDebug() << "password:" << _password;
  qDebug() << "hostAddr:" << _hostAddr;
  qDebug() << "hostPort:" << _hostPort;
}


QString CDatabaseParams::asString( void ) {
  return QString( "database '%1', user '%2', password '%3', host '%4', port '%5'" )
    .arg( _database ).arg( _user ).arg( _password ).arg( _hostAddr ).arg( _hostPort )
  ;
}
