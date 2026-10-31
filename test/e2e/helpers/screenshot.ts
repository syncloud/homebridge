import { Page } from '@playwright/test'
import * as path from 'node:path'
import * as fs from 'node:fs'
import { env } from './env'

export async function shoot(page: Page, name: string) {
  const dir = path.join(env('PLAYWRIGHT_ARTIFACT_DIR'), 'screenshots')
  fs.mkdirSync(dir, { recursive: true })
  const file = `${env('PLAYWRIGHT_SPEC_NAME')}-${name}`
  await page.screenshot({ path: path.join(dir, `${file}.png`), fullPage: true })
  fs.writeFileSync(path.join(dir, `${file}.html`), await page.content())
}
