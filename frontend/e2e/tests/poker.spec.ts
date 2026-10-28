import { expect, test, type Browser, type Page } from '@playwright/test';
import { createRoom, joinRoom, joinRoomByID, login, open, uniqueName } from './helpers';

// SnackBar などの文言は flt-announcement-polite にも出るので、semantics ツリーに絞る
const text = (page: Page, value: string) =>
  page.locator('flt-semantics-host').getByText(value, { exact: true });

/**
 * 別々のブラウザコンテキストで A と B をログインさせ、A が作った部屋に B を入れる。
 * A は部屋の管理者になる。後片付けは `close` を呼ぶ。
 */
const setupTwoUsers = async (browser: Browser) => {
  const contextA = await browser.newContext();
  const contextB = await browser.newContext();
  const a = await contextA.newPage();
  const b = await contextB.newPage();
  const nameB = uniqueName();

  await open(a, '/');
  await login(a, uniqueName());
  const roomID = await createRoom(a);

  await open(b, '/');
  await login(b, nameB);
  await expect(b).toHaveURL('/room');
  await joinRoom(b, roomID);

  for (const page of [a, b]) {
    await expect(text(page, '2 voters, 0 observers')).toBeVisible();
  }

  const close = async () => {
    await contextA.close();
    await contextB.close();
  };
  return { a, b, nameB, roomID, close };
};

test('2 セッションで同じ部屋に入ると、投票 / Open / Reset が互いに反映される', async ({ browser }) => {
  const { a, b, close } = await setupTwoUsers(browser);

  for (const page of [a, b]) {
    await expect(page.getByRole('button', { name: 'Open' })).toBeDisabled();
  }

  // Auto open は既定で ON だが、2 人中 1 人の投票では自動で開かない
  await a.getByRole('button', { name: '5', exact: true }).click();
  for (const page of [b, a]) {
    await expect(page.getByRole('button', { name: 'Open' })).toBeEnabled();
  }

  await a.getByRole('button', { name: 'Open' }).click();
  for (const page of [b, a]) {
    await expect(text(page, 'Avg: 5.0')).toBeVisible();
  }

  await a.getByRole('button', { name: 'Reset' }).click();
  for (const page of [b, a]) {
    await expect(page.getByRole('button', { name: 'Open' })).toBeDisabled();
    await expect(text(page, '2 voters, 0 observers')).toBeVisible();
  }

  await close();
});

test('Leave すると部屋選択へ戻り、Room ID を入れて同じ部屋に入り直せる', async ({ browser }) => {
  const { a, b, roomID, close } = await setupTwoUsers(browser);

  await b.getByRole('button', { name: 'Leave' }).click();
  await b.getByRole('button', { name: 'Yes' }).click();
  await expect(b).toHaveURL('/room');
  await expect(text(a, '1 voters, 0 observers')).toBeVisible();

  await joinRoomByID(b, roomID);
  await expect(text(a, '2 voters, 0 observers')).toBeVisible();

  await close();
});

test('管理者が別ユーザーをキックすると、キックされた側は部屋選択へ戻る', async ({ browser }) => {
  const { a, b, nameB, close } = await setupTwoUsers(browser);

  await a.getByRole('button', { name: `Forced exit ${nameB}` }).click();
  await a.getByRole('button', { name: 'Yes' }).click();
  await expect(b).toHaveURL('/room');
  await expect(text(a, '1 voters, 0 observers')).toBeVisible();

  await close();
});
