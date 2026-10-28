import { expect, test, type Page } from '@playwright/test';
import { createRoom, joinRoom, login, open, uniqueName } from './helpers';

// SnackBar などの文言は flt-announcement-polite にも出るので、semantics ツリーに絞る
const text = (page: Page, value: string) =>
  page.locator('flt-semantics-host').getByText(value, { exact: true });

test('2 セッションで同じ部屋に入ると、投票 / Open / Reset が互いに反映される', async ({ browser }) => {
  const contextA = await browser.newContext();
  const contextB = await browser.newContext();
  const a = await contextA.newPage();
  const b = await contextB.newPage();

  await open(a, '/');
  await login(a, uniqueName());
  const roomID = await createRoom(a);

  await open(b, '/');
  await login(b, uniqueName());
  await expect(b).toHaveURL('/room');
  await joinRoom(b, roomID);

  for (const page of [a, b]) {
    await expect(text(page, '2 voters, 0 observers')).toBeVisible();
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

  await contextA.close();
  await contextB.close();
});
