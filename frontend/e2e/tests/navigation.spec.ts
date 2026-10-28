import { expect, test } from '@playwright/test';
import { createRoom, login, loginHeading, logout, open, uniqueName } from './helpers';

test('未ログインで部屋 URL を直接開くと、ログイン後にその部屋へ入る', async ({ page }) => {
  await open(page, '/');
  await login(page, uniqueName());
  await expect(page).toHaveURL('/room');
  const roomID = await createRoom(page);
  await logout(page);
  await expect(loginHeading(page)).toBeVisible();

  await open(page, `/poker?room-id=${roomID}`);
  await expect(page).toHaveURL(`/?room-id=${roomID}`);
  await expect(loginHeading(page)).toBeVisible();

  await login(page, uniqueName());
  await expect(page).toHaveURL(`/poker?room-id=${roomID}`);
  await expect(page.getByRole('heading', { name: `Room ID: ${roomID}` })).toBeVisible();
});

test('存在しない部屋の URL では Room not found を出して部屋選択へ戻る', async ({ page }) => {
  await open(page, '/poker?room-id=99999');
  await expect(page).toHaveURL('/?room-id=99999');
  await expect(loginHeading(page)).toBeVisible();

  await login(page, uniqueName());
  // SnackBar の文言はスクリーンリーダー向けの flt-announcement-polite にも出るので、semantics ツリーに絞る
  await expect(page.locator('flt-semantics-host').getByText('Room not found')).toBeVisible();
  await expect(page).toHaveURL('/room');
});

test('Poker 画面からログアウトすると room-id なしのログイン画面へ戻り、再ログインで前の部屋に入らない', async ({ page }) => {
  await open(page, '/');
  await login(page, uniqueName());
  await createRoom(page);

  await logout(page);
  await expect(page).toHaveURL('/');
  await expect(loginHeading(page)).toBeVisible();

  await login(page, uniqueName());
  await expect(page).toHaveURL('/room');
  // 前の部屋への遷移が遅れて起きないことを確かめるため、少し待ってから再確認する
  await page.waitForTimeout(1_000);
  await expect(page).toHaveURL('/room');
});
