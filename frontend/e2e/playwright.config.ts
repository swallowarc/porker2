import { defineConfig, devices } from '@playwright/test';

const ci = !!process.env.CI;

// E2E_BASE_URL が指定されたら、起動済みのアプリ (例: 本番 Docker イメージの nginx 8082) に対して
// テストを流す。その場合 webServer (静的配信 + go run) は起動しない。
const baseURL = process.env.E2E_BASE_URL;

export default defineConfig({
  testDir: './tests',
  forbidOnly: ci,
  retries: ci ? 1 : 0,
  reporter: ci ? [['github'], ['html', { open: 'never' }]] : 'list',
  use: {
    baseURL: baseURL ?? 'http://localhost:53676',
    trace: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  // 起動済みのサーバーがあればローカルでは再利用する (make be/run-for-debug 中でも動く)
  webServer: baseURL ? undefined : [
    {
      command: 'node serve.mjs',
      port: 53676,
      reuseExistingServer: !ci,
    },
    {
      command: 'go run cmd/porker2/main.go',
      cwd: '../../backend',
      port: 8080,
      timeout: 120_000,
      reuseExistingServer: !ci,
      env: {
        ENV: 'local',
        REDIS_HOST_PORT: 'localhost:6379',
        REDIS_DB: '0',
        CONNECT_CORS_ALLOW_ORIGINS: 'http://localhost:53676',
        SESSION_COOKIE_DOMAIN: 'localhost',
        SESSION_COOKIE_SECURE: 'false',
      },
    },
  ],
});
