#!/usr/bin/python

import os
import sys

RELEASE_DIR = 'release'

manifest = 'AndroidManifest.xml'
manifest_bk = 'AndroidManifest.xml.bk'

channels = [i.strip() for i in open(sys.argv[-1]).read().split() if i.strip()]
# channels = ['tiantiandongting']

def backup():
    os.system('cp %s %s' % (manifest, manifest_bk))

def restore():
    os.system('rm %s' % manifest)
    os.system('mv %s %s' % (manifest_bk, manifest))

def replace_channel(channel_name):
    from xml.dom.minidom import parse
    dom = parse(open(manifest))

    chann = dom.getElementsByTagName('meta-data')[1]
    chann.setAttribute('android:value', channel_name)

    open(manifest, 'w').write(dom.toxml().encode('utf-8'))

def rename_apk(channel_name):
    apk_file = 'bin/shitouren-qmap-android-release.apk'
    channel_apk_file = '%s/shitouren-qmap-android-%s.apk' % (RELEASE_DIR, channel_name)

    os.system('mv %s %s' % (apk_file, channel_apk_file))

def main():
    if not os.path.exists(RELEASE_DIR):
        os.mkdir(RELEASE_DIR)

    backup()
    os.system('rm %s/*' % RELEASE_DIR)

    for i in channels:
        os.system('ant clean')
        replace_channel(i)
        os.system('ant release')
        rename_apk(i)

    restore()


if __name__ == '__main__':
    if not sys.argv[-1].endswith('txt'):
        print './build.py channel.txt'
        exit(1)

    main()

