import argparse
import boto3
import configparser
import sys

from botocore.errorfactory import ClientError


def cleanup(client, username, aws_access_key_id):
    try:
        client.delete_access_key(UserName=args.username, AccessKeyId=aws_access_key_id)
    except ClientError:
        sys.exit('Error deleting user\'s ("{}") aws_access_key_id: {}')


def main(args):
    config = configparser.ConfigParser()
    config.read(args.config_file)
    old_aws_access_key_id = config[args.profile_name]["aws_access_key_id"]

    iam = boto3.client("iam")

    try:
        new_access_data = iam.create_access_key(UserName=args.username)
    except ClientError as exc:
        print(exc)
        sys.exit("Error retrieving new access credentials. Exiting.")

    if new_access_data:
        new_aws_access_key_id = new_access_data["AccessKey"]["AccessKeyId"]
        new_aws_secret_access_key = new_access_data["AccessKey"]["SecretAccessKey"]

        config[args.profile_name]["aws_access_key_id"] = new_aws_access_key_id
        config[args.profile_name]["aws_secret_access_key"] = new_aws_secret_access_key

    try:
        with open(args.config_file, "w") as config_file:
            config.write(config_file)
    except configparser.Error:
        print(" Rollback! Cleaning up {}".format(new_aws_access_key_id))
        cleanup(iam, args.username, new_aws_access_key_id)
        sys.exit("Error writing file")

    cleanup(iam, args.username, old_aws_access_key_id)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-u", "--username", help="username to rotate credential for. This is a required field", required=True
    )
    parser.add_argument(
        "-c", "--config-file", help="aws config file to use, default: /root/.aws/config", default="/root/.aws/config"
    )
    parser.add_argument(
        "-p",
        "--profile-name",
        default="profile default",
        help="aws profile name which contains aws_access_key_id and aws_secret_access_key"
        'for rotation, default: "profile default"',
    )
    args = parser.parse_args()
    main(args)
