import os
import boto3

rds = boto3.client('rds')
DB_INSTANCE_ID = os.environ['DB_INSTANCE_ID']

# Define scaling plan: vertical scaling classes
SCALE_UP_CLASSES = ["db.t3.medium", "db.t3.large", "db.m5.large"]
SCALE_DOWN_CLASSES = ["db.t3.large", "db.t3.medium"]

def lambda_handler(event, context):
    print("Received event:", event)
    response = rds.describe_db_instances(DBInstanceIdentifier=DB_INSTANCE_ID)
    current_class = response['DBInstances'][0]['DBInstanceClass']
    
    alarm_name = event['Records'][0]['Sns']['Subject']
    
    if "high" in alarm_name.lower():
        # Scale Up
        try:
            next_class = SCALE_UP_CLASSES[SCALE_UP_CLASSES.index(current_class)+1]
        except IndexError:
            print("Already at max instance class")
            return
    else:
        # Scale Down
        try:
            next_class = SCALE_DOWN_CLASSES[SCALE_DOWN_CLASSES.index(current_class)+1]
        except IndexError:
            print("Already at min instance class")
            return

    print(f"Modifying DB to class: {next_class}")
    rds.modify_db_instance(
        DBInstanceIdentifier=DB_INSTANCE_ID,
        DBInstanceClass=next_class,
        ApplyImmediately=True
    )

