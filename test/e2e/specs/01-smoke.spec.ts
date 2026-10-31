import { test } from '../helpers/fixtures'
import { shoot } from '../helpers/screenshot'
import { env } from '../helpers/env'
import { login, expectDashboard, openPlugins, searchPlugin, installPlugin, expectInstalledPlugin, pluginInstalled } from '../helpers/homebridge'

const user = env('PLAYWRIGHT_DEVICE_USER')
const password = env('PLAYWRIGHT_DEVICE_PASSWORD')

test.describe('homebridge smoke', () => {
  test('login and install a plugin', async ({ page }) => {
    await login(page, user, password)
    await expectDashboard(page)
    await shoot(page, 'dashboard')
    await openPlugins(page)
    if (!pluginInstalled()) {
      await searchPlugin(page)
      await shoot(page, 'plugin-search')
      await installPlugin(page)
      await shoot(page, 'plugin-installed')
      await openPlugins(page)
    }
    await expectInstalledPlugin(page)
    await shoot(page, 'plugins')
  })
})
