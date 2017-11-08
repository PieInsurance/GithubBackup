# Copyright 2012-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
# http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

import boto3
client = boto3.client('codebuild')
def handler(event, context): 
    response = client.start_build(projectName='${CodeBuildProject}')
    output = "Triggered CodeBuild project: 'CodeCommitBackup' to back all CodeCommit repos. Status={}".format(response["build"]["buildStatus"])
    print(output)
    return output
