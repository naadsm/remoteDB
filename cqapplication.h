/*
cqapplication.h
---------------
Begin: 2007/03/19
Last revision: $Date: 2007-09-24 18:04:50 $ $Author: areeves $
Version: $Revision: 1.3 $
Project: NAADSM remote database support
Website: http://www.naadsm.org
Author: Aaron Reeves <Aaron.Reeves@colostate.edu>
--------------------------------------------------
Copyright (C) 2007 Animal Population Health Institute at Colorado State University

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/


#ifndef _CQAPPLICATION_H_
#define _CQAPPLICATION_H_

#include <qcoreapplication.h>

class CQMyHTTPServer;
class CSqlDatabase;
class CQStringList;
class QTimer;
class CDatabaseParams;

class CQApplication:public QCoreApplication {
  Q_OBJECT

  public:
    CQApplication( int& argc, char** argv, CDatabaseParams* dbParams );
    virtual ~CQApplication( void );

    bool handleMessage( const QString& message, const bool isRawData );

  protected slots:
    void pingDatabase( void );
    
  protected:
    CQStringList* newSqlListFromString( const QString& str );
    
    CQMyHTTPServer* pHttpServer;
    CSqlDatabase* pDatabase;
    QTimer* pTimer;
};



#endif // _CQAPPLICATION_H_

