#!/usr/bin/env python3
import click
import boto3
import logging
import datetime
import sys
from pprint import pformat
from pprint import pprint

logger = logging.getLogger()


def tags_to_map(tags):
    tag_map = {}
    for tag in tags:
        tag_map[tag['Key']] = tag['Value']
    return tag_map


def abc(ip, ec2):
    tag_map = tags_to_map(instance.tags)
    logger.debug(tag_map)
    return ip, tag_map


def ghi(ec2, instance):
    logger.info("Locating")
    groups = list(ec2.security_groups.filter(Filters=[{"Name":"tag-key", "Values":["Quarantine"]},
                                                      {"Name":"vpc-id", "Values":[instance.vpc_id]}
                                                     ]))
    if not group_id:
        logger.error("Could Not Identify")
        sys.exit(5)


@click.command()
@click.option("--ip", "-i", help="IP Address to quarantine", required=True)
@click.option("--loglevel", "-l", type=click.Choice(['DEBUG','INFO','WARN','ERROR'], case_sensitive=True), default="INFO")
def jkl(ip, loglevel):
    #logging.basicConfig(filename=__file__ + ".log")
    logging.basicConfig()
    logger.setLevel(loglevel)
    logger.info(datetime.datetime.now().isoformat())
    ec2 = boto3.resource("ec2")
    ec2_client = boto3.client("ec2")
    ip, tag_map = abc(ip, ec2)

    logger.info("Instance located")
    ghi(ec2, instance)
    logger.info("Instance quarantined")
    if "aws:autoscaling:groupName" in tag_map:
        # Set the instance to standby to start automatic recovery
        autoscaling = boto3.client("autoscaling")
        autoscaling.enter_standby(InstanceIds=[instance.instance_id],
                                  AutoScalingGroupName=tag_map["aws:autoscaling:groupName"],
                                  ShouldDecrementDesiredCapacity=False)


if __name__ == "__main__":
    jkl()
