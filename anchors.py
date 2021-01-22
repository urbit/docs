#!/usr/bin/env python3

import os
import sys
from pathlib import Path
from typing import List, Tuple


# inspired by weights.sh

# NOTE: This script does not prevent you from shooting yourself in the foot.
# If you manually set a bogus value for insert_anchor_links it will not fix it for you
"""
1. get a list of all .md files
2. for each md file
	a. get front matter
	b. get value of key `insert_anchor_links`, default to none if not present
	c. output a tuple of (setting, file)
3. accumulate all anchor setting values for all md files
4. write tuple to 'anchors' file, prompt to edit, open in preferred editor
5. once prompt is answered, read back file
6. read edited 'anchors' file, overwrite new setting for each file
"""

ANCHOR_KEY = "insert_anchor_links = "
ANCHOR_FILE = "anchors"

def nth_occurrence(arr, target_value, wanted_idx):
	return [idx for idx, val in enumerate(arr) if val == target_value][wanted_idx - 1]

def validate_entry(setting: str, file: str):
	if not setting in ["left", "right", "none"]:
		sys.exit(f"Invalid setting '{setting}' provided for file '{file}'")


def find_all_mds() -> List[str]:
	# the `insert_anchor_links` is only applicable on `_index.md` files (i.e. sections)
	return [str(p) for p in Path('./').rglob('**/_index.md')]

def setting_from_frontmatter(lines: List[str]) -> str:
	# 'insert_anchor_links = "none"' -> 'none'
	for line in lines:
		if line.startswith(ANCHOR_KEY):
			# 1. 'insert_anchor_links = "none"\n'
			# 2. ['insert_anchor_links = ' '"none"\n'][1] => '"none"\n'
			# 3. "none\n"
			# 4. "none"
			return line               \
				.split(ANCHOR_KEY)[1] \
				.replace('\"', '')    \
				.replace('\n', '')

	return "none"  # default setting if key not present

def anchors_from_frontmatter(md_files: List[str]) -> List[Tuple[str, str]]:
	# returns tuple(setting, file)
	anchor_settings = []

	for md_file in md_files:
		with open(md_file, "r") as f:
			lines = f.readlines()
			setting = setting_from_frontmatter(lines)
			anchor_settings.append((setting, md_file))

	return anchor_settings

def write_anchor_file(anchor_settings: List[Tuple[str, str]]):
	with open(ANCHOR_FILE, "w+") as f:
		for setting, file in anchor_settings:
			f.write(f"{setting} {file}\n")


def prompt_editor():
	editor = os.getenv('EDITOR', 'nano')
	os.system(f"{editor} {ANCHOR_FILE}")
	input("Edit the anchor settings and press enter...")

def read_anchor_file() -> List[Tuple[str, str]]:
	anchor_settings = []

	with open(ANCHOR_FILE, "r") as f:
		for line in f:
			line = line.replace('\n', '')
			setting, file = line.split(' ')
			anchor_settings.append((setting, file))

	return anchor_settings


def write_entry(setting: str, file: str):
	validate_entry(setting, file)


	# not optimized
	with open(file, "r+") as f:
		lines = f.readlines()
		# lines = list(filter(bool, text.split('\n')))  # split text by lines,
		fm_end = nth_occurrence(lines, "+++\n", 2)  # get index of end of front matter (signaled by second '+++')

		# remove existing setting if it exists
		for line in lines[:fm_end]:
			if line.startswith(ANCHOR_KEY):
				lines.remove(line)
				fm_end -= 1  # correct the index for the removal

		if setting != "none":
			# by default, there is no need to specify "none"
			lines.insert(fm_end, ANCHOR_KEY + f'"{setting}"' + '\n') # insert the setting right before the end of front matter
		f.seek(0)           # go to beginning of file
		f.writelines(lines) # overwrite with new contents
		f.truncate()  # idk why but necessary for bug-free behviour (otherwise it adds excess newlines and stuff)



def anchors_to_frontmatter(anchor_settings: List[Tuple[str, str]]):
	for setting, file in anchor_settings:
		write_entry(setting, file)

def cleanup():
	os.remove("anchors")


def main():
	files = find_all_mds()
	print(f'found {len(files)} .md files')
	write_anchor_file(anchors_from_frontmatter(files))
	prompt_editor()
	anchors_to_frontmatter(read_anchor_file())
	cleanup()
	print('done')


if __name__ == '__main__':
	main()

