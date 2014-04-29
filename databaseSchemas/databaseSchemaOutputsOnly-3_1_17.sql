CREATE DATABASE naadsm_3_1_17;
USE naadsm_3_1_17;

CREATE TABLE `DBSchemaVersion` (
  `VersionNumber` varchar(255),
  `VersionApplication` Char(10),
  `VersionDate` Datetime,
  `VersionInfoURL` varchar(255),
  `VersionID` int
);

INSERT INTO `DBSchemaVersion` ( `VersionNumber`, `VersionApplication`, `VersionDate`, `VersionInfoURL`, `VersionID` ) VALUES
 ( '3.1.17', 'NAADSMXXXX', '2007-08-07 17:06:00', '', '1189206366' );


CREATE TABLE `scenario` (
	`scenarioID` int,
	`descr` mediumtext
);

ALTER TABLE `scenario`
  ADD CONSTRAINT PRIMARY KEY ( `scenarioID` );

 
CREATE TABLE `job` (
	`jobID` int, 
	`scenarioID` int
);

ALTER TABLE `job`
  ADD CONSTRAINT PRIMARY KEY ( `jobID` );
  
ALTER TABLE `job`
	ADD CONSTRAINT FOREIGN KEY ( `scenarioID` ) 
	REFERENCES `scenario` ( `scenarioID` );
 
CREATE TABLE `message` (
	`messageID` int,
	`jobID` int
);

ALTER TABLE `message`
	ADD CONSTRAINT PRIMARY KEY ( `messageID`, `jobID` );

ALTER TABLE `message`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` );


CREATE TABLE `inProductionType` (
	`productionTypeID` int,
	`descr` varchar(255),
	`scenarioID` int
);

ALTER TABLE `inProductionType`
	ADD CONSTRAINT PRIMARY KEY ( `productionTypeID`, `scenarioID` );

ALTER TABLE `inProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `scenarioID` ) 
	REFERENCES `scenario` ( `scenarioID` );


CREATE TABLE `inZone` (
	`zoneID` int,
	`descr` varchar(255),
	`scenarioID` int
);

ALTER TABLE `inZone`
	ADD CONSTRAINT PRIMARY KEY ( `zoneID`, `scenarioID` );

ALTER TABLE `inZone`
	ADD CONSTRAINT 
	FOREIGN KEY ( `scenarioID` ) REFERENCES `scenario` ( `scenarioID` );
	

CREATE TABLE `outGeneral` (
	`jobID` int,
  `outGeneralID` Char(10),
  `simulationStartTime` Datetime,
  `simulationEndTime` Datetime,
  `completedIterations` int,
  `version` varchar(50),
  `lastUpdated` timestamp
);

ALTER TABLE `outGeneral`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );


CREATE TABLE `outIteration` (
	`jobID` int,
  `iteration` int,
  `diseaseEnded` boolean,
  `diseaseEndDay` int,
  `outbreakEnded` boolean,
  `outbreakEndDay` int,
  `zoneFociCreated` boolean,
  `lastUpdated` timestamp
);

ALTER TABLE `outIteration`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outIteration`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID` );


CREATE TABLE `outCustIteration` (
	`jobID` int,
	`iteration` int
);

ALTER TABLE `outCustIteration`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 
	
ALTER TABLE `outCustIteration`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );


CREATE TABLE `outCustIterationByProductionType` (
	`jobID` int,
	`productionTypeID` int,
	`iteration` int
);

ALTER TABLE `outCustIterationByProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 

ALTER TABLE `outCustIterationByProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` ) 
	REFERENCES `inProductionType` ( `productionTypeID` ); 

ALTER TABLE `outCustIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );


CREATE TABLE `outCustIterationByZone` (
	`jobID` int,
	`zoneID` int,
	`iteration` int
);

ALTER TABLE `outCustIterationByZone`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 


ALTER TABLE `outCustIterationByZone`
	ADD CONSTRAINT FOREIGN KEY ( `zoneID` ) 
	REFERENCES `inZone` ( `zoneID` ); 

ALTER TABLE `outCustIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );


CREATE TABLE `outCustIterationByZoneAndProductionType` (
	`jobID` int,
	`zoneID` int,
	`productionTypeID` int,
	`iteration` int
);

ALTER TABLE `outCustIterationByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 


ALTER TABLE `outCustIterationByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `zoneID` ) 
	REFERENCES `inZone` ( `zoneID` ); 

ALTER TABLE `outCustIterationByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` ) 
	REFERENCES `inProductionType` ( `productionTypeID` ); 

ALTER TABLE `outCustIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
  

CREATE TABLE `outSelectDailyByProductionType` (
	`jobID` int,
	`productionTypeID` int,
	`iteration` int,
	`day` int
);

ALTER TABLE `outSelectDailyByProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 

ALTER TABLE `outSelectDailyByProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` ) 
	REFERENCES `inProductionType` ( `productionTypeID` ); 

ALTER TABLE `outSelectDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
  
CREATE TABLE `outSelectDailyByZoneAndProductionType` (
	`jobID` int,
	`zoneID` int,
	`productionTypeID` int,
	`iteration` int,
	`day` int
);

ALTER TABLE `outSelectDailyByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `jobID` ) 
	REFERENCES `job` ( `jobID` ); 

ALTER TABLE `outSelectDailyByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `zoneID` ) 
	REFERENCES `inZone` ( `zoneID` ); 

ALTER TABLE `outSelectDailyByZoneAndProductionType`
	ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` ) 
	REFERENCES `inProductionType` ( `productionTypeID` ); 

ALTER TABLE `outSelectDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );











CREATE TABLE `outDailyByProductionType` (
	`jobID` int,
  `iteration` int,
  `day` int,
  `productionTypeID` int,
  `tsdUSusc` int,
  `tsdASusc` int,
  `tsdULat` int,
  `tsdALat` int,
  `tsdUSubc` int,
  `tsdASubc` int,
  `tsdUClin` int,
  `tsdAClin` int,
  `tsdUNImm` int,
  `tsdANImm` int,
  `tsdUVImm` int,
  `tsdAVImm` int,
  `tsdUDest` int,
  `tsdADest` int,
  `tscUSusc` int,
  `tscASusc` int,
  `tscULat` int,
  `tscALat` int,
  `tscUSubc` int,
  `tscASubc` int,
  `tscUClin` int,
  `tscAClin` int,
  `tscUNImm` int,
  `tscANImm` int,
  `tscUVImm` int,
  `tscAVImm` int,
  `tscUDest` int,
  `tscADest` int,
  `infnUAir` int,
  `infnAAir` int,
  `infnUDir` int,
  `infnADir` int,
  `infnUInd` int,
  `infnAInd` int,
  `infcUIni` int,
  `infcAIni` int,
  `infcUAir` int,
  `infcAAir` int,
  `infcUDir` int,
  `infcADir` int,
  `infcUInd` int,
  `infcAInd` int,
  `expcUDir` int,
  `expcADir` int,
  `expcUInd` int,
  `expcAInd` int,
  `trcUDir` int,
  `trcADir` int,
  `trcUInd` int,
  `trcAInd` int,
  `trcUDirp` int,
  `trcADirp` int,
  `trcUIndp` int,
  `trcAIndp` int,
  `detnUClin` int,
  `detnAClin` int,
  `desnUAll` int,
  `desnAAll` int,
  `vaccnUAll` int,
  `vaccnAAll` int,
  `detcUClin` int,
  `detcAClin` int,
  `descUIni` int,
  `descAIni` int,
  `descUDet` int,
  `descADet` int,
  `descUDir` int,
  `descADir` int,
  `descUInd` int,
  `descAInd` int,
  `descURing` int,
  `descARing` int,
  `vaccUIni` int,
  `vaccAIni` int,
  `vaccURing` int,
  `vaccARing` int,
  `zonnFoci` int,
  `zoncFoci` int,
  `appUInfectious` int
);

ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `day`, `productionTypeID` );


CREATE TABLE `outDailyByZone` (
	`jobID` int,
  `iteration` int,
  `day` int,
  `zoneID` int,
  `area` Double
);

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `day`, `zoneID` );


CREATE TABLE `outDailyByZoneAndProductionType` (
	`jobID` int,
  `iteration` int,
  `day` int,
  `zoneID` int,
  `productionTypeID` int,
  `unitDaysInZone` int,
  `animalDaysInZone` int,
  `unitsInZone` int,
  `animalsInZone` int
);

ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );
  
ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `day`, `zoneID`, `productionTypeID` );


CREATE TABLE `outEpidemicCurves` (
	`jobID` int,
  `iteration` int,
  `day` int,
  `productionTypeID` int,
  `infectedUnits` int,
  `infectedAnimals` int,
  `detectedUnits` int,
  `detectedAnimals` int,
  `infectiousUnits` int,
  `apparentInfectiousUnits` int
);


ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `day`, `productionTypeID` );


CREATE TABLE `outIterationByProductionType` (
	`jobID` int,
  `iteration` int,
  `productionTypeID` int,
  `tscUSusc` int,
  `tscASusc` int,
  `tscULat` int,
  `tscALat` int,
  `tscUSubc` int,
  `tscASubc` int,
  `tscUClin` int,
  `tscAClin` int,
  `tscUNImm` int,
  `tscANImm` int,
  `tscUVImm` int,
  `tscAVImm` int,
  `tscUDest` int,
  `tscADest` int,
  `infcUIni` int,
  `infcAIni` int,
  `infcUAir` int,
  `infcAAir` int,
  `infcUDir` int,
  `infcADir` int,
  `infcUInd` int,
  `infcAInd` int,
  `expcUDir` int,
  `expcADir` int,
  `expcUInd` int,
  `expcAInd` int,
  `trcUDir` int,
  `trcADir` int,
  `trcUInd` int,
  `trcAInd` int,
  `trcUDirp` int,
  `trcADirp` int,
  `trcUIndp` int,
  `trcAIndp` int,
  `detcUClin` int,
  `detcAClin` int,
  `descUIni` int,
  `descAIni` int,
  `descUDet` int,
  `descADet` int,
  `descUDir` int,
  `descADir` int,
  `descUInd` int,
  `descAInd` int,
  `descURing` int,
  `descARing` int,
  `vaccUIni` int,
  `vaccAIni` int,
  `vaccURing` int,
  `vaccARing` int,
  `zoncFoci` int,
  `firstDetection` int,
  `firstDestruction` int,
  `firstVaccination` int
);

ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `productionTypeID` );


CREATE TABLE `outIterationByZone` (
	`jobID` int,
  `iteration` int,
  `zoneID` int,
  `maxArea` Double,
  `maxAreaDay` int,
  `finalArea` Double
);

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `zoneID` );


CREATE TABLE `outIterationByZoneAndProductionType` (
	`jobID` int,
  `iteration` int,
  `zoneID` int,
  `productionTypeID` int,
  `unitDaysInZone` int,
  `animalDaysInZone` int,
  `costSurveillance` double
);

ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );
  
ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `productionTypeID`, `zoneID` );


CREATE TABLE `outIterationCosts` (
	`jobID` int,
  `iteration` int,
  `productionTypeID` int,
  `destrAppraisal` double,
  `destrCleaning` double,
  `destrEuthanasia` double,
  `destrIndemnification` double,
  `destrDisposal` double,
  `vaccSetup` double,
  `vaccVaccination` double
);


ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT FOREIGN KEY ( `jobID` )
  REFERENCES `job` ( `jobID` );

ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `jobID`, `productionTypeID` );


