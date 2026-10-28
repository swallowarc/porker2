import { defineConfig, devices } from '@playwright/test';

const ci = !!process.env.CI;

export default defineConfig({
  testDir: './tests',
  forbidOnly: ci,
  retries: ci ? 1 : 0,
  reporter: ci ? [['github'], ['html', { open: 'never' }]] : 'list',
  use: {
    baseURL: 'http://localhost:53676',
    trace: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  // 起動済みのサーバーがあればローカルでは再利用する (make be/run-for-debug 中でも動く)
  webServer: [
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
