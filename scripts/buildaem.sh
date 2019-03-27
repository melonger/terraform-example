#!/bin/bash -x
#########################################################################
## Starting AEM Script
#########################################################################
basefiles="acs-aem-commons-content-3.14.8.zip"
uniquefiles="cq-6.2.0-hotfix-21560-1.0.zip"
URL="https://${storageacct}.blob.core.windows.net"
CONTAINER="aemfiles"
createService aem || :
[[ -z "$1" ]] && VERSION="2" || VERSION="$1"
yum install -y java-1.8.0-openjdk
if [ "$VERSION" -eq "4" ]; then
	aemfile="aem-quickstart-6.4.jar"
	oakfile="oak-run-1.8.2.jar"
elif [ "$VERSION" -eq "3" ]; then
	aemfile="aem-quickstart-6.3.jar"
	oakfile="oak-run-1.6.2.jar"
else
	aemfile="aem-quickstart-6.2.jar"
	oakfile="oak-run-1.4.20.jar"
fi

if [ ! -f /home/aem/$aemfile ]; then
	wget $URL/$CONTAINER/$aemfile -P /home/aem/
fi
if [ ! -f /home/aem/$oakfile ]; then
	wget $URL/$CONTAINER/$oakfile -P /home/aem/
fi

if [ ! -f /home/aem/crx-quickstart/readme.txt ]; then
	cd /home/aem/ && java -jar $aemfile -unpack
	mkdir -p /home/aem/crx-quickstart/install
fi

if [ "$VERSION" -eq "4" ] || [ "$VERSION" -eq "3" ]; then
	for f in $basefiles
	do
		if [ ! -f /home/aem/crx-quickstart/install/$f ]; then
			wget $URL/$CONTAINER/packages/$f -P /home/aem/crx-quickstart/install/
		fi
	done
else
	for f in $basefiles
	do
		if [ ! -f /home/aem/crx-quickstart/install/$f ]; then
			wget $URL/$CONTAINER/packages/$f -P /home/aem/crx-quickstart/install/
		fi
	done
	for f in $uniquefiles
	do
		if [ ! -f /home/aem/crx-quickstart/install/$f ]; then
			wget $URL/$CONTAINER/packages/$f -P /home/aem/crx-quickstart/install/
		fi
	done
fi

chown -R aem:aem /home/aem && chmod 770 /home/aem

#########################################################################
## Finished AEM Script
#########################################################################
