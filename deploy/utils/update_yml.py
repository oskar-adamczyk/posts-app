#!/usr/bin/env python3

import argparse
import yaml
import os

parser = argparse.ArgumentParser(description='Insert new node to the specific file')
parser.add_argument('-p', action='store', dest='file_path', default=os.environ.get('GITHUB_WORKSPACE'), help='file path')
parser.add_argument('-f', action='store', dest='file_name', required=True, help='file name')
parser.add_argument('-n', action='store', dest='node', help='absolute node to add')
parser.add_argument('-v', action='store', dest='value', help='value for new node')
args = parser.parse_args()


def merge_dicts(dict1, dict2):
    for k in set(dict1.keys()).union(dict2.keys()):
        if k in dict1 and k in dict2:
            if isinstance(dict1[k], dict) and isinstance(dict2[k], dict):
                yield (k, dict(merge_dicts(dict1[k], dict2[k])))
            else:
                # If one of the values is not a dict, you can't continue merging it.
                # Value from second dict overrides one in first and we move on.
                yield (k, dict2[k])
                # Alternatively, replace this with exception raiser to alert you of value conflicts
        elif k in dict1:
            yield (k, dict1[k])
        else:
            yield (k, dict2[k])


def main():
    # Create new dict node to add
    node_chunks = args.node.split('.')
    new_node = args.value
    for key in reversed(node_chunks):
        new_node = {key: new_node}

    # Load yml file and append new node
    with open(str(args.file_path) + '/' + str(args.file_name), 'r') as yml_file:
        ymls = list(yaml.safe_load_all(yml_file))
        ymls[0] = dict(merge_dicts(yamls[0], new_node))

    if ymls[0]:
        with open(str(args.file_path) + '/' + str(args.file_name), 'w') as yml_file:
            yaml.safe_dump_all(ymls, yml_file)


if __name__ == '__main__':
    main()

