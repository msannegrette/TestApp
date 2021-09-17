#!/bin/bash
PER95=$1
HITS=$2
PERERR=$3
REQ=$4
if [ -z $REQ ];
then echo "reporting: 
- module: passfail 
  criteria: 
    Se supero el tiempo maximo del 95 percentil ("$PER95"ms): p95>"$PER95"ms, continue as failed
    No se llego a la cantidad especificada de requests ("$HITS"): hits<"$HITS", continue as failed
    Se supero el procentaje maximo de errores ("$PERERR"%): fail>"$PERERR"%, continue as failed">passfail.yaml; 
else echo "reporting: 
- module: passfail 
  criteria: 
    Se supero el tiempo maximo del 95 percentil ("$PER95"ms): p95 of $REQ>"$PER95"ms, continue as failed
    No se llego a la cantidad especificada de requests ("$HITS"): hits of $REQ<"$HITS", continue as failed    
    Se supero el procentaje maximo de errores ("$PERERR"%): fail>"$PERERR"%, continue as failed">passfail.yaml; fi

echo "services:
- module: shellexec
  post-process:
  - /home/jenkins/.bzt/jmeter-taurus/5.2.1/bin/jmeter.sh -Jjmeter.save.saveservice.assertion_results_failure_message=false -Jjmeter.reportgenerator.overall_granularity=15000 -Jjmeter.reportgenerator.report_title=${JOB_NAME} -g "'${TAURUS_ARTIFACTS_DIR}'"/kpi.jtl -o dashboard 
  - mv "'${TAURUS_ARTIFACTS_DIR}'"/kpi.jtl .
  - ls -a" >>passfail.yaml
