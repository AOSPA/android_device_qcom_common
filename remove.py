#!/usr/bin/env python3

import os
import sys
import getopt

MY_DIR = os.path.dirname(os.path.abspath(__file__))
ANDROID_ROOT = os.path.abspath(os.path.join(MY_DIR, '..', '..', '..'))
QCOM_COMMON_PATH = 'device/qcom/common'
TARGET_FILE = 'proprietary-files.txt'

def remove_lines_from_file(lines, file_path):
    removed_lines = []
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            for i, target_line in enumerate(lines):
                if line in target_line:
                    lines[i] = ''
                    if line.startswith('-'):
                        removed_lines.append(line[1:])
                    else:
                        removed_lines.append(line)
                    break
    return removed_lines

def main(argv):
    component = None
    try:
        opts, args = getopt.getopt(argv, "c:")
    except getopt.GetoptError:
        print("Invalid option: Use -c to specify the component.")
        sys.exit(1)

    for opt, arg in opts:
        if opt == '-c':
            component = arg

    if not component:
        print("Component not specified. Use -c to specify the component.")
        sys.exit(1)

    removed_lines = []
    for division in ('system', 'vendor'):
        component_file_path = os.path.join(ANDROID_ROOT, QCOM_COMMON_PATH, division, component, TARGET_FILE)
        if not os.path.isfile(component_file_path):
            continue

        with open(TARGET_FILE, 'r') as target_file:
            lines = target_file.readlines()

        removed_lines += remove_lines_from_file(lines, component_file_path)

        with open(TARGET_FILE, 'w') as target_file:
            target_file.write(''.join(lines))

    if removed_lines:
        print(f"The following lines were removed from the file '{TARGET_FILE}':")
        for line in removed_lines:
            print(f"\033[31m- {line}\033[0m")
    else:
        print(f"No lines were removed from the file '{TARGET_FILE}'.")

if __name__ == '__main__':
    main(sys.argv[1:])