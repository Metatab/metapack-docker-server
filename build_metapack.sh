#!/bin/sh 


PATH=/usr/local/bin:$PATH

cd /opt/metapack/collection

# Store the AWS credentials where the crontable file can get to them. 
#env | grep AWS  > /opt/metapack/aws_credentials

# Clone all of the packages mentioned in the metapacl.yaml file
invoke clone

# Make the packages, if they have change and the UpdateFrequence indicates it is time to rebuild
invoke make
