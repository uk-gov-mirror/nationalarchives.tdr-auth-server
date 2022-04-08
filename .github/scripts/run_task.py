import boto3
import sys

account_number = sys.argv[1]
stage = sys.argv[2]
update_policy = sys.argv[3]

client = boto3.client('ecs')
ec2_client = boto3.client("ec2")

filtered_security_groups = list(filter(lambda filtered_sg: filtered_sg['GroupName'] == "allow-outbound-https",
                                       ec2_client.describe_security_groups()['SecurityGroups']))
security_groups = [security_group['GroupId'] for security_group in filtered_security_groups]
subnets = [subnet['SubnetId'] for subnet in ec2_client.describe_subnets(Filters=[
    {
        'Name': 'tag:Name',
        'Values': [
            'tdr-private-subnet-0-' + stage,
            'tdr-private-subnet-1-' + stage,
        ]
    },
])['Subnets']]

response = client.run_task(
    cluster="keycloak_update_intg",
    taskDefinition="keycloak-update-intg",
    launchType="FARGATE",
    platformVersion="1.4.0",
    overrides={
        'containerOverrides': [
            {
                'name': 'tdr-keycloak-update',
                'environment': [
                    {
                        'name': 'UPDATE_POLICY',
                        'value': update_policy
                    },
                ]
            }
        ]
    },
    networkConfiguration={
        'awsvpcConfiguration': {
            'subnets': subnets,
            'securityGroups': security_groups
        }
    }
)
