#!/usr/bin/env python3
# coding=utf8

# Copyright (C) 2022, marble. Released under the MIT license.
# Based on https://github.com/wokwi/kicad-jlcpcb-bom-plugin
#
# usage: pos2cpl_jlcpcb.py [-h] [-q | -v] -i INPUT -o OUTPUT [-a ADJUST]
#
# Converts a KiCad Footprint Position File into JLCPCB compatible CPL file
#
# optional arguments:
#   -h, --help            show this help message and exit
#   -q, --quiet           turn off warnings
#   -v, --verbose         set verbosity level
#   -i INPUT, --input INPUT
#                         Path to pos input file
#   -o OUTPUT, --output OUTPUT
#                         Path to cpl outputput file
#   -a ADJUST, --adjust ADJUST
#                         Path to angle adjustment file

from argparse import ArgumentParser, FileType, ArgumentTypeError
from logging import DEBUG, INFO, WARNING, ERROR, basicConfig as logConfig
from logging import debug, info, warning, error
import csv
import json
from collections import OrderedDict

def parse_arguments():
    parser = ArgumentParser(
        description="Converts a KiCad Footprint Position File into JLCPCB compatible CPL file",
        epilog="")

    verbosity = parser.add_mutually_exclusive_group()
    verbosity.add_argument("-q", "--quiet",   action="store_true", help="turn off warnings")
    verbosity.add_argument("-v", "--verbose", action="count",      help="set verbosity level")

    parser.add_argument("-i", "--input",  required=True, type=str, help='Path to pos input file')
    parser.add_argument("-o", "--output", required=True, type=str, help='Path to cpl outputput file')
    parser.add_argument("-a", "--adjust",                type=str, help='Path to angle adjustment file')

    args = parser.parse_args()
    return args

def get_log_level(verbose, quiet):
    return  ERROR   if quiet else \
            WARNING if not verbose else \
            INFO    if 1 == verbose else \
            DEBUG   #  2 <= verbose

def configure_logging(verbose, quiet):
    logConfig(format="%(asctime)-15s %(levelname)-8s %(message)s", datefmt="%Y-%m-%d %H:%M:%S", level=get_log_level(verbose, quiet))
    debug("DEBUG Log Level")

def main():
    args = parse_arguments()
    configure_logging(args.verbose, args.quiet)

    adjustments = {}
    if args.adjust:
        info(f"Loading adjustments {args.adjust}")
        with open(args.adjust, 'r') as adjustment_file:
            adjustments = json.load(adjustment_file)

    info(f"Reading from {args.input}")
    info(f"Writing to {args.output}")
    with open(args.input, 'r', newline='') as in_file, open(args.output, 'w', newline='') as out_file:
        reader = csv.DictReader(in_file)
        ordered_fieldnames = OrderedDict([('Designator',None),('Mid X',None),('Mid Y',None),('Layer',None),('Rotation',None)])
        writer = csv.DictWriter(out_file, fieldnames=ordered_fieldnames)
        writer.writeheader()

        for row in reader:
            angle_adjustment = adjustments.get(row['Val'], 0)
            debug(f"Angle adjustment for {row['Ref']}: {angle_adjustment}")
            writer.writerow({
                'Designator': row['Ref'],
                'Mid X': row['PosX'] + 'mm',
                'Mid Y': row['PosY'] + 'mm',
                'Layer': row['Side'].capitalize(),
                'Rotation': (float(row['Rot']) + angle_adjustment) % 360
            })
    info("Finished")

if "__main__" == __name__:
    main()
