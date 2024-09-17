#!/usr/bin/env python
import sys
import urllib3
import json

class nomad_wrapper:
    def __init__(self,dev=False):
        self.base_url = "https://nomad.prod.box.net/devicemgr/api/devices/"
        self.auth_token = "redacted"

    def get_device(self,hostname):
        url = self.base_url + "?fqdn__contains=" + str(hostname)
        http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED',ca_certs='/etc/pki/tls/certs/ca-bundle.crt')
        headers = {'content-type': 'application/json'}
        r = http.request('GET', url, headers=headers)
        return r.data.decode('utf-8')

    def __get_device_id(self,hostname):
        r = self.get_device(hostname)
        r_dict = json.loads(r)
        try:
            devid = r_dict['results'][0]['id']
        except:
            print "failed to get devid"
            print str(r_dict)
            devid = None
        return devid

    def get_eav_value(self,eav_name,hostname):
        r = self.get_device(hostname)
        r_dict = json.loads(r)
        return_dict = {}
        try:
            for item in r_dict['results']:
                return_dict[item['name']] = item['sparse']
                for eav_attribute in item['sparse']:
                    if eav_attribute['attribute']['name'] == eav_name:
                        return eav_attribute['value']
        except:
            return None
        return None

    def set_eav_value(self,eav_name,value,hostname):
        devid = self.__get_device_id(hostname)
        #escape quotes and stuff
        value = value.replace("\"", "\\\"")
        if devid:
            url = self.base_url + str(devid) + "/sparse/"
            http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED',ca_certs='/etc/pki/tls/certs/ca-bundle.crt')
            headers = {'content-type': 'application/json','authorization': "Token " + self.auth_token}
            data = '''{"attribute": "''' + eav_name + '''", "value": "''' + value + '''"}'''
            try:
                r = http.request('POST', url, body=data, headers=headers)
            except:
                return None
            else:
                print(hostname + " was updated successfully\n")
        else:
            return None

def main():
    hostname = sys.argv[1]
    attribute = sys.argv[2]
    value = sys.argv[3]
    nm = nomad_wrapper()
    nm.set_eav_value(attribute.upper(),value,hostname)

if __name__ == "__main__":
    sys.exit(main())
