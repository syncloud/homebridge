import { Locator, Page, expect } from '@playwright/test'
import { ssh } from './ssh'

export const PLUGIN = 'homebridge-tplink-smarthome'
export const PLUGIN_TITLE = 'Homebridge Tplink Smarthome'
const PLUGIN_DIR = `/var/snap/homebridge/current/storage/node_modules/${PLUGIN}`

function menu(page: Page, name: string): Locator {
  return page.getByRole('menuitem', { name })
}

export function pluginInstalled(): boolean {
  return ssh(`test -f ${PLUGIN_DIR}/package.json && echo yes`, { throw: false }).trim() === 'yes'
}

export async function login(page: Page, user: string, password: string) {
  await page.goto('/')
  await page.locator('#form-username').fill(user)
  await page.locator('#form-pass').fill(password)
  await page.getByRole('button', { name: 'Continue' }).click()
  await expect(menu(page, 'Plugins')).toBeVisible()
}

export async function expectDashboard(page: Page) {
  await expect(page.locator('i.green-text[aria-label="Running"]').first()).toBeVisible({ timeout: 180_000 })
  const plugins = page.locator('.hb-status-item', { has: page.locator('a.card-link-title', { hasText: 'Plugins' }) })
  await expect(plugins.getByText('Up to Date')).toBeVisible({ timeout: 180_000 })
}

export async function dismissModals(page: Page) {
  const close = page.locator('.modal.show .modal-header button.btn-close')
  for (let i = 0; i < 5; i++) {
    try {
      await close.first().waitFor({ state: 'visible', timeout: 5_000 })
    } catch {
      return
    }
    await close.first().click()
    await page.waitForTimeout(1_000)
  }
}

export async function openPlugins(page: Page) {
  await dismissModals(page)
  await menu(page, 'Plugins').click()
  await expect(page.locator('h3', { hasText: 'Plugins' })).toBeVisible()
}

export async function searchPlugin(page: Page) {
  const search = page.locator('input.hb-npm-search')
  if (!(await search.isVisible())) {
    await page.getByRole('button', { name: 'Search Plugins' }).click()
  }
  await search.fill(PLUGIN)
  await search.press('Enter')
  await expect(page.locator('h5.card-title', { hasText: PLUGIN_TITLE }).first()).toBeVisible()
}

export async function installPlugin(page: Page) {
  const card = page.locator('.card', { has: page.locator('h5.card-title', { hasText: PLUGIN_TITLE }) }).first()
  await card.locator('i.fa-arrow-alt-circle-down').click()
  const versions = page.locator('.modal.show')
  await expect(versions.getByText('Select the version to install')).toBeVisible()
  await versions.locator('li', { hasText: 'latest' }).first().locator('button').click()
  await expect.poll(() => pluginInstalled(), { timeout: 420_000, intervals: [5_000] }).toBe(true)
}

export async function expectInstalledPlugin(page: Page) {
  await expect(page.locator('h5.card-title', { hasText: PLUGIN_TITLE }).first()).toBeVisible()
  expect(pluginInstalled()).toBe(true)
}
