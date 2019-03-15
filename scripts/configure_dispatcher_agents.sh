#!/bin/bash -x
CURL_RETRY_NUM="2"
AEM_ADMIN_PASSWORD="admin"
agent="Dispatcher"
CQ_PORT="4502"
sitename=${site_dnsname}
AUTHORIP="localhost"
IPS=${disppriv_ips}
TEMPNUM=0

for i in $(echo $IPS | sed "s/,/ /g")
do
	((TEMPNUM=TEMPNUM+1))
	agent_name="Flush0$TEMPNUM"
	agent_front_fqdn="$sitename"
	agent_title="$agent $agent_name"

	CURL="curl --retry $CURL_RETRY_NUM -s -# -u admin:$AEM_ADMIN_PASSWORD"

	$CURL --data jcr:primaryType=cq:Page http://$AUTHORIP:$CQ_PORT/etc/replication/agents.publish/$agent_name | grep -E 'id="Status|Message".*200|OK'

	$CURL -X POST \
	--data-urlencode "./sling:resourceType=cq/replication/components/agent" \
	--data-urlencode "./jcr:lastModified=" \
	--data-urlencode "./jcr:lastModifiedBy=" \
	--data-urlencode "_charset_=utf-8" \
	--data-urlencode ":status=browser" \
	--data-urlencode "./jcr:title=$agent_name" \
	--data-urlencode "./jcr:description=Agent that sends flush requests to the dispatcher." \
	--data-urlencode "./enabled=true" \
	--data-urlencode "./enabled@Delete=" \
	--data-urlencode "./serializationType=flush" \
	--data-urlencode "./retryDelay=60000" \
	--data-urlencode "./userId=" \
	--data-urlencode "./logLevel=error" \
	--data-urlencode "./reverseReplication@Delete=" \
	--data-urlencode "./transportUri=http://$i:80/dispatcher/invalidate.cache" \
	--data-urlencode "./transportUser=" \
	--data-urlencode "./transportPassword=" \
	--data-urlencode "./transportNTLMDomain=" \
	--data-urlencode "./transportNTLMHost=" \
	--data-urlencode "./ssl=" \
	--data-urlencode "./protocolHTTPExpired@Delete=" \
	--data-urlencode "./proxyHost=" \
	--data-urlencode "./proxyPort=" \
	--data-urlencode "./proxyUser=" \
	--data-urlencode "./proxyPassword=" \
	--data-urlencode "./proxyNTLMDomain=" \
	--data-urlencode "./proxyNTLMHost=" \
	--data-urlencode "./protocolInterface=" \
	--data-urlencode "./protocolHTTPMethod=" \
	--data-urlencode "./protocolHTTPHeaders@Delete=" \
	--data-urlencode "./protocolHTTPConnectionClose@Delete=true" \
	--data-urlencode "./protocolConnectTimeout=" \
	--data-urlencode "./protocolSocketTimeout=" \
	--data-urlencode "./protocolVersion=" \
	--data-urlencode "./triggerSpecific@Delete=" \
	--data-urlencode "./triggerModified@Delete=" \
	--data-urlencode "./triggerDistribute@Delete=" \
	--data-urlencode "./triggerOnOffTime@Delete=" \
	--data-urlencode "./triggerReceive@Delete=" \
	--data-urlencode "./noStatusUpdate@Delete=" \
	--data-urlencode "./noVersioning@Delete=" \
	--data-urlencode "./queueBatchMode@Delete=" \
	--data-urlencode "./queueBatchWaitTime=" \
	--data-urlencode "./queueBatchMaxSize=" \
	http://$AUTHORIP:$CQ_PORT/etc/replication/agents.publish/$agent_name/jcr:content | grep -E 'id="Status|Message".*200|OK'
done

$CURL -F cmd=activate -F ignoredeactivated=true -F onlymodified=true -F path=/etc/replication/agents.publish http://$AUTHORIP:$CQ_PORT/etc/replication/treeactivation.html
