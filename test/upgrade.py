import pytest
import requests
from subprocess import check_output
from syncloudlib.integration.hosts import add_host_alias
from syncloudlib.integration.installer import local_install
from syncloudlib.http import wait_for_rest

from test import snapd

TMP_DIR = '/tmp/syncloud'


@pytest.fixture(scope="session")
def module_setup(request, device, artifact_dir):
    def module_teardown():
        device.run_ssh('mkdir -p {0}'.format(TMP_DIR), throw=False)
        device.run_ssh('journalctl > {0}/refresh.journalctl.log'.format(TMP_DIR), throw=False)
        device.scp_from_device('{0}/*'.format(TMP_DIR), artifact_dir, throw=False)
        check_output('chmod -R a+r {0}'.format(artifact_dir), shell=True)

    request.addfinalizer(module_teardown)


def test_start(module_setup, app, device_host, domain, device):
    add_host_alias(app, device_host, domain)
    snapd.settle(device)
    device.activated()
    device.run_ssh('mkdir -p {0}'.format(TMP_DIR), throw=False)


def test_upgrade(device_host, device_password, app_archive_path, app_domain):
    local_install(device_host, device_password, app_archive_path)
    wait_for_rest(requests.session(), "https://{0}".format(app_domain), 200, 100)


def test_service_stable(device, app):
    restarts = device.run_ssh('systemctl show snap.{0}.web.service -p NRestarts --value'.format(app)).strip()
    assert restarts == '0', restarts
    device.run_ssh('systemctl is-active snap.{0}.web.service'.format(app))
