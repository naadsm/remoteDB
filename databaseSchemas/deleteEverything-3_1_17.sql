delete from outIterationByProductionType WHERE jobID > 100;
delete from outIterationByZone WHERE jobID > 100;
delete from outIterationByZoneAndProductionType WHERE jobID > 100;
delete from outIterationCosts WHERE jobID > 100;

delete from outEpidemicCurves WHERE jobID > 100;

delete from outDailyByProductionType WHERE jobID > 100;
delete from outDailyByZone WHERE jobID > 100;
delete from outDailyByZoneAndProductionType WHERE jobID > 100;

delete from outCustIteration WHERE jobID > 100;
delete from outCustIterationByProductionType WHERE jobID > 100;
delete from outCustIterationByZone WHERE jobID > 100;
delete from outCustIterationByZoneAndProductionType WHERE jobID > 100;

delete from outSelectDailyByProductionType WHERE jobID > 100;
delete from outSelectDailyByZoneAndProductionType WHERE jobID > 100;

delete from outIteration WHERE jobID > 100;
delete from outGeneral WHERE jobID > 100;

delete from message WHERE jobID > 100;
delete from job where scenarioID < 100;
delete from inProductionType  WHERE scenarioID < 100;
delete from inZone WHERE scenarioID < 100;
#delete from scenario WHERE scenarioID < 100;

