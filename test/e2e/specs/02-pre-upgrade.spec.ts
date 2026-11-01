import { test, expect } from '../helpers/fixtures'
import { shoot } from '../helpers/screenshot'
import { env } from '../helpers/env'
import { login, expectDashboard, openPlugins, searchPlugin, installPlugin, pluginInstalled } from '../helpers/homebridge'

const user = env('PLAYWRIGHT_DEVICE_USER')
const password = env('PLAYWRIGHT_DEVICE_PASSWORD')

test.describe('homebridge pre-upgrade', () => {
  test('install a plugin on the released version', async ({ page }) => {
    await login(page, user, password)
    await expectDashboard(page)
    await shoot(page, 'dashboard')
    await openPlugins(page)
    if (!pluginInstalled()) {
      await searchPlugin(page)
      await shoot(page, 'plugin-search')
      await installPlugin(page)
      await shoot(page, 'plugin-installed')
    }
    expect(pluginInstalled()).toBe(true)
  })
})
