#!/usr/bin/env python3
# coding=utf8

from argparse import ArgumentParser, FileType, ArgumentTypeError

from sexpdata import loads


def parse_arguments():
    parser = ArgumentParser(description="Print list of board layers", epilog="")

    parser.add_argument(
        "-p", "--pcb", required=True, type=FileType("r"), help="path to PCB file"
    )
    parser.add_argument(
        "-c", "--comma", action="store_true", help="print comma seperated list"
    )

    action = parser.add_subparsers(dest="action")
    action.add_parser("layers", help="print layers")
    action.add_parser("stackup", help="print stackup")
    action.add_parser("copper", help="print copper layers")

    args = parser.parse_args()
    return args


def sexp_to_set(sexp):
    return {sub_sexp[0].value(): sub_sexp for sub_sexp in sexp}


def main():
    args = parse_arguments()

    board_sexp = loads(args.pcb.read())
    args.pcb.close()

    board_sexp_set = sexp_to_set(board_sexp[1:])

    if args.action == "stackup":
        setup_sexp_set = sexp_to_set(board_sexp_set["setup"][1:])
        layer_names = [
            layer[1]
            for layer in setup_sexp_set["stackup"][1:]
            if ("layer" == layer[0].value()) and (not layer[1].startswith("dielectric"))
        ]

    if args.action in ("layers", "copper"):
        layer_names = [layer[1] for layer in board_sexp_set["layers"][1:]]
        if args.action == "copper":
            layer_names = [
                layer_name for layer_name in layer_names if layer_name.endswith(".Cu")
            ]

    seperator = "," if args.comma else " "
    print(seperator.join(layer_names))


if "__main__" == __name__:
    main()
