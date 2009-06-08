#!/usr/bin/python

import urllib, urllib2, base64
import getpass
from pyquery import PyQuery as pq
import os


class DBLeecher(object):

    def __call__(self):
        self.askDomain()
        self.get_selected_db()
        self.pack_database()
        self.leech_database()
        self.backup_and_untar()

    def askDomain(self):
        self.domain = raw_input('Enter Productive-Domain (e.g. www.domain.com): ')

    def getUrl(self, postfix):
        return 'http://%s/%s' % (self.domain, postfix)


    def get_selected_db(self):
        if '_selected_db' not in dir(self):
            databases = self.get_databases()
            print 'Select the Database to leech:'
            for i, db in enumerate(databases):
                name, url = db
                print ' ', (i+1), ':', name
            selected_db = None
            while not selected_db:
                input = raw_input('Select DB (1-%i):' % (len(databases)))
                input = input.strip()
                try:
                    input = int(input)
                    if input>0:
                        selected_db = databases[input-1]
                except:
                    pass
            self._selected_db = Database(self, *selected_db)
            # show db stats
            print 'Selected Database:'
            print '  Name:', self._selected_db.name
            print '  URL: ', self._selected_db.url
            print '  Path:', self._selected_db.location
            print '  Size:', self._selected_db.size
            print ''
        return self._selected_db

    def pack_database(self):
        database = self.get_selected_db()
        pack = None
        while pack==None:
            input = raw_input('Should the database %s be packed before leeching? [y/N]: ' % database.name)
            if input.strip().lower()=='n' or len(input)==0:
                pack = False
            elif input.strip().lower()=='y' or input.strip().lower()=='yes':
                pack = True
        if pack==True:
            print 'packing database... this may take a while...'
            database.pack()
            print 'done. New Database size: %s' % database.size
            print ''
        else:
            print 'skipping packing database'
            print ''

    def get_databases(self):
        if '_databases' not in dir(self):
            html = self.zopeRequest(self.getUrl('Control_Panel/Database/manage_main'))
            database_table = pq(html)('table')[2]
            self._databases = []
            for node in pq(database_table)('a'):
                if node.text.strip()!='temporary':
                    self._databases.append((node.text, node.get('href')))
        return self._databases

    def getZopeCredentials(self):
        if '_zopeCredentials' not in dir(self):
            zopeUser = raw_input('Zope User: ')
            zopePass = getpass.getpass('Zope Password (%s): ' % zopeUser)
            self._zopeCredentials = (zopeUser, zopePass)
        return self._zopeCredentials

    def zopeRequest(self, url):
        username, password = self.getZopeCredentials()
        credentials = ':'.join([username.encode('hex'), password.encode('hex')])
        credentials = str(base64.encodestring(credentials)).strip()
        data = ''
        headers = {
                'User-Agent'            : 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)',
                'Content-Type'          : 'application/x-www-form-urlencoded',
                'Cookie'                : '__ac=' + credentials,
        }
        request = urllib2.Request(url, urllib.urlencode(data), headers)
        response = urllib2.urlopen(request)
        return response.read()

    def get_ssh_user(self):
        if '_ssh_user' not in dir(self):
            self._ssh_user = raw_input('Enter a SSH-User (Nothing for current user): ')
            print ''
        return self._ssh_user

    def run_cmd(self, cmd):
        print '  >', cmd
        os.system(cmd)

    def copy_database(self):
        print 'Trying to copy .fs-file to a tar-archive. SSH may prompt you for a password'
        user_part = self.get_ssh_user() and '%s@' % self.get_ssh_user() or ''
        database = self.get_selected_db()
        self.run_cmd('ssh %s%s tar -czf %s -C %s %s' % (
            user_part,
            self.domain,
            database.tar_name,
            '/'.join(database.location.split('/')[:-1]),
            database.location.split('/')[-1],
        ))

    def leech_database(self):
        self.copy_database()
        database = self.get_selected_db()
        user_part = self.get_ssh_user() and '%s@' % self.get_ssh_user() or ''
        cmd = 'sftp %s%s:%s var/filestorage/%s/' % (
            user_part,
            self.domain,
            database.tar_name,
            database.name
        )
        self.run_cmd(cmd)
        print ''

    def backup_and_untar(self):
        database = self.get_selected_db()
        print 'Creating backup of current local database:'
        cmd = 'mv var/filestorage/%s/%s var/filestorage/%s/%s.bak' % (
            database.name,
            database.location.split('/')[-1],
            database.name,
            database.location.split('/')[-1],
        )
        self.run_cmd(cmd)
        print ''
        print 'Unpacking archive:'
        cmd = 'cd var/filestorage/%s ; tar -xvf %s' % (
            database.name,
            database.tar_name
        )
        self.run_cmd(cmd)


class Database(object):

    def __init__(self, leecher, name, url):
        self.leecher = leecher
        self.name = name
        self.url = url
        self.loadInfos()

    def loadInfos(self):
        doc = pq(self.leecher.zopeRequest(self.url))
        self.location = doc('div.form-text')[0].text.strip()
        self.size = doc('div.form-text')[1].text.strip()
        self.tar_name = self.location.split('/')[-1] + '.tar.gz'

    def pack(self):
        pack_url = '/'.join(self.url.split('/')[:-1] + ['manage_pack?days:float=0'])
        self.leecher.zopeRequest(pack_url)
        self.loadInfos()

if __name__=='__main__':
    DBLeecher()()
