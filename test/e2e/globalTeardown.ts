import { ssh, scpFrom } from './helpers/ssh'
import { env } from './helpers/env'
import * as path from 'node:path'
import * as fs from 'node:fs'
import { execSync } from 'node:child_process'

export default async function () {
  const name = env('PLAYWRIGHT_SPEC_NAME')
  const tmp = `/tmp/syncloud/e2e-${name}`
  const out = path.join(env('PLAYWRIGHT_ARTIFACT_DIR'), 'log', `e2e-${name}`)
  fs.mkdirSync(out, { recursive: true })

  ssh(`mkdir -p ${tmp}`, { throw: false })
  ssh(`journalctl > ${tmp}/journalctl.log`, { throw: false })
  ssh(`cp /var/snap/homebridge/current/storage/homebridge.log ${tmp}/homebridge.log`, { throw: false })
  ssh(`ls -la /var/snap/homebridge/current/storage/node_modules > ${tmp}/plugins.ls.log`, { throw: false })
  scpFrom(`${tmp}/*`, out, { throw: false })
  try { execSync(`chmod -R a+r ${out}`) } catch {}
}
