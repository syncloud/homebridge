from os.path import dirname, join
from subprocess import check_output
import logging
import pytest
import requests
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from syncloudlib.integration.hosts import add_host_alias

DIR = dirname(__file__)
TMP_DIR = '/tmp/syncloud/ui'

log = logging.getLogger()

@pytest.fixture(scope="session")
def module_setup(request, selenium, device, artifact_dir, ui_mode):
    def module_teardown():
        device.activated()
        device.run_ssh('mkdir -p {0}'.format(TMP_DIR), throw=False)
        device.run_ssh('journalctl > {0}/journalctl.ui.{1}.log'.format(TMP_DIR, ui_mode), throw=False)
        device.run_ssh('cp /var/log/syslog {0}/syslog.ui.{1}.log'.format(TMP_DIR, ui_mode), throw=False)
        device.scp_from_device('{0}/*'.format(TMP_DIR), join(artifact_dir, 'log'))
        check_output('cp /videos/* {0}'.format(artifact_dir), shell=True)
        check_output('chmod -R a+r {0}'.format(artifact_dir), shell=True)
        selenium.log()

    request.addfinalizer(module_teardown)


def test_start(module_setup, app, domain, device_host):
    add_host_alias(app, device_host, domain)


@pytest.mark.flaky(retries=10, delay=5)
def test_visible_through_platform(app_domain):
    response = requests.get('https://{0}'.format(app_domain), verify=False)
    assert response.status_code == 200, response.text


def test_login(selenium, device_user, device_password):
    log.info('open app')
    selenium.driver.command_executor.set_timeout(10)
    selenium.open_app()
    log.info('find')
    #selenium.click_by(By.XPATH, "//button[contains(.,'Get Started')]")
    log.info('find password')
    selenium.find_by_id("form-login").send_keys(device_user)
    selenium.find_by_id("form-pass").send_keys(device_password)
    selenium.find_by(By.XPATH, "//button[contains(.,'Continue')]").click()
    #password.send_keys(device_password)
    #selenium.screenshot('login')
    #password.send_keys(Keys.RETURN)
    #selenium.find_by_xpath("//h2[contains(.,'Stock overview')]")
    selenium.screenshot('main')

