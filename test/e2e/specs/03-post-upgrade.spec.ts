import { test } from '../helpers/fixtures'
import { shoot } from '../helpers/screenshot'
import { env } from '../helpers/env'
import { login, expectDashboard, openPlugins, expectInstalledPlugin } from '../helpers/homebridge'

const user = env('PLAYWRIGHT_DEVICE_USER')
const password = env('PLAYWRIGHT_DEVICE_PASSWORD')

test.describe('homebridge post-upgrade', () => {
  test('plugin installed before upgrade survives', async ({ page }) => {
    await login(page, user, password)
    await expectDashboard(page)
    await shoot(page, 'dashboard')
    await openPlugins(page)
    await expectInstalledPlugin(page)
    await shoot(page, 'plugins')
  })
})
