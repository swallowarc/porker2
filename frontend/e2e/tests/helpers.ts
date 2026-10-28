import { expect, type Page } from '@playwright/test';

/**
 * バックエンドは同名ログインを AlreadyExists で拒否し、ユーザーは 180 分残るので、
 * 実行ごと・ログインごとに別の名前を使う。`[a-zA-Z0-9_-]{1,10}` に収める。
 */
export const uniqueName = (): string =>
  'e2e' + Math.random().toString(36).slice(2, 9).padEnd(7, '0');

/**
 * ページを開き、Flutter web のアクセシビリティツリーを有効化する。
 * 既定では無効なので、goto のたびに flt-semantics-placeholder を click する必要がある。
 */
export const open = async (page: Page, path: string): Promise<void> => {
  await page.goto(path);
  const placeholder = page.locator('flt-semantics-placeholder');
  await placeholder.waitFor({ state: 'attached' });
  await placeholder.dispatchEvent('click');
};

export const loginHeading = (page: Page) =>
  page.getByRole('heading', { name: 'Welcome to Porker2' });

/** ログイン画面が表示されている前提でログインする。 */
export const login = async (page: Page, name: string): Promise<void> => {
  // semantics が有効になった直後は入力が Flutter の TextEditingController に届かず捨てられる。
  // DOM の value では判定できないので、文字数カウンタに反映されるまで入力をやり直す
  const textbox = page.getByRole('textbox', { name: 'User name' });
  const remaining = 10 - name.length;
  const counter = page.getByText(
    remaining === 0 ? 'No characters remaining' : `${remaining} characters remaining`,
    { exact: true },
  );
  await expect(async () => {
    await textbox.fill(name);
    await expect(counter).toBeVisible({ timeout: 1_000 });
  }).toPass();
  await page.getByRole('button', { name: 'Login' }).click();
};

/** 部屋選択画面で部屋を作成し、入室した部屋の room-id を返す。 */
export const createRoom = async (page: Page): Promise<string> => {
  await page.getByRole('button', { name: 'Create a room' }).click();
  await expect(page).toHaveURL(/\/poker\?room-id=\d{5}$/);
  const roomID = new URL(page.url()).searchParams.get('room-id')!;
  await expect(page.getByRole('heading', { name: `Room ID: ${roomID}` })).toBeVisible();
  return roomID;
};

/** Account メニューからログアウトする。 */
export const logout = async (page: Page): Promise<void> => {
  await page.getByRole('button', { name: 'Account' }).click();
  await page.getByRole('menuitem', { name: 'Logout' }).click();
  await page.getByRole('button', { name: 'Yes' }).click();
};

/** ログイン済みのページで部屋の URL を直接開いて入室する。 */
export const joinRoom = async (page: Page, roomID: string): Promise<void> => {
  await open(page, `/poker?room-id=${roomID}`);
  await expect(page.getByRole('heading', { name: `Room ID: ${roomID}` })).toBeVisible();
};
