#!/usr/bin/python2

import getopt
import glob
import libxml2
import os
import re
import sgmllib
import string
import sys
import urllib2

class BukkitSGMLParser(sgmllib.SGMLParser):
	'''A simple parser class for getting the Bukkit version associated with a CraftBukkit version'''

	BukkitNumber = ''

	in_dt = False
	in_dd = False
	in_li = False
	in_a = False

	in_upstream = False
	in_bukkit = False

	prog = re.compile(r'.*\(Build #(?P<build_num>[0-9]+)\).*')

	def __init__(self, verbose=0):
		sgmllib.SGMLParser.__init__(self, verbose)

	def parse(self, s):
		self.feed(s)
		self.close()

	def handle_data(self, data):
		if self.in_dt and data.strip() == 'Upstream Artifacts:':
			self.in_upstream = True
		elif self.in_li and self.in_a and self.in_upstream:
			if self.in_bukkit and self.BukkitNumber == '':
				match = self.prog.match(data)
				if match:
					self.BukkitNumber = match.group('build_num')
			else:
				self.in_bukkit = (data.strip() == 'Bukkit')

	def start_a(self, attributes):
		self.in_a = True

	def end_a(self):
		self.in_a = False
		
	def start_dt(self, attributes):
		self.in_dt = True

	def end_dt(self):
		self.in_dt = False

	def start_dd(self, attributes):
		self.in_dd = True

	def end_dd(self):
		self.in_dd = False
		self.in_upstream = False

	def start_li(self, attributes):
		self.in_li = True

	def end_li(self):
		self.in_li = False
		self.in_bukkit = False

class CraftBukkitRelease:
	'''Represents a release of CraftBukkit'''

	Version = ''
	BuildNumber = ''
	Commit = ''
	IsBroken = True
	IsStable = False
	FileVersion = ''

	BukkitVersion = ''
	BukkitBuildNumber = ''
	BukkitCommit = ''
	BukkitIsBroken = True
	BukkitIsStable = False
	BukkitFileVersion = ''

	IsValid = False

	html_url = ''

	version_pattern = re.compile(r'^(?P<version_string>[^-]+)(-.*)$')

	def __init__(self, build_number):
		(v, b, c, f, s, h) = self.parseViewApi('craftbukkit', build_number)

		self.Version = v
		self.BuildNumber = b
		self.Commit = c
		self.IsBroken = f
		self.IsStable = s

		try:
			resp = get_url(h)
			html = resp.read()

			parser = BukkitSGMLParser()
			parser.parse(html)

			(v, b, c, f, s, h) = self.parseViewApi('bukkit', parser.BukkitNumber)

			self.BukkitVersion = v
			self.BukkitBuildNumber = b
			self.BukkitCommit = c
			self.BukkitIsBroken = f
			self.BukkitIsStable = s
		except:
			print('Unexpected error: %s - %s [%s]' % sys.exc_info())

			self.BukkitIsBroken = True

		match = self.version_pattern.match(self.Version)
		if match:
			self.FileVersion = match.group('version_string') + '.' + self.BuildNumber
			if not self.IsStable:
				self.FileVersion += '_beta'

		match = self.version_pattern.match(self.BukkitVersion)
		if match:
			self.BukkitFileVersion = match.group('version_string') + '.' + self.BukkitBuildNumber
			if not self.BukkitIsStable:
				self.BukkitFileVersion += '_beta'
			
		self.IsValid = ((len(self.Version) > 0) and
			(len(self.BuildNumber) > 0) and
			(len(self.Commit) > 0) and
			(len(self.FileVersion) > 0) and
			(len(self.BukkitVersion) > 0) and
			(len(self.BukkitBuildNumber) > 0) and
			(len(self.BukkitCommit) > 0) and
			(len(self.BukkitFileVersion) > 0))

	def parseViewApi(self, project, build_number):
		api = 'http://dl.bukkit.org/api/1.0/downloads/projects/%s/view/build-%s/?_accept=application/xml' % (project, build_number)

		V = ''
		B = ''
		C = ''
		F = True
		S = False
		H = ''

		try:
			resp = get_url(api)
			xml = resp.read()

			doc = libxml2.parseDoc(xml.encode('UTF-8'))
			ctxt = doc.xpathNewContext()

			version      = ctxt.xpathEval('/root/version')
			build_number = ctxt.xpathEval('/root/build_number')
			commit       = ctxt.xpathEval('/root/commit/ref')
			html_url     = ctxt.xpathEval('/root/html_url')
			is_broken    = ctxt.xpathEval('/root/is_broken')
			channel      = ctxt.xpathEval('/root/channel/slug')

			if len(version) > 0:
				V = version[0].getContent()
			if len(build_number) > 0:
				B = build_number[0].getContent()
			if len(commit) > 0:
				C = commit[0].getContent()
			if len(is_broken) > 0:
				F = ( is_broken[0].getContent() is True )
			if len(channel) > 0:
				S = ( channel[0].getContent() == 'rb' )
			if len(html_url) > 0:
				H = 'http://dl.bukkit.org' + html_url[0].getContent()

			doc.freeDoc()
			ctxt.xpathFreeContext()
		except:
			print('Unexpected error: %s - %s [%s]' % sys.exc_info())

			F = True

		return (V, B, C, F, S, H)

def get_bukkits(channels):
	craftbukkits = []

	for channel in channels:
		api = 'http://dl.bukkit.org/api/1.0/downloads/projects/craftbukkit/artifacts/%s/?_accept=application/xml' % (channel)

		resp = get_url(api)
		xml = resp.read()

		doc = libxml2.parseDoc(xml.encode('UTF-8'))
		ctxt = doc.xpathNewContext()

		items = ctxt.xpathEval('/root/results/list-item')

		for item in items:
			ctxt.setContextNode(item)
			build = ctxt.xpathEval('build_number')[0].getContent()
			craftbukkits.append(CraftBukkitRelease(build))

		doc.freeDoc()
		ctxt.xpathFreeContext()

	return craftbukkits

def add_mask(overlay_dir, mask):
	mask_file = os.path.join(overlay_dir, 'profile', 'package.mask')
	mask_exists = False

	if not os.access(os.path.dirname(mask_file, os.F_OK)):
		os.makedirs(os.path.dirname(mask_file))

	with open(mask_file, 'rw') as f:
		for line in f:
			if line == mask:
				mask_exists = True
				break;

		if not mask_exists:
			f.write(mask + '\n')

def get_url(url):
	req = urllib2.Request(url=url)
	req.add_header('User-agent', 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)')
	return urllib2.urlopen(req)

def main():
	OPT_channels = []
	OPT_prune = False
	OPT_overlay_dir = None

	DEF_script_dir = os.path.dirname(os.path.realpath(__file__))
	DEF_craftbukkit_category = 'games-server'
	DEF_craftbukkit_package = 'craftbukkit-server'
	DEF_bukkit_category = 'dev-java'
	DEF_bukkit_package = 'bukkit'
	DEF_craftbukkit_ebuild_tpl = None
	DEF_bukkit_ebuild_tpl = None

	try:
		with open(os.path.join(DEF_script_dir, DEF_craftbukkit_package + '.etpl')) as f:
			DEF_craftbukkit_ebuild_tpl = string.Template(f.read())
		with open(os.path.join(DEF_script_dir, DEF_bukkit_package + '.etpl')) as f:
			DEF_bukkit_ebuild_tpl = string.Template(f.read())
	except:
		print('Unexpected error: %s - %s [%s]' % sys.exc_info())

	if not DEF_craftbukkit_ebuild_tpl or not DEF_bukkit_ebuild_tpl:
		print('!!! Unable to locate ebuild templates !!!')
		sys.exit(' ')

	try:
		opts, args = getopt.getopt(sys.argv[1:], 'c:hp', ['channel=', 'help'])
	except getopt.GetoptError:
		print('!!! Error parsing command-line options !!!')
		usage()

	if len(args) != 1:
		print('!!! No overlay directory specified !!!')
		usage()

	OPT_overlay_dir = os.path.realpath(args[0])

	for o, a in opts:
		if o in ('-c', '--channel'):
			OPT_channels.append(a)
		elif o in ('-h', '--help'):
			usage()
		elif o in ('-p', '--prune'):
			OPT_prune = True

	craftbukkit_dir = os.path.join(OPT_overlay_dir, DEF_craftbukkit_category, DEF_craftbukkit_package)
	bukkit_dir = os.path.join(OPT_overlay_dir, DEF_bukkit_category, DEF_bukkit_package)

	print('CraftBukkit ebuild directory: %s' % craftbukkit_dir)
	print('Bukkit ebuild directory:      %s' % bukkit_dir)

	if OPT_prune:
		print('Pruning Craftbukkit ebuilds:')
		for ebuild in glob.glob('%s/%s-*.*.ebuild' % (craftbukkit_dir, DEF_craftbukkit_package)):
			print('  Deleting: %s' % ebuild)
			os.remove(ebuild)

		print('Pruning Bukkit ebuilds:')
		for ebuild in glob.glob('%s/%s-*.*.ebuild' % (bukkit_dir, DEF_bukkit_package)):
			print('  Deleting: %s' % ebuild)
			os.remove(ebuild)

	bukkits = get_bukkits(OPT_channels)

	for bukkit in bukkits:
		if bukkit.IsValid:
			print('Found CRAFTBUKKIT %s / BUKKIT %s' % (bukkit.FileVersion, bukkit.BukkitFileVersion))

			# ensure our output directories exist
			if not os.access(craftbukkit_dir, os.R_OK):
				os.makedirs(craftbukkit_dir)
			if not os.access(bukkit_dir, os.R_OK):
				os.makedirs(bukkit_dir)

			craftbukkit_atom = DEF_craftbukkit_category + '/' + DEF_craftbukkit_package + '-' + bukkit.FileVersion
			bukkit_atom = DEF_bukkit_category + '/' + DEF_bukkit_package + '-' + bukkit.BukkitFileVersion

			# check for stability issues and mask broken packages
			if bukkit.IsBroken:
				print('  CraftBukkit is broken, adding to package mask list')
				add_mask(OPT_overlay_dir, '=' + craftbukkit_atom)
			if bukkit.BukkitIsBroken:
				print('  Bukkit is broken, adding to package mask list')
				add_mask(OPT_overlay_dir, '=' + bukkit_atom)

			craftbukkit_file = os.path.join(craftbukkit_dir, DEF_craftbukkit_package + '-' + bukkit.FileVersion + '.ebuild')
			bukkit_file = os.path.join(bukkit_dir, DEF_bukkit_package + '-' + bukkit.BukkitFileVersion + '.ebuild')

			if not os.access(craftbukkit_file, os.F_OK):
				print('  Generating CraftBukkit ebuild')

				craftbukkit_keywords = 'amd64 x86'
				if not bukkit.IsStable:
					craftbukkit_keywords = '~amd64 ~x86'

				with open(craftbukkit_file, 'w+') as f:
					out = DEF_craftbukkit_ebuild_tpl.substitute(COMMIT=bukkit.Commit,
							KEYWORDS=craftbukkit_keywords,
							BUKKIT_VERSION=bukkit.BukkitFileVersion)
					f.write(out)
			else:
				print('  CraftBukkit ebuild exists, skipping...')

			if not os.access(bukkit_file, os.F_OK):
				print('  Generating Bukkit ebuild')

				bukkit_keywords = 'amd64 x86'
				if not bukkit.BukkitIsStable:
					bukkit_keywords = '~amd64 ~x86'

				with open(bukkit_file, 'w+') as f:
					out = DEF_bukkit_ebuild_tpl.substitute(COMMIT=bukkit.BukkitCommit,
							KEYWORDS=bukkit_keywords)
					f.write(out)
			else:
				print('  Bukkit ebuild exists, skipping...')
		else:
			print('Found invalid CRAFTBUKKIT / BUKKIT. Dumping data:')
			print('  CRAFTBUKKIT:')
			print('    Version     = %s' % bukkit.Version)
			print('    BuildNumber = %s' % bukkit.BuildNumber)
			print('    Commit      = %s' % bukkit.Commit)
			print('    IsBroken    = %s' % bukkit.IsBroken)
			print('    IsStable    = %s' % bukkit.IsStable)
			print('    FileVersion = %s' % bukkit.FileVersion)
			print('  BUKKIT:')
			print('    Version     = %s' % bukkit.BukkitVersion)
			print('    BuildNumber = %s' % bukkit.BukkitBuildNumber)
			print('    Commit      = %s' % bukkit.BukkitCommit)
			print('    IsBroken    = %s' % bukkit.BukkitIsBroken)
			print('    IsStable    = %s' % bukkit.BukkitIsStable)
			print('    FileVersion = %s' % bukkit.BukkitFileVersion)

def usage():
	print('Get latest Bukkit JAR')
	print('')
	print('Downloads the latest Bukkit artifact JAR.')
	print('Usage:')
	print('  get-bukkit.py [-p|--prune] [-c|--channel <channel>] <overlay_dir>')
	print('  get-bukkit.py [-h|--help]')
	sys.exit(' ')

if __name__ == '__main__':
	main()
