import { execFileSync } from 'node:child_process'
import { env } from './env'

const baseArgs = [
  '-o', 'StrictHostKeyChecking=no',
  '-o', 'UserKnownHostsFile=/dev/null',
  '-o', 'LogLevel=ERROR',
]

function sshpass(args: string[]): string {
  return execFileSync('sshpass', ['-e', ...args], {
    encoding: 'utf8',
    timeout: 120_000,
    env: { ...process.env, SSHPASS: env('PLAYWRIGHT_SSH_PASSWORD') },
  })
}

function target(): string {
  return `${env('PLAYWRIGHT_SSH_USER')}@${env('PLAYWRIGHT_DEVICE_HOST')}`
}

export function ssh(cmd: string, opts: { throw?: boolean } = {}): string {
  try {
    return sshpass(['ssh', ...baseArgs, target(), cmd])
  } catch (e: any) {
    if (opts.throw === false) {
      return (e.stdout?.toString() ?? '') + (e.stderr?.toString() ?? '')
    }
    throw e
  }
}

export function scpFrom(remote: string, local: string, opts: { throw?: boolean } = {}): void {
  try {
    sshpass(['scp', ...baseArgs, '-r', `${target()}:${remote}`, local])
  } catch (e) {
    if (opts.throw !== false) throw e
  }
}
