CREATE TABLE `DBSchemaVersion` (
  `VersionNumber` varchar(255),
  `VersionApplication` Char(10),
  `VersionDate` Datetime,
  `VersionInfoURL` varchar(255)
);

INSERT INTO `DBSchemaVersion` ( `VersionNumber`, `VersionApplication`, `VersionDate`, `VersionInfoURL`) VALUES
 ( '3.1.8', 'NAADSMXXXX', '2007-03-23 13:42:00', '' );


CREATE TABLE `scenario` (
	`scenarioID` int,
	`descr` mediumtext
);

ALTER TABLE `scenario`
  ADD CONSTRAINT PRIMARY KEY ( `scenarioID` );
  
 
CREATE TABLE `message` (
	`messageID` int,
	`scenarioID` int
);

ALTER TABLE `message`
	ADD CONSTRAINT PRIMARY KEY ( `messageID`, `scenarioID` );

ALTER TABLE `message`
	ADD CONSTRAINT FOREIGN KEY ( `scenarioID` ) 
	REFERENCES `scenario` ( `scenarioID` );


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
	`scenarioID` int,
  `outGeneralID` Char(10),
  `simulationStartTime` Datetime,
  `simulationEndTime` Datetime,
  `completedIterations` int,
  `version` varchar(50),
  `lastUpdated` timestamp
);

ALTER TABLE `outGeneral`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );


CREATE TABLE `outIteration` (
	`scenarioID` int,
  `iteration` int,
  `diseaseEnded` boolean,
  `diseaseEndDay` int,
  `outbreakEnded` boolean,
  `outbreakEndDay` int,
  `lastUpdated` timestamp
);

ALTER TABLE `outIteration`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outIteration`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID` );


CREATE TABLE `outDailyByProductionType` (
	`scenarioID` int,
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
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outDailyByProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `day`, `productionTypeID` );


CREATE TABLE `outDailyByZone` (
	`scenarioID` int,
  `iteration` int,
  `day` int,
  `zoneID` int,
  `area` Double
);

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outDailyByZone`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `day`, `zoneID` );


CREATE TABLE `outDailyByZoneAndProductionType` (
	`scenarioID` int,
  `iteration` int,
  `day` int,
  `zoneID` int,
  `productionTypeID` int,
  `unitDays` int,
  `animalDays` int,
  `unitsInZone` int,
  `animalsInZone` int
);

ALTER TABLE `outDailyByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

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
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `day`, `zoneID`, `productionTypeID` );


CREATE TABLE `outEpidemicCurves` (
	`scenarioID` int,
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
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outEpidemicCurves`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `day`, `productionTypeID` );


CREATE TABLE `outIterationByProductionType` (
	`scenarioID` int,
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
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outIterationByProductionType`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `productionTypeID` );


CREATE TABLE `outIterationByZone` (
	`scenarioID` int,
  `iteration` int,
  `zoneID` int,
  `maxArea` Double,
  `maxAreaDay` int,
  `finalArea` Double
);

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT FOREIGN KEY ( `zoneID` )
  REFERENCES `inZone` ( `zoneID` );

ALTER TABLE `outIterationByZone`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `zoneID` );


CREATE TABLE `outIterationByZoneAndProductionType` (
	`scenarioID` int,
  `iteration` int,
  `zoneID` int,
  `productionTypeID` int,
  `unitDays` int,
  `animalDays` int
);

ALTER TABLE `outIterationByZoneAndProductionType`
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

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
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `productionTypeID`, `zoneID` );


CREATE TABLE `outIterationCosts` (
	`scenarioID` int,
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
  ADD CONSTRAINT FOREIGN KEY ( `scenarioID` )
  REFERENCES `scenario` ( `scenarioID` );

ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT FOREIGN KEY ( `iteration` )
  REFERENCES `outIteration` ( `iteration` );
  
ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT FOREIGN KEY ( `productionTypeID` )
  REFERENCES `inProductionType` ( `productionTypeID` );

ALTER TABLE `outIterationCosts`
  ADD CONSTRAINT PRIMARY KEY ( `iteration`, `scenarioID`, `productionTypeID` );


