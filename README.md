# sinusbot OpenShift

Based on https://github.com/SinusBot/docker.git with modifications to run under openshift with any non-root uid

Tested on OpenShift 4.2

## Usage

Install the template:
- in current project: `oc create -f openshift-template.yaml`
- for the entire cluster: `oc create -f openshift-template.yaml -n openshift`

### install inside a namespace

1. __show parameter:__ `oc process sinusbot-openshift-template --parameters`
1. __create from template:__ `oc process sinusbot-openshift-template -p WEBPANEL_DOMAIN=sinusbot.apps.yourclouster.local -p NAME=sinusbot -p NAMESPACE=sinus-openshift`
1. trigger build: `oc start-build sinusbot-openshift-build`
1. **wait until build is complete** `oc get builds -w`
1. trigger the deployment `deployment.apps/sinusbot`

### remove everything

1. `oc delete all,pvc,cm,secret -l app=NAME,template=sinusbot-openshift-template -n YOUR-NAMESPACE`

## youtube-dl

Update of youtube-dl is moved to the Dockerfile. So you can update is by rebuilding the Image

1. trigger build: `oc start-build sinusbot-openshift-build`